unit ufrmAutoWipeItem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  FMX.DateTimeCtrls, FMX.Objects, System.Rtti, FMX.Grid.Style, FMX.ScrollBox,
  FMX.Grid;

type
  TfrmAutoWipeItem = class(TForm)
    lblDescription: TLabel;
    edtDescrpiton: TEdit;
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
    vrtscrlbxClient: TVertScrollBox;
    rctnglEnabled: TRectangle;
    swtchEnabled: TSwitch;
    lblEnabledHeader: TLabel;
    rctnglDescription: TRectangle;
    rctnglInterval: TRectangle;
    lblInterval: TLabel;
    rctnglWipeOptions: TRectangle;
    lblWipeOptionsHeader: TLabel;
    lytWipeBlueprints: TLayout;
    swtchWipeBlueprints: TSwitch;
    lblWipeBlueprintsDescription: TLabel;
    btnEditTitle: TButton;
    lytDeleteSavFiles: TLayout;
    swtchDeleteSavFiles: TSwitch;
    lblDeleteSavFilesDescription: TLabel;
    rctnglDeleteFilesDirs: TRectangle;
    lblDeleteFilesDirsHeader: TLabel;
    strngrdDeleteFilesDirs: TStringGrid;
    strngclmnFileName: TStringColumn;
    strngclmnFilePath: TStringColumn;
    procedure OnIntervalChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAutoWipeItem: TfrmAutoWipeItem;

implementation

{$R *.fmx}

procedure TfrmAutoWipeItem.OnIntervalChange(Sender: TObject);
begin
  lytIntervalDay.Enabled := False;

  if Sender = rbIntervalOnce then // Once
  begin

  end
  else if Sender = rbIntervalDaily then // Daily
  begin

  end
  else if Sender = rbIntervalWeekly then // Weekly
  begin
    lytIntervalDay.Enabled := True;
  end
  else if Sender = rbIntervalBiWeekly then // Bi Weekly
  begin
    lytIntervalDay.Enabled := True;
  end
  else // Unknown Sender
  begin
    raise Exception.Create('[TfrmAutoWipeItem.OnIntervalChange] Unknown Sender.');
  end;
end;

end.

