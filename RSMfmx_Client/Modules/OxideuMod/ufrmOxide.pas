unit ufrmOxide;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox,
  FMX.Edit, System.IOUtils, ufrmMain, System.Threading, System.Zip, Rest.Client;

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
    btnSaveConfig: TButton;
    lytDownloadStatus: TLayout;
    rctnglDownloadStatusBG: TRectangle;
    lblDownloadStatus: TLabel;
    procedure btnInstallUpdateClick(Sender: TObject);
    procedure btnSaveConfigClick(Sender: TObject);
    procedure btnUninstallClick(Sender: TObject);
    procedure cbbServerListCategoryMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateDownloadStatus(const Text: string; UIVisible: Boolean = True);
    procedure DownloadExtractOxideAsync;
  public
    { Public declarations }
    oxideSettings: TOxideSettings;
  end;

var
  frmOxide: TfrmOxide;

implementation

uses
  System.JSON.Types, System.JSON.Writers, System.JSON, uframeMessageBox,
  ufrmServerInstaller;

{$R *.fmx}

procedure TfrmOxide.btnInstallUpdateClick(Sender: TObject);
begin
  DownloadExtractOxideAsync;
end;

procedure TfrmOxide.btnSaveConfigClick(Sender: TObject);
begin
  case cbbServerListCategory.ItemIndex of
    0:
      oxideSettings.Modded := False;
    1:
      oxideSettings.Modded := True;
  end;

  oxideSettings.PluginWatchers := swtchPluginWatchers.IsChecked;
  oxideSettings.DefaultPlayerGroup := edtDefaultPlayerGroup.Text;
  oxideSettings.DefaultAdminGroup := edtAdminGroup.Text;
  oxideSettings.WebRequestIP := edtWebRequestIP.Text;
  oxideSettings.EnableOxideConsole := swtchEnableOxideConsole.IsChecked;
  oxideSettings.MinimalistOxideConsole := swtchMinimalistMode.IsChecked;
  oxideSettings.ShowStatusBar := swtchShowStatusBar.IsChecked;

  oxideSettings.SaveSettings;

  ShowMessageBox('Saved Oxide Config', 'Oxide Config', frmMain.tbtmOxideuMod);
end;

procedure TfrmOxide.btnUninstallClick(Sender: TObject);
begin
  frmMain.lstNav.ItemIndex := frmMain.lstServerInstaller.Index;
  frmServerInstaller.btnVerifyServerFiles.OnClick(btnUninstall);
end;

procedure TfrmOxide.cbbServerListCategoryMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
begin
  Abort;
end;

procedure TfrmOxide.DownloadExtractOxideAsync;
begin
  TTask.Run(
    procedure
    begin
      var oxideZip := ExtractFilePath(ParamStr(0)) + 'oxide.zip';

      try
        UpdateDownloadStatus('Downloading Oxide / uMod...');
        try
          var memStream := TMemoryStream.Create;
          try
            TDownloadURL.DownloadRawBytes('https://umod.org/games/rust/download?tag=public', memStream);

            memStream.SaveToFile(oxideZip);
          finally
            memStream.Free;
          end;
        except
          on E: Exception do
          begin
            TThread.Synchronize(TThread.Current,
              procedure
              begin
                ShowMessageBox(E.Message, 'Oxide Download Error', frmMain.tbtmOxideuMod);
              end);
          end;
        end;

        UpdateDownloadStatus('Extracting Oxide / uMod...');
        try
          TZipFile.ExtractZipFile(oxideZip, ExtractFileDir(oxideZip));
        except
          on E: Exception do
          begin
            TThread.Synchronize(TThread.Current,
              procedure
              begin
                ShowMessageBox(E.Message, 'Oxide EXTRACT Error', frmMain.tbtmOxideuMod);
              end);
          end;
        end;
      finally
        UpdateDownloadStatus('Done', False);
      end;
    end);
end;

procedure TfrmOxide.FormDestroy(Sender: TObject);
begin
  oxideSettings.Free;
end;

procedure TfrmOxide.UpdateDownloadStatus(const Text: string; UIVisible: Boolean);
begin
  TThread.Synchronize(TThread.Current,
    procedure
    begin
      lblDownloadStatus.Text := Text;

      lytDownloadStatus.Visible := UIVisible;
      if UIVisible then
      begin
        lytDownloadStatus.BringToFront;
      end
      else
      begin
        lytDownloadStatus.SendToBack;
      end;
    end);
end;

procedure TfrmOxide.FormCreate(Sender: TObject);
begin
  oxideSettings := TOxideSettings.Create;

  lytDownloadStatus.Visible := False;
  lytDownloadStatus.SendToBack;

  if oxideSettings.Modded then
    cbbServerListCategory.ItemIndex := 1
  else
    cbbServerListCategory.ItemIndex := 0;

  swtchPluginWatchers.IsChecked := oxideSettings.PluginWatchers;

  edtDefaultPlayerGroup.Text := oxideSettings.DefaultPlayerGroup;
  edtAdminGroup.Text := oxideSettings.DefaultAdminGroup;

  edtWebRequestIP.Text := oxideSettings.WebRequestIP;

  swtchEnableOxideConsole.IsChecked := oxideSettings.EnableOxideConsole;
  swtchMinimalistMode.IsChecked := oxideSettings.MinimalistOxideConsole;
  swtchShowStatusBar.IsChecked := oxideSettings.ShowStatusBar;
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
  finally
    jData.Free;
  end;
end;

function TOxideSettings.OxideConfigFile: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'oxide\oxide.config.json';
end;

procedure TOxideSettings.SaveSettings;
begin
  var StringWriter := TStringWriter.Create();
  var Writer := TJsonTextWriter.Create(StringWriter);
  try
    Writer.Formatting := TJsonFormatting.Indented;

    Writer.WriteStartObject;
    Writer.WritePropertyName('Options');
    Writer.WriteStartObject;

    Writer.WritePropertyName('Modded');
    Writer.WriteValue(Self.Modded);

    Writer.WritePropertyName('PluginWatchers');
    Writer.WriteValue(Self.PluginWatchers);

    Writer.WritePropertyName('DefaultGroups');
    Writer.WriteStartObject;
    Writer.WritePropertyName('Players');
    Writer.WriteValue(Self.DefaultPlayerGroup);

    Writer.WritePropertyName('Administrators');
    Writer.WriteValue(Self.DefaultAdminGroup);
    Writer.WriteEndObject;

    Writer.WritePropertyName('WebRequestIP');
    Writer.WriteValue(Self.WebRequestIP);
    Writer.WriteEndObject;

    Writer.WritePropertyName('OxideConsole');
    Writer.WriteStartObject;
    Writer.WritePropertyName('Enabled');
    Writer.WriteValue(Self.EnableOxideConsole);

    Writer.WritePropertyName('MinimalistMode');
    Writer.WriteValue(Self.MinimalistOxideConsole);

    Writer.WritePropertyName('ShowStatusBar');
    Writer.WriteValue(Self.ShowStatusBar);
    Writer.WriteEndObject;
    Writer.WriteEndObject;

    TFile.WriteAllText(Self.OxideConfigFile, StringWriter.ToString, TEncoding.UTF8);
  finally
    Writer.Free;
    StringWriter.Free;
  end;
end;

end.

