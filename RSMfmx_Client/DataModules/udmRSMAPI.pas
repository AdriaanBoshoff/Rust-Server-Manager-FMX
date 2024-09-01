unit udmRSMAPI;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp;

type
  TdmRSMApi = class(TWebModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmRSMApi: TdmRSMApi;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
