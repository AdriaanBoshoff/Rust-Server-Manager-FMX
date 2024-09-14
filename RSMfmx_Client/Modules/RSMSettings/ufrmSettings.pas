unit ufrmSettings;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.TreeView, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.TabControl, FMX.Edit, FMX.EditBox, FMX.NumberBox, udmMapServer, ufrmMain,
  udmTrayIcon, FMX.ListBox, udmRSMAPI;

type
  TfrmSettings = class(TForm)
    tvNav: TTreeView;
    tbcNav: TTabControl;
    tviAPISettings: TTreeViewItem;
    tviSteamAPI: TTreeViewItem;
    tviRustMapsAPI: TTreeViewItem;
    tviModAPI: TTreeViewItem;
    pnlFooter: TPanel;
    tbtmAPISettings: TTabItem;
    btnSave: TButton;
    btnCancel: TButton;
    tbtmSteamAPI: TTabItem;
    tbtmRustMapsAPI: TTabItem;
    tbtmuModAPI: TTabItem;
    lblSteamAPIDescription: TLabel;
    lytSteamAPIKey: TLayout;
    lblSteamAPIKeyHeader: TLabel;
    edtSteamAPIKeyValue: TEdit;
    btnGetSteamAPIKey: TButton;
    lblRustMapsAPIDescription: TLabel;
    lytRustMapsAPIKey: TLayout;
    lblRustMapsAPIKeyHeader: TLabel;
    edtRustMapsAPIKeyValue: TEdit;
    btnGetRustMapsAPI: TButton;
    lbluModAPIDescription: TLabel;
    lytuModLogin: TLayout;
    lbluModAPIDescription2: TLabel;
    btnuModLogin: TButton;
    lblViewuModLoginSourceCode: TLabel;
    tbcAPISettings: TTabControl;
    tviCodeFlingAPI: TTreeViewItem;
    tbtmCodeflingAPI: TTabItem;
    lblCodeflingAPIDescription: TLabel;
    tlbSteamAPIHeader: TToolBar;
    lblSteamAPIHeader: TLabel;
    tlbRustMapsAPIHeader: TToolBar;
    lblRustMapsAPIHeader: TLabel;
    tlbuModAPIHeader: TToolBar;
    lbluModAPIHeader: TLabel;
    tlbCodeflingAPIHeader: TToolBar;
    lblCodeflingAPIHeader: TLabel;
    tviServices: TTreeViewItem;
    tviMapServer: TTreeViewItem;
    tbtmServices: TTabItem;
    tbcServices: TTabControl;
    tbtmMapServer: TTabItem;
    tlbMapServerHeader: TToolBar;
    lblMapServerHeader: TLabel;
    lblMapServerDescription: TLabel;
    vrtscrlbxMapServer: TVertScrollBox;
    lytMapServerIP: TLayout;
    lblMapServerIPHeader: TLabel;
    edtMapServerListenIP: TEdit;
    lblMapServerPortHeader: TLabel;
    nmbrbxMapServerPort: TNumberBox;
    lytMapServerControls: TLayout;
    btnStartStopMapServer: TButton;
    chkMapServerAutoStart: TCheckBox;
    lytMapServerButtons: TLayout;
    btnOpenMapServerFolder: TButton;
    lytMapServerExampleLink: TLayout;
    lblMapServerLinkHeader: TLabel;
    edtMapServerExampleLink: TEdit;
    lblMapServerExpl: TLabel;
    lblMapServerPortTCPDescription: TLabel;
    tviRSMSettings: TTreeViewItem;
    tbtmRSMSettings: TTabItem;
    tbcRSMSettings: TTabControl;
    tbtmTrayIconSettings: TTabItem;
    tviTrayIconSettings: TTreeViewItem;
    lytApplicationTitle: TLayout;
    lblApplicationTitleDescription: TLabel;
    edtApplicationTitleValue: TEdit;
    grpTrayIcon: TGroupBox;
    lytEnableTrayIcon: TLayout;
    chkEnableTrayIcon: TCheckBox;
    lytTrayIconTitle: TLayout;
    lblTrayIconTitleHeader: TLabel;
    edtTrayIconTitleValue: TEdit;
    tviRSMAPI: TTreeViewItem;
    tbtmRSMAPI: TTabItem;
    tlbRSMAPIHeader: TToolBar;
    lblRSMAPIHeader: TLabel;
    lblRSMAPIDescription: TLabel;
    lstRSMAPISettings: TListBox;
    lstRSMAPIServerSettings: TListBoxGroupHeader;
    lstRSMAPIServerHost: TListBoxItem;
    lstRSMAPIServerPort: TListBoxItem;
    lytRSMAPIServerControls: TLayout;
    btnStartStopRSMAPIServer: TButton;
    chkRSMAPIAutoStart: TCheckBox;
    lstRSMAPIServerAuthSettings: TListBoxGroupHeader;
    lstRSMAPIKey: TListBoxItem;
    lstRSMAPIServerTLSSettings: TListBoxGroupHeader;
    lstRSMAPITLSEnabled: TListBoxItem;
    lstRSMAPITLSCertFile: TListBoxItem;
    lstRSMAPITLSCertKey: TListBoxItem;
    edtRSMAPIHost: TEdit;
    nmbrbxRSMAPIPort: TNumberBox;
    edtRSMAPIKey: TEdit;
    btnGenerateAPIKey: TSpeedButton;
    swtchRSMAPITLSEnabled: TSwitch;
    edtRSMAPICertFile: TEdit;
    edtRSMAPIKeyFile: TEdit;
    btnBrowserRSMAPICertFile: TEllipsesEditButton;
    btnBrowseRSMAPIKeyFile: TEllipsesEditButton;
    lblRSMAPIDocumentation: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure tvNavChange(Sender: TObject);
    procedure btnuModLoginClick(Sender: TObject);
    procedure lblViewuModLoginSourceCodeClick(Sender: TObject);
    procedure btnGetRustMapsAPIClick(Sender: TObject);
    procedure btnGetSteamAPIKeyClick(Sender: TObject);
    procedure btnOpenMapServerFolderClick(Sender: TObject);
    procedure btnStartStopMapServerClick(Sender: TObject);
    procedure btnBrowserRSMAPICertFileClick(Sender: TObject);
    procedure btnBrowseRSMAPIKeyFileClick(Sender: TObject);
    procedure btnStartStopRSMAPIServerClick(Sender: TObject);
    procedure btnGenerateAPIKeyClick(Sender: TObject);
    procedure lblRSMAPIDocumentationClick(Sender: TObject);
  private
    { Private declarations }
    FuModSessionToken: string;
    procedure PopulateConfig;
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

