unit uWinUtils;

interface

uses
  Winapi.Windows, Winapi.ShellAPI, System.SysUtils, IdHashMessageDigest,
  IdGlobal, System.Classes, System.Win.Registry, FMX.Forms;

function isWebView2RuntimeInstalled: Boolean;

function CalculateMD5(const FileName: string): string;

procedure OpenURL(const URL: string);

function CreateProcess(const Exe, Params, AppTitle: string; const WaitUntilClosed: Boolean = False): Integer; overload;

function CreateProcess(const Exe, Params, AppTitle: string; const WaitUntilClosed, InheritHandle: Boolean): Integer; overload;

implementation

function isWebView2RuntimeInstalled: Boolean;
begin
  Result := False;

  var reg := TRegistry.Create(KEY_READ);
  try
    // Installed for all users
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.KeyExists('SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}') then
    begin
      Result := True;
      Exit;
    end;

    // Installed for Current User
    reg.RootKey := HKEY_CURRENT_USER;
    if reg.KeyExists('Software\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}') then
    begin
      Result := True;
      Exit;
    end;
  finally
    reg.Free;
  end;
end;

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
    begin
      WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
      Application.ProcessMessages;
    end;

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

