unit ufrmPluginInstaller;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects;

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPluginInstaller: TfrmPluginInstaller;

implementation

{$R *.fmx}

end.
