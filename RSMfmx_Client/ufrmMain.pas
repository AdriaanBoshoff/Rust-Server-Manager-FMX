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
  sgcWebSocket, RSM.Core, FMX.DialogService, System.Skia, FMX.Skia,
  FMX.DateTimeCtrls, System.NetEncoding;

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
    tbtmOxideuMod: TTabItem;
    lstOxideMod: TListBoxItem;
    lblOxideMod: TLabel;
    rctnglOxideModNavImage: TRectangle;
    lytStatServerFPS: TLayout;
    lblStatServerFPSHeader: TLabel;
    lblStatServerFPSValue: TLabel;
    lytStatPlayerCount: TLayout;
    lblStatPlayerCountHeader: TLabel;
    lblStatPlayerCountValue: TLabel;
    tbtmCarbonMod: TTabItem;
    lstCarbonmod: TListBoxItem;
    lblCarbonmod: TLabel;
    rctnglCarbonmodNavImg: TRectangle;
    lstPluginManager: TListBoxItem;
    imgPluginManager: TImage;
    lblPluginManager: TLabel;
    tbtmPluginManager: TTabItem;
    mniRSM: TMenuItem;
    mniClearRSMCache: TMenuItem;
    pnlExperimentalWarning: TPanel;
    lblExperimentalWarning: TSkLabel;
    lytUpdateAvailable: TLayout;
    rctnglUpdateAvailibleBG: TRectangle;
    pnlUpdateAvailableMain: TPanel;
    tlbUpdateAvailableHeader: TToolBar;
    lblUpdateAvailable: TLabel;
    btnOpenUpdater: TButton;
    btnCloseUpdateMessage: TButton;
    lblAutoRestartHeader: TLabel;
    lytAutoRestart1: TLayout;
    lytAutoRestart2: TLayout;
    lytAutoRestart3: TLayout;
    swtchAutoRestart1: TSwitch;
    swtchAutoRestart2: TSwitch;
    swtchAutoRestart3: TSwitch;
    lblAutoRestart1Header: TLabel;
    lblAutoRestart2Header: TLabel;
    lblAutoRestart3Header: TLabel;
    tmedtAutoRestart1: TTimeEdit;
    tmedtAutoRestart2: TTimeEdit;
    tmedtAutoRestart3: TTimeEdit;
    tmrAutoRestart: TTimer;
    lblAutoRestartWarningHeader: TLabel;
    lblAutoRestartWarningHeader2: TLabel;
    lblAutoRestartWarningHeader3: TLabel;
    spnedtAutoRestartTimer1: TSpinBox;
    spnedtAutoRestartTimer2: TSpinBox;
    spnedtAutoRestartTimer3: TSpinBox;
    lblAutoRestartWarningSecs1: TLabel;
    lblAutoRestartWarningSecs2: TLabel;
    lblAutoRestartWarningSecs3: TLabel;
    lytServerNetworking4: TLayout;
    lblFavouritesListURLHeader: TLabel;
    edtFavouritesListEndpoint: TEdit;
    btnFavouritesListEndpointHelp: TEditButton;
    tbtmLogs: TTabItem;
    lstLogs: TListBoxItem;
    imgLogsIcon: TImage;
    lblLogsHeader: TLabel;
    mniServerConsole: TMenuItem;
    rctnglVersionInfo: TRectangle;
    lblServerInfoHeader: TLabel;
    lyt: TLayout;
    lblPlayerCountHeader: TLabel;
    lblPlayerCountValue: TLabel;
    lyt1: TLayout;
    lblQueuedHeader: TLabel;
    lblQueuedValue: TLabel;
    lyt2: TLayout;
    lblJoiningHeader: TLabel;
    lblJoiningValue: TLabel;
    lyt3: TLayout;
    lblNetworkInHeader: TLabel;
    lblNetworkInValue: TLabel;
    lyt4: TLayout;
    lblNetworkOutHeader: TLabel;
    lblNetworkOutValue: TLabel;
    lyt5: TLayout;
    lblServerFPSHeader: TLabel;
    lblServerFPSValue: TLabel;
    lyt6: TLayout;
    lblServerProtocolHeader: TLabel;
    lblServerProtocolValue: TLabel;
    lyt7: TLayout;
    lblServerEntityCountHeader: TLabel;
    lblServerEntityCountValue: TLabel;
    lyt8: TLayout;
    lblServerMemoryUsageHeader: TLabel;
    lblServerMemoryUsageValue: TLabel;
    lyt9: TLayout;
    lblServerSizeHeader: TLabel;
    lblServerSizeValue: TLabel;
    lyt10: TLayout;
    lblLastWipeHeader: TLabel;
    lblLastWipeValue: TLabel;
    lytStartServerWithRSM: TLayout;
    swtchStartServerWithRSM: TSwitch;
    lblStartServerWithRSM: TLabel;
    lytCheckServerUpdateBeforeStartingServer: TLayout;
    swtchUpdateServerBeforeStartingServer: TSwitch;
    lblCheckServerUpdateBeforeStartingServer: TLabel;
    lytInstallLatestOxideBeforeStartingServer: TLayout;
    swtchInstallOxideBeforeServerStart: TSwitch;
    lblInstallOxideBeforeStartingServer: TLabel;
    lytAutoStartServerAfterShutdown: TLayout;
    swtchAutoStartServerAfterShutdown: TSwitch;
    lblAutoStartServerAfterShutdown: TLabel;
    btnPreviewMap: TButton;
    rctnglServiceStatus: TRectangle;
    lblServicesStatusHeader: TLabel;
    lytMapServerStatus: TLayout;
    lblMapServerStatusHeader: TLabel;
    lblMapServerStatusValue: TLabel;
    tmrServicesStatus: TTimer;
    lytExecuteBeforeServerStart: TLayout;
    swtchExecuteBeforeServerStart: TSwitch;
    lblExecuteBeforeServerStart: TLabel;
    edtExecuteBeforeServerStart: TEdit;
    btnBrowseExecuteBeforeStart: TEllipsesEditButton;
    lytRSMAPIStatus: TLayout;
    lblRSMAPIStatusHeader: TLabel;
    lblRSMAPIStatusValue: TLabel;
    lytAutoWipe: TLayout;
    swtchEnableAutoWipe: TSwitch;
    lblAutoWiipeHeader: TLabel;
    btnConfigureAutoWipe: TButton;
    btnStartServerDebug: TButton;
    rctnglBorderTop: TRectangle;
    rctnglBorderLeft: TRectangle;
    rctnglBorderRight: TRectangle;
    lytClient: TLayout;
    rctnglBorderBottom: TRectangle;
    btnClose: TSpeedButton;
    btnMaximize: TSpeedButton;
    btnMinimize: TSpeedButton;
    lblBorderTitle: TLabel;
    imgBorderIcon: TImage;
    lnBorderTop: TLine;
    lstGameModePrimitve: TListBoxItem;
    lytServerInfoUptime: TLayout;
    lblServerInfoUptimeHeader: TLabel;
    lblServerInfoUptimeValue: TLabel;
    procedure btnAdjustAffinityClick(Sender: TObject);
    procedure btnCloseUpdateMessageClick(Sender: TObject);
    procedure btnCopyRconPasswordClick(Sender: TObject);
    procedure btnEditServerDescriptionClick(Sender: TObject);
    procedure btnFavouritesListEndpointHelpClick(Sender: TObject);
    procedure btnForceSaveClick(Sender: TObject);
    procedure btnGameModeInfoClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGenerateMapSeedClick(Sender: TObject);
    procedure btnKillServerClick(Sender: TObject);
    procedure btnOpenUpdaterClick(Sender: TObject);
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
    procedure lblExperimentalWarningWords2Click(Sender: TObject);
    procedure lblStatPlayerCountValueResized(Sender: TObject);
    procedure lblStatRconValueClick(Sender: TObject);
    procedure lblStatRconValueResized(Sender: TObject);
    procedure lblStatServerFPSValueResized(Sender: TObject);
    procedure lstNavChange(Sender: TObject);
    procedure mniClearRSMCacheClick(Sender: TObject);
    procedure mniExitRSMClick(Sender: TObject);
    procedure mniOpenServerRootClick(Sender: TObject);
    procedure mniServerConsoleClick(Sender: TObject);
    procedure mniTrayIconEnabledClick(Sender: TObject);
    procedure mniTrayIconExitRSMClick(Sender: TObject);
    procedure mniTrayIconStartServerClick(Sender: TObject);
    procedure mniTrayIconStopServerClick(Sender: TObject);
    procedure OnServerPIDResized(Sender: TObject);
    procedure spnbxMaxPlayersMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
    procedure spnedtAutoRestartTimer1Change(Sender: TObject);
    procedure spnedtAutoRestartTimer2Change(Sender: TObject);
    procedure spnedtAutoRestartTimer3Change(Sender: TObject);
    procedure swtchAutoRestart1Switch(Sender: TObject);
    procedure swtchAutoRestart2Switch(Sender: TObject);
    procedure swtchAutoRestart3Switch(Sender: TObject);
    procedure swtchAutoStartServerAfterShutdownSwitch(Sender: TObject);
    procedure swtchInstallOxideBeforeServerStartSwitch(Sender: TObject);
    procedure swtchStartServerWithRSMSwitch(Sender: TObject);
    procedure swtchUpdateServerBeforeStartingServerSwitch(Sender: TObject);
    procedure tmedtAutoRestart1Change(Sender: TObject);
    procedure tmedtAutoRestart2Change(Sender: TObject);
    procedure tmedtAutoRestart3Change(Sender: TObject);
    procedure tmrAutoRestartTimer(Sender: TObject);
    procedure tmrCheckServerRunningStatusTimer(Sender: TObject);
    procedure tmrServerInfoTimer(Sender: TObject);
    procedure wsClientRconConnect(Connection: TsgcWSConnection);
    procedure wsClientRconDisconnect(Connection: TsgcWSConnection; Code: Integer);
    procedure wsClientRconError(Connection: TsgcWSConnection; const Error: string);
    procedure wsClientRconException(Connection: TsgcWSConnection; E: Exception);
    procedure wsClientRconMessage(Connection: TsgcWSConnection; const Text: string);
    procedure FormShow(Sender: TObject);
    procedure btnAppSettingsClick(Sender: TObject);
    procedure btnPreviewMapClick(Sender: TObject);
    procedure tmrServicesStatusTimer(Sender: TObject);
    procedure OnMapServerStatusClick(Sender: TObject);
    procedure btnBrowseExecuteBeforeStartClick(Sender: TObject);
    procedure swtchExecuteBeforeServerStartSwitch(Sender: TObject);
    procedure OnRSMAPIServerStatusClick(Sender: TObject);
    procedure btnConfigureAutoWipeClick(Sender: TObject);
    procedure btnStartServerDebugClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure rctnglBorderTopMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure btnCloseClick(Sender: TObject);
    procedure btnMaximizeClick(Sender: TObject);
    procedure btnMinimizeClick(Sender: TObject);
    procedure rctnglBorderTopDblClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
  private
    { Private Const }
  private
    { Private Variables }
    // Server Info auto expand
    FServerInfoExpandAfter: Boolean;
    // Skip Update Message
    FSkipUpdateMessage: Boolean;
    // Do Auto Restart
    FDoAutoRestart: boolean;
    // OverrideClose
    FOverrideClose: Boolean;
  private
    { Private declarations }
    // UI
    procedure LoadRSMUIConfig;
    procedure ResetServerInfoValues;
    // Startup
    procedure ModifyUIForRelease;
    procedure CreateClasses;
    procedure InitVariables;
    procedure CreateModules;
    // Shutdown
    procedure FreeClasses;
    procedure HideServerInfo;
    procedure ShowServerInfo;
    // Window Border Controls
    procedure MaximizeWindow;
  public
    { Public Variables }
    MainFormCreated: Boolean;
    FServerIsStarting: Boolean;
  public
    { Public Methods }

    // Server Config
    procedure PopulateServerConfigUI;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uServerConfig, RSM.Config, uframeMessageBox, ufrmServerInstaller, uWinUtils,
  uServerProcess, RCON.Commands, RCON.Types, RCON.Events, RCON.Parser, uMisc,
  ufrmOxide, uframeServerDescriptionEditor, ufrmCarbonMod, ufrmPluginManager,
  Rest.Client, Rest.Types, uframeToastMessage, ufrmAffinitySelect, uHelpers,
  ufrmLogs, ufrmServerConsole, ufrmAutoServerStartDlg, uGlobalConst,
  ufrmSettings, udmMapServer, udmTrayIcon, udmRSMAPI, ufrmAutoWipe,
  uAutoWipeManager, ufrmConfirmCloseToTray, ufrmPlayerManager;

