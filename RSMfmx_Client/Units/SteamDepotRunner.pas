unit SteamDepotRunner;

{
  Cross-platform DepotDownloader wrapper for Delphi 13+

  Windows: Uses a Job Object (JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE) so the child
           is automatically killed when our process ends — even on a hard crash.

  Linux (WIP):   Uses prctl(PR_SET_PDEATHSIG, SIGTERM) set inside the child process
           right after fork(), so the kernel sends SIGTERM to DepotDownloader
           whenever the parent dies for any reason, including SIGKILL.
}

interface

uses
  System.Classes,
  System.SysUtils,
  System.Threading;

type
  TOutputEvent = reference to procedure(const Line: string);
  TExitEvent   = reference to procedure(ExitCode: Integer);

  /// Identifies a Steam branch (beta) to target.
  /// Leave BranchName empty to use the default (public) branch.
  TSteamBranch = record
    BranchName    : string;   // e.g. 'beta', 'staging', 'experimental'
    BranchPassword: string;   // Only needed for password-protected branches

    class function Default: TSteamBranch; static;
    class function Named(const AName: string;
      const APassword: string = ''): TSteamBranch; static;
  end;

  /// Identifies one or more specific depots to download.
  /// Leave Depots empty to download all depots for the app.
  TSteamDepotFilter = record
    DepotIDs: TArray<Integer>;

    class function All: TSteamDepotFilter; static;
    class function Only(const ADepotIDs: TArray<Integer>): TSteamDepotFilter; static;
  end;

  TDepotDownloader = class
  private
    FDepotDownloaderPath : string;
    FOnOutput            : TOutputEvent;
    FOnExit              : TExitEvent;
    FTask                : ITask;

    {$IFDEF MSWINDOWS}
    FJobHandle    : THandle;   // Job object — outlives individual runs
    FProcessHandle: THandle;   // Current child process handle
    {$ENDIF}
    {$IFDEF LINUX}
    FChildPID: Integer;        // Current child PID
    {$ENDIF}

    procedure RunInternal(const Args: string);

    {$IFDEF MSWINDOWS}
    procedure CreateJobObject;
    {$ENDIF}

    // Builds the branch/depot portion of the argument string
    class function BuildBranchArgs(const Branch: TSteamBranch): string; static;
    class function BuildDepotArgs(const DepotFilter: TSteamDepotFilter): string; static;

  public
    constructor Create(const ADepotDownloaderPath: string);
    destructor  Destroy; override;

    /// Install or update a Steam app — anonymous, default branch, all depots.
    procedure InstallOrUpdate(AppID: Integer; const InstallDir: string); overload;

    /// Install or update with explicit credentials, default branch, all depots.
    procedure InstallOrUpdate(AppID: Integer; const InstallDir: string;
      const Username: string; const Password: string = ''); overload;

    /// Install or update with full control over credentials, branch, and depots.
    procedure InstallOrUpdate(AppID: Integer; const InstallDir: string;
      const Username: string; const Password: string;
      const Branch: TSteamBranch;
      const DepotFilter: TSteamDepotFilter); overload;

    /// Verify an installed app — anonymous, default branch, all depots.
    procedure Verify(AppID: Integer; const InstallDir: string); overload;

    /// Verify with explicit credentials, default branch, all depots.
    procedure Verify(AppID: Integer; const InstallDir: string;
      const Username: string); overload;

    /// Verify with full control over credentials, branch, and depots.
    procedure Verify(AppID: Integer; const InstallDir: string;
      const Username: string;
      const Branch: TSteamBranch;
      const DepotFilter: TSteamDepotFilter); overload;

    /// Terminate the running DepotDownloader process immediately.
    procedure Terminate;

    property OnOutput: TOutputEvent read FOnOutput write FOnOutput;
    property OnExit  : TExitEvent   read FOnExit   write FOnExit;
  end;

implementation

{ == Platform imports ======================================================== }
{$IFDEF MSWINDOWS}
uses
  Winapi.Windows;

