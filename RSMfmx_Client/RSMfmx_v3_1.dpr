program RSMfmx_v3_1;

uses
  System.StartUpCopy,
  FMX.Forms,
  ufrmMain in 'ufrmMain.pas' {frmMain},
  udmStyles in 'DataModules\udmStyles.pas' {dmStyles: TDataModule},
  udmIcons in 'DataModules\udmIcons.pas' {dmIcons: TDataModule},
  XSuperJSON in 'Libs\XSuperObject\XSuperJSON.pas',
  XSuperObject in 'Libs\XSuperObject\XSuperObject.pas',
  uServerConfig in 'Units\Configs\ServerConfig\uServerConfig.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  Application.Title := 'RSMfmx v3.1 (DEBUG BUILD)';
  {$ENDIF}

  {$IFDEF RELEASE}
  ReportMemoryLeaksOnShutdown := False;
  Application.Title := 'RSMfmx v3.1';
  {$ENDIF}

  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmStyles, dmStyles);
  Application.CreateForm(TdmIcons, dmIcons);
  Application.Run;
end.