{$R *.fmx}

{ TfrmMain }

procedure TfrmMain.btnAdjustAffinityClick(Sender: TObject);
begin
  // Show affinity selection
  var affinityDlg := TfrmSelectAffinity.Create(Self);
 // affinityDlg.GetSavedAffinity;

  // Ok button pressed
  if affinityDlg.ShowModal = mrOk then
  begin
    // Apply Affinity
    if serverProcess.isRunning then
    begin
      var serverHandle := OpenProcess(PROCESS_ALL_ACCESS, False, serverProcess.PID);
      try
        SetProcessAffinityMask(serverHandle, CombinedProcessorMask(serverConfig.ServerAffinity));

        ShowToast('Applied server affinity!');
      finally
        CloseHandle(serverHandle);
      end;
    end
    else
    begin
      ShowToast('Affinity will be applied when the server starts.');
    end;
  end;
end;

procedure TfrmMain.btnAppSettingsClick(Sender: TObject);
begin
  frmSettings := TfrmSettings.Create(Self);
  try
    frmSettings.ShowModal;
  finally
    frmSettings.Free;
    frmSettings := nil;
  end;
end;

procedure TfrmMain.btnBrowseExecuteBeforeStartClick(Sender: TObject);
begin
  var dlg := TOpenDialog.Create(Self);
  try
    dlg.InitialDir := GetCurrentDir;
    dlg.Options := [TOpenOption.ofDontAddToRecent, TOpenOption.ofFileMustExist];

    if dlg.Execute then
    begin
      edtExecuteBeforeServerStart.Text := dlg.FileName;
      rsmConfig.Misc.ExecuteBeforeServerStartFilePath := dlg.FileName;
      rsmConfig.SaveConfig;
    end;
  finally
    dlg.Free;
  end;
