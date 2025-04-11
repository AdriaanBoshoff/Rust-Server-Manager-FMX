unit uHelpers;

interface

uses
  System.Types, System.Classes, Winapi.Windows, PsAPI, System.SysUtils,
  Rest.Client, FMX.Graphics, System.Math, System.Threading, FMX.Grid, XML.XMLDoc,
  XML.XMLIntf, System.JSON.Types, System.JSON.Writers, ActiveX, ShellAPI;

type
  TBitmapHelper = class helper for TBitmap
  public
    procedure LoadFromURLAsync(const URL: string);
    procedure LoadFromURL(const URL: string);
  end;

type
  TStringGridHelper = class helper for TStringGrid
  public
    procedure DeleteRow(const RowID: Integer);
  end;

function StringContains(const Str: string; const Values: TArray<string>): boolean;

function GenerateAPIKey: string;

procedure SaveToFile(const aText, aFile: string);

function ReadFromFile(const aFile: string): string;

function GetPathFromPID(const PID: cardinal): string;

function TerminateProcessByID(ProcessID: cardinal): Boolean;

function SecToDaysTime(const Seconds: Int64): string;

function ConvertBytes(Bytes: Int64): string;

function GetNumberOfProcessors: Integer;

function GetSteamAvatarURL(const SteamID: string; const Owner: TComponent): string;

function FindText(const Text: string; const TagLeft, TagRight: string): string;

function CombinedProcessorMask(const Processors: array of Integer): DWORD_PTR;

function SingleProcessorMask(const ProcessorIndex: Integer): DWORD_PTR;

function SetupRestRequest(const Owner: TComponent): TRESTRequest;

procedure SelectFileInExplorer(const Fn: string);

implementation

function StringContains(const Str: string; const Values: TArray<string>): boolean;
begin
  Result := False;

  for var aValue in Values do
  begin
    if Str.Contains(aValue) then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function GenerateAPIKey: string;
begin
  var newGUID: TGUID;
  CreateGUID(newGUID);
  Result := GUIDToString(newGUID);
  Result := Result.Replace('-', '', [rfReplaceAll]).Replace('{', '').Replace('}', '');
end;

procedure SelectFileInExplorer(const Fn: string);
begin
  ShellExecute(0, 'open', 'explorer.exe', PChar('/select,"' + Fn + '"'), nil, SW_NORMAL);
end;

function SetupRestRequest(const Owner: TComponent): TRESTRequest;
begin
  Result := TRESTRequest.Create(Owner);
  Result.Client := TRESTClient.Create(Result);
  Result.Response := TRESTResponse.Create(Result);
  Result.Client.RaiseExceptionOn500 := False;
end;

function SingleProcessorMask(const ProcessorIndex: Integer): DWORD_PTR;
begin
  // When shifting constants the compiler will force the result to be 32-bit
  // if you have more than 32 processors, `Result:= 1 shl x` will return
  // an incorrect result.
  Result := DWORD_PTR(1) shl (ProcessorIndex);
end;

function CombinedProcessorMask(const Processors: array of Integer): DWORD_PTR;
var
  i: Integer;
begin
  Result := 0;
  for i := low(Processors) to high(Processors) do
    Result := Result or SingleProcessorMask(Processors[i]);
end;

function FindText(const Text: string; const TagLeft, TagRight: string): string;
begin
  Result := '';

  var PD1 := Pos(TagLeft, Text) + Length(TagLeft);
  var PD2 := Pos(TagRight, Text);

  Result := Copy(Text, PD1, PD2 - PD1);
end;

function GetSteamAvatarURL(const SteamID: string; const Owner: TComponent): string;
begin
  Result := '';
  CoInitialize(Owner);
  var XML := TXMLDocument.Create(Owner);
  try
    var memStream := TMemoryStream.Create;
    try
      TDownloadURL.DownloadRawBytes('https://steamcommunity.com/profiles/' + SteamID + '/?xml=1', memStream);

      XML.LoadFromStream(memStream);
    finally
      memStream.Free;
    end;

    Result := XML.DocumentElement.ChildNodes['avatarMedium'].Text;
  finally
    XML.Free;
    CoUninitialize;
  end;