uses
  RSM.Config, uWinUtils, System.IOUtils, RSM.Core, Rest.Client, WinAPI.Windows,
  uHelpers;

{$R *.fmx}

function GetuModLoginSession: PWChar; stdcall; external 'uModLoginHelper.dll';

procedure TfrmSettings.btnBrowserRSMAPICertFileClick(Sender: TObject);
begin
  var dlg := TOpenDialog.Create(Self);
  try
    dlg.Title := 'Select .crt file';
    dlg.Filter := 'Certificate File | *.crt';
    dlg.Options := [TOpenOption.ofFileMustExist, TOpenOption.ofDontAddToRecent];

    if dlg.Execute then
      edtRSMAPICertFile.Text := dlg.FileName;
  finally
    dlg.Free;
  end;
end;

procedure TfrmSettings.btnBrowseRSMAPIKeyFileClick(Sender: TObject);
begin
  var dlg := TOpenDialog.Create(Self);
  try
    dlg.Title := 'Select .key file';
    dlg.Filter := 'Certificate Key File | *.key';
    dlg.Options := [TOpenOption.ofFileMustExist, TOpenOption.ofDontAddToRecent];

    if dlg.Execute then
      edtRSMAPIKeyFile.Text := dlg.FileName;
  finally
    dlg.Free;
  end;
