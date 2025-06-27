unit ufrmSyntaxEditor;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.RichEdit.Style, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, System.IOUtils, ufrmMain, FMX.Layouts;

type
  TfrmSyntaxEditor = class(TForm)
    mmoCode: TMemo;
    pnlFooter: TPanel;
    btnSave: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure mmoCodePresentationNameChoosing(Sender: TObject; var PresenterName: string);
    procedure btnSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FConfigFile: string;
    procedure SetConfigFile(const Value: string);
  public
    { Public declarations }
    property ConfigFile: string read FConfigFile write SetConfigFile;
  end;

//var
//  frmSyntaxEditor: TfrmSyntaxEditor;

procedure EditConfig(const aFile: string);

implementation

uses
  FMX.BehaviorManager, RCON.Types;

{$R *.fmx}

procedure EditConfig(const aFile: string);
begin
  if not TFile.Exists(aFile) then
  begin
    ShowMessage('Config File "' + aFile + '" does not exist.');
    Exit;
  end;

  var frmEditConfig := TfrmSyntaxEditor.Create(frmMain);
  frmEditConfig.ConfigFile := aFile;
  if (TPath.GetExtension(aFile) = '.json') and (frmEditConfig.mmoCode.Presentation is TRichEditStyled) then
  begin
    TRichEditStyled(frmEditConfig.mmoCode.Presentation).SetCodeSyntaxName('json', frmEditConfig.mmoCode.Font, frmEditConfig.mmoCode.FontColor);
  end;
  frmEditConfig.mmoCode.Lines.LoadFromFile(aFile, TEncoding.UTF8);
  frmEditConfig.Show;
  frmEditConfig.BringToFront;
end;

procedure TfrmSyntaxEditor.btnCancelClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmSyntaxEditor.btnSaveClick(Sender: TObject);
begin
  mmoCode.Lines.SaveToFile(Self.FConfigFile, TEncoding.UTF8);
  TRCON.SendRconCommand('o.reload "' + tpATH.GetFileNameWithoutExtension(Self.FConfigFile) + '"', -1, frmMain.wsClientRconICS);
  Self.Close;
end;

procedure TfrmSyntaxEditor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TfrmSyntaxEditor.FormCreate(Sender: TObject);
begin
  mmoCode.ScrollAnimation := TBehaviorBoolean.True;
end;

procedure TfrmSyntaxEditor.mmoCodePresentationNameChoosing(Sender: TObject; var PresenterName: string);
begin
  PresenterName := 'RichEditStyled';
end;

procedure TfrmSyntaxEditor.SetConfigFile(const Value: string);
begin
  FConfigFile := Value;

  Self.Caption := Value;
end;

end.

