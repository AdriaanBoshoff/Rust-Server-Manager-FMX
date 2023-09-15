unit uServerProcess;

interface

type
  TServerProcess = class
  private
    function GetProcessPath(ProcessID: Integer): string;
    function TerminateProcessByPID(PID: Integer): Boolean;
  public
    PID: Integer;
    constructor Create;
    procedure Save;
    procedure Load;
    function isRunning: Boolean;
    function KillProcess: Boolean;
  end;

var
  serverProcess: TServerProcess;

implementation

uses
  System.IOUtils, System.SysUtils, XSuperObject, WinAPI.Windows, WinAPI.PsAPI;

{ TServerProcess }

constructor TServerProcess.Create;
begin
  { Defaults }

  // Server PID
  Self.PID := -1;

  // Load Info
  Self.Load;
end;

function TServerProcess.GetProcessPath(ProcessID: Integer): string;
var
  hProcess: THandle;
  path: array[0..MAX_PATH - 1] of char;
begin
  Result := '';

  if ProcessID = -1 then
  Exit;


  hProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, PID);
  if hProcess <> 0 then
  try
    if GetModuleFileNameEx(hProcess, 0, path, MAX_PATH) <> 0 then
      Result := path
    else
      Result := '';
  finally
    CloseHandle(hProcess)
  end;
end;

function TServerProcess.isRunning: Boolean;
begin
  Result := (Self.GetProcessPath(Self.PID) = ExtractFilePath(ParamStr(0)) + 'RustDedicated.exe');
end;

function TServerProcess.KillProcess: Boolean;
begin
  Result := False;

  // Check if PID is running
  if not Self.isRunning then
    Exit;

  // Kill PID
  Result := Self.TerminateProcessByPID(Self.PID);
end;

procedure TServerProcess.Load;
begin
  var aFile := ExtractFilePath(ParamStr(0)) + 'rsm\serverProcess.dat';

  // Create Directory if it does not exists
  if not TDirectory.Exists(ExtractFileDir(aFile)) then
    ForceDirectories(ExtractFileDir(aFile));

  // Load Config if exists
  if TFile.Exists(aFile) then
    Self.AssignFromJSON(TFile.ReadAllText(aFile, TEncoding.UTF8));

  // Save config after loading to populate new properties
  Self.Save;
end;

procedure TServerProcess.Save;
begin
  var aFile := ExtractFilePath(ParamStr(0)) + 'rsm\serverProcess.dat';

  // Create Directory if it does not exists
  if not TDirectory.Exists(ExtractFileDir(aFile)) then
    ForceDirectories(ExtractFileDir(aFile));

  // Save
  TFile.WriteAllText(aFile, Self.AsJSON(True), TEncoding.UTF8);
end;

function TServerProcess.TerminateProcessByPID(PID: Integer): Boolean;
var
  ProcessHandle: THandle;
begin
  Result := False;

  ProcessHandle := OpenProcess(PROCESS_TERMINATE, False, PID);
  if ProcessHandle <> 0 then
  begin
    Result := TerminateProcess(ProcessHandle, 0);
    CloseHandle(ProcessHandle);
  end;
end;

end.

