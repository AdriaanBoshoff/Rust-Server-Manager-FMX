program RSMfmx_v3_1;

uses
  System.StartUpCopy,
  FMX.Forms,
  ufrmMain in 'ufrmMain.pas' {frmMain},
  udmStyles in 'DataModules\udmStyles.pas' {dmStyles: TDataModule};

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Initialize;

  Application.Title := 'RSMfmx v3.1';

  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmStyles, dmStyles);
  Application.Run;
end.
