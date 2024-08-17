unit ufrmSettings;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.TreeView, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.TabControl, FMX.Edit;

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
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure tvNavChange(Sender: TObject);
    procedure btnuModLoginClick(Sender: TObject);
    procedure lblViewuModLoginSourceCodeClick(Sender: TObject);
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
  RSM.Config, uWinUtils, System.IOUtils, RSM.Core, Rest.Client, WinAPI.Windows;

{$R *.fmx}

function GetuModLoginSession: PWChar; stdcall; external 'uModLoginHelper.dll';

procedure TfrmSettings.btnCancelClick(Sender: TObject);
begin
  rsmConfig.LoadConfig;
  Self.ModalResult := mrCancel;
end;

procedure TfrmSettings.btnSaveClick(Sender: TObject);
begin
  rsmConfig.APIKeys.SteamAPIKey := edtSteamAPIKeyValue.Text;
  rsmConfig.APIKeys.RustMapsAPIKey := edtRustMapsAPIKeyValue.Text;
  rsmConfig.LoginTokens.uModToken := FuModSessionToken;
  rsmConfig.SaveConfig;

  Self.ModalResult := mrOk;
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
  { Main Nav }
  //tbcNav.TabPosition := TTabPosition.None;

  tbcNav.TabIndex := 0;

  PopulateConfig;
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

  // uMod login
  if rsmConfig.LoginTokens.uModToken.Trim.IsEmpty then
    btnuModLogin.Text := 'uMod.org Login'
  else
    btnuModLogin.Text := 'Logout uMod.org';
end;

procedure TfrmSettings.tvNavChange(Sender: TObject);
begin
  for var I := 0 to tbcNav.TabCount - 1 do
  begin
    if tvNav.Selected.GlobalIndex = tbcNav.Tabs[I].Index then
    begin
      tbcNav.ActiveTab := tbcNav.Tabs[I];
      Break;
    end;
  end;

end;

end.