end;

function GetNumberOfProcessors: Integer;
var
  si: TSystemInfo;
begin
  GetSystemInfo(si);
  Result := si.dwNumberOfProcessors;
end;

function ConvertBytes(Bytes: Int64): string;
const
  Description: array[0..8] of string = ('Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB');
var
  i: Integer;
begin
  i := 0;

  while Bytes > Power(1024, i + 1) do
    Inc(i);

  Result := FormatFloat('###0.##', Bytes / IntPower(1024, i)) + ' ' + Description[i];
end;

function SecToDaysTime(const Seconds: Int64): string;
var
  D, H, M, S, ATime: Integer;
begin
  D := Seconds div 86400;
  H := (Seconds - D * 86400) div 60 div 60;
  M := (Seconds - D * 86400 - H * 3600) div 60;
  S := Seconds - D * 86400 - H * 3600 - M * 60;

  Result := Format('%dd %dh %dm %ds', [D, H, M, S]);
end;

function TerminateProcessByID(ProcessID: cardinal): Boolean;
var
  hProcess: THandle;
begin
  Result := False;

  hProcess := OpenProcess(PROCESS_TERMINATE, False, ProcessID);
  if hProcess > 0 then
  try
    Result := Win32Check(TerminateProcess(hProcess, 0));
  finally
    CloseHandle(hProcess);
  end;
end;

function GetPathFromPID(const PID: cardinal): string;
var
  hProcess: THandle;
  path: array[0..MAX_PATH - 1] of char;
begin
  hProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, PID);
  if hProcess <> 0 then
  try
    if GetModuleFileNameEx(hProcess, 0, path, MAX_PATH) <> 0 then
      Result := path
    else
      Result := '';
  finally
    CloseHandle(hProcess)
  end
  else
    Result := '';
end;

procedure SaveToFile(const aText, aFile: string);
begin
  var sl := TStringList.Create;
  try
    sl.Text := aText;

    sl.SaveToFile(aFile, TEncoding.UTF8);
  finally
    sl.Free;
  end;
end;

function ReadFromFile(const aFile: string): string;
begin
  var sl := TStringList.Create;
  try
    sl.LoadFromFile(aFile, TEncoding.UTF8);

    Result := sl.Text.Trim;
  finally
    sl.Free;
  end;
end;

{ TBitmapHelper }

procedure TBitmapHelper.LoadFromURL(const URL: string);
begin
  var memStream := TMemoryStream.Create;
  try
    TDownloadURL.DownloadRawBytes(URL, memStream);

    if Assigned(Self) then
      Self.LoadFromStream(memStream);
  finally
    memStream.Free;
  end;
end;

procedure TBitmapHelper.LoadFromURLAsync(const URL: string);
begin
  TTask.Run(
    procedure
    begin
      var memStream := TMemoryStream.Create;
      try
        TDownloadURL.DownloadRawBytes(URL, memStream);

        TThread.Synchronize(nil,
          procedure
          begin
            if Assigned(Self) then
              Self.LoadFromStream(memStream);
          end);
      finally
        memStream.Free;
      end;
    end);
end;

{ TStringGridHelper }

procedure TStringGridHelper.DeleteRow(const RowID: Integer);
begin
  Self.BeginUpdate;
  try
    for var i := RowID to Self.RowCount - 2 do
    begin
      for var X := 0 to Self.ColumnCount - 1 do
      begin
        Self.Cells[X, i] := Self.Cells[X, i + 1];
      end;
    end;
    Self.RowCount := Self.RowCount - 1;
  finally
    Self.EndUpdate;
  end;
end;

end.

