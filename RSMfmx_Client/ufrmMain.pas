unit ufrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Math, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  udmStyles, udmIcons, FMX.Menus, FMX.StdCtrls, FMX.MultiView,
  FMX.Controls.Presentation, FMX.Layouts, FMX.TabControl, FMX.Ani, FMX.Objects,
  FMX.ListBox, System.Rtti, FMX.Grid.Style, FMX.Grid, FMX.ScrollBox, FMX.Edit,
  FMX.SpinBox, FMX.EditBox, FMX.NumberBox, FMX.Trayicon.Win, FMX.Platform.Win,
  Winapi.Windows, System.IOUtils, FMX.Memo.Types, FMX.Memo, System.Threading,
  FMX.Clipboard, FMX.Platform;

type
  TfrmMain = class(TForm)
    mnbrMain: TMenuBar;
    statMain: TStatusBar;
    mltvwNav: TMultiView;
    tlbHeader: TToolBar;
    btnNavBurger: TSpeedButton;
    lblNavHeader: TLabel;
    lytMain: TLayout;
    lytServerInfo: TLayout;
    mniFile: TMenuItem;
    tbcNav: TTabControl;
    tbtmNavServerControls: TTabItem;
    tbcServerInfo: TTabControl;
    tbtmServerInfo: TTabItem;
    btnShowHideServerInfo: TSpeedButton;
    fltnmtnServerInfoExpand: TFloatAnimation;
    lstNav: TListBox;
    lstServerControls: TListBoxItem;
    lblServerControls: TLabel;
    imgServerControls: TImage;
    lstServerConfig: TListBoxItem;
    imgServerConfig: TImage;
    lblServerConfig: TLabel;
    lstServerInstaller: TListBoxItem;
    imgServerInstaller: TImage;
    lblServerInstaller: TLabel;
    tbtmServerConfig: TTabItem;
    tbtmServerInstaller: TTabItem;
    rctnglServerInfo: TRectangle;
    lblServerInfoHeader: TLabel;
    lytPlayerCount: TLayout;
    lblPlayerCountHeader: TLabel;
    lblPlayerCountValue: TLabel;
    lytQueued: TLayout;
    lblQueuedHeader: TLabel;
    lblQueuedValue: TLabel;
    lytJoining: TLayout;
    lblJoiningHeader: TLabel;
    lblJoiningValue: TLabel;
    lytNetworkIn: TLayout;
    lblNetworkInHeader: TLabel;
    lblNetworkInValue: TLabel;
    lytNetworkOut: TLayout;
    lblNetworkOutHeader: TLabel;
    lblNetworkOutValue: TLabel;
    lytServerFPS: TLayout;
    lblServerFPSHeader: TLabel;
    lblServerFPSValue: TLabel;
    lytServerVersion: TLayout;
    lblServerProtocolHeader: TLabel;
    lblServerProtocolValue: TLabel;
    lytServerEntityCount: TLayout;
    lblServerEntityCountHeader: TLabel;
    lblServerEntityCountValue: TLabel;
    lytServerMemoryUsage: TLayout;
    lblServerMemoryUsageHeader: TLabel;
    lblServerMemoryUsageValue: TLabel;
    lytServerSize: TLayout;
    lblServerSizeHeader: TLabel;
    lblServerSizeValue: TLabel;
    lytLastWipe: TLayout;
    lblLastWipeHeader: TLabel;
    lblLastWipeValue: TLabel;
    rctnglSystemInfo: TRectangle;
    lblSystemInfoHeader: TLabel;
    lytCPUUsage: TLayout;
    lblCPUUsageHeader: TLabel;
    lblCPUUsageValue: TLabel;
    lytRamUsage: TLayout;
    lblRamUsageheader: TLabel;
    lblRamUsageValue: TLabel;
    vrtscrlbxServerConfig: TVertScrollBox;
    lytHostnameHeader: TLayout;
    lblHostnameHeader: TLabel;
    lytHostnameValue: TLayout;
    edtHostnameValue: TEdit;
    btnClearHostname: TClearEditButton;
    lytServerTagsHeader: TLayout;
    lblServerTagsHeader: TLabel;
    lytServerTagsValue: TLayout;
    edtServerTagsValue: TEdit;
    btnSelectServerTags: TEllipsesEditButton;
    lytServerDescriptionHeader: TLayout;
    lblServerDescriptionHeader: TLabel;
    lytServerDescriptionValue: TLayout;
    edtServerDescriptionValue: TEdit;
    btnEditServerDescription: TEllipsesEditButton;
    lytServerURLHeader: TLayout;
    lblServerURLHeader: TLabel;
    lytServerURLValue: TLayout;
    edtServerURLValue: TEdit;
    btnClearServerURL: TClearEditButton;
    lytServerBannerURLHeader: TLayout;
    lblServerBannerURL: TLabel;
    lytServerBannerURLValue: TLayout;
    edtServerBannerURLValue: TEdit;
    btnClearServerBannerURL: TClearEditButton;
    lytAppLogoURLHeader: TLayout;
    lblAppLogoURLHeader: TLabel;
    lytAppLogoURLValue: TLayout;
    edtAppLogoURLValue: TEdit;
    btnClearAppLogoURL: TClearEditButton;
    expndrServerMap: TExpander;
    lytServerMap1: TLayout;
    lblServerMapHeader: TLabel;
    cbbServerMap: TComboBox;
    lblCustomMapURLHeader: TLabel;
    edtCustomMapURLValue: TEdit;
    btnClearCustomMapURL: TClearEditButton;
    lytServerMap2: TLayout;
    lblMapSize: TLabel;
    nmbrbxMapSize: TNumberBox;
    lblMapSeed: TLabel;
    nmbrbxMapSeed: TNumberBox;
    btnGenerateMapSeed: TSpeedButton;
    expndrMiscServerConfig: TExpander;
    lytServerConfigMisc1: TLayout;
    lblMaxPlayers: TLabel;
    spnbxMaxPlayers: TSpinBox;
    lblCensorPlayerList: TLabel;
    swtchCensorPlayerlist: TSwitch;
    lytServerConfigMisc2: TLayout;
    cbbServerGamemodeValue: TComboBox;
    lblServerGamemodeDescriptionValue: TLabel;
    lblServerGameModeHead: TLabel;
    expndrServerNetworking: TExpander;
    lytServerNetworking1: TLayout;
    lblServerIPHeader: TLabel;
    edtServerIP: TEdit;
    lblServerPortHeader: TLabel;
    nmbrbxServerPort: TNumberBox;
    lblQueryPortHeader: TLabel;
    nmbrbxQueryPort: TNumberBox;
    lytServerNetworking2: TLayout;
    lblRconIPHeader: TLabel;
    edtRconIPValue: TEdit;
    lblRconPortHeader: TLabel;
    nmbrbxRconPortValue: TNumberBox;
    lblRconPasswordHeader: TLabel;
    edtRconPasswordValue: TEdit;
    btnViewRconPassword: TPasswordEditButton;
    btnCopyRconPassword: TEditButton;
    lytServerNetworking3: TLayout;
    lblAppIPHeader: TLabel;
    edtAppIPValue: TEdit;
    lblAppPortValue: TLabel;
    nmbrbxAppPortValue: TNumberBox;
    lblAppPublicIPHeader: TLabel;
    edtAppPublicIPValue: TEdit;
    expndrServerConfigServerCFG: TExpander;
    rctnglServerControlsHeader: TRectangle;
    lytServerPIDInfo: TLayout;
    lblServerPIDHeader: TLabel;
    lblServerPIDValue: TLabel;
    rctnglServerControls: TRectangle;
    lblServerControlsHeader: TLabel;
    btnStartServer: TButton;
    btnStopServer: TButton;
    btnRestartServer: TButton;
    btnForceSave: TButton;
    btnKillServer: TButton;
    rctnglServerOptions: TRectangle;
    vrtscrlbxServerControlsMain: TVertScrollBox;
    lytServerAffinity: TLayout;
    swtchServerAffinity: TSwitch;
    lblServerAffinityHeader: TLabel;
    btnAdjustAffinity: TButton;
    lblServerOptionsHeader: TLabel;
    mniOpenFolder: TMenuItem;
    mniOpenServerRoot: TMenuItem;
    btnAppSettings: TSpeedButton;
    lytAppVersion: TLayout;
    lblAppVersionValue: TLabel;
    lblAppVersionHeader: TLabel;
    mniSepExit: TMenuItem;
    mniExitRSM: TMenuItem;
    tbtmPlayerManager: TTabItem;
    lstPlayerManager: TListBoxItem;
    imgPlayerManager: TImage;
    lblPlayerManager: TLabel;
    vrtscrlbxServerInfo: TVertScrollBox;
    mmoServerCFG: TMemo;
    btnEditRadioList: TButton;
    btnEditEmojis: TButton;
    rctnglServerConfigControls: TRectangle;
    btnSaveServerConfig: TButton;
    procedure btnCopyRconPasswordClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGenerateMapSeedClick(Sender: TObject);
    procedure btnSaveServerConfigClick(Sender: TObject);
    procedure btnShowHideServerInfoClick(Sender: TObject);
    procedure btnStartServerClick(Sender: TObject);
    procedure cbbServerInstallerBranchMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
    procedure cbbServerMapMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
    procedure edtCustomMapURLValueEnter(Sender: TObject);
    procedure edtCustomMapURLValueExit(Sender: TObject);
    procedure edtRconPasswordValueEnter(Sender: TObject);
    procedure edtRconPasswordValueExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lblAppVersionValueResized(Sender: TObject);
    procedure lstNavChange(Sender: TObject);
    procedure mniExitRSMClick(Sender: TObject);
    procedure trayIconMainClick(Sender: TObject);
  private
    { Private Variables }
    FServerInfoExpandAfter: Boolean;
  private
    { Private declarations }
    // UI
    procedure LoadRSMUIConfig;
    procedure ResetServerInfoValues;
    procedure BringToForeground;
    // Server Config
    procedure PopulateServerConfigUI;
    // Startup
    procedure ModifyUIForRelease;
    procedure CreateClasses;
    procedure InitVariables;
    procedure CreateModules;
    // Shutdown
    procedure FreeClasses;
    procedure HideServerInfo;
    procedure ShowServerInfo;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uServerConfig, RSM.Config, uframeMessageBox, ufrmServerInstaller, uWinUtils;

