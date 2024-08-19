unit udmMapServer;

interface

uses
  System.SysUtils, System.Classes, RSM.Config;

type
  TdmMapServer = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmMapServer: TdmMapServer;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
