unit ufrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Math, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  udmStyles, udmIcons, FMX.Menus, FMX.StdCtrls, FMX.MultiView,
  FMX.Controls.Presentation, FMX.Layouts, FMX.TabControl, FMX.Ani, FMX.Objects,
  FMX.ListBox, System.Rtti, FMX.Grid.Style, FMX.Grid, FMX.ScrollBox, FMX.Edit,
  FMX.SpinBox, FMX.EditBox, FMX.NumberBox, FMX.Platform.Win, Winapi.Windows,
  System.IOUtils, FMX.Memo.Types, FMX.Memo, System.Threading, FMX.Clipboard,
  FMX.Platform, sgcBase_Classes, sgcSocket_Classes, sgcTCP_Classes,
  sgcWebSocket_Classes, sgcWebSocket_Classes_Indy, sgcWebSocket_Client,
  sgcWebSocket;

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
    rctnglServerConfigControls: TRectangle;
    btnSaveServerConfig: TButton;
    tmrCheckServerRunningStatus: TTimer;
    lstMapProcedural: TListBoxItem;
    lstMapBarren: TListBoxItem;
    lstMapCraggyIsland: TListBoxItem;
    lstMapCustom: TListBoxItem;
    btnGameModeInfo: TSpeedButton;
    lstGameModeVanilla: TListBoxItem;
    lstGameModeSurvival: TListBoxItem;
    lstGameModeSoftcore: TListBoxItem;
    lstGameModeHardcore: TListBoxItem;
    lstGameModeWeapontest: TListBoxItem;
    btnServerTagsInfo: TSpeedButton;
    wsClientRcon: TsgcWebSocketClient;
    lytStatServerPID: TLayout;
    lblStatServerPIDHeader: TLabel;
    lblStatServerPIDValue: TLabel;
    lytStatRcon: TLayout;
    lblStatRconHeader: TLabel;
    lblStatRconValue: TLabel;
    tmrServerInfo: TTimer;
    procedure btnCopyRconPasswordClick(Sender: TObject);
    procedure btnForceSaveClick(Sender: TObject);
    procedure btnGameModeInfoClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGenerateMapSeedClick(Sender: TObject);
    procedure btnKillServerClick(Sender: TObject);
    procedure btnRestartServerClick(Sender: TObject);
    procedure btnSaveServerConfigClick(Sender: TObject);
    procedure btnServerTagsInfoClick(Sender: TObject);
    procedure btnShowHideServerInfoClick(Sender: TObject);
    procedure btnStartServerClick(Sender: TObject);
    procedure btnStopServerClick(Sender: TObject);
    procedure cbbServerGamemodeValueMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
    procedure cbbServerInstallerBranchMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
    procedure cbbServerMapMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
    procedure edtCustomMapURLValueEnter(Sender: TObject);
    procedure edtCustomMapURLValueExit(Sender: TObject);
    procedure edtRconPasswordValueEnter(Sender: TObject);
    procedure edtRconPasswordValueExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lblAppVersionValueResized(Sender: TObject);
    procedure lblStatRconValueResized(Sender: TObject);
    procedure lstNavChange(Sender: TObject);
    procedure mniExitRSMClick(Sender: TObject);
    procedure OnServerPIDResized(Sender: TObject);
    procedure tmrCheckServerRunningStatusTimer(Sender: TObject);
    procedure tmrServerInfoTimer(Sender: TObject);
    procedure wsClientRconConnect(Connection: TsgcWSConnection);
    procedure wsClientRconDisconnect(Connection: TsgcWSConnection; Code: Integer);
    procedure wsClientRconMessage(Connection: TsgcWSConnection; const Text: string);
  private
    { Private Variables }
    // Server Info auto expand
    FServerInfoExpandAfter: Boolean;
  private
    { Private declarations }
    // UI
    procedure LoadRSMUIConfig;
    procedure ResetServerInfoValues;

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
    procedure BringToForeground;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uServerConfig, RSM.Config, uframeMessageBox, ufrmServerInstaller,
  ufrmPlayerManager, uWinUtils, uServerProcess, RCON.Commands, RCON.Types,
  RCON.Events, RCON.Parser;

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

procedure TfrmMain.btnForceSaveClick(Sender: TObject);
begin
  TRCON.SendRconCommand('server.save', 0, wsClientRcon);
end;

procedure TfrmMain.btnGameModeInfoClick(Sender: TObject);
begin
  OpenURL('https://wiki.facepunch.com/rust/server-gamemodes');