end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmMain.btnCloseUpdateMessageClick(Sender: TObject);
begin
  FSkipUpdateMessage := True;
  lytUpdateAvailable.Visible := False;
  lytUpdateAvailable.SendToBack;
end;

procedure TfrmMain.btnConfigureAutoWipeClick(Sender: TObject);
begin
  var dlg := TfrmAutoWipe.Create(Self);
  try
    dlg.ShowModal;
  finally
    dlg.Free;
  end;
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

procedure TfrmMain.btnEditServerDescriptionClick(Sender: TObject);
begin
  var frameEditServerDescription := TframeServerDescriptionEditor.Create(tbtmServerConfig);
  frameEditServerDescription.Parent := tbtmServerConfig;
  frameEditServerDescription.Align := TAlignLayout.Contents;
  frameEditServerDescription.BringToFront;
end;

procedure TfrmMain.btnFavouritesListEndpointHelpClick(Sender: TObject);
begin
  OpenURL('https://wiki.facepunch.com/rust/dns-records#favoriteslist');
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

procedure TfrmMain.btnMaximizeClick(Sender: TObject);
begin
  MaximizeWindow;
end;

procedure TfrmMain.btnMinimizeClick(Sender: TObject);
begin
  if rsmConfig.TrayIcon.Enabled then
    Self.Hide
  else
    Self.WindowState := TWindowState.wsMinimized;
end;

procedure TfrmMain.btnOpenUpdaterClick(Sender: TObject);
begin
  OpenURL('https://rsm.rustservermanager.com/rsm/v3/downloadlatestversion');
end;

procedure TfrmMain.btnPreviewMapClick(Sender: TObject);
begin
  OpenURL('https://rustmaps.com/map/' + nmbrbxMapSize.Value.ToString + '_' + nmbrbxMapSeed.Value.ToString);
end;

