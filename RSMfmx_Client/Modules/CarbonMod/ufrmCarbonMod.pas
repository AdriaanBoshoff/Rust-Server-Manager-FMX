unit ufrmCarbonMod;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects,
  FMX.TabControl, FMX.ListBox, FMX.Edit, System.IOUtils, System.Threading,
  Rest.Client, Rest.Types, System.Zip;

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
    lblNoCarbonModulesFound: TLabel;
    lytLoading: TLayout;
    rctnglLoadingBG: TRectangle;
    lblLoadingText: TLabel;
    procedure btnInstallUpdateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOpenCarbonConfigClick(Sender: TObject);
    procedure btnUninstallClick(Sender: TObject);
    procedure cbbCarbonConfigServerListCategoryMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
    procedure flwlytCarbonModulesResized(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure tbcCarbonModChange(Sender: TObject);
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
  uWinUtils, uframeCarbonModuleItem, RSM.Core;

{$R *.fmx}

procedure TfrmCarbonMod.btnInstallUpdateClick(Sender: TObject);
begin
  TTask.Run(
    procedure
    begin
      try
        TThread.Synchronize(TThread.Current,
          procedure
          begin
            lytLoading.Visible := True;
            lytLoading.BringToFront;
            lblLoadingText.Text := 'Downloading...';
          end);

        var savePath := TPath.Combine([rsmCore.Paths.GetRootDir, 'carbon.zip']);

        var memStream := TMemoryStream.Create;
        try
          TDownloadURL.DownloadRawBytes('https://github.com/CarbonCommunity/Carbon/releases/latest/download/Carbon.Windows.Release.zip ', memStream);

          memStream.SaveToFile(savePath);
        finally
          memStream.Free;
        end;

        TThread.Synchronize(TThread.Current,
          procedure
          begin
            lblLoadingText.Text := 'Extracting...';
          end);

        TZipFile.ExtractZipFile(savePath, rsmCore.Paths.GetRootDir, TEncoding.UTF8);

        TThread.Synchronize(TThread.Current,
          procedure
          begin
            ShowMessage('CarbonMod Installed!');
          end);

        TFile.Delete(savePath);
      finally
        TThread.Synchronize(TThread.Current,
          procedure
          begin
            lytLoading.Visible := False;
            lytLoading.SendToBack;
          end);
      end;
    end);
end;

procedure TfrmCarbonMod.FormCreate(Sender: TObject);
begin
  LoadCarbonModules;

  lytLoading.Visible := False;
  lytLoading.SendToBack;
end;

procedure TfrmCarbonMod.LoadCarbonModules;
begin
  ClearCarbonModulesUI;

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

  // Check if there are any carbon modules loaded
  var moduleCount := 0;
  for var aControl in flwlytCarbonModules do
    Inc(moduleCount);
  lblNoCarbonModulesFound.Visible := (moduleCount = 0);

  ReCalcCarbonModulesSize;
end;

procedure TfrmCarbonMod.btnOpenCarbonConfigClick(Sender: TObject);
begin
  var configFile := ExtractFilePath(ParamStr(0)) + '\carbon\config.json';

  if TFile.Exists(configFile) then
    OpenURL(configFile);
end;

procedure TfrmCarbonMod.btnUninstallClick(Sender: TObject);
begin
  if TFile.Exists(TPath.Combine([rsmCore.Paths.GetRootPath, 'doorstop_config.ini'])) then
  begin
    TFile.Delete(TPath.Combine([rsmCore.Paths.GetRootPath, 'doorstop_config.ini']));

    ShowMessage('Carbonmod Uninstalled! Your carbon data has been preserved in the "carbon" folder.');
  end;
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

procedure TfrmCarbonMod.FormActivate(Sender: TObject);
begin
  LoadCarbonModules;
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

procedure TfrmCarbonMod.tbcCarbonModChange(Sender: TObject);
begin
  LoadCarbonModules;
end;

end.

