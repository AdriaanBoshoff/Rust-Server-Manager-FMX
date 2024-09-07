unit udmRSMAPI;

interface

uses
  System.SysUtils, System.Classes, Horse;

type
  TdmRSMAPI = class(TDataModule)
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
  { Private declarations }
    function GetRunningStatus: boolean;
    procedure RegisterV1Endpoints;
    procedure OnGetTLSPassword(var Password: string);
  public
    { Public declarations }
    procedure Start;
    procedure Stop;
  published
   { Published Properties }
    property isRunning: boolean read GetRunningStatus;
  end;

var
  dmRSMAPI: TdmRSMAPI;

implementation

uses
  RSM.Config, uRSMAPIv1, IdSSLOpenSSL;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TdmRSMAPI }

procedure TdmRSMAPI.DataModuleCreate(Sender: TObject);
begin
  RegisterV1Endpoints;

  if rsmConfig.Services.RSMAPI.AutoStart then
    Self.Start;
end;

procedure TdmRSMAPI.DataModuleDestroy(Sender: TObject);
begin
  if Self.isRunning then
    Self.Stop;
end;

function TdmRSMAPI.GetRunningStatus: boolean;
begin
  Result := THorse.IsRunning;
end;

procedure TdmRSMAPI.OnGetTLSPassword(var Password: string);
begin
  Password := rsmConfig.Services.RSMAPI.TLSPassword;
end;

procedure TdmRSMAPI.RegisterV1Endpoints;
begin
  with THorse.Group.Prefix('/v1') do
  begin
    // Get - serverConfig
    Route('/serverConfig').Get(Tv1RSMAPIEndpoints.v1GETserverConfig);
    // Put - serverConfig
    Route('/serverConfig').Put(Tv1RSMAPIEndpoints.v1PUTserverConfig);
  end;
end;

procedure TdmRSMAPI.Start;
begin
  // Server Host & Port
  THorse.Host := rsmConfig.Services.RSMAPI.Host;
  THorse.Port := rsmConfig.Services.RSMAPI.Port;

  // TLS
  if rsmConfig.Services.RSMAPI.TLSEnabled then
  begin
    THorse.IOHandleSSL.CertFile(rsmConfig.Services.RSMAPI.TLSCertFile);
    THorse.IOHandleSSL.KeyFile(rsmConfig.Services.RSMAPI.TLSKeyFile);
    THorse.IOHandleSSL.OnGetPassword(Self.OnGetTLSPassword);
    THorse.IOHandleSSL.SSLVersions([sslvTLSv1_2]);
    THorse.IOHandleSSL.Active(rsmConfig.Services.RSMAPI.TLSEnabled);
  end;

  // Start Listen
  THorse.Listen;
end;

procedure TdmRSMAPI.Stop;
begin
  THorse.StopListen;
end;

end.

