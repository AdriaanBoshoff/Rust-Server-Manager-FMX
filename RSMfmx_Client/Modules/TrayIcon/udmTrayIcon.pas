unit udmTrayIcon;

interface

uses
  System.SysUtils, System.Classes, ufrmMain, Vcl.ExtCtrls, System.UITypes,
  Vcl.Menus;

type
  TdmTrayIcon = class(TDataModule)
    trycnMain: TTrayIcon;
    pmTrayIcon: TPopupMenu;
    mniServerStatusValue: TMenuItem;
    mniSep: TMenuItem;
    mniStartServer: TMenuItem;
    mniStopServer: TMenuItem;
    procedure DataModuleCreate(Sender: TObject);
    procedure pmTrayIconPopup(Sender: TObject);
    procedure mniStartServerClick(Sender: TObject);
    procedure mniStopServerClick(Sender: TObject);
    procedure trycnMainDblClick(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  dmTrayIcon: TdmTrayIcon;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses
  RSM.Config, uServerProcess;

{$R *.dfm}

procedure TdmTrayIcon.DataModuleCreate(Sender: TObject);
begin
  trycnMain.Hint := rsmConfig.TrayIcon.Title;
  trycnMain.Visible := rsmConfig.TrayIcon.Enabled;
end;

procedure TdmTrayIcon.mniStartServerClick(Sender: TObject);
begin
  frmMain.btnStartServerClick(mniStartServer);
end;

procedure TdmTrayIcon.mniStopServerClick(Sender: TObject);
begin
  frmMain.btnStopServerClick(mniStopServer);
end;

procedure TdmTrayIcon.pmTrayIconPopup(Sender: TObject);
begin
  if serverProcess.isRunning then
  begin
    mniServerStatusValue.Caption := 'Server Running';
    mniStartServer.Enabled := False;
    mniStopServer.Enabled := True;
  end
  else
  begin
    mniServerStatusValue.Caption := 'Server Offline';
    mniStartServer.Enabled := True;
    mniStopServer.Enabled := False;
  end;
end;

procedure TdmTrayIcon.trycnMainDblClick(Sender: TObject);
begin
  frmMain.Show;
end;

end.

