program RSMfmx_v3_1;

uses
  System.StartUpCopy,
  FMX.Forms,
  ufrmMain in 'ufrmMain.pas' {frmMain},
  udmStyles in 'DataModules\udmStyles.pas' {dmStyles: TDataModule},
  uServerConfig in 'Units\Configs\uServerConfig.pas',
  udmIcons in 'DataModules\udmIcons.pas' {dmIcons: TDataModule};

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Initialize;

  Application.Title := 'RSMfmx v3.1';

  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmStyles, dmStyles);
  Application.CreateForm(TdmIcons, dmIcons);
  Application.Run;
end.
