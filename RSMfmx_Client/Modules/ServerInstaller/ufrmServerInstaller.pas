unit ufrmServerInstaller;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.StdCtrls, FMX.ListBox, FMX.Layouts, FMX.Controls.Presentation, FMX.Objects,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, System.IOUtils, uServerProcess,
  SteamDepotRunner;

type
  TfrmServerInstaller = class(TForm)
    rctnglServerInstallerControls: TRectangle;
    lblServerInstallerControlsHeader: TLabel;
    lytServerInstallerBranch: TLayout;
    lblServerInstallerBranchHeader: TLabel;
    cbbServerInstallerBranch: TComboBox;
    lstServerBranchMain: TListBoxItem;
    lstServerBranchStaging: TListBoxItem;
    lstServerBranchAux01: TListBoxItem;
    lstServerBranchAux02: TListBoxItem;
    btnInstallServer: TButton;
    btnVerifyServerFiles: TButton;
    btnCleanInstallServer: TButton;
    rctnglServerInstallerLogBG: TRectangle;
    lblServerInstallerLogHeader: TLabel;
    mmoServerInstallerLog: TMemo;
    pbSteamDepotDownloader: TProgressBar;
    lstServerBranchAux04: TListBoxItem;
    btnStopInstaller: TButton;
    procedure btnCleanInstallServerClick(Sender: TObject);
    procedure btnInstallServerClick(Sender: TObject);
    procedure btnVerifyServerFilesClick(Sender: TObject);
    procedure btnStopInstallerClick(Sender: TObject);
    procedure cbbServerInstallerBranchChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    const
      STEAMCMD_URL = 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip';
    var
      FSteamCMDFilePath: string;
      FSteamCMDZipPath: string;
      FServerInstallPath: string;
      FActiveDepotDownloader: TDepotDownloader;
    function GetSelectedBranch: TSteamBranch;
    procedure SetInstallerBusy(const Busy: Boolean);
    procedure InstallSteamCMD;
    procedure AddLog(const Text: string);
  public
    { Public declarations }
    FIsInstallingServer: Boolean;
  end;

var
  frmServerInstaller: TfrmServerInstaller;

implementation

uses
  System.Zip, Rest.Client, uSteamCMD, uframeMessageBox, RSM.Config,
  uframeToastMessage;

{$R *.fmx}

procedure TfrmServerInstaller.AddLog(const Text: string);
begin
  mmoServerInstallerLog.Lines.Add(Format('[%s] %s', [FormatDateTime('hh:nn:ss', Now), Text]));
end;

procedure TfrmServerInstaller.SetInstallerBusy(const Busy: Boolean);
begin
  btnInstallServer.Enabled      := not Busy;
  btnVerifyServerFiles.Enabled  := not Busy;
  btnCleanInstallServer.Enabled := not Busy;
  cbbServerInstallerBranch.Enabled := not Busy;
  btnStopInstaller.Enabled := Busy;
end;

function TfrmServerInstaller.GetSelectedBranch: TSteamBranch;
begin
  if      cbbServerInstallerBranch.ItemIndex = lstServerBranchStaging.Index then Result := TSteamBranch.Named('staging')
  else if cbbServerInstallerBranch.ItemIndex = lstServerBranchAux01.Index   then Result := TSteamBranch.Named('aux01')
  else if cbbServerInstallerBranch.ItemIndex = lstServerBranchAux02.Index   then Result := TSteamBranch.Named('aux02')
  else if cbbServerInstallerBranch.ItemIndex = lstServerBranchAux04.Index   then Result := TSteamBranch.Named('aux04')
  else                                                                            Result := TSteamBranch.Default;
end;