procedure TfrmMain.btnRestartServerClick(Sender: TObject);
begin
  TRCON.SendRconCommand('restart 5', 0, wsClientRcon);
  FDoAutoRestart := True;
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
  serverConfig.Networking.FavouritesListEndpoint := edtFavouritesListEndpoint.Text;

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

    // Tell the server to load the config file
    TRCON.SendRconCommand('server.readcfg', 0, wsClientRcon);

    // ShowMessage('Config Saved!');
   // ShowMessageBox('Saved Server Config!', 'Server Config', Self);
    ShowToast('Server Config Saved');
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
  FServerIsStarting := True;
  try
    var rustDedicatedExe := ExtractFilePath(ParamStr(0)) + 'RustDedicated.exe';

  // Set this again because auto restart function changes the config value
  // when cancelled. Do not save it again.
    rsmConfig.Misc.StartServerAfterShutdown := swtchAutoStartServerAfterShutdown.IsChecked;

  // Check if server is installed
    if not TFile.Exists(rustDedicatedExe) and Assigned(Sender) and (Sender is TButton) then
    begin
      ShowMessageBox('Server not installed! Use the server installer to install the server.', 'Start Failure', Self);
      Exit;
    end;

  // Check if Server is running
    if serverProcess.isRunning and Assigned(Sender) and (Sender is TButton) then
    begin
      ShowMessageBox('Server is already running with PID: ' + serverProcess.PID.ToString, 'Start Failure', Self);
      Exit;
    end;

  // Check if server is being installed
    if frmServerInstaller.FIsInstallingServer and Assigned(Sender) and (Sender is TButton) then
    begin
      ShowToast('ERROR: Server is being installed');
      Exit;
    end;

  // Update Server
    if rsmConfig.Misc.UpdateServerBeforeServerStart then
    begin
      frmServerInstaller.btnInstallServerClick(frmServerInstaller.btnInstallServer);
    end;

  // Install Oxide / uMod
    if rsmConfig.Misc.InstallOxideBeforeServerStart then
    begin
      ShowToast('Installing the latest Oxide', 5);
      frmOxide.btnInstallUpdateClick(frmOxide.btnInstallUpdate);
      Sleep(500);
      while frmOxide.FIsInstallingOxide do
        Application.ProcessMessages;
    end;

  // Execute Before Server Start
    if rsmConfig.Misc.ExecuteBeforeServerStart then
    begin
      if not TFile.Exists(rsmConfig.Misc.ExecuteBeforeServerStartFilePath) then
      begin
        if Assigned(Sender) and (Sender is TButton) then
          ShowMessageBox('File "' + rsmConfig.Misc.ExecuteBeforeServerStartFilePath + '" does not exists. Cannot execute before server start.', 'Execute Before Start', Self);

        Exit;
      end;

      try
        CreateProcess(rsmConfig.Misc.ExecuteBeforeServerStartFilePath, '', '', True);
      except
        on E: Exception do
        begin
          if Assigned(Sender) and (Sender is TButton) then
          begin
            ShowMessage('[TfrmMain.btnStartServerClick] Failed to execute before server start. ' + E.ClassName + E.Message);
          end;
          Exit;
        end;
      end;
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
      if not serverConfig.Networking.AppPublicIP.Trim.IsEmpty then
    // Dont add if empty
        slParams.Add('+app.publicip ' + serverConfig.Networking.AppPublicIP + '');

    // Networking - Misc
      slParams.Add('+server.favoritesEndpoint "' + serverConfig.Networking.FavouritesListEndpoint + '" ^');

    // Debug Start
      if (Sender is TButton) then
      begin
      // Check if debug start button is used
        if ((Sender as TButton).Name = 'btnStartServerDebug') then
        begin
          ShowMessage('WARNING: Debug start creates a debug_start.bat and executes it. This is used for when your server does not start and just closes. Do not permanently run your server with this.');

          TFile.WriteAllText(TPath.Combine([rsmCore.Paths.GetRootDir, 'debug_start.bat']), rustDedicatedExe.QuotedString('"') + ' ' + slParams.Text + sLineBreak + 'pause');

          OpenURL(TPath.Combine([rsmCore.Paths.GetRootDir, 'debug_start.bat']));

          Exit;
        end;
      end;

    // Start Server and Save PID
      try
        serverProcess.PID := CreateProcess(rustDedicatedExe, slParams.Text, serverConfig.Hostname, False);
      except
        on E: Exception do
        begin
          ShowMessage('[TfrmMain.btnStartServerClick] Create Process Failure: ' + E.ClassName + ': ' + E.Message);
          raise E;
        end;
      end;

    // Save processs details
      try
        serverProcess.Save;
      except
        on E: Exception do
        begin
          if Assigned(Sender) then
            ShowMessage('[TfrmMain.btnStartServerClick] Failed to save process ID. ' + E.ClassName + ': ' + E.Message);
        end;
      end;

    // Apply affinity mask
      try
        var serverHandle := OpenProcess(PROCESS_ALL_ACCESS, False, serverProcess.PID);
        try
          SetProcessAffinityMask(serverHandle, CombinedProcessorMask(serverConfig.ServerAffinity));

          if Sender is TButton then
            ShowToast('Server affinity applied.');
        finally
          CloseHandle(serverHandle);
        end;
      except
        on E: Exception do
        begin
          if Assigned(Sender) then
            ShowMessage('[TfrmMain.btnStartServerClick] Failed to apply affinity mask. ' + E.ClassName + ': ' + E.Message);
        end;
      end;
    finally
      slParams.Free;
    end;
  finally
    FServerIsStarting := False;
  end;
end;

procedure TfrmMain.btnStartServerDebugClick(Sender: TObject);
begin
  btnStartServerClick(btnStartServerDebug);
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

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  // Server Size
  lblServerSizeValue.Text := ConvertBytes(GetDirSize(ExtractFileDir(ParamStr(0)), True));
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FOverrideClose then
  begin
    CanClose := True;
    Exit;
  end;

  var dlg := TfrmConfirmCloseToTray.Create(Self);
  case dlg.ShowModal of
    mrYes: // Quit App
      begin
        CanClose := True;
      end;
    mrOk: // Minimize to tray
      begin
        CanClose := False;

        if rsmConfig.TrayIcon.Enabled then
          Self.Hide
        else
          Self.WindowState := TWindowState.wsMinimized;
      end
  else
    CanClose := False;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Self.MainFormCreated := False;
  FDoAutoRestart := False;
  FSkipUpdateMessage := False;
  FServerIsStarting := False;
  FOverrideClose := False;

