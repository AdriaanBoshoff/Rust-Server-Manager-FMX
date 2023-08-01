program RSMfmx_v3_1;

uses
  System.StartUpCopy,
  FMX.Forms,
  ufrmMain in 'ufrmMain.pas' {frmMain},
  udmStyles in 'DataModules\udmStyles.pas' {dmStyles: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmStyles, dmStyles);
  Application.Run;
end.
