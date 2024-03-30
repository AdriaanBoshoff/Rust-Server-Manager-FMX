unit udmTrayIcon;

interface

uses
  System.SysUtils, System.Classes, FMX.Trayicon.Win, ufrmMain;

type
  TdmTrayIcon = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure OnTrayIconDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    trayIcon: TFMXTrayIcon;
    procedure UpdateConfig;
  end;

var
  dmTrayIcon: TdmTrayIcon;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses
  RSM.Config;

{$R *.dfm}

procedure TdmTrayIcon.DataModuleCreate(Sender: TObject);
begin
  trayIcon := TFMXTrayIcon.Create(frmMain);
  trayIcon.OnDblClick := OnTrayIconDblClick;
  Self.UpdateConfig;
end;

procedure TdmTrayIcon.OnTrayIconDblClick(Sender: TObject);
begin
  frmMain.BringToForeground;
end;

procedure TdmTrayIcon.UpdateConfig;
begin
  trayIcon.Hint := rsmConfig.TrayIcon.Title;

  if rsmConfig.TrayIcon.Enabled then
    trayIcon.Show
  else
    trayIcon.Hide;

  trayIcon.PopupMenu := frmMain.pmTrayIcon;
end;

end.

