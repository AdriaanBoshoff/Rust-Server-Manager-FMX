program RichMemoDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  RichMemo.Main in 'RichMemo.Main.pas' {FormMain},
  FMX.RichEdit.Style in '..\FMX.RichEdit.Style.pas',
  Syntax.Code.MarkDown in '..\Syntax.Code.MarkDown.pas',
  Syntax.Code in '..\Syntax.Code.pas',
  Syntax.Code.Pascal in '..\Syntax.Code.Pascal.pas',
  Syntax.Code.Python in '..\Syntax.Code.Python.pas',
  Syntax.Code.SQL in '..\Syntax.Code.SQL.pas',
  Syntax.Code.JSON in '..\Syntax.Code.JSON.pas',
  SpellChecker in '..\SpellChecker.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