{$R *.fmx}

{ TfrmMain }

procedure TfrmMain.BringToForeground;
begin
  SetForegroundWindow(ApplicationHWND);
end;

procedure TfrmMain.btnCopyRconPasswordClick(Sender: TObject);
begin
  // Check if platform supports copying
  if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService) then
  begin
    var clp := IFMXClipboardService(TPlatformServices.Current.GetPlatformService(IFMXClipboardService));
    clp.SetClipboard(edtRconPasswordValue.Text);
  end
  else
  begin
    ShowMessageBox('Platform does not support copying.', 'Copy Failure', Self);
  end;
end;

procedure TfrmMain.btnGenerateMapSeedClick(Sender: TObject);
begin
  Randomize;
  nmbrbxMapSeed.Value := RandomRange(1, 99999999);
end;

procedure TfrmMain.btnSaveServerConfigClick(Sender: TObject);
begin
  // General Config
  serverConfig.Hostname := edtHostnameValue.Text;
  serverConfig.Tags := edtServerTagsValue.Text;
  serverConfig.Description := edtServerDescriptionValue.Text;
  serverConfig.ServerURL := edtServerURLValue.Text;
  serverConfig.ServerBannerURL := edtServerBannerURLValue.Text;
  serverConfig.AppLogoURL := edtAppLogoURLValue.Text;

  // Map
  serverConfig.Map.MapName := cbbServerMap.Selected.Text;
  serverConfig.Map.MapIndex := cbbServerMap.ItemIndex;
  serverConfig.Map.CustomMapURL := edtCustomMapURLValue.Text;
  serverConfig.Map.MapSize := Trunc(nmbrbxMapSize.Value);
  serverConfig.Map.MapSeed := Trunc(nmbrbxMapSeed.Value);

  // Misc
  serverConfig.Misc.MaxPlayers := Trunc(spnbxMaxPlayers.Value);
  serverConfig.Misc.CensorPlayerList := swtchCensorPlayerlist.IsChecked;
 // serverConfig.Misc.GameMode := cbbServerGamemodeValue.Selected.Text;

 // Networking
  serverConfig.Networking.ServerIP := edtServerIP.Text;
  serverConfig.Networking.ServerPort := Trunc(nmbrbxServerPort.Value);
  serverConfig.Networking.ServerQueryPort := Trunc(nmbrbxQueryPort.Value);
  serverConfig.Networking.RconIP := edtRconIPValue.Text;
  serverConfig.Networking.RconPort := Trunc(nmbrbxRconPortValue.Value);
  serverConfig.Networking.RconPassword := edtRconPasswordValue.Text;
  serverConfig.Networking.AppIP := edtAppIPValue.Text;
  serverConfig.Networking.AppPort := Trunc(nmbrbxAppPortValue.Value);
  serverConfig.Networking.AppPublicIP := edtAppPublicIPValue.Text;

  try
    // Save Server Config
    serverConfig.SaveConfig;

   // ShowMessage('Config Saved!');
    ShowMessageBox('Saved Server Config!', 'Server Config', Self);
  except
    on E: Exception do
    begin
      serverConfig.LoadConfig; // Reset Config class if failed to save

      var errMessage := Format('Failed to save server config %s %s: %s', [sLineBreak, E.ClassName, E.Message]);

      ShowMessageBox(errMessage, 'Server Config', Self);
    end;
  end;