procedure TfrmServerInstaller.btnCleanInstallServerClick(Sender: TObject);
begin
  if FIsInstallingServer then
  begin
    //ShowMessageBox('Server is currently busy installing!', 'SteamCMD busy', Self.Owner as TFmxObject);
    ShowToast('SteamCMD is busy!');
    Exit;
  end;

  if serverProcess.isRunning then
  begin
    ShowMessageBox('Server is Running. Please stop the server first!', 'Server Running', Self.Owner as TFmxObject);
    Exit;
  end;

  SetInstallerBusy(True);
  try
    AddLog('Performing Clean Install...');

    AddLog('Deleting Installed Files.');

    // Bundles Folder
    if TDirectory.Exists(FServerInstallPath + 'Bundles') then
      TDirectory.Delete(FServerInstallPath + 'Bundles', True);

    // cfg Folder
    if TDirectory.Exists(FServerInstallPath + 'cfg') then
      TDirectory.Delete(FServerInstallPath + 'cfg', True);

    // MonoBleedingEdge Folder
    if TDirectory.Exists(FServerInstallPath + 'MonoBleedingEdge') then
      TDirectory.Delete(FServerInstallPath + 'MonoBleedingEdge', True);

    // RustDedicated_Data Folder
    if TDirectory.Exists(FServerInstallPath + 'RustDedicated_Data') then
      TDirectory.Delete(FServerInstallPath + 'RustDedicated_Data', True);

    // steamapps Folder
    if TDirectory.Exists(FServerInstallPath + 'steamapps') then
      TDirectory.Delete(FServerInstallPath + 'steamapps', True);

    // steamcmd Folder
    if TDirectory.Exists(FServerInstallPath + 'steamcmd') then
      TDirectory.Delete(FServerInstallPath + 'steamcmd', True);

    // RustDedicated.exe file
    if TFile.Exists(FServerInstallPath + 'RustDedicated.exe') then
      TFile.Delete(FServerInstallPath + 'RustDedicated.exe');

    // steam_api64.dll file
    if TFile.Exists(FServerInstallPath + 'steam_api64.dll') then
      TFile.Delete(FServerInstallPath + 'steam_api64.dll');

    // steamclient64.dll file
    if TFile.Exists(FServerInstallPath + 'steamclient64.dll') then
      TFile.Delete(FServerInstallPath + 'steamclient64.dll');

    // tier0_s64.dll file
    if TFile.Exists(FServerInstallPath + 'tier0_s64.dll') then
      TFile.Delete(FServerInstallPath + 'tier0_s64.dll');

    // UnityCrashHandler64.exe file
    if TFile.Exists(FServerInstallPath + 'UnityCrashHandler64.exe') then
      TFile.Delete(FServerInstallPath + 'UnityCrashHandler64.exe');

    // UnityPlayer.dll file
    if TFile.Exists(FServerInstallPath + 'UnityPlayer.dll') then
      TFile.Delete(FServerInstallPath + 'UnityPlayer.dll');

    // vstdlib_s64.dllfile
    if TFile.Exists(FServerInstallPath + 'vstdlib_s64.dll') then
      TFile.Delete(FServerInstallPath + 'vstdlib_s64.dll');

    // Install Server Files
    btnInstallServerClick(btnCleanInstallServer);

    FIsInstallingServer := False;
  except
    on E: Exception do
    begin
      FIsInstallingServer := False;
      SetInstallerBusy(False);
      AddLog('ERROR - ' + E.ClassName + ': ' + E.Message);
    end;
  end;
end;