{$IFDEF DEBUG}
  Self.Caption := 'RSMfmx v3.1 (DEBUG BUILD)';
  lblAppVersionValue.Text := uGlobalConst.APP_VERSION + '(DEBUG)';
{$ENDIF}
{$IFDEF RELEASE}
  Self.Caption := 'RSMfmx v3.1';
  lblAppVersionValue.Text := APP_VERSION;
{$ENDIF}
  // Classes
  CreateClasses;

  // Variables
  InitVariables;

  // Modules
  CreateModules;

  // Directories
  try
    // Map Server
    ForceDirectories(rsmCore.Paths.GetMapServerDir);
  except
    on E: Exception do
    begin
      ShowMessage('Unable to create folder.' + sLineBreak + E.ClassName + ': ' + E.Message);
    end;
  end;

  // Change UI Layout for redistribution
  ModifyUIForRelease;
  ResetServerInfoValues;
  PopulateServerConfigUI;
  LoadRSMUIConfig;

  // Auto Start Server when RSM starts
  if rsmConfig.Misc.StartServerOnRSMBoot then
  begin
    // Check if server is running
    if not serverProcess.isRunning then
    begin
      TTask.Run(
        procedure
        begin
          while not frmMain.MainFormCreated do
            Sleep(1000);

          TThread.Synchronize(TThread.Current,
            procedure
            begin
              var autoStartDlg := TfrmAutoServerStartDlg.Create(Self);
              try
                case autoStartDlg.ShowModal of
                  mrOk:
                    frmMain.btnStartServerClick(btnStartServer);
                end;
              finally
                autoStartDlg.Free;
              end;
            end);
        end);
    end;
  end;

  // Should Always be last
  Self.MainFormCreated := True;
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

procedure TfrmMain.FormHide(Sender: TObject);
begin
  if rsmConfig.TrayIcon.Enabled then
    HideAppOnTaskbar;

  dmTrayIcon.trycnMain.BalloonTitle := 'RSMfmx v3.1';
  dmTrayIcon.trycnMain.BalloonHint := 'Running in background.';
  dmTrayIcon.trycnMain.ShowBalloonHint;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  ShowAppOnTaskbar;

  Self.WindowState := TWindowState.wsNormal;
end;

procedure TfrmMain.CreateClasses;
begin
  // Server Config
  serverConfig := TServerConfig.Create;

  // RSM Config
  rsmConfig := TRSMConfig.Create;

  // Server Process
  serverProcess := TServerProcess.Create;

  // Auto Wipe Manager
  autoWipeManager := TAutoWipeManager.Create;
end;

procedure TfrmMain.CreateModules;
begin
  // Tray Icon
  dmTrayIcon := TdmTrayIcon.Create(Self);

  // Server Installer Module
  frmServerInstaller := TfrmServerInstaller.Create(tbtmServerInstaller);
  while frmServerInstaller.ChildrenCount > 0 do
    frmServerInstaller.Children[0].Parent := tbtmServerInstaller;

  // Player Manager Module
  frmPlayerManager := TfrmPlayerManager.Create(tbtmPlayerManager);
  while frmPlayerManager.ChildrenCount > 0 do
    frmPlayerManager.Children[0].Parent := tbtmPlayerManager;

  // Oxide / uMod
  frmOxide := TfrmOxide.Create(tbtmOxideuMod);
  while frmOxide.ChildrenCount > 0 do
    frmOxide.Children[0].Parent := tbtmOxideuMod;

  // Carbon Mod
  frmCarbonMod := TfrmCarbonMod.Create(tbtmCarbonMod);
  while frmCarbonMod.ChildrenCount > 0 do
    frmCarbonMod.Children[0].Parent := tbtmCarbonMod;

  // Plugin Manager
  frmPluginManager := TfrmPluginManager.Create(tbtmPluginManager);
  while frmPluginManager.ChildrenCount > 0 do
    frmPluginManager.Children[0].Parent := tbtmPluginManager;

  // Logs
  frmLogs := TfrmLogs.Create(tbtmLogs);
  while frmLogs.ChildrenCount > 0 do
    frmLogs.Children[0].Parent := tbtmLogs;

  // Services - Map Service
  dmMapServer := TdmMapServer.Create(Self);

  // Services - RSM API
  dmRSMAPI := TdmRSMAPI.Create(Self);

  // Start Services Monitor
  tmrServicesStatus.Enabled := True;
end;

procedure TfrmMain.FreeClasses;
begin
  // Server Config
  serverConfig.Free;

  // RSM Config
  rsmConfig.Free;

  // Server Process
  serverProcess.Free;

  // Auto Wipe Manager
  autoWipeManager.Free;
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

procedure TfrmMain.lblExperimentalWarningWords2Click(Sender: TObject);
begin
  OpenURL('https://discord.gg/U7jsFBrgFh');
end;

procedure TfrmMain.lblStatPlayerCountValueResized(Sender: TObject);
begin
  lytStatPlayerCount.Width := lblStatPlayerCountHeader.Width + 3 + lblStatPlayerCountValue.Width;
end;

procedure TfrmMain.lblStatRconValueClick(Sender: TObject);
begin
  ShowMessageBox(lblStatRconValue.Text, 'Rcon Status Value', Self);
end;

procedure TfrmMain.lblStatRconValueResized(Sender: TObject);
begin
  lytStatRcon.Width := lblStatRconHeader.Width + 3 + lblStatRconValue.Width;
end;