end;

procedure TfrmMain.btnShowHideServerInfoClick(Sender: TObject);
begin
  // Expand
  if lytServerInfo.Width = 0 then
  begin
    ShowServerInfo;
    rsmConfig.UI.ShowServerInfoPanel := True;
  end;

  // Collapse
  if lytServerInfo.Width = 220 then
  begin
    HideServerInfo;
    rsmConfig.UI.ShowServerInfoPanel := False;
  end;
end;

procedure TfrmMain.btnStartServerClick(Sender: TObject);
begin
  var rustDedicatedExe := ExtractFilePath(ParamStr(0)) + 'RustDedicated.exe';

  // Check if server is installed
  if not TFile.Exists(rustDedicatedExe) then
  begin
    ShowMessageBox('Server not installed!', 'Start Failure', Self);
    Exit;
  end;

  // Build Params
  var slParams := TStringList.Create;
  try
    // Console Mode
    slParams.Add('-batchmode -nographics -silent-crashes ^');

    // Server Identity
    slParams.Add('+server.identity "rsm" ^');

    // TEMP
    slParams.Add('+server.level "CraggyIsland" ^');

    // Networking - Server
    slParams.Add('+server.ip ' + serverConfig.Networking.ServerIP + ' ^');
    slParams.Add('+server.port ' + serverConfig.Networking.ServerPort.ToString + ' ^');
    slParams.Add('+server.queryport ' + serverConfig.Networking.ServerQueryPort.ToString + ' ^');

    // Networking - RCON
    slParams.Add('+rcon.ip ' + serverConfig.Networking.RconIP + ' ^');
    slParams.Add('+rcon.port ' + serverConfig.Networking.RconPort.ToString + ' ^');
    slParams.Add('+rcon.password ' + serverConfig.Networking.RconPassword + ' ^');

    // Networking - Rust +
    slParams.Add('+app.listenip ' + serverConfig.Networking.AppIP + ' ^');
    slParams.Add('+app.port ' + serverConfig.Networking.AppPort.ToString + ' ^');
    if not serverConfig.Networking.AppPublicIP.Trim.IsEmpty then // Dont add if empty
      slParams.Add('+app.publicip ' + serverConfig.Networking.AppPublicIP + '');

    CreateProcess(rustDedicatedExe, slParams.Text, serverConfig.Hostname, False)
  finally
    slParams.Free;
  end;
