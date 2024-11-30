unit ufrmSyntaxEditor;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCTypes, FMX.TMSFNCUtils,
  FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCWebBrowser, FMX.TMSFNCCustomWEBControl, FMX.TMSFNCMemo;

type
  TfrmSyntaxEditor = class(TForm)
    pnlFooter: TPanel;
    mmoEditor: TTMSFNCMemo;
    btnCancel: TButton;
    btnSave: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    FfilePath: string;
  end;

//var
//  frmSyntaxEditor: TfrmSyntaxEditor;

implementation

{$R *.fmx}

procedure TfrmSyntaxEditor.btnCancelClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmSyntaxEditor.btnSaveClick(Sender: TObject);
begin
  mmoEditor.Lines.SaveToFile(FfilePath);
  Self.Close;
end;

procedure TfrmSyntaxEditor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

end.

