unit ufrmConfirmCloseToTray;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmConfirmCloseToTray = class(TForm)
    pnlButtons: TPanel;
    btnCancel: TButton;
    btnQuit: TButton;
    btnCloseToTray: TButton;
    lblMessage: TLabel;
    procedure btnCloseToTrayClick(Sender: TObject);
    procedure btnQuitClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConfirmCloseToTray: TfrmConfirmCloseToTray;

implementation

{$R *.fmx}

procedure TfrmConfirmCloseToTray.btnCancelClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel; // Cancel
end;

procedure TfrmConfirmCloseToTray.btnCloseToTrayClick(Sender: TObject);
begin
  Self.ModalResult := mrOk; // Close to Tray
end;

procedure TfrmConfirmCloseToTray.btnQuitClick(Sender: TObject);
begin
  Self.ModalResult := mrYes; // Quit App
end;

procedure TfrmConfirmCloseToTray.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

end.

