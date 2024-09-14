unit ufrmAutoWipe;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmAutoWipe = class(TForm)
    statFooter: TStatusBar;
    tlbHeader: TToolBar;
    lblHeader: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
//  frmAutoWipe: TfrmAutoWipe;

implementation

{$R *.fmx}

end.
