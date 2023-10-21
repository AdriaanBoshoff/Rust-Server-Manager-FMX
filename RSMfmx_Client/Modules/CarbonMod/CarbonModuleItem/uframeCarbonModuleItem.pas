unit uframeCarbonModuleItem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation;

type
  TframeCarbonModuleItem = class(TFrame)
    rctnglBG: TRectangle;
    swtchEnable: TSwitch;
    lblTitle: TLabel;
    btnOpenConfig: TButton;
    procedure btnOpenConfigClick(Sender: TObject);
    procedure swtchEnableSwitch(Sender: TObject);
  private
    { Private declarations }
    FmoduleConfigFile: string;
    function GetConfigFile: string;
    procedure SetConfigFile(const Value: string);
  public
    { Public declarations }
    moduleDir: string;
    moduleName: string;
    constructor Create(AOwner: TComponent); override;
  published
    property moduleConfigFile: string read GetConfigFile write SetConfigFile;
  end;

implementation

uses
  System.JSON, System.IOUtils, uWinUtils, ufrmMain, Rcon.Types, Rcon.Commands;

{$R *.fmx}
{ TframeCarbonModuleItem }

constructor TframeCarbonModuleItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

end;

function TframeCarbonModuleItem.GetConfigFile: string;
begin
  Result := FmoduleConfigFile;
end;

procedure TframeCarbonModuleItem.SetConfigFile(const Value: string);
begin
  FmoduleConfigFile := Value;

  if not TFile.Exists(Value) then
    Exit;

  swtchEnable.BeginUpdate;
  var jData := TJSONObject.ParseJSONValue(TFile.ReadAllText(Value, TEncoding.UTF8));
  try
    var enabled := False;

    if jData.TryGetValue<Boolean>('Enabled', enabled) then
    begin
      swtchEnable.IsChecked := enabled;
    end
    else
      swtchEnable.Visible := False;
  finally
    jData.Free;
    swtchEnable.EndUpdate;
  end;
end;

procedure TframeCarbonModuleItem.btnOpenConfigClick(Sender: TObject);
begin
  OpenURL(Self.FmoduleConfigFile);
end;

procedure TframeCarbonModuleItem.swtchEnableSwitch(Sender: TObject);
begin
  // Load json Data
  var jData := TJSONObject.ParseJSONValue(TFile.ReadAllText(Self.FmoduleConfigFile, TEncoding.UTF8));
  try
    var enabled := False;
    if jData.TryGetValue<Boolean>('Enabled', enabled) then
    begin
      // Change enabled property
      TJSONObject(jData).RemovePair('Enabled').Free;
      // .Free to avoid memory leak
      TJSONObject(jData).AddPair('Enabled', swtchEnable.IsChecked);

      // Save json
      TFile.WriteAllText(Self.FmoduleConfigFile, TJSONObject(jData).Format(2), TEncoding.UTF8);

      // Tell the server to reload all modules
      if frmMain.wsClientRcon.Active then
        TRCON.SendRconCommand(RCON_CMD_Carbon_ReloadModules, RCON_ID_Carbon_ReloadModules, frmMain.wsClientRcon);
    end
    else
      // Remove switch option if the json option does not exist
      swtchEnable.Visible := False;
  finally
    // Free
    jData.Free;
  end;
end;

end.

