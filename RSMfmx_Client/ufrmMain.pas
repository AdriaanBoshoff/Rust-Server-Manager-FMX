unit ufrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Math, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  udmStyles, udmIcons, FMX.Menus, FMX.StdCtrls, FMX.MultiView,
  FMX.Controls.Presentation, FMX.Layouts, FMX.TabControl, FMX.Ani, FMX.Objects,
  FMX.ListBox, System.Rtti, FMX.Grid.Style, FMX.Grid, FMX.ScrollBox, FMX.Edit,
  FMX.SpinBox, FMX.EditBox, FMX.NumberBox, FMX.Trayicon.Win, FMX.Platform.Win,
  Winapi.Windows, System.IOUtils, FMX.Memo.Types, FMX.Memo;

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
    tbcPlayerManager: TTabControl;
    tbtmOnlinePlayers: TTabItem;
    tbtmBannedPlayers: TTabItem;
    tbtmPlayerReports: TTabItem;
    tbtmPlayerDatabase: TTabItem;
    rctnglOnlinePlayersHeader: TRectangle;
    edtSearchOnlinePlayers: TEdit;
    btnRefreshOnlinePlayers: TSpeedButton;
    vrtscrlbxOnlinePlayers: TVertScrollBox;
    vrtscrlbxServerInfo: TVertScrollBox;
    mmoServerCFG: TMemo;
    btnEditRadioList: TButton;
    btnEditEmojis: TButton;
    rctnglServerConfigControls: TRectangle;
    btnSaveServerConfig: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure btnGenerateMapSeedClick(Sender: TObject);
    procedure btnSaveServerConfigClick(Sender: TObject);
    procedure btnShowHideServerInfoClick(Sender: TObject);
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
    procedure ResetServerInfoValues;
    procedure BringToForeground;
    // Startup
    procedure ModifyUIForRelease;
    procedure CreateClasses;
    procedure InitVariables;
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
  uServerConfig;

{$R *.fmx}

{ TfrmMain }

procedure TfrmMain.BringToForeground;
begin
  SetForegroundWindow(ApplicationHWND);
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

    ShowMessage('Config Saved!');
  except
    on E: Exception do
    begin
      serverConfig.LoadConfig; // Reset Config class if failed to save
      ShowMessage('Error saving config.' + sLineBreak + E.Message);
    end;
  end;
end;

procedure TfrmMain.btnShowHideServerInfoClick(Sender: TObject);
begin
  // Expand
  if lytServerInfo.Width = 0 then
    ShowServerInfo;

  // Collapse
  if lytServerInfo.Width = 220 then
    HideServerInfo;
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
  // Classes
  CreateClasses;

  // Variables
  InitVariables;

  // Change UI Layout for redistribution
  ModifyUIForRelease;
  ResetServerInfoValues;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  // Classes
  FreeClasses;
end;

procedure TfrmMain.CreateClasses;
begin
  // Server Config
  serverConfig := TServerConfig.Create;
end;

procedure TfrmMain.FreeClasses;
begin
  // Server Config
  serverConfig.Free;
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

procedure TfrmMain.lstNavChange(Sender: TObject);
begin
  // Check for -1 Indexes
  if lstNav.ItemIndex < -1 then
    Exit;

  // Switch to tab
  tbcNav.TabIndex := lstNav.ItemIndex;
  lblNavHeader.Text := tbcNav.Tabs[tbcNav.TabIndex].Text;
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

