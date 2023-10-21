unit ufrmCarbonMod;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects,
  FMX.TabControl, FMX.ListBox, FMX.Edit, System.IOUtils;

type
  TfrmCarbonMod = class(TForm)
    rctnglHeader: TRectangle;
    rctnglCarbonModNavImage: TRectangle;
    lytHeaderInfo: TLayout;
    lytHeaderControls: TLayout;
    btnInstallUpdate: TButton;
    btnUninstall: TButton;
    lytTitle: TLayout;
    lblHeader: TLabel;
    lblCompatibilityWarning: TLabel;
    lytDescription: TLayout;
    lblDescription: TLabel;
    tbcCarbonMod: TTabControl;
    tbtmCarbonConfig: TTabItem;
    tbtmCarbonModules: TTabItem;
    btnOpenCarbonConfig: TButton;
    vrtscrlbxCarbonModules: TVertScrollBox;
    flwlytCarbonModules: TFlowLayout;
    procedure FormCreate(Sender: TObject);
    procedure btnOpenCarbonConfigClick(Sender: TObject);
    procedure cbbCarbonConfigServerListCategoryMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
    procedure flwlytCarbonModulesResized(Sender: TObject);
  private
    { Private declarations }
    procedure ReCalcCarbonModulesSize;
    procedure LoadCarbonModules;
    procedure ClearCarbonModulesUI;
  public
    { Public declarations }
  end;

var
  frmCarbonMod: TfrmCarbonMod;

implementation

uses
  uWinUtils, uframeCarbonModuleItem;

{$R *.fmx}

procedure TfrmCarbonMod.FormCreate(Sender: TObject);
begin
  LoadCarbonModules;
end;

procedure TfrmCarbonMod.LoadCarbonModules;
begin
  var modulesDir := ExtractFilePath(ParamStr(0)) + '\carbon\modules';

  if not TDirectory.Exists(modulesDir) then
    Exit;

  var dirList := TDirectory.GetDirectories(modulesDir);

  var I := 0;
  for var aDir in dirList do
  begin
    var dirName := ExtractFileName(aDir);

    var carbonModuleItem := TframeCarbonModuleItem.Create(flwlytCarbonModules);
    carbonModuleItem.Name := 'carbonModuleItem_' + I.ToString;
    carbonModuleItem.Parent := flwlytCarbonModules;

    // Dir title (Module Title)
    carbonModuleItem.lblTitle.Text := dirName;

    // Info
    carbonModuleItem.moduleConfigFile := aDir + '\config.json';
    carbonModuleItem.moduleDir := aDir;
    carbonModuleItem.moduleName := dirName;

    Inc(I);
  end;

  ReCalcCarbonModulesSize;
end;

procedure TfrmCarbonMod.btnOpenCarbonConfigClick(Sender: TObject);
begin
  var configFile := ExtractFilePath(ParamStr(0)) + '\carbon\config.json';

  OpenURL(configFile);
end;

procedure TfrmCarbonMod.cbbCarbonConfigServerListCategoryMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
begin
  Abort;
end;

procedure TfrmCarbonMod.ClearCarbonModulesUI;
begin
  for var I := flwlytCarbonModules.ChildrenCount - 1 downto 0 do
  begin
    if flwlytCarbonModules.Children[I] is TframeCarbonModuleItem then
      (flwlytCarbonModules.Children[I] as TframeCarbonModuleItem).Free;
  end;

  ReCalcCarbonModulesSize;
end;

procedure TfrmCarbonMod.flwlytCarbonModulesResized(Sender: TObject);
begin
  ReCalcCarbonModulesSize;
end;

procedure TfrmCarbonMod.ReCalcCarbonModulesSize;
begin
  var newSize: single := 0;

  for var aControl in flwlytCarbonModules.Controls do
  begin
    aControl.Width := flwlytCarbonModules.Width;

    if aControl is TframeCarbonModuleItem then
    begin
      newSize := newSize + aControl.Height + flwlytCarbonModules.VerticalGap;
    end;
  end;

  flwlytCarbonModules.Height := newSize;
end;

end.

