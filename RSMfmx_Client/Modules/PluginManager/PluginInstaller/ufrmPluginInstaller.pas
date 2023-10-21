unit ufrmPluginInstaller;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects,
  FMX.TabControl;

type
  TfrmPluginInstaller = class(TForm)
    lytNav: TLayout;
    grdpnllytBottomNav: TGridPanelLayout;
    rctnglNavuMod: TRectangle;
    lblNavuMod: TLabel;
    rctnglNavCodeFling: TRectangle;
    lblNavCodeFling: TLabel;
    rctnglNavLoneDesign: TRectangle;
    lblNavLoneDesign: TLabel;
    tbcVendors: TTabControl;
    tbtmuMod: TTabItem;
    tbtmCodeFling: TTabItem;
    tbtmLoneDesign: TTabItem;
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
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPluginInstaller: TfrmPluginInstaller;

implementation

{$R *.fmx}

procedure TfrmPluginInstaller.OnNavItemClick(Sender: TObject);
begin
  // Unselect other nav Items
  for var aControl in grdpnllytBottomNav.Controls do
  begin
    if aControl is TRectangle then
      TRectangle(aControl).Fill.Color := UI_COLOR_DEFAULT;
  end;

  // Change Nav Tab
  if (Sender = rctnglNavuMod) then // Installed Plugins
    tbcVendors.TabIndex := tbtmuMod.Index
  else if (Sender = rctnglNavCodeFling) then // Plugin Installer
    tbcVendors.TabIndex := tbtmCodeFling.Index
  else if (Sender = rctnglNavLoneDesign) then // Plugin Updater
    tbcVendors.TabIndex := tbtmLoneDesign.Index;

  // Mark current nav Item as selected
  (Sender as TRectangle).Fill.Color := UI_COLOR_SELECTED;
end;

procedure TfrmPluginInstaller.OnNavItemMouseEnter(Sender: TObject);
begin
  if (Sender as TRectangle).Fill.Color <> UI_COLOR_SELECTED then
    (Sender as TRectangle).Fill.Color := UI_COLOR_HOVER;
end;

procedure TfrmPluginInstaller.OnNavItemMouseLeave(Sender: TObject);
begin
  if (Sender as TRectangle).Fill.Color <> UI_COLOR_SELECTED then
    (Sender as TRectangle).Fill.Color := UI_COLOR_DEFAULT
end;

end.

