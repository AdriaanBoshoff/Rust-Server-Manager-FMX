unit ufrmAutoServerStartDlg;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects;

type
  TfrmAutoServerStartDlg = class(TForm)
    tlbHeader: TToolBar;
    lblHeader: TLabel;
    lblCountdown: TLabel;
    lytButtons: TLayout;
    btnStartNow: TButton;
    btnCancel: TButton;
    tmrCountdown: TTimer;
    rctnglBG: TRectangle;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnStartNowClick(Sender: TObject);
    procedure tmrCountdownTimer(Sender: TObject);
  private
    { Private declarations }
    FCountdown: Integer;
  public
    { Public declarations }
  end;

var
  frmAutoServerStartDlg: TfrmAutoServerStartDlg;

implementation

{$R *.fmx}

procedure TfrmAutoServerStartDlg.FormCreate(Sender: TObject);
begin
  FCountdown := 10;
  tmrCountdown.Interval := 1000;
  tmrCountdown.Enabled := True;
end;

procedure TfrmAutoServerStartDlg.btnCancelClick(Sender: TObject);
begin
  tmrCountdown.Enabled := False;
  Self.ModalResult := mrCancel;
end;

procedure TfrmAutoServerStartDlg.btnStartNowClick(Sender: TObject);
begin
  tmrCountdown.Enabled := False;
  Self.ModalResult := mrOk;
end;

procedure TfrmAutoServerStartDlg.tmrCountdownTimer(Sender: TObject);
begin
  if FCountdown <= 0 then
  begin
    tmrCountdown.Enabled := False;

    Self.ModalResult := mrOk;
  end
  else
  begin
    FCountdown := FCountdown - 1;

    lblCountdown.Text := Format('Starting Server in %d Seconds...', [FCountdown]);
  end;
end;

end.

