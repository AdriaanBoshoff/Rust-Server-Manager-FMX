unit udmTrayIcon;

interface

uses
  System.SysUtils, System.Classes, ufrmMain, Vcl.ExtCtrls, System.UITypes,
  Vcl.Menus;

type
  TdmTrayIcon = class(TDataModule)
    trycnMain: TTrayIcon;
    pmTrayIcon: TPopupMenu;
    mnitest1: TMenuItem;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  dmTrayIcon: TdmTrayIcon;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses
  RSM.Config;

{$R *.dfm}

procedure TdmTrayIcon.DataModuleCreate(Sender: TObject);
begin
  trycnMain.Hint := rsmConfig.TrayIcon.Title;
  trycnMain.Visible := rsmConfig.TrayIcon.Enabled;
end;

end.