end;

procedure TfrmMain.cbbServerInstallerBranchMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
begin
  Abort;
end;

procedure TfrmMain.cbbServerMapMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
begin
  Abort;
end;

procedure TfrmMain.edtCustomMapURLValueEnter(Sender: TObject);
begin
// Used in ShowServerInfo to check if the server info
  // was visible before editing the rcon password
  FServerInfoExpandAfter := (lytServerInfo.Width = 0);

  if edtCustomMapURLValue.Width < 600 then
    HideServerInfo;
end;

procedure TfrmMain.edtCustomMapURLValueExit(Sender: TObject);
begin
  ShowServerInfo;
end;

procedure TfrmMain.edtRconPasswordValueEnter(Sender: TObject);
begin
  // Used in ShowServerInfo to check if the server info
  // was visible before editing the rcon password
  FServerInfoExpandAfter := (lytServerInfo.Width = 0);

  if edtRconPasswordValue.Width < 600 then
    HideServerInfo;
end;

procedure TfrmMain.edtRconPasswordValueExit(Sender: TObject);
begin
  ShowServerInfo;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  {$IFDEF DEBUG}
  Self.Caption := 'RSMfmx v3.1 (DEBUG BUILD)';
  {$ENDIF}

  {$IFDEF RELEASE}
  Self.Caption := 'RSMfmx v3.1';
  {$ENDIF}

  // Classes
  CreateClasses;

  // Variables
  InitVariables;

  // Modules
  CreateModules;

  // Change UI Layout for redistribution
  ModifyUIForRelease;
  ResetServerInfoValues;
  PopulateServerConfigUI;
  LoadRSMUIConfig;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  // Dont save UI pos when maximized
  if not (Self.WindowState = TWindowState.wsMaximized) then
  begin
    // Save Window size
    rsmConfig.UI.windowHeight := Self.Height;
    rsmConfig.UI.windowWidth := Self.Width;

    // Save Window pos
    rsmConfig.UI.windowPosX := Self.Left;
    rsmConfig.UI.windowPosY := Self.Top;

    // Save RSM Config
    rsmConfig.SaveConfig;
  end;

  // Classes
  FreeClasses;
