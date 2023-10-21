unit ufrmPluginManager;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.TabControl, FMX.Layouts, FMX.ExtCtrls, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmPluginManager = class(TForm)
    lytNav: TLayout;
    tbcNav: TTabControl;
    tbtmInstalledPlugins: TTabItem;
    tbtmPluginInstaller: TTabItem;
    tbtmPluginUpdater: TTabItem;
    grdpnllytBottomNav: TGridPanelLayout;
    rctnglNavInstalledPlugins: TRectangle;
    rctnglNavPluginInstaller: TRectangle;
    rctnglNavPluginUpdater: TRectangle;
    lblNavInstallPlugins: TLabel;
    lblNavPluginInstallers: TLabel;
    lblNavPluginUpdater: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure OnNavItemClick(Sender: TObject);
    procedure OnNavItemMouseEnter(Sender: TObject);
    procedure OnNavItemMouseLeave(Sender: TObject);
  private
    { Private Const }
    const
      UI_COLOR_DEFAULT = $FF1F222A;
      UI_COLOR_HOVER = $FF6F0000;
      UI_COLOR_SELECTED = $FF900000;
  private
    { Private Methods }
    procedure CreateModules;
  public
    { Public declarations }
  end;

var
  frmPluginManager: TfrmPluginManager;

implementation

uses
  ufrmPluginInstaller;

{$R *.fmx}

procedure TfrmPluginManager.CreateModules;
begin
  // Plugin Installer
  frmPluginInstaller := TfrmPluginInstaller.Create(tbtmPluginInstaller);
  while frmPluginInstaller.ChildrenCount > 0 do
    frmPluginInstaller.Children[0].Parent := tbtmPluginInstaller;
end;

procedure TfrmPluginManager.FormCreate(Sender: TObject);
begin
  CreateModules;

  {$IFDEF RELEASE}
  tbcNav.TabPosition := TTabPosition.None;
  {$ENDIF}
  OnNavItemClick(rctnglNavInstalledPlugins);
end;

procedure TfrmPluginManager.OnNavItemClick(Sender: TObject);
begin
  // Unselect other nav Items
  for var aControl in grdpnllytBottomNav.Controls do
  begin
    if aControl is TRectangle then
      TRectangle(aControl).Fill.Color := UI_COLOR_DEFAULT;
  end;

  // Change Nav Tab
  if (Sender = rctnglNavInstalledPlugins) then // Installed Plugins
    tbcNav.TabIndex := tbtmInstalledPlugins.Index
  else if (Sender = rctnglNavPluginInstaller) then // Plugin Installer
    tbcNav.TabIndex := tbtmPluginInstaller.Index
  else if (Sender = rctnglNavPluginUpdater) then // Plugin Updater
    tbcNav.TabIndex := tbtmPluginUpdater.Index;

  // Mark current nav Item as selected
  (Sender as TRectangle).Fill.Color := UI_COLOR_SELECTED;
end;

procedure TfrmPluginManager.OnNavItemMouseEnter(Sender: TObject);
begin
  if (Sender as TRectangle).Fill.Color <> UI_COLOR_SELECTED then
    (Sender as TRectangle).Fill.Color := UI_COLOR_HOVER;
end;

procedure TfrmPluginManager.OnNavItemMouseLeave(Sender: TObject);
begin
  if (Sender as TRectangle).Fill.Color <> UI_COLOR_SELECTED then
    (Sender as TRectangle).Fill.Color := UI_COLOR_DEFAULT
end;

end.