procedure TfrmMain.lblStatServerFPSValueResized(Sender: TObject);
begin
  lytStatServerFPS.Width := lblStatServerFPSHeader.Width + 3 + lblStatServerFPSValue.Width;
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

  // Auto Restart
  swtchAutoRestart1.IsChecked := rsmConfig.AutoRestart.AutoRestart1.Enabled;
  swtchAutoRestart2.IsChecked := rsmConfig.AutoRestart.AutoRestart2.Enabled;
  swtchAutoRestart3.IsChecked := rsmConfig.AutoRestart.AutoRestart3.Enabled;
  tmedtAutoRestart1.Time := rsmConfig.AutoRestart.AutoRestart1.Time;
  tmedtAutoRestart2.Time := rsmConfig.AutoRestart.AutoRestart2.Time;
  tmedtAutoRestart3.Time := rsmConfig.AutoRestart.AutoRestart3.Time;
  spnedtAutoRestartTimer1.Value := rsmConfig.AutoRestart.AutoRestart1.WarningTimeSecs;
  spnedtAutoRestartTimer2.Value := rsmConfig.AutoRestart.AutoRestart2.WarningTimeSecs;
  spnedtAutoRestartTimer3.Value := rsmConfig.AutoRestart.AutoRestart3.WarningTimeSecs;

  // Server Options (Server Controls)
  swtchStartServerWithRSM.IsChecked := rsmConfig.Misc.StartServerOnRSMBoot;
  swtchUpdateServerBeforeStartingServer.IsChecked := rsmConfig.Misc.UpdateServerBeforeServerStart;
  swtchInstallOxideBeforeServerStart.IsChecked := rsmConfig.Misc.InstallOxideBeforeServerStart;
  swtchAutoStartServerAfterShutdown.IsChecked := rsmConfig.Misc.StartServerAfterShutdown;
  swtchExecuteBeforeServerStart.IsChecked := rsmConfig.Misc.ExecuteBeforeServerStart;
  edtExecuteBeforeServerStart.Text := rsmConfig.Misc.ExecuteBeforeServerStartFilePath;

  // Application Title
  Application.Title := rsmConfig.TrayIcon.AppTitle;
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

procedure TfrmMain.MaximizeWindow;
begin
  case Self.WindowState of
    TWindowState.wsNormal:
      Self.WindowState := TWindowState.wsMaximized;
    TWindowState.wsMinimized:
      Self.WindowState := TWindowState.wsMaximized;
    TWindowState.wsMaximized:
      Self.WindowState := TWindowState.wsNormal;
  end;
end;

procedure TfrmMain.mniClearRSMCacheClick(Sender: TObject);
begin
  // Delete RSM Cache Folder
  TDialogService.PreferredMode := TDialogService.TPreferredMode.Async;
  var msg := '''
  This will delete the RSM Cache folder.

  Are you sure you want to Continue?
  ''';
  TDialogService.MessageDialog(msg, TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbCancel], TMsgDlgBtn.mbYes, 0,
    procedure(const AResult: TModalResult)
    begin
      if AResult = mrYes then
      begin
        rsmCore.ClearRSMCache;
        ShowMessageBox('RSM Cache Deleted!', 'RSM Cache', Self);
      end;
    end);
end;

procedure TfrmMain.mniExitRSMClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmMain.mniOpenServerRootClick(Sender: TObject);
begin
  OpenURL(ExtractFileDir(ParamStr(0)));
end;

procedure TfrmMain.mniServerConsoleClick(Sender: TObject);
begin
  frmServerConsole.Show;
end;

procedure TfrmMain.mniTrayIconEnabledClick(Sender: TObject);
begin
  rsmConfig.TrayIcon.Enabled := not rsmConfig.TrayIcon.Enabled;
  rsmConfig.SaveConfig;
end;

procedure TfrmMain.mniTrayIconExitRSMClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmMain.mniTrayIconStartServerClick(Sender: TObject);
begin
  btnStartServerClick(btnStartServer);
end;

procedure TfrmMain.mniTrayIconStopServerClick(Sender: TObject);
begin
  btnStopServerClick(btnStopServer);
end;

procedure TfrmMain.ModifyUIForRelease;
begin
{$IFDEF RELEASE}
  // Set Default Nav Items
  tbcNav.TabPosition := TTabPosition.None;
  tbcNav.TabIndex := tbtmNavServerControls.Index;
  lstNav.ItemIndex := lstServerControls.Index;
{$ENDIF}
end;

procedure TfrmMain.OnMapServerStatusClick(Sender: TObject);
begin
  frmSettings := TfrmSettings.Create(Self);
  try
    frmSettings.tbcNav.ActiveTab := frmSettings.tbtmServices;
    frmSettings.tbcServices.ActiveTab := frmSettings.tbtmMapServer;
    frmSettings.tvNav.Selected := frmSettings.tviMapServer;
    frmSettings.ShowModal;
  finally
    frmSettings.Free;
    frmSettings := nil;
  end;
end;

procedure TfrmMain.OnRSMAPIServerStatusClick(Sender: TObject);
begin
  frmSettings := TfrmSettings.Create(Self);
  try
    frmSettings.tbcNav.ActiveTab := frmSettings.tbtmServices;
    frmSettings.tbcServices.ActiveTab := frmSettings.tbtmRSMAPI;
    frmSettings.tvNav.Selected := frmSettings.tviRSMAPI;
    frmSettings.ShowModal;
  finally
    frmSettings.Free;
    frmSettings := nil;
  end;
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
  if serverConfig.Map.MapIndex <= cbbServerMap.Count - 1 then
  // Prevent range index issues
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
  nmbrbxRconPortValue.Value := serverConfig.Networking.RconPort;
  edtRconPasswordValue.Text := serverConfig.Networking.RconPassword;
  edtAppIPValue.Text := serverConfig.Networking.AppIP;
  nmbrbxAppPortValue.Value := serverConfig.Networking.AppPort;
  edtAppPublicIPValue.Text := serverConfig.Networking.AppPublicIP;
  edtFavouritesListEndpoint.Text := serverConfig.Networking.FavouritesListEndpoint;

  // GameMode
  if serverConfig.GameMode.Index <= cbbServerGamemodeValue.Count - 1 then
  // Prevent range index issues
    cbbServerGamemodeValue.ItemIndex := serverConfig.GameMode.Index
  else
    cbbServerGamemodeValue.ItemIndex := lstGameModeVanilla.Index;

  // server.cfg
  mmoServerCFG.Text := serverConfig.ServerCFGText;
end;