end;

procedure TfrmMain.btnGenerateMapSeedClick(Sender: TObject);
begin
  Randomize;
  nmbrbxMapSeed.Value := RandomRange(1, 99999999);
end;

procedure TfrmMain.btnKillServerClick(Sender: TObject);
begin
  serverProcess.KillProcess;
end;

procedure TfrmMain.btnRestartServerClick(Sender: TObject);
begin
  TRCON.SendRconCommand('restart', 0, wsClientRcon);
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
  serverConfig.Map.MapName := cbbServerMap.Selected.ItemData.Detail;
  serverConfig.Map.MapIndex := cbbServerMap.ItemIndex;
  serverConfig.Map.CustomMapURL := edtCustomMapURLValue.Text;
  serverConfig.Map.MapSize := Trunc(nmbrbxMapSize.Value);
  serverConfig.Map.MapSeed := Trunc(nmbrbxMapSeed.Value);

  // Misc
  serverConfig.Misc.MaxPlayers := Trunc(spnbxMaxPlayers.Value);
  serverConfig.Misc.CensorPlayerList := swtchCensorPlayerlist.IsChecked;

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

  // GameMode
  serverConfig.GameMode.Index := cbbServerGamemodeValue.ItemIndex;
  serverConfig.GameMode.GameModeName := cbbServerGamemodeValue.Selected.ItemData.Detail;

  // Server.cfg
  serverConfig.ServerCFGText := mmoServerCFG.Text;

  try
    // Save Server Config
    serverConfig.SaveConfig;

    // Repopulate UI
    PopulateServerConfigUI;

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

procedure TfrmMain.btnServerTagsInfoClick(Sender: TObject);
begin
  OpenURL('https://wiki.facepunch.com/rust/server-browser-tags');
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

  // Check if Server is running
  if serverProcess.isRunning then
  begin
    ShowMessageBox('Server is already running with PID: ' + serverProcess.PID.ToString, 'Start Failure', Self);
    Exit;
  end;

  // Build Params
  var slParams := TStringList.Create;
  try
    // Console Mode
    slParams.Add('-batchmode -nographics -silent-crashes ^');

    // Server Identity
    slParams.Add('+server.identity "rsm" ^');

    // Server Game Mode
    slParams.Add('+server.gamemode "' + serverConfig.GameMode.GameModeName + '" ^');

    // Server Map
    if not (serverConfig.Map.MapIndex = lstMapCustom.Index) then
      slParams.Add('+server.level "' + serverConfig.Map.MapName + '" ^')
    else
      slParams.Add('+server.levelurl "' + serverConfig.Map.CustomMapURL + '" ^');
    slParams.Add('+server.seed ' + serverConfig.Map.MapSeed.ToString + ' ^');
    slParams.Add('+server.worldsize ' + serverConfig.Map.MapSize.ToString + ' ^');

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

    // Server Server and Save PID
    serverProcess.PID := CreateProcess(rustDedicatedExe, slParams.Text, serverConfig.Hostname, False);
    serverProcess.Save;
  finally
    slParams.Free;
  end;
end;

procedure TfrmMain.btnStopServerClick(Sender: TObject);
begin
  TRCON.SendRconCommand('quit', 0, wsClientRcon);
end;

procedure TfrmMain.cbbServerGamemodeValueMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
begin
  Abort;
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
  // Disconnect Rcon if connected
  if wsClientRcon.Active then
    wsClientRcon.Active := False;

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

  // Server Process
  serverProcess := TServerProcess.Create;
end;

procedure TfrmMain.CreateModules;
begin
  // Server Installer Module
  frmServerInstaller := TfrmServerInstaller.Create(tbtmServerInstaller);
  while frmServerInstaller.ChildrenCount > 0 do
    frmServerInstaller.Children[0].Parent := tbtmServerInstaller;

  // Player Manager Module
  frmPlayerManager := TfrmPlayerManager.Create(tbtmPlayerManager);
  while frmPlayerManager.ChildrenCount > 0 do
    frmPlayerManager.Children[0].Parent := tbtmPlayerManager;
end;

procedure TfrmMain.FreeClasses;
begin
  // Server Config
  serverConfig.Free;

  // RSM Config
  rsmConfig.Free;

  // Server Process
  serverProcess.Free;
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

procedure TfrmMain.lblStatRconValueResized(Sender: TObject);
begin
  lytStatRcon.Width := lblStatRconHeader.Width + 3 + lblStatRconValue.Width;
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

