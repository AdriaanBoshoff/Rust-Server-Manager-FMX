unit ufrmCarbonMod;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects;

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCarbonMod: TfrmCarbonMod;

implementation

{$R *.fmx}

end.
