unit ufrmOxide;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox,
  FMX.Edit, System.IOUtils, System.JSON;

type
  TOxideSettings = class
  public
    Modded: Boolean;
    PluginWatchers: Boolean;
    DefaultPlayerGroup: string;
    DefaultAdminGroup: string;
    WebRequestIP: string;
    EnableOxideConsole: Boolean;
    MinimalistOxideConsole: Boolean;
    ShowStatusBar: Boolean;
  private
    function OxideConfigFile: string;
    procedure PopulateUIConfig;
  public
    procedure LoadSettings;
    procedure SaveSettings;
    constructor Create;
  end;

type
  TfrmOxide = class(TForm)
    rctnglHeader: TRectangle;
    rctnglOxideModNavImage: TRectangle;
    lytHeaderInfo: TLayout;
    lblHeader: TLabel;
    lytHeaderControls: TLayout;
    lblDescription: TLabel;
    btnInstallUpdate: TButton;
    btnUninstall: TButton;
    rctnglSettings: TRectangle;
    lytTitle: TLayout;
    lytDescription: TLayout;
    lytSettingsHeader: TLayout;
    lblSettingsHeader: TLabel;
    btnRefreshSettings: TSpeedButton;
    lstSettings: TListBox;
    lstOptions: TListBoxGroupHeader;
    lstModded: TListBoxItem;
    cbbServerListCategory: TComboBox;
    lstPluginWatchers: TListBoxItem;
    swtchPluginWatchers: TSwitch;
    lstWebRequestIP: TListBoxItem;
    edtWebRequestIP: TEdit;
    lstPermissionGroups: TListBoxGroupHeader;
    lstDefaultPlayerGroup: TListBoxItem;
    edtDefaultPlayerGroup: TEdit;
    lstAdminGroup: TListBoxItem;
    edtAdminGroup: TEdit;
    lstOxideConsole: TListBoxGroupHeader;
    lstEnableOxideConsole: TListBoxItem;
    swtchEnableOxideConsole: TSwitch;
    lstMinimalistMode: TListBoxItem;
    swtchMinimalistMode: TSwitch;
    lstShowStatusBar: TListBoxItem;
    swtchShowStatusBar: TSwitch;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    oxideSettings: TOxideSettings;
  end;

var
  frmOxide: TfrmOxide;

implementation

{$R *.fmx}

procedure TfrmOxide.FormDestroy(Sender: TObject);
begin
  oxideSettings.Free;
end;

procedure TfrmOxide.FormCreate(Sender: TObject);
begin
  oxideSettings := TOxideSettings.Create;
end;

{ TOxideSettings }

constructor TOxideSettings.Create;
begin
  inherited;
  Self.Modded := True;
  Self.PluginWatchers := True;
  Self.DefaultPlayerGroup := 'default';
  Self.DefaultAdminGroup := 'admin';
  Self.WebRequestIP := '0.0.0.0';
  Self.EnableOxideConsole := True;
  Self.MinimalistOxideConsole := True;
  Self.ShowStatusBar := True;

  LoadSettings;
end;

procedure TOxideSettings.LoadSettings;
begin
  // Dont load if it doesnt exist
  if not TFile.Exists(Self.OxideConfigFile) then
    Exit;

  // Load Values
  var jData := TJSONObject.ParseJSONValue(tfile.ReadAllText(Self.OxideConfigFile, TEncoding.UTF8));
  try
    Modded := jData.GetValue<Boolean>('Options.Modded');
    PluginWatchers := jData.GetValue<Boolean>('Options.PluginWatchers');

    DefaultPlayerGroup := jData.GetValue<string>('Options.DefaultGroups.Players');
    DefaultAdminGroup := jData.GetValue<string>('Options.DefaultGroups.Administrators');

    WebRequestIP := jData.GetValue<string>('Options.WebRequestIP');

    EnableOxideConsole := jData.GetValue<Boolean>('OxideConsole.Enabled');
    MinimalistOxideConsole := jData.GetValue<Boolean>('OxideConsole.MinimalistMode');
    ShowStatusBar := jData.GetValue<Boolean>('OxideConsole.ShowStatusBar');

    PopulateUIConfig;
  finally
    jData.Free;
  end;
end;

function TOxideSettings.OxideConfigFile: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'oxide\oxide.config.json';
end;

procedure TOxideSettings.PopulateUIConfig;
begin
  with frmOxide do
  begin
    if Modded then
      cbbServerListCategory.ItemIndex := 1
    else
      cbbServerListCategory.ItemIndex := 0;

    swtchPluginWatchers.IsChecked := PluginWatchers;

    edtDefaultPlayerGroup.Text := DefaultPlayerGroup;
    edtAdminGroup.Text := DefaultAdminGroup;

    edtWebRequestIP.Text := WebRequestIP;

    swtchEnableOxideConsole.IsChecked := EnableOxideConsole;
    swtchMinimalistMode.IsChecked := MinimalistOxideConsole;
    swtchShowStatusBar.IsChecked := ShowStatusBar;
  end;
end;

procedure TOxideSettings.SaveSettings;
begin

end;

end.