procedure TfrmMain.rctnglBorderTopDblClick(Sender: TObject);
begin
  TTask.Run(
    procedure
    begin
      // Delay by 100ms because it tries to maximize it while clicking
      // fucking with the form position
      Sleep(100);

      TThread.ForceQueue(TThread.CurrentThread,
        procedure
        begin
          Self.MaximizeWindow;
        end);
    end);
end;

procedure TfrmMain.rctnglBorderTopMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if Button = TMouseButton.mbLeft then
  begin
    if Self.WindowState = TWindowState.wsMaximized then
      Self.WindowState := TWindowState.wsNormal;

    StartWindowDrag;
  end;
end;

procedure TfrmMain.ResetServerInfoValues;
begin
  // Side Panel
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

  // Stat Bar
  lblStatServerFPSValue.Text := '---';
  lblStatPlayerCountValue.Text := '--- / ---';
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

    // btnShowHideServerInfo.StyleLookup := 'nexttoolbutton';
  end;
end;

procedure TfrmMain.spnbxMaxPlayersMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
begin
  Abort;
end;

procedure TfrmMain.spnedtAutoRestartTimer1Change(Sender: TObject);
begin
  rsmConfig.AutoRestart.AutoRestart1.WarningTimeSecs := Trunc(spnedtAutoRestartTimer1.Value);
  rsmConfig.SaveConfig;
end;

procedure TfrmMain.spnedtAutoRestartTimer2Change(Sender: TObject);
begin
  rsmConfig.AutoRestart.AutoRestart2.WarningTimeSecs := Trunc(spnedtAutoRestartTimer2.Value);
  rsmConfig.SaveConfig;
end;

procedure TfrmMain.spnedtAutoRestartTimer3Change(Sender: TObject);
begin
  rsmConfig.AutoRestart.AutoRestart3.WarningTimeSecs := Trunc(spnedtAutoRestartTimer3.Value);
  rsmConfig.SaveConfig;
end;

procedure TfrmMain.swtchAutoRestart1Switch(Sender: TObject);
begin
  rsmConfig.AutoRestart.AutoRestart1.Enabled := swtchAutoRestart1.IsChecked;
  rsmConfig.SaveConfig;
end;

procedure TfrmMain.swtchAutoRestart2Switch(Sender: TObject);
begin
  rsmConfig.AutoRestart.AutoRestart2.Enabled := swtchAutoRestart2.IsChecked;
  rsmConfig.SaveConfig;
end;

procedure TfrmMain.swtchAutoRestart3Switch(Sender: TObject);
begin
  rsmConfig.AutoRestart.AutoRestart3.Enabled := swtchAutoRestart3.IsChecked;
  rsmConfig.SaveConfig;
end;

procedure TfrmMain.swtchAutoStartServerAfterShutdownSwitch(Sender: TObject);
begin
  rsmConfig.Misc.StartServerAfterShutdown := swtchAutoStartServerAfterShutdown.IsChecked;
  rsmConfig.SaveConfig;
end;

procedure TfrmMain.swtchExecuteBeforeServerStartSwitch(Sender: TObject);
begin
  rsmConfig.Misc.ExecuteBeforeServerStart := swtchExecuteBeforeServerStart.IsChecked;
  rsmConfig.SaveConfig;
end;

procedure TfrmMain.swtchInstallOxideBeforeServerStartSwitch(Sender: TObject);
begin
  rsmConfig.Misc.InstallOxideBeforeServerStart := swtchInstallOxideBeforeServerStart.IsChecked;
  rsmConfig.SaveConfig;
end;

procedure TfrmMain.swtchStartServerWithRSMSwitch(Sender: TObject);
begin
  rsmConfig.Misc.StartServerOnRSMBoot := swtchStartServerWithRSM.IsChecked;
  rsmConfig.SaveConfig;
end;

procedure TfrmMain.swtchUpdateServerBeforeStartingServerSwitch(Sender: TObject);
begin
  rsmConfig.Misc.UpdateServerBeforeServerStart := swtchUpdateServerBeforeStartingServer.IsChecked;
  rsmConfig.SaveConfig;
end;

procedure TfrmMain.tmedtAutoRestart1Change(Sender: TObject);
begin
  rsmConfig.AutoRestart.AutoRestart1.Time := tmedtAutoRestart1.Time;
  rsmConfig.SaveConfig;
end;

procedure TfrmMain.tmedtAutoRestart2Change(Sender: TObject);
begin
  rsmConfig.AutoRestart.AutoRestart2.Time := tmedtAutoRestart2.Time;
  rsmConfig.SaveConfig;
end;

procedure TfrmMain.tmedtAutoRestart3Change(Sender: TObject);
begin
  rsmConfig.AutoRestart.AutoRestart3.Time := tmedtAutoRestart3.Time;
  rsmConfig.SaveConfig;
end;

procedure TfrmMain.tmrAutoRestartTimer(Sender: TObject);
begin
  if FDoAutoRestart then
    Exit;

  if rsmConfig.AutoRestart.AutoRestart1.Enabled then
  begin
    if not (FormatDateTime('hh:nn', Now) = FormatDateTime('hh:nn', rsmConfig.AutoRestart.AutoRestart1.Time)) then
      Exit;

    wsClientRcon.SendRconCommand('restart ' + rsmConfig.AutoRestart.AutoRestart1.WarningTimeSecs.ToString);
    FDoAutoRestart := True;
  end
  else if rsmConfig.AutoRestart.AutoRestart2.Enabled then
  begin
    if not (FormatDateTime('hh:nn', Now) = FormatDateTime('hh:nn', rsmConfig.AutoRestart.AutoRestart2.Time)) then
      Exit;

    wsClientRcon.SendRconCommand('restart ' + rsmConfig.AutoRestart.AutoRestart2.WarningTimeSecs.ToString);
    FDoAutoRestart := True;
  end
  else if rsmConfig.AutoRestart.AutoRestart3.Enabled then
  begin
    if not (FormatDateTime('hh:nn', Now) = FormatDateTime('hh:nn', rsmConfig.AutoRestart.AutoRestart3.Time)) then
      Exit;

    wsClientRcon.SendRconCommand('restart ' + rsmConfig.AutoRestart.AutoRestart3.WarningTimeSecs.ToString);
    FDoAutoRestart := True;
  end;
