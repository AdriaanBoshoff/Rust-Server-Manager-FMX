unit ufrmServerInstaller;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.StdCtrls, FMX.ListBox, FMX.Layouts, FMX.Controls.Presentation, FMX.Objects,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, System.IOUtils;

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
    lytAutoQuitSteamCMD: TLayout;
    swtchAutoQuitSteamCMD: TSwitch;
    lblAutoQuitSteamCMDHeader: TLabel;
    btnInstallServer: TButton;
    btnVerifyServerFiles: TButton;
    btnCleanInstallServer: TButton;
    rctnglServerInstallerLogBG: TRectangle;
    lblServerInstallerLogHeader: TLabel;
    mmoServerInstallerLog: TMemo;
    procedure btnCleanInstallServerClick(Sender: TObject);
    procedure btnInstallServerClick(Sender: TObject);
    procedure btnVerifyServerFilesClick(Sender: TObject);
    procedure cbbServerInstallerBranchChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    const
      STEAMCMD_URL = 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip';
    var
      FSteamCMDFilePath: string;
      FSteamCMDZipPath: string;
      FIsInstallingServer: Boolean;
      FServerInstallPath: string;
    procedure InstallSteamCMD;
    procedure AddLog(const Text: string);
  public
    { Public declarations }
  end;

var
  frmServerInstaller: TfrmServerInstaller;

implementation

uses
  System.Zip, Rest.Client, uSteamCMD, uframeMessageBox, RSM.Config;

{$R *.fmx}

procedure TfrmServerInstaller.AddLog(const Text: string);
begin
  mmoServerInstallerLog.Lines.Add(Format('[%s] %s', [FormatDateTime('hh:nn:ss', Now), Text]));
end;

procedure TfrmServerInstaller.btnCleanInstallServerClick(Sender: TObject);
begin
  if FIsInstallingServer then
  begin
    ShowMessageBox('Server is currently busy installing!', 'SteamCMD busy', Self.Owner as TFmxObject);
    Exit;
  end;

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
      AddLog('ERROR - ' + E.ClassName + ': ' + E.Message);
    end;
  end;
end;

procedure TfrmServerInstaller.btnInstallServerClick(Sender: TObject);
begin
  if FIsInstallingServer then
  begin
    ShowMessageBox('Server is currently busy installing!', 'SteamCMD busy', Self.Owner as TFmxObject);
    Exit;
  end;

  try
    FIsInstallingServer := True;

    // Install SteamCMD
    InstallSteamCMD;

    // Install Update Server
    var steamCMD := TSteamCMD.Create(ExtractFilePath(FSteamCMDFilePath));
    try
      AddLog('Running SteamCMD...');

      // Main Branch
      if cbbServerInstallerBranch.ItemIndex = lstServerBranchMain.Index then
        steamCMD.InstallApp(258550, ExtractFileDir(ParamStr(0)), swtchAutoQuitSteamCMD.IsChecked, False, 'none');

      // Staging Branch
      if cbbServerInstallerBranch.ItemIndex = lstServerBranchStaging.Index then
        steamCMD.InstallApp(258550, ExtractFileDir(ParamStr(0)), swtchAutoQuitSteamCMD.IsChecked, False, 'staging');

      // aux01 Branch
      if cbbServerInstallerBranch.ItemIndex = lstServerBranchAux01.Index then
        steamCMD.InstallApp(258550, ExtractFileDir(ParamStr(0)), swtchAutoQuitSteamCMD.IsChecked, False, 'aux01');

      // aux02 Branch
      if cbbServerInstallerBranch.ItemIndex = lstServerBranchAux02.Index then
        steamCMD.InstallApp(258550, ExtractFileDir(ParamStr(0)), swtchAutoQuitSteamCMD.IsChecked, False, 'aux02');

      FIsInstallingServer := False;

      AddLog('DONE.');
    finally
      steamCMD.Free;
    end;
  except
    on E: Exception do
    begin
      FIsInstallingServer := False;
      AddLog('ERROR - ' + E.ClassName + ': ' + E.Message);
    end;
  end;
end;

procedure TfrmServerInstaller.btnVerifyServerFilesClick(Sender: TObject);
begin
  if FIsInstallingServer then
  begin
    ShowMessageBox('Server is currently busy installing!', 'SteamCMD busy', Self.Owner as TFmxObject);
    Exit;
  end;

  try
    FIsInstallingServer := True;

    // Install SteamCMD
    InstallSteamCMD;

    // Install Update Server
    var steamCMD := TSteamCMD.Create(ExtractFilePath(FSteamCMDFilePath));
    try
      AddLog('Running SteamCMD...');

      // Main Branch
      if cbbServerInstallerBranch.ItemIndex = lstServerBranchMain.Index then
        steamCMD.InstallApp(258550, ExtractFileDir(ParamStr(0)), swtchAutoQuitSteamCMD.IsChecked, TRUE, 'none');

      // Staging Branch
      if cbbServerInstallerBranch.ItemIndex = lstServerBranchStaging.Index then
        steamCMD.InstallApp(258550, ExtractFileDir(ParamStr(0)), swtchAutoQuitSteamCMD.IsChecked, TRUE, 'staging');

      // aux01 Branch
      if cbbServerInstallerBranch.ItemIndex = lstServerBranchAux01.Index then
        steamCMD.InstallApp(258550, ExtractFileDir(ParamStr(0)), swtchAutoQuitSteamCMD.IsChecked, TRUE, 'aux01');

      // aux02 Branch
      if cbbServerInstallerBranch.ItemIndex = lstServerBranchAux02.Index then
        steamCMD.InstallApp(258550, ExtractFileDir(ParamStr(0)), swtchAutoQuitSteamCMD.IsChecked, TRUE, 'aux02');

      FIsInstallingServer := False;

      AddLog('DONE.');
    finally
      steamCMD.Free;
    end;
  except
    on E: Exception do
    begin
      FIsInstallingServer := False;
      AddLog('ERROR - ' + E.ClassName + ': ' + E.Message);
    end;
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

