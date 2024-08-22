unit udmTrayIcon;

interface

uses
  System.SysUtils, System.Classes, ufrmMain, Vcl.ExtCtrls, System.UITypes;

type
  TdmTrayIcon = class(TDataModule)
    trycnMain: TTrayIcon;
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
  RSM.Config;

{$R *.dfm}

procedure TdmTrayIcon.trycnMainDblClick(Sender: TObject);
begin
  frmMain.WindowState := TWindowState.wsNormal;
end;

end.