const
  // Missing from older Winapi.Windows
  JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE = $00002000;
  JobObjectExtendedLimitInformation   = 9;

type
  TJobObjectBasicLimitInformation = record
    PerProcessUserTimeLimit : Int64;
    PerJobUserTimeLimit     : Int64;
    LimitFlags              : DWORD;
    MinimumWorkingSetSize   : ULONG_PTR;
    MaximumWorkingSetSize   : ULONG_PTR;
    ActiveProcessLimit      : DWORD;
    Affinity                : ULONG_PTR;
    PriorityClass           : DWORD;
    SchedulingClass         : DWORD;
  end;

  TIOCounters = record
    ReadOperationCount  : UInt64;
    WriteOperationCount : UInt64;
    OtherOperationCount : UInt64;
    ReadTransferCount   : UInt64;
    WriteTransferCount  : UInt64;
    OtherTransferCount  : UInt64;
  end;

  TJobObjectExtendedLimitInformation = record
    BasicLimitInformation : TJobObjectBasicLimitInformation;
    IoInfo                : TIOCounters;
    ProcessMemoryLimit    : ULONG_PTR;
    JobMemoryLimit        : ULONG_PTR;
    PeakProcessMemoryUsed : ULONG_PTR;
    PeakJobMemoryUsed     : ULONG_PTR;
  end;

function SetInformationJobObject(hJob: THandle;
  JobObjectInfoClass: DWORD; lpJobObjectInfo: Pointer;
  cbJobObjectInfoLength: DWORD): BOOL; stdcall;
  external kernel32 name 'SetInformationJobObject';

function AssignProcessToJobObject(hJob, hProcess: THandle): BOOL; stdcall;
  external kernel32 name 'AssignProcessToJobObject';
{$ENDIF}

{$IFDEF LINUX}
uses
  Posix.Unistd,
  Posix.SysWait,
  Posix.Signal,
  Posix.Stdio;

const
  PR_SET_PDEATHSIG = 1;
  SIGTERM          = 15;

// prctl is a Linux syscall — Delphi has no Posix unit for it,
// so we declare it directly from libc which wraps the syscall.
function prctl(option: Integer; arg2, arg3, arg4, arg5: NativeUInt): Integer;
  cdecl; external 'libc' name 'prctl';
{$ENDIF}

{ == TSteamBranch ============================================================ }

class function TSteamBranch.Default: TSteamBranch;
begin
  Result.BranchName     := '';
  Result.BranchPassword := '';
end;

class function TSteamBranch.Named(const AName: string;
  const APassword: string): TSteamBranch;
begin
  Result.BranchName     := AName;
  Result.BranchPassword := APassword;
end;

{ == TSteamDepotFilter ======================================================= }

class function TSteamDepotFilter.All: TSteamDepotFilter;
begin
  Result.DepotIDs := [];
end;

class function TSteamDepotFilter.Only(
  const ADepotIDs: TArray<Integer>): TSteamDepotFilter;
begin
  Result.DepotIDs := ADepotIDs;
end;

{ == TDepotDownloader ======================================================== }

constructor TDepotDownloader.Create(const ADepotDownloaderPath: string);
begin
  inherited Create;
  FDepotDownloaderPath := ADepotDownloaderPath;
  {$IFDEF MSWINDOWS}
  FJobHandle     := 0;
  FProcessHandle := 0;
  CreateJobObject;   // Create once; all child processes get assigned to it
  {$ENDIF}
  {$IFDEF LINUX}
  FChildPID := 0;
  {$ENDIF}
end;

destructor TDepotDownloader.Destroy;
begin
  Terminate;
  {$IFDEF MSWINDOWS}
  if FJobHandle <> 0 then
  begin
    // Closing the Job handle triggers JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE —
    // every process still in the job is killed by the kernel immediately.
    Winapi.Windows.CloseHandle(FJobHandle);
    FJobHandle := 0;
  end;
  {$ENDIF}
  inherited;
