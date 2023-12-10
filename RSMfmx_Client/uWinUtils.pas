unit uWinUtils;

interface

uses
  Winapi.Windows, Winapi.ShellAPI, System.SysUtils, IdHashMessageDigest,
  IdGlobal, System.Classes;

function CalculateMD5(const FileName: string): string;

procedure OpenURL(const URL: string);

function CreateProcess(const Exe, Params, AppTitle: string; const WaitUntilClosed: Boolean = False): Integer; overload;

function CreateProcess(const Exe, Params, AppTitle: string; const WaitUntilClosed, InheritHandle: Boolean): Integer; overload;

implementation

function CalculateMD5(const FileName: string): string;
var
  FileStream: TFileStream;
  MD5Hash: TIdHashMessageDigest5;
begin
  MD5Hash := TIdHashMessageDigest5.Create;
  try
    FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      Result := IdGlobal.IndyLowerCase(MD5Hash.HashStreamAsHex(FileStream));
    finally
      FileStream.Free;
    end;
  finally
    MD5Hash.Free;
  end;
end;

procedure OpenURL(const URL: string);
begin
  var newURL := StringReplace(URL, '"', '%22', [rfReplaceAll]);
  ShellExecute(0, 'open', PChar(newURL), nil, nil, SW_SHOWNORMAL);
end;

function CreateProcess(const Exe, Params, AppTitle: string; const WaitUntilClosed: Boolean): Integer;
var
  StartupInfo: TStartupInfoW;
  ProcessInfo: TProcessInformation;
  CommandLine: WideString;
  ProgramPath: WideString;
begin
  // Return ProcessID. Default -1
  Result := -1;

  // Set up the command line and program path
  CommandLine := Params;
  ProgramPath := Exe + ' ' + CommandLine;

  // Initialize the StartupInfo structure
  FillChar(StartupInfo, SizeOf(StartupInfo), 0);
  StartupInfo.lpTitle := PWideChar(AppTitle);
  StartupInfo.cb := SizeOf(StartupInfo);

  // Create the process
  if CreateProcessW(nil, PWideChar(ProgramPath), nil, nil, False, 0, nil, nil, StartupInfo, ProcessInfo) then
  begin
    // Wait for the process to complete (optional)
    if WaitUntilClosed then
      WaitForSingleObject(ProcessInfo.hProcess, INFINITE);

    Result := ProcessInfo.dwProcessId;

    // Close process and thread handles
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
  end
  else
  begin
    // Failed to create the process
    Result := -1;
  end;
end;

function CreateProcess(const Exe, Params, AppTitle: string; const WaitUntilClosed, InheritHandle: Boolean): Integer;
var
  StartupInfo: TStartupInfoW;
  ProcessInfo: TProcessInformation;
  CommandLine: WideString;
  ProgramPath: WideString;
begin
  // Return ProcessID. Default -1
  Result := -1;

  // Set up the command line and program path
  CommandLine := Params;
  ProgramPath := Exe + ' ' + CommandLine;

  // Initialize the StartupInfo structure
  FillChar(StartupInfo, SizeOf(StartupInfo), 0);
  StartupInfo.lpTitle := PWideChar(AppTitle);
  StartupInfo.cb := SizeOf(StartupInfo);

  // Create the process
  if CreateProcessW(nil, PWideChar(ProgramPath), nil, nil, InheritHandle, 0, nil, nil, StartupInfo, ProcessInfo) then
  begin
    // Wait for the process to complete (optional)
    if WaitUntilClosed then
      WaitForSingleObject(ProcessInfo.hProcess, INFINITE);

    Result := ProcessInfo.dwProcessId;

    // Close process and thread handles
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
  end
  else
  begin
    // Failed to create the process
    Result := -1;
  end;
end;

end.