procedure TfrmMain.OnServerPIDResized(Sender: TObject);
begin
  // Server PID in stat bar resize
  lytServerPIDInfo.Width := lblServerPIDHeader.Width + 3 + lblServerPIDValue.Width;
  lytStatServerPID.Width := lblStatServerPIDHeader.Width + 3 + lblStatServerPIDValue.Width;
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
  if serverConfig.Map.MapIndex <= cbbServerMap.Count - 1 then // Prevent range index issues
    cbbServerMap.ItemIndex := serverConfig.Map.MapIndex
  else
    cbbServerMap.ItemIndex := lstMapProcedural.Index;
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

  // GameMode
  if serverConfig.GameMode.Index <= cbbServerGamemodeValue.Count - 1 then // Prevent range index issues
    cbbServerGamemodeValue.ItemIndex := serverConfig.GameMode.Index
  else
    cbbServerGamemodeValue.ItemIndex := lstGameModeVanilla.Index;

  // server.cfg
  mmoServerCFG.Text := serverConfig.ServerCFGText;
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

procedure TfrmMain.tmrCheckServerRunningStatusTimer(Sender: TObject);
begin
  // Check if serverProcess is assigned
  if not Assigned(serverProcess) then
    Exit;

  // Check if PID is default value
  if serverProcess.PID = -1 then
    Exit;

  { Set Running state }

  // Labels
  var isServerRunning := serverProcess.isRunning;
  if isServerRunning then
  begin
    lblServerPIDValue.Text := serverProcess.PID.ToString;
    lblStatServerPIDValue.Text := serverProcess.PID.ToString;
  end
  else
  begin
    lblServerPIDValue.Text := '---';
    lblStatServerPIDValue.Text := '---';
  end;

  // Server Controls
  btnStartServer.Enabled := not isServerRunning;
  btnKillServer.Enabled := isServerRunning;

  // Server Config
  lytServerMap1.Enabled := not isServerRunning;
  lytServerMap2.Enabled := not isServerRunning;
  lytServerNetworking1.Enabled := not isServerRunning;
  lblRconIPHeader.Enabled := not isServerRunning;
  edtRconIPValue.Enabled := not isServerRunning;
  lblRconPortHeader.Enabled := not isServerRunning;
  nmbrbxRconPortValue.Enabled := not isServerRunning;
  edtRconPasswordValue.ReadOnly := isServerRunning;
  lytServerNetworking3.Enabled := not isServerRunning;
  lytServerConfigMisc2.Enabled := not isServerRunning;

  // Rcon Connection
  btnStopServer.Enabled := wsClientRcon.Active;
  btnRestartServer.Enabled := wsClientRcon.Active;
  btnForceSave.Enabled := wsClientRcon.Active;

  // Check if server is running and rcon is connected.
  // If server is running and rcon is not connected then
  // try to connect
  if isServerRunning and not wsClientRcon.Active then
  begin
    wsClientRcon.Host := 'localhost';
    wsClientRcon.Port := serverConfig.Networking.RconPort;
    wsClientRcon.Options.Parameters := '/' + serverConfig.Networking.RconPassword;
    wsClientRcon.ConnectTimeout := 1;
    wsClientRcon.Active := True;
  end;
end;

procedure TfrmMain.tmrServerInfoTimer(Sender: TObject);
begin
  if wsClientRcon.Active then
    TRCON.SendRconCommand(RCON_CMD_SERVERINFO, RCON_ID_SERVERINFO, wsClientRcon);
end;

procedure TfrmMain.wsClientRconConnect(Connection: TsgcWSConnection);
begin
  // Stat bar
  lblStatRconValue.Text := 'Connected';
  lblStatRconValue.FontColor := TAlphaColorRec.Lime;

  // Server Info Command timer
  tmrServerInfo.Enabled := True;
end;

procedure TfrmMain.wsClientRconDisconnect(Connection: TsgcWSConnection; Code: Integer);
begin
  // Stat bar
  lblStatRconValue.Text := 'Disconnected';
  lblStatRconValue.FontColor := TAlphaColorRec.Red;

  // Server Info Command timer
  tmrServerInfo.Enabled := False;

  // Reset Server Info UI
  ResetServerInfoValues;
end;

procedure TfrmMain.wsClientRconMessage(Connection: TsgcWSConnection; const Text: string);
begin
  rconEvents.OnRconMessage(TRCONParser.ParseRconMessage(Text));
end;

end.

