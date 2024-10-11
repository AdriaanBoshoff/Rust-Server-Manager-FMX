unit ufrmAutoWipeItem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  FMX.DateTimeCtrls;

type
  TfrmAutoWipeItem = class(TForm)
    lytDescription: TLayout;
    lblDescription: TLabel;
    edtDescrpiton: TEdit;
    grpInterval: TGroupBox;
    lytIntervalType: TLayout;
    rbIntervalOnce: TRadioButton;
    rbIntervalDaily: TRadioButton;
    rbIntervalWeekly: TRadioButton;
    rbIntervalBiWeekly: TRadioButton;
    lytIntervalDay: TLayout;
    rbIntervalMon: TRadioButton;
    rbIntervalTue: TRadioButton;
    rbIntervalWed: TRadioButton;
    rbIntervalThur: TRadioButton;
    rbIntervalFri: TRadioButton;
    rbIntervalSat: TRadioButton;
    rbIntervalSun: TRadioButton;
    lytIntervalTime: TLayout;
    lblIntervalTime: TLabel;
    tmdtInterval: TTimeEdit;
    lytEnabled: TLayout;
    chkEnabled: TCheckBox;
    grpDay: TGroupBox;
    lytClient: TLayout;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAutoWipeItem: TfrmAutoWipeItem;

implementation

{$R *.fmx}

end.
