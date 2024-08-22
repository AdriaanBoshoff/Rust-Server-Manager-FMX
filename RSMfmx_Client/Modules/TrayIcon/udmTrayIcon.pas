unit udmTrayIcon;

interface

uses
  System.SysUtils, System.Classes, ufrmMain, Vcl.ExtCtrls, System.UITypes;

type
  TdmTrayIcon = class(TDataModule)
    trycnMain: TTrayIcon;
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

end.

