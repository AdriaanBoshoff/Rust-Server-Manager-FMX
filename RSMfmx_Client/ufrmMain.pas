unit ufrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Menus, FMX.StdCtrls, FMX.MultiView, FMX.Controls.Presentation, FMX.Layouts,
  FMX.TabControl, FMX.Ani, FMX.Objects, FMX.ListBox, System.Rtti,
  FMX.Grid.Style, FMX.Grid, FMX.ScrollBox, FMX.Edit, FMX.SpinBox,
  FMX.EditBox, FMX.NumberBox;

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
    lytMaxPlayers: TLayout;
    lblMaxPlayers: TLabel;
    spnbxMaxPlayers: TSpinBox;
    lblCensorPlayerList: TLabel;
    swtchCensorPlayerlist: TSwitch;
    lytServerGamemode: TLayout;
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
    procedure btnShowHideServerInfoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstNavChange(Sender: TObject);
  private
    { Private declarations }
    procedure ModifyUIForRelease;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

procedure TfrmMain.btnShowHideServerInfoClick(Sender: TObject);
begin
  // Expand
  if lytServerInfo.Width = 0 then
  begin
    fltnmtnServerInfoExpand.StartValue := 0;
    fltnmtnServerInfoExpand.StopValue := 200;

    fltnmtnServerInfoExpand.Start;

    btnShowHideServerInfo.StyleLookup := 'nexttoolbutton';

    Exit;
  end;

  // Collapse
  if lytServerInfo.Width = 200 then
  begin
    fltnmtnServerInfoExpand.StartValue := 200;
    fltnmtnServerInfoExpand.StopValue := 0;

    fltnmtnServerInfoExpand.Start;

    btnShowHideServerInfo.StyleLookup := 'priortoolbutton';

    Exit;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // Change UI Layout for redistribution
  ModifyUIForRelease;
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

{ TfrmMain }

procedure TfrmMain.ModifyUIForRelease;
begin
  {$IFDEF RELEASE}
  // Set Default Nav Items
  tbcNav.TabPosition := TTabPosition.None;
  tbcNav.TabIndex := tbtmNavServerControls.Index;
  lstNav.ItemIndex := lstServerControls.Index;
  {$ENDIF}
end;

end.

