unit udmMapServer;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, RSM.Config, RSM.Core,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdCustomHTTPServer,
  IdHTTPServer, IdContext;

type
  TdmMapServer = class(TDataModule)
    idhttpserverMapServer: TIdHTTPServer;
    procedure idhttpserverMapServerCommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure DataModuleCreate(Sender: TObject);
  private
    function GetServerStatus: boolean;
    { Private declarations }
  public
    { Public declarations }
    procedure StartServer;
    procedure StopServer;
  published
    property isRunning: boolean read GetServerStatus;
  end;

var
  dmMapServer: TdmMapServer;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TdmMapServer.DataModuleCreate(Sender: TObject);
begin
  if rsmConfig.Services.MapServer.AutoStart then
    Self.StartServer;
end;

function TdmMapServer.GetServerStatus: boolean;
begin
  Result := idhttpserverMapServer.Active;
end;

procedure TdmMapServer.idhttpserverMapServerCommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  // Only Get Requests
  if not (ARequestInfo.CommandType = hcGET) then
  begin
    AResponseInfo.ResponseNo := 400;
    AResponseInfo.ContentText := 'Invalid request';
    Exit;
  end;

  // Only allow /map/ requests
  if not ARequestInfo.URI.StartsWith('/map/', True) and not ARequestInfo.URI.EndsWith('.map', True) then
  begin
    AResponseInfo.ResponseNo := 400;
    AResponseInfo.ContentText := 'Invalid request';
    Exit;
  end;

  // Strip file from uri
  var requestedFile := ARequestInfo.URI.Replace('/map/', '');

  // Check if filename contains any slashes.
  if requestedFile.Contains('/') or requestedFile.Contains('\') then
  begin
    AResponseInfo.ResponseNo := 400;
    AResponseInfo.ContentText := 'Invalid request';
    Exit;
  end;

  var mapFile := TPath.Combine([rsmCore.Paths.GetMapServerDir, requestedFile]);

  // Check if map exists
  if not TFile.Exists(mapFile) then
  begin
    AResponseInfo.ResponseNo := 404;
    AResponseInfo.ContentText := 'Map Does not exists';
    Exit;
  end;

  // Provide Map File
  AResponseInfo.ResponseNo := 200;
  AResponseInfo.ContentType := 'application/octet-stream';
  AResponseInfo.ServeFile(AContext, mapFile);
end;

procedure TdmMapServer.StartServer;
begin
  if idhttpserverMapServer.Active then
    idhttpserverMapServer.Active := False;

  idhttpserverMapServer.Bindings.Clear;
  idhttpserverMapServer.DefaultPort := rsmConfig.Services.MapServer.Port;
  idhttpserverMapServer.Bindings.Add.SetBinding(rsmConfig.Services.MapServer.IP, rsmConfig.Services.MapServer.Port);
  idhttpserverMapServer.Active := True;
end;

procedure TdmMapServer.StopServer;
begin
  idhttpserverMapServer.Active := False;
end;

end.

