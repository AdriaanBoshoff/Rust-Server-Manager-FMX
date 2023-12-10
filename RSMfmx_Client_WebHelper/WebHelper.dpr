program WebHelper;

uses
  Vcl.Forms,
  ufrmMain in 'ufrmMain.pas' {frmMain};

{$R *.res}

begin
  // Make sure a URL is supplied
  if ParamCount = 0 then
    Exit;

  Application.Initialize;

  // Application Title
  Application.Title := '[RSM] ' + ParamStr(1);

  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