end;

procedure TfrmMain.CreateClasses;
begin
  // Server Config
  serverConfig := TServerConfig.Create;

  // RSM Config
  rsmConfig := TRSMConfig.Create;
end;

procedure TfrmMain.CreateModules;
begin
  // Server Installer Module
  frmServerInstaller := TfrmServerInstaller.Create(tbtmServerInstaller);
  while frmServerInstaller.ChildrenCount > 0 do
    frmServerInstaller.Children[0].Parent := tbtmServerInstaller;
end;

procedure TfrmMain.FreeClasses;
begin
  // Server Config
  serverConfig.Free;

  // RSM Config
  rsmConfig.Free;
end;

procedure TfrmMain.HideServerInfo;
begin
  if lytServerInfo.Width = 220 then
  begin
    fltnmtnServerInfoExpand.StartValue := 220;
    fltnmtnServerInfoExpand.StopValue := 0;

    fltnmtnServerInfoExpand.Start;

   // btnShowHideServerInfo.StyleLookup := 'priortoolbutton';
  end;
end;

procedure TfrmMain.InitVariables;
begin
  // Default Value
  Self.FServerInfoExpandAfter := False;
end;

procedure TfrmMain.lblAppVersionValueResized(Sender: TObject);
begin
  lytAppVersion.Width := lblAppVersionHeader.Width + 5 + lblAppVersionValue.Width;
end;

procedure TfrmMain.LoadRSMUIConfig;
begin
  // Nav - Check if nav index is within bounds before assigning
  if rsmConfig.UI.navIndex <= lstNav.Items.Count - 1 then
  begin
    lstNav.ItemIndex := rsmConfig.UI.navIndex;
  end;

  // Window
  Self.Left := rsmConfig.UI.windowPosX;
  Self.Top := rsmConfig.UI.windowPosY;
  Self.Height := Round(rsmConfig.UI.windowHeight);
  Self.Width := Round(rsmConfig.UI.windowWidth);

  // Server Info Panel
  if rsmConfig.UI.ShowServerInfoPanel then
    ShowServerInfo
  else
    HideServerInfo;