end;

procedure TfrmSettings.btnCancelClick(Sender: TObject);
begin
  rsmConfig.LoadConfig;
  Self.ModalResult := mrCancel;
end;

procedure TfrmSettings.btnGenerateAPIKeyClick(Sender: TObject);
begin
  edtRSMAPIKey.Text := GenerateAPIKey;
end;

procedure TfrmSettings.btnGetRustMapsAPIClick(Sender: TObject);
begin
  OpenURL('https://rustmaps.com/dashboard');
end;

procedure TfrmSettings.btnGetSteamAPIKeyClick(Sender: TObject);
begin
  OpenURL('https://steamcommunity.com/dev/apikey');
end;

procedure TfrmSettings.btnOpenMapServerFolderClick(Sender: TObject);
begin
  OpenURL(rsmCore.Paths.GetMapServerDir);
end;

procedure TfrmSettings.btnSaveClick(Sender: TObject);
begin
  // APIs
  rsmConfig.APIKeys.SteamAPIKey := edtSteamAPIKeyValue.Text;
  rsmConfig.APIKeys.RustMapsAPIKey := edtRustMapsAPIKeyValue.Text;
  rsmConfig.LoginTokens.uModToken := FuModSessionToken;

  // Services - Map Server
  rsmConfig.Services.MapServer.Port := Trunc(nmbrbxMapServerPort.Value);
  rsmConfig.Services.MapServer.IP := edtMapServerListenIP.Text;
  rsmConfig.Services.MapServer.AutoStart := chkMapServerAutoStart.IsChecked;

  // Services - RSM API
  rsmConfig.Services.RSMAPI.Host := edtRSMAPIHost.Text;
  rsmConfig.Services.RSMAPI.Port := Round(nmbrbxRSMAPIPort.Value);
  rsmConfig.Services.RSMAPI.TLSEnabled := swtchRSMAPITLSEnabled.IsChecked;
  rsmConfig.Services.RSMAPI.TLSCertFile := edtRSMAPICertFile.Text;
  rsmConfig.Services.RSMAPI.TLSKeyFile := edtRSMAPIKeyFile.Text;
  rsmConfig.Services.RSMAPI.APIKey := edtRSMAPIKey.Text;
  rsmConfig.Services.RSMAPI.AutoStart := chkRSMAPIAutoStart.IsChecked;

  // Title and Tray Icon
  rsmConfig.TrayIcon.AppTitle := edtApplicationTitleValue.Text;
  rsmConfig.TrayIcon.Enabled := chkEnableTrayIcon.IsChecked;
  rsmConfig.TrayIcon.Title := edtTrayIconTitleValue.Text;
  rsmConfig.SaveConfig;

  // Title & Tray Icon
  frmMain.Caption := rsmConfig.TrayIcon.AppTitle;
  Application.Title := rsmConfig.TrayIcon.AppTitle;
  dmTrayIcon.trycnMain.Visible := rsmConfig.TrayIcon.Enabled;
  dmTrayIcon.trycnMain.Hint := rsmConfig.TrayIcon.Title;

  // Restart RSMAPI if running
  if dmRSMAPI.isRunning then
  begin
    dmRSMAPI.Stop;
    dmRSMAPI.Start;
  end;

  // Restart Map Server if running
  if dmMapServer.isRunning then
  begin
    dmMapServer.StopServer;
    dmMapServer.StartServer;
  end;

  Self.ModalResult := mrOk;
end;