procedure TfrmServerInstaller.btnInstallServerClick(Sender: TObject);
begin
  // Testing Support
  // TODO: Verify depotDownloader exists
  // TODO: Fix potential memory leak
  // TODO: Add method to stop download.
  // TODO: Enable / Disable UI buttons according to status
  // TODO: Limit Process Threads

  var steamDP := TDepotDownloader.Create(TPath.Combine([ExtractFilePath(ParamStr(0)), 'depotDownloader', 'DepotDownloader.exe']));
  FActiveDepotDownloader := steamDP;
  steamDP.OnOutput :=
    procedure(const Line: string)
    begin
      if Line.Contains('%') then
      begin
        var percVal := Copy(Line, 1, AnsiPos('%', Line) - 1);
        percVal := percVal.Replace(',', '.');
        var percValDouble: Double;
        var fs: TFormatSettings;
        fs.DecimalSeparator := '.';
        if TryStrToFloat(percVal, percValDouble, fs) then
          pbSteamDepotDownloader.Value := percValDouble;

      //  mmoServerInstallerLog.Lines.Add(percVal);
      end;

      mmoServerInstallerLog.Lines.Add(Line);
      mmoServerInstallerLog.GoToTextEnd;
    end;

  steamDP.OnExit :=
    procedure(Code: Integer)
    begin
      mmoServerInstallerLog.Lines.Add('Done. Exit Code: ' + Code.ToString);
      mmoServerInstallerLog.GoToTextEnd;
      SetInstallerBusy(False);
      FActiveDepotDownloader := nil;
      FreeAndNil(steamDP);
    end;

  SetInstallerBusy(True);
  var branch := GetSelectedBranch;
  if branch.BranchName.IsEmpty then
    AddLog('Starting install/update on branch: main')
  else
    AddLog('Starting install/update on branch: ' + branch.BranchName);
  steamDP.InstallOrUpdate(258550, ExtractFileDir(ParamStr(0)),
    'anonymous', '', branch, TSteamDepotFilter.All);

////////////////////////////////////// OLD SteamCMD Method ///////////////////////////////////////////
//  if FIsInstallingServer then
//  begin
//    ShowMessageBox('Server is currently busy installing!', 'SteamCMD busy', Self.Owner as TFmxObject);
//    Exit;
//  end;
//
//  if serverProcess.isRunning then
//  begin
//    ShowMessageBox('Server is Running. Please stop the server first!', 'Server Running', Self.Owner as TFmxObject);
//    Exit;
//  end;
//
//  try
//    FIsInstallingServer := True;
//
//    // Install SteamCMD
//    InstallSteamCMD;
//
//    // Install Update Server
//    var steamCMD := TSteamCMD.Create(ExtractFilePath(FSteamCMDFilePath));
//    try
//      AddLog('Running SteamCMD...');
//
//      // Main Branch
//      if cbbServerInstallerBranch.ItemIndex = lstServerBranchMain.Index then
//        steamCMD.InstallApp(258550, ExtractFileDir(ParamStr(0)), swtchAutoQuitSteamCMD.IsChecked, False, '', swtchLimitCPU.IsChecked);
//
//      // Staging Branch
//      if cbbServerInstallerBranch.ItemIndex = lstServerBranchStaging.Index then
//        steamCMD.InstallApp(258550, ExtractFileDir(ParamStr(0)), swtchAutoQuitSteamCMD.IsChecked, False, 'staging', swtchLimitCPU.IsChecked);
//
//      // aux01 Branch
//      if cbbServerInstallerBranch.ItemIndex = lstServerBranchAux01.Index then
//        steamCMD.InstallApp(258550, ExtractFileDir(ParamStr(0)), swtchAutoQuitSteamCMD.IsChecked, False, 'aux01', swtchLimitCPU.IsChecked);
//
//      // aux02 Branch
//      if cbbServerInstallerBranch.ItemIndex = lstServerBranchAux02.Index then
//        steamCMD.InstallApp(258550, ExtractFileDir(ParamStr(0)), swtchAutoQuitSteamCMD.IsChecked, False, 'aux02', swtchLimitCPU.IsChecked);
//
//      FIsInstallingServer := False;
//
//      AddLog('DONE. If you have any issues please disable the SteamCMD auto close option and see the console window logs.');
//    finally
//      steamCMD.Free;
//    end;
//  except
//    on E: Exception do
//    begin
//      FIsInstallingServer := False;
//      AddLog('ERROR - ' + E.ClassName + ': ' + E.Message);
//    end;
//  end;
end;