end;

procedure TfrmMain.lstNavChange(Sender: TObject);
begin
  // Check for -1 Indexes
  if lstNav.ItemIndex < -1 then
    Exit;

  // Switch to tab
  tbcNav.TabIndex := lstNav.ItemIndex;
  lblNavHeader.Text := tbcNav.Tabs[tbcNav.TabIndex].Text;

  // Save Last Index
  rsmConfig.UI.navIndex := lstNav.ItemIndex;
  rsmConfig.SaveConfig;
end;

procedure TfrmMain.mniExitRSMClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmMain.ModifyUIForRelease;
begin
  {$IFDEF RELEASE}
  // Set Default Nav Items
  tbcNav.TabPosition := TTabPosition.None;
  tbcNav.TabIndex := tbtmNavServerControls.Index;
  lstNav.ItemIndex := lstServerControls.Index;

  // Default Player Manager Items
  tbcPlayerManager.TabIndex := tbtmOnlinePlayers.Index;
  {$ENDIF}
end;

procedure TfrmMain.PopulateServerConfigUI;
begin
  // General
  edtHostnameValue.Text := serverConfig.Hostname;
  edtServerTagsValue.Text := serverConfig.Tags;
  edtServerDescriptionValue.Text := serverConfig.Description;
  edtServerURLValue.Text := serverConfig.ServerURL;
  edtServerBannerURLValue.Text := serverConfig.ServerBannerURL;
  edtAppLogoURLValue.Text := serverConfig.AppLogoURL;

  // Map
  cbbServerMap.ItemIndex := serverConfig.Map.MapIndex;
  edtCustomMapURLValue.Text := serverConfig.Map.CustomMapURL;
  nmbrbxMapSize.Value := serverConfig.Map.MapSize;
  nmbrbxMapSeed.Value := serverConfig.Map.MapSeed;

  // Misc
  spnbxMaxPlayers.Value := serverConfig.Misc.MaxPlayers;
  swtchCensorPlayerlist.IsChecked := serverConfig.Misc.CensorPlayerList;

  // Networking
  edtServerIP.Text := serverConfig.Networking.ServerIP;
  nmbrbxServerPort.Value := serverConfig.Networking.ServerPort;
  nmbrbxQueryPort.Value := serverConfig.Networking.ServerQueryPort;
  edtRconIPValue.Text := serverConfig.Networking.RconIP;
  nmbrbxRconPortValue.value := serverConfig.Networking.RconPort;
  edtRconPasswordValue.Text := serverConfig.Networking.RconPassword;
  edtAppIPValue.Text := serverConfig.Networking.AppIP;
  nmbrbxAppPortValue.Value := serverConfig.Networking.AppPort;
  edtAppPublicIPValue.Text := serverConfig.Networking.AppPublicIP;
end;

procedure TfrmMain.ResetServerInfoValues;
begin
  lblPlayerCountValue.Text := '--- / ---';
  lblQueuedValue.Text := '---';
  lblJoiningValue.Text := '---';
  lblNetworkOutValue.Text := '---b/s ↑';
  lblNetworkInValue.Text := '---b/s ↓';
  lblServerFPSValue.Text := '---';
  lblServerEntityCountValue.Text := '---';
  lblServerProtocolValue.Text := '---';
  lblServerMemoryUsageValue.Text := '---';
  lblLastWipeValue.Text := '---';
  lblServerSizeValue.Text := '---';
end;

procedure TfrmMain.ShowServerInfo;
begin
  // If the server info was not visible before editing
  // the rcon password then do not show it.
  if FServerInfoExpandAfter then
    Exit;

  if lytServerInfo.Width = 0 then
  begin
    fltnmtnServerInfoExpand.StartValue := 0;
    fltnmtnServerInfoExpand.StopValue := 220;

    fltnmtnServerInfoExpand.Start;

  //  btnShowHideServerInfo.StyleLookup := 'nexttoolbutton';
  end;
end;

procedure TfrmMain.trayIconMainClick(Sender: TObject);
begin
  Self.BringToForeground;
end;

end.