end;

{ == Windows Job Object setup ================================================ }

{$IFDEF MSWINDOWS}
procedure TDepotDownloader.CreateJobObject;
var
  ExtInfo: TJobObjectExtendedLimitInformation;
begin
  FJobHandle := Winapi.Windows.CreateJobObject(nil, nil);  // anonymous job
  if FJobHandle = 0 then
    RaiseLastOSError;

  FillChar(ExtInfo, SizeOf(ExtInfo), 0);
  ExtInfo.BasicLimitInformation.LimitFlags := JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE;

  if not SetInformationJobObject(FJobHandle,
    JobObjectExtendedLimitInformation, @ExtInfo, SizeOf(ExtInfo)) then
  begin
    Winapi.Windows.CloseHandle(FJobHandle);
    FJobHandle := 0;
    RaiseLastOSError;
  end;
end;
{$ENDIF}

{ == Argument builders ======================================================= }

class function TDepotDownloader.BuildBranchArgs(
  const Branch: TSteamBranch): string;
begin
  Result := '';
  if Branch.BranchName = '' then
    Exit;

  Result := ' -beta ' + Branch.BranchName;
  if Branch.BranchPassword <> '' then
    Result := Result + ' -betapassword ' + Branch.BranchPassword;
end;

class function TDepotDownloader.BuildDepotArgs(
  const DepotFilter: TSteamDepotFilter): string;
var
  ID: Integer;
begin
  Result := '';
  for ID in DepotFilter.DepotIDs do
    Result := Result + ' -depot ' + ID.ToString;
end;

{ == Public API ============================================================== }

procedure TDepotDownloader.InstallOrUpdate(AppID: Integer;
  const InstallDir: string);
begin
  InstallOrUpdate(AppID, InstallDir, 'anonymous', '',
    TSteamBranch.Default, TSteamDepotFilter.All);
end;

procedure TDepotDownloader.InstallOrUpdate(AppID: Integer;
  const InstallDir: string; const Username: string; const Password: string);
begin
  InstallOrUpdate(AppID, InstallDir, Username, Password,
    TSteamBranch.Default, TSteamDepotFilter.All);
end;

procedure TDepotDownloader.InstallOrUpdate(AppID: Integer;
  const InstallDir: string; const Username: string; const Password: string;
  const Branch: TSteamBranch; const DepotFilter: TSteamDepotFilter);
var
  Args: string;
begin
  Args := Format('-app %d -dir "%s"', [AppID, InstallDir]);

  if not Username.Equals('anonymous') then
  begin
    Args := Args + ' -username ' + Username;
    if Password <> '' then
      Args := Args + ' -password ' + Password
    else
      Args := Args + ' -remember-password';
  end;

  Args := Args + BuildBranchArgs(Branch);
  Args := Args + BuildDepotArgs(DepotFilter);

  RunInternal(Args);
end;

procedure TDepotDownloader.Verify(AppID: Integer; const InstallDir: string);
begin
  Verify(AppID, InstallDir, 'anonymous',
    TSteamBranch.Default, TSteamDepotFilter.All);
end;

procedure TDepotDownloader.Verify(AppID: Integer; const InstallDir: string;
  const Username: string);
begin
  Verify(AppID, InstallDir, Username,
    TSteamBranch.Default, TSteamDepotFilter.All);
end;

procedure TDepotDownloader.Verify(AppID: Integer; const InstallDir: string;
  const Username: string; const Branch: TSteamBranch;
  const DepotFilter: TSteamDepotFilter);
var
  Args: string;
begin
  Args := Format('-app %d -dir "%s" -verify-all', [AppID, InstallDir]);

  if not Username.Equals('anonymous') then
    Args := Args + ' -username ' + Username;

  Args := Args + BuildBranchArgs(Branch);
  Args := Args + BuildDepotArgs(DepotFilter);

  RunInternal(Args);
end;