procedure TfrmServerInstaller.btnVerifyServerFilesClick(Sender: TObject);
begin
  var steamDP := TDepotDownloader.Create(TPath.Combine([ExtractFilePath(ParamStr(0)), 'depotDownloader', 'DepotDownloader.exe']));
  FActiveDepotDownloader := steamDP;
  steamDP.OnOutput :=
    procedure(const Line: string)
    begin
      if Line.Contains('%') then
      begin
        var percVal := Copy(Line, 1, AnsiPos('%', Line) - 1);
        percVal := percVal.Replace(',', '.');
        var percValDouble: Double;
        var fs: TFormatSettings;
        fs.DecimalSeparator := '.';
        if TryStrToFloat(percVal, percValDouble, fs) then
          pbSteamDepotDownloader.Value := percValDouble;
      end;

      mmoServerInstallerLog.Lines.Add(Line);
      mmoServerInstallerLog.GoToTextEnd;
    end;

  steamDP.OnExit :=
    procedure(Code: Integer)
    begin
      mmoServerInstallerLog.Lines.Add('Done. Exit Code: ' + Code.ToString);
      mmoServerInstallerLog.GoToTextEnd;
      SetInstallerBusy(False);
      FActiveDepotDownloader := nil;
      FreeAndNil(steamDP);
    end;

  SetInstallerBusy(True);
  var branch := GetSelectedBranch;
  if branch.BranchName.IsEmpty then
    AddLog('Starting file verification on branch: main')
  else
    AddLog('Starting file verification on branch: ' + branch.BranchName);
  steamDP.Verify(258550, ExtractFileDir(ParamStr(0)),
    'anonymous', branch, TSteamDepotFilter.All);
end;

procedure TfrmServerInstaller.btnStopInstallerClick(Sender: TObject);
begin
  if Assigned(FActiveDepotDownloader) then
  begin
    AddLog('Stopping download...');
    FActiveDepotDownloader.Terminate;
  end;
end;

procedure TfrmServerInstaller.cbbServerInstallerBranchChange(Sender: TObject);
begin
  rsmConfig.UI.serverInstallerBranchIndex := cbbServerInstallerBranch.ItemIndex;
  rsmConfig.SaveConfig;
end;

procedure TfrmServerInstaller.FormCreate(Sender: TObject);
begin
  // Vars
  FIsInstallingServer := False;
  FServerInstallPath := ExtractFilePath(ParamStr(0));

  // SteamCMD Path
  Self.FSteamCMDFilePath := ExtractFilePath(ParamStr(0)) + 'steamcmd\steamcmd.exe';
  // SteamCMD Zip Path
  Self.FSteamCMDZipPath := ExtractFilePath(FSteamCMDFilePath) + 'steamcmd.zip';

  // Server Branch
  cbbServerInstallerBranch.ItemIndex := rsmConfig.UI.serverInstallerBranchIndex;
end;

procedure TfrmServerInstaller.InstallSteamCMD;
begin
  // Check if steamcmd exists
  if TFile.Exists(FSteamCMDFilePath) then
  begin
    AddLog('SteamCMD is installed.');
    Exit;
  end;

  // Create SteamCMD dir
  if not TDirectory.Exists(ExtractFileDir(FSteamCMDFilePath)) then
    ForceDirectories(ExtractFileDir(FSteamCMDFilePath));

  // Download SteamCMD
  AddLog('SteamCMD is not installed. Downloading...');
  var memStream := TMemoryStream.Create;
  try
    TDownloadURL.DownloadRawBytes(STEAMCMD_URL, memStream);
    memStream.SaveToFile(FSteamCMDZipPath);
  finally
    memStream.Free;
  end;

  // Extract SteamCMD
  AddLog('Extracting SteamCMD');
  var zip := TZipFile.Create;
  try
    zip.Open(FSteamCMDZipPath, zmRead);
    zip.ExtractAll(ExtractFilePath(FSteamCMDZipPath));
  finally
    zip.Free;
  end;

  // Delete Zip after extracting
  AddLog('Cleaning Up...');
  TFile.Delete(FSteamCMDZipPath);
end;

end.