procedure TfrmSettings.btnStartStopMapServerClick(Sender: TObject);
begin
  if dmMapServer.isRunning then
    dmMapServer.StopServer
  else
    dmMapServer.StartServer;

  if dmMapServer.isRunning then
  begin
    btnStartStopMapServer.Text := 'Stop Server';
    btnStartStopMapServer.TintColor := TAlphaColorRec.Darkred;
  end
  else
  begin
    btnStartStopMapServer.Text := 'Start Server';
    btnStartStopMapServer.TintColor := TAlphaColorRec.Green;
  end;

  edtMapServerListenIP.Enabled := not dmMapServer.isRunning;
  nmbrbxMapServerPort.Enabled := not dmMapServer.isRunning;
end;

procedure TfrmSettings.btnStartStopRSMAPIServerClick(Sender: TObject);
begin
  if dmRSMAPI.isRunning then
    dmRSMAPI.Stop
  else
    dmRSMAPI.Start;

  if dmRSMAPI.isRunning then
  begin
    btnStartStopRSMAPIServer.Text := 'Stop Server';
    btnStartStopRSMAPIServer.TintColor := TAlphaColorRec.Darkred;
  end
  else
  begin
    btnStartStopRSMAPIServer.Text := 'Start Server';
    btnStartStopRSMAPIServer.TintColor := TAlphaColorRec.Green;
  end;

  lstRSMAPISettings.Enabled := not dmRSMAPI.isRunning;
end;

procedure TfrmSettings.btnuModLoginClick(Sender: TObject);
begin
  // uMod login
  if not rsmConfig.LoginTokens.uModToken.Trim.IsEmpty then
  begin
    btnuModLogin.Text := 'uMod.org Login';
    rsmConfig.LoginTokens.uModToken := '';
    Exit;
  end;

  if not isWebView2RuntimeInstalled then
  begin
    ShowMessage('WebView2 is missing and will now be installed.');
    Application.ProcessMessages;

    var webViewPath := TPath.Combine([rsmCore.Paths.GetRootDir, 'webView2Installer.exe']);

    var memStream := TMemoryStream.Create;
    try
      TDownloadURL.DownloadRawBytes('https://go.microsoft.com/fwlink/p/?LinkId=2124703', memStream);

      memStream.SaveToFile(webViewPath);
    finally
      memStream.Free;
    end;

    Application.ProcessMessages;

    uWinUtils.CreateProcess(webViewPath, '', '', True);

    TFile.Delete(webViewPath);

    FuModSessionToken := GetuModLoginSession;
  end
  else
  begin
    FuModSessionToken := GetuModLoginSession;
  end;

  // uMod login
  if rsmConfig.LoginTokens.uModToken.Trim.IsEmpty then
    btnuModLogin.Text := 'uMod.org Login'
  else
    btnuModLogin.Text := 'Logout uMod.org';
end;

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  {$IFDEF RELEASE}
  tbcNav.TabPosition := TTabPosition.None;
  tbcAPISettings.TabPosition := TTabPosition.None;
  tbcServices.TabPosition := TTabPosition.None;
  tbcRSMSettings.TabPosition := TTabPosition.None;
  {$ENDIF}

  tbcNav.TabIndex := -1;
  tbcAPISettings.TabIndex := -1;

  PopulateConfig;
end;

procedure TfrmSettings.lblRSMAPIDocumentationClick(Sender: TObject);
begin
  OpenURL('https://github.com/RustServerManager/RSMfmx_v3.1_API-Docs/blob/main/README.md');
end;

procedure TfrmSettings.lblViewuModLoginSourceCodeClick(Sender: TObject);
begin
  OpenURL('https://github.com/RustServerManager/uMod-Login-Helper');
end;

