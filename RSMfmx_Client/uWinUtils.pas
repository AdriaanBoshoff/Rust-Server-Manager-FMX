unit uWinUtils;

interface

uses
  Winapi.Windows, System.SysUtils;

function CreateProcess(const Exe, Params, AppTitle: string; const WaitUntilClosed: Boolean = False): Integer;

implementation

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

    RaiseLastOSError;
  end;
end;

end.

