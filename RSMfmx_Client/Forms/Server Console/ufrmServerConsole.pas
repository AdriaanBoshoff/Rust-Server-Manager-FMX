unit ufrmServerConsole;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo;

type
  TfrmServerConsole = class(TForm)
    statFooter: TStatusBar;
    mmoServerConsole: TMemo;
    tlbHeader: TToolBar;
    chkAutoScroll: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmServerConsole: TfrmServerConsole;

procedure ServerConsoleLog(const Text: string; const IncludeDTM: Boolean = True);

implementation

{$R *.fmx}

procedure ServerConsoleLog(const Text: string; const IncludeDTM: Boolean = True);
begin
  frmServerConsole.mmoServerConsole.BeginUpdate;
  try
    var logText := Text;

    if IncludeDTM then
      logText := Format('[%s] %s', [FormatDateTime('yyyy-mm-dd', Now), logText]);

    frmServerConsole.mmoServerConsole.Lines.Add(logText);

    if frmServerConsole.mmoServerConsole.Lines.Count > 200 then
      frmServerConsole.mmoServerConsole.Lines.Delete(0);
  finally
    frmServerConsole.mmoServerConsole.EndUpdate;
  end;

  if frmServerConsole.chkAutoScroll.IsChecked then
    frmServerConsole.mmoServerConsole.GoToTextEnd;
end;

end.

