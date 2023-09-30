unit uframeServerDescriptionEditor;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo, ufrmMain;

type
  TframeServerDescriptionEditor = class(TFrame)
    rctnglBG: TRectangle;
    pnlMain: TPanel;
    pnlHeader: TPanel;
    lblHeader: TLabel;
    btnClose: TSpeedButton;
    mmoDescription: TMemo;
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

procedure TframeServerDescriptionEditor.btnCloseClick(Sender: TObject);
begin
  frmMain.edtServerDescriptionValue.Text := mmoDescription.Text.Replace(sLineBreak, '\n');

  Self.Release;
end;

constructor TframeServerDescriptionEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  mmoDescription.Text := frmMain.edtServerDescriptionValue.Text.Replace('\n', sLineBreak);
end;

end.