procedure TDepotDownloader.Terminate;
begin
  {$IFDEF MSWINDOWS}
  if FProcessHandle <> 0 then
  begin
    Winapi.Windows.TerminateProcess(FProcessHandle, 1);
    // Don't close FProcessHandle here — RunInternal owns the lifetime
  end;
  {$ENDIF}
  {$IFDEF LINUX}
  if FChildPID > 0 then
    Posix.Signal.kill(FChildPID, SIGTERM);
  {$ENDIF}
end;

{ == Core runner ============================================================= }

procedure TDepotDownloader.RunInternal(const Args: string);
var
  CapturedOnOutput: TOutputEvent;
  CapturedOnExit  : TExitEvent;
  FullExe         : string;
begin
  if (FTask <> nil) and (FTask.Status = TTaskStatus.Running) then
    raise Exception.Create('A download is already in progress');

  CapturedOnOutput := FOnOutput;
  CapturedOnExit   := FOnExit;
  FullExe          := FDepotDownloaderPath;

  FTask := TTask.Run(
    procedure
    var
      Line   : string;
      Partial: string;

      {$IFDEF MSWINDOWS}
      SA          : TSecurityAttributes;
      hRead       : THandle;
      hWrite      : THandle;
      SI          : TStartupInfo;
      PI          : TProcessInformation;
      CmdLine     : string;
      WinBuffer   : array[0..4095] of AnsiChar;
      BytesReadWin: DWORD;
      ExitCode    : DWORD;
      Idx         : Integer;
      {$ENDIF}

      {$IFDEF LINUX}
      PipeFD      : TPipeDescriptors;
      ChildPID    : Integer;
      LinuxBuffer : array[0..4095] of AnsiChar;
      BytesReadLin: Integer;
      ExitStatus  : Integer;
      ExitCode    : Integer;
      ArgList     : TArray<string>;
      Argv        : array of MarshaledAString;
      I           : Integer;
      Idx         : Integer;
      {$ENDIF}

    begin

    {$IFDEF MSWINDOWS}
      FillChar(SA, SizeOf(SA), 0);
      SA.nLength        := SizeOf(SA);
      SA.bInheritHandle := True;

      Win32Check(Winapi.Windows.CreatePipe(hRead, hWrite, @SA, 0));
      SetHandleInformation(hRead, HANDLE_FLAG_INHERIT, 0);
      try
        FillChar(SI, SizeOf(SI), 0);
        SI.cb          := SizeOf(SI);
        SI.dwFlags     := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
        SI.wShowWindow := SW_HIDE;
        SI.hStdOutput  := hWrite;
        SI.hStdError   := hWrite;
        SI.hStdInput   := INVALID_HANDLE_VALUE;

        CmdLine := Format('"%s" %s', [FullExe, Args]);
        UniqueString(CmdLine);

        FillChar(PI, SizeOf(PI), 0);
        Win32Check(Winapi.Windows.CreateProcess(
          nil, PChar(CmdLine),
          nil, nil,
          True,
          CREATE_NO_WINDOW or CREATE_SUSPENDED,
          nil, nil, SI, PI));

        if FJobHandle <> 0 then
          AssignProcessToJobObject(FJobHandle, PI.hProcess);

        FProcessHandle := PI.hProcess;

        ResumeThread(PI.hThread);
        Winapi.Windows.CloseHandle(PI.hThread);
        Winapi.Windows.CloseHandle(hWrite);
        hWrite := 0;

        Partial := '';
        repeat
          FillChar(WinBuffer, SizeOf(WinBuffer), 0);
          if not Winapi.Windows.ReadFile(
            hRead, WinBuffer, SizeOf(WinBuffer) - 1, BytesReadWin, nil) then
            Break;
          if BytesReadWin = 0 then
            Break;

          Partial := Partial +
            string(AnsiString(WinBuffer)).Substring(0, Integer(BytesReadWin));

          while Partial.Contains(#10) do
          begin
            Idx     := Partial.IndexOf(#10);
            Line    := Partial.Substring(0, Idx).TrimRight([#13, #10]);
            Partial := Partial.Substring(Idx + 1);
            if (Line <> '') and Assigned(CapturedOnOutput) then
              TThread.Synchronize(nil,
                procedure begin CapturedOnOutput(Line) end);
          end;
        until False;

        if Partial.Trim <> '' then
          if Assigned(CapturedOnOutput) then
            TThread.Synchronize(nil,
              procedure begin CapturedOnOutput(Partial.Trim) end);

        ExitCode := 0;
        Winapi.Windows.GetExitCodeProcess(FProcessHandle, ExitCode);
        Winapi.Windows.CloseHandle(FProcessHandle);
        FProcessHandle := 0;

        if Assigned(CapturedOnExit) then
          TThread.Synchronize(nil,
            procedure begin CapturedOnExit(Integer(ExitCode)) end);

      finally
        Winapi.Windows.CloseHandle(hRead);
        if hWrite <> 0 then
          Winapi.Windows.CloseHandle(hWrite);
      end;
    {$ENDIF}

    {$IFDEF LINUX}
      if pipe(PipeFD) <> 0 then
        raise Exception.Create('pipe() failed: ' + SysErrorMessage(GetLastError));

      ChildPID := fork();

      if ChildPID < 0 then
      begin
        __close(PipeFD.ReadDes);
        __close(PipeFD.WriteDes);
        raise Exception.Create('fork() failed: ' + SysErrorMessage(GetLastError));
      end;

      if ChildPID = 0 then
      begin
        // Child process
        prctl(PR_SET_PDEATHSIG, SIGTERM, 0, 0, 0);
        if getppid() = 1 then
          _exit(1);

        dup2(PipeFD.WriteDes, STDOUT_FILENO);
        dup2(PipeFD.WriteDes, STDERR_FILENO);
        __close(PipeFD.ReadDes);
        __close(PipeFD.WriteDes);

        ArgList := Args.Split([' ']);
        SetLength(Argv, Length(ArgList) + 2);
        Argv[0] := MarshaledAString(AnsiString(FullExe));
        for I := 0 to High(ArgList) do
          Argv[I + 1] := MarshaledAString(AnsiString(ArgList[I]));
        Argv[High(Argv)] := nil;

        execv(MarshaledAString(AnsiString(FullExe)), PPAnsiChar(@Argv[0]));
        _exit(127);
      end
      else
      begin
        // Parent process
        FChildPID := ChildPID;

        __close(PipeFD.WriteDes);

        Partial := '';
        repeat
          FillChar(LinuxBuffer, SizeOf(LinuxBuffer), 0);
          BytesReadLin := __read(PipeFD.ReadDes, @LinuxBuffer, SizeOf(LinuxBuffer) - 1);
          if BytesReadLin <= 0 then
            Break;

          Partial := Partial +
            string(AnsiString(@LinuxBuffer)).Substring(0, BytesReadLin);

          while Partial.Contains(#10) do
          begin
            Idx     := Partial.IndexOf(#10);
            Line    := Partial.Substring(0, Idx).TrimRight([#13, #10]);
            Partial := Partial.Substring(Idx + 1);
            if (Line <> '') and Assigned(CapturedOnOutput) then
              TThread.Synchronize(nil,
                procedure begin CapturedOnOutput(Line) end);
          end;
        until False;

        if Partial.Trim <> '' then
          if Assigned(CapturedOnOutput) then
            TThread.Synchronize(nil,
              procedure begin CapturedOnOutput(Partial.Trim) end);

        __close(PipeFD.ReadDes);

        ExitStatus := 0;
        waitpid(ChildPID, @ExitStatus, 0);
        FChildPID := 0;

        ExitCode := (ExitStatus shr 8) and $FF;

        if Assigned(CapturedOnExit) then
          TThread.Synchronize(nil,
            procedure begin CapturedOnExit(ExitCode) end);
      end;
    {$ENDIF}

    end); // TTask.Run
end;

end.