end;

procedure TfrmMain.tmrCheckServerRunningStatusTimer(Sender: TObject);
begin
  tmrCheckServerRunningStatus.Enabled := False;
  try
    // Check if serverProcess is assigned
    if not Assigned(serverProcess) then
      Exit;

    //  // Check if PID is default value
    //  if serverProcess.PID = -1 then
    //    Exit;

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
    btnStartServerDebug.Enabled := not isServerRunning;
    btnKillServer.Enabled := isServerRunning;

    // Rcon Connection
    btnStopServer.Enabled := wsClientRcon.Active;
    btnRestartServer.Enabled := wsClientRcon.Active;
    btnForceSave.Enabled := wsClientRcon.Active;

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

    // Oxide Module
    frmOxide.rctnglHeader.Enabled := not isServerRunning;
    frmOxide.rctnglSettings.Enabled := not isServerRunning;
    // Cabon Module
    frmCarbonMod.rctnglHeader.Enabled := not isServerRunning;

    // Check if server is running and rcon is connected.
    // If server is running and rcon is not connected then
    // try to connect
    if isServerRunning and not wsClientRcon.Active then
    begin
      if serverConfig.Networking.RconIP = '0.0.0.0' then
        wsClientRcon.Host := 'localhost'
      else
        wsClientRcon.Host := serverConfig.Networking.RconIP;

      wsClientRcon.Port := serverConfig.Networking.RconPort;
      wsClientRcon.Options.Parameters := '/' + TNetEncoding.URL.Encode(serverConfig.Networking.RconPassword);
      wsClientRcon.ConnectTimeout := 5;
      wsClientRcon.Active := True;
    end;

    // Auto Restart
    if not serverProcess.isRunning and not FServerIsStarting then
    begin
      if FDoAutoRestart or rsmConfig.Misc.StartServerAfterShutdown then
      begin
        var autoStartDlg := TfrmAutoServerStartDlg.Create(Self);
        try
          case autoStartDlg.ShowModal of
            mrOk:
              begin
                btnStartServerClick(btnStartServer);
                FDoAutoRestart := False;
              end;
            mrCancel:
              begin
                FDoAutoRestart := False;
                rsmConfig.Misc.StartServerAfterShutdown := False;
              end;
          end;
        finally
          autoStartDlg.Free;
        end;
      end;
    end;
  finally
    tmrCheckServerRunningStatus.Enabled := True;
  end;
end;

procedure TfrmMain.tmrServerInfoTimer(Sender: TObject);
begin
  // Request Server Info
  if wsClientRcon.Active then
    TRCON.SendRconCommand(RCON_CMD_SERVERINFO, RCON_ID_SERVERINFO, wsClientRcon);
end;

procedure TfrmMain.tmrServicesStatusTimer(Sender: TObject);
begin
  // Services Status

  // Map Server
  if dmMapServer.isRunning then
  begin
    lblMapServerStatusValue.Text := 'Online';
    lblMapServerStatusValue.FontColor := TAlphaColorRec.Lime;
  end
  else
  begin
    lblMapServerStatusValue.Text := 'Offline';
    lblMapServerStatusValue.FontColor := TAlphaColorRec.Red;
  end;

  // RSM API
  if dmRSMAPI.isRunning then
  begin
    lblRSMAPIStatusValue.Text := 'Online';
    lblRSMAPIStatusValue.FontColor := TAlphaColorRec.Lime;
  end
  else
  begin
    lblRSMAPIStatusValue.Text := 'Offline';
    lblRSMAPIStatusValue.FontColor := TAlphaColorRec.Red;
  end;
end;

procedure TfrmMain.wsClientRconConnect(Connection: TsgcWSConnection);
begin
  // Stat bar
  lblStatRconValue.Text := 'Connected';
  lblStatRconValue.FontColor := TAlphaColorRec.Lime;

  // Server Info Command timer
  tmrServerInfo.Enabled := True;

  // Auto Restart Timer
  FDoAutoRestart := False;
  tmrAutoRestart.Enabled := True;

  // Get Manifest
  wsClientRcon.SendRconCommand(RCON_CMD_PRINTMANIFEST, RCON_ID_MANIFEST);
end;

procedure TfrmMain.wsClientRconDisconnect(Connection: TsgcWSConnection; Code: Integer);
begin
  // Stat bar
  lblStatRconValue.Text := 'Disconnected';
  lblStatRconValue.FontColor := TAlphaColorRec.Red;

  // Server Info Command timer
  tmrServerInfo.Enabled := False;

  // Auto Restart Timer
  tmrAutoRestart.Enabled := False;

  // Reset Server Info UI
  ResetServerInfoValues;

  // Clear Online Players
end;

procedure TfrmMain.wsClientRconError(Connection: TsgcWSConnection; const Error: string);
begin
  lblStatRconValue.Text := 'Err: ' + Error;
end;

procedure TfrmMain.wsClientRconException(Connection: TsgcWSConnection; E: Exception);
begin
  if E.Message.ToLower.Contains('closed gracefully') then
    lblStatRconValue.Text := 'Invalid rcon Password. Only use A-z and 0-9 chars!'
  else if E.Message.ToLower.Contains('timed out') then
    lblStatRconValue.Text := 'Waiting rcon server to start...'
  else
    lblStatRconValue.Text := 'Connection Failure: ' + E.ClassName + ': ' + E.Message;
end;

procedure TfrmMain.wsClientRconMessage(Connection: TsgcWSConnection; const Text: string);
begin
  rconEvents.OnRconMessage(TRCONParser.ParseRconMessage(Text));
end;

end.

