unit uSteamCMD;

interface

uses
  FMX.Forms;

type
  TSteamCMD = class
  public
  { Public Variables }
    FSTEAMCMD_PATH: string;
  public
  { Public Methods }
    constructor Create(const SteamCMDPath: string);
    procedure DownloadSteamCMD;
    procedure InstallApp(const AppID: Integer; const InstallDir: string; const QuitSteamCMDAfterComplete: Boolean; const VerifyFiles: Boolean = False; const Beta: string = 'none'; const LimitCPU: Boolean = True);
  end;

var
  steamCMD: TSteamCMD;

implementation

uses
  Rest.Client, System.Classes, System.SysUtils, System.IOUtils, System.Zip,
  Winapi.Windows, uHelpers, RSM.Core;

{ TSteamCMD }

constructor TSteamCMD.Create(const SteamCMDPath: string);
begin
  FSTEAMCMD_PATH := SteamCMDPath;
  ForceDirectories(FSTEAMCMD_PATH);
end;

procedure TSteamCMD.DownloadSteamCMD;
begin
  if TFile.Exists(TPath.Combine(FSTEAMCMD_PATH, 'steamcmd.exe')) then
  begin
    Exit;
  end;

  var memStream := TMemoryStream.Create;
  try
    TDownloadURL.DownloadRawBytes('https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip', memStream);

    memStream.SaveToFile(TPath.Combine(FSTEAMCMD_PATH, 'steamcmd.zip'));

    TZipFile.ExtractZipFile(TPath.Combine(FSTEAMCMD_PATH, 'steamcmd.zip'), FSTEAMCMD_PATH);

    TFile.Delete(TPath.Combine(FSTEAMCMD_PATH, 'steamcmd.zip'));
  finally
    memStream.Free;
  end;
end;

procedure TSteamCMD.InstallApp(const AppID: Integer; const InstallDir: string; const QuitSteamCMDAfterComplete: Boolean; const VerifyFiles: Boolean; const Beta: string; const LimitCPU: Boolean);
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  var steamcmd_file := TPath.Combine(FSTEAMCMD_PATH, 'steamcmd.exe');

  ZeroMemory(@StartupInfo, SizeOf(StartupInfo));
  ZeroMemory(@ProcessInfo, SizeOf(ProcessInfo));

  StartupInfo.lpTitle := PChar('RSMv3 - SteamCMD');
  StartupInfo.cb := SizeOf(StartupInfo);

  var startStr := steamcmd_file;
  startStr := startStr + Format(' +force_install_dir "%s"', [InstallDir]);
  startStr := startStr + Format(' +login %s', ['anonymous']);
  startStr := startStr + Format(' +app_update %d', [AppID]);

  if not Beta.Trim.IsEmpty then
    startStr := startStr + ' -beta ' + Beta
  else
  begin
    // Delete app manifest file to get rid of previous beta selection
    var appManifest := TPath.Combine([rsmCore.Paths.GetRootDir, 'steamapps', 'appmanifest_258550.acf']);
    if TFile.Exists(appManifest) then
      TFile.Delete(appManifest);
  end;

  if VerifyFiles then
    startStr := startStr + ' -validate';

  if QuitSteamCMDAfterComplete then
    startStr := startStr + ' +quit';

  // Make install.bat file
  TFile.WriteAllText(TPath.Combine([ExtractFilePath(ParamStr(0)), 'install.bat']), startStr);

  if not CreateProcessW(nil, PWideChar(startStr), nil, nil, False, 0, nil, PWideChar(ExtractFilePath(ParamStr(0))), StartupInfo, ProcessInfo) then
  begin
    RaiseLastOSError;
  end
  else
  begin
    if LimitCPU then
      SetProcessAffinityMask(ProcessInfo.hProcess, CombinedProcessorMask([0]));

    while WaitForSingleObject(ProcessInfo.hProcess, 10) > 0 do
    begin
      Application.ProcessMessages;
    end;

    CloseHandle(ProcessInfo.hThread);
    CloseHandle(ProcessInfo.hProcess);
  end;
end;

initialization
begin
  steamCMD := TSteamCMD.Create(TPath.Combine(ExtractFilePath(ParamStr(0)), 'steamcmd'));
end;


finalization
begin
  steamCMD.Free;
end;

end.