procedure TfrmSettings.PopulateConfig;
begin
  // API Settings
  edtSteamAPIKeyValue.Text := rsmConfig.APIKeys.SteamAPIKey;
  edtRustMapsAPIKeyValue.Text := rsmConfig.APIKeys.RustMapsAPIKey;

  // Services - Map Server
  edtMapServerListenIP.Text := rsmConfig.Services.MapServer.IP;
  nmbrbxMapServerPort.Value := rsmConfig.Services.MapServer.Port;
  chkMapServerAutoStart.IsChecked := rsmConfig.Services.MapServer.AutoStart;
  edtMapServerListenIP.Enabled := not dmMapServer.isRunning;
  nmbrbxMapServerPort.Enabled := not dmMapServer.isRunning;
  if dmMapServer.isRunning then
  begin
    btnStartStopMapServer.Text := 'Stop Server';
    btnStartStopMapServer.TintColor := TAlphaColorRec.Darkred;
  end
  else
  begin
    btnStartStopMapServer.Text := 'Start Server';
    btnStartStopMapServer.TintColor := TAlphaColorRec.Green;
  end;

  // Services - RSM API
  chkRSMAPIAutoStart.IsChecked := rsmConfig.Services.RSMAPI.AutoStart;
  edtRSMAPIHost.Text := rsmConfig.Services.RSMAPI.Host;
  nmbrbxRSMAPIPort.Value := rsmConfig.Services.RSMAPI.Port;
  edtRSMAPIKey.Text := rsmConfig.Services.RSMAPI.APIKey;
  swtchRSMAPITLSEnabled.IsChecked := rsmConfig.Services.RSMAPI.TLSEnabled;
  edtRSMAPICertFile.Text := rsmConfig.Services.RSMAPI.TLSCertFile;
  edtRSMAPIKeyFile.Text := rsmConfig.Services.RSMAPI.TLSKeyFile;
  lstRSMAPISettings.Enabled := not dmRSMAPI.isRunning;
  if dmRSMAPI.isRunning then
  begin
    btnStartStopRSMAPIServer.Text := 'Stop Server';
    btnStartStopRSMAPIServer.TintColor := TAlphaColorRec.Darkred;
  end
  else
  begin
    btnStartStopRSMAPIServer.Text := 'Start Server';
    btnStartStopRSMAPIServer.TintColor := TAlphaColorRec.Green;
  end;

  // uMod login
  if rsmConfig.LoginTokens.uModToken.Trim.IsEmpty then
    btnuModLogin.Text := 'uMod.org Login'
  else
    btnuModLogin.Text := 'Logout uMod.org';

  // Tray Icon
  edtApplicationTitleValue.Text := rsmConfig.TrayIcon.AppTitle;
  edtTrayIconTitleValue.Text := rsmConfig.TrayIcon.Title;
  chkEnableTrayIcon.IsChecked := rsmConfig.TrayIcon.Enabled;
end;

procedure TfrmSettings.tvNavChange(Sender: TObject);
begin
  // Note: Make sure the items are in the correct order as
  // this code works from indexes
  var selectedTvItem := tvNav.Selected;
  var parentTvItem: TTreeViewItem;
  var isChild := False;

  // Check if selected treeview item is a child
  if selectedTvItem.Level > 1 then
  begin
    parentTvItem := selectedTvItem.ParentItem;
    isChild := True;
  end;

  if isChild then
  begin
    // Set Main Nav
    tbcNav.TabIndex := parentTvItem.Index;

    // Set Child Nav
    // Loop through children to find the TTabControl
    for var I := 0 to tbcNav.Tabs[tbcNav.TabIndex].GetTabList.Count - 1 do
    begin
      if tbcNav.Tabs[tbcNav.TabIndex].GetTabList.GetItem(I).GetObject is TTabControl then
      begin
        // Found the TTabControl. Now set the index
        var childTabControl := tbcNav.Tabs[tbcNav.TabIndex].GetTabList.GetItem(I).GetObject as TTabControl;
        childTabControl.TabIndex := selectedTvItem.Index;
        Break;
      end;
    end;
  end
  else
  begin
    // Only set main tab index
    tbcNav.TabIndex := selectedTvItem.Index;
  end;

end;

end.

