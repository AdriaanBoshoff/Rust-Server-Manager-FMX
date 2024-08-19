unit udmMapServer;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, RSM.Config, RSM.Core, Horse;

type
  TdmMapServer = class(TDataModule)
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    var
      FisRunning: boolean;
  public
    { Public declarations }
    procedure StartServer;
    procedure StopServer;
    procedure RegisterEndpoints;
  published
    property isRunning: boolean read FisRunning write FisRunning;
  end;

var
  dmMapServer: TdmMapServer;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TdmMapServer.DataModuleCreate(Sender: TObject);
begin
  RegisterEndpoints;

  if rsmConfig.Services.MapServer.AutoStart and not Self.isRunning then
    Self.StartServer;
end;

procedure TdmMapServer.DataModuleDestroy(Sender: TObject);
begin
  if Self.isRunning then
    Self.StopServer;
end;

procedure TdmMapServer.RegisterEndpoints;
begin
  // Test
  THorse.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send('pong');
    end);

  // Download Endpoint
  THorse.Get('/download',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      // Get Requested Map
      var aMap := '';
      if not Req.Query.TryGetValue('map', aMap) then
      begin
        Res.Status(400).Send('Missing map query');
        Exit;
      end;

      // Check trailing
      if aMap.Contains('/') or aMap.Contains('\') then
      begin
        Res.Status(400).Send('Invalid Request');
        Exit;
      end;

      var mapFile := TPath.Combine([rsmCore.Paths.GetMapServerDir, aMap]);

      if not TFile.Exists(mapFile) then
      begin
        Res.Status(404).Send('Requested Map does not exist');
        Exit;
      end;

      var fs := TFileStream.Create(mapFile, fmShareDenyWrite);
      try
        Res.Status(200).SendFile(fs, TPath.GetFileName(mapFile), 'application/octet-stream');
      finally
        fs.Free;
      end;
    end);
end;

procedure TdmMapServer.StartServer;
begin
  var aPort := rsmConfig.Services.MapServer.Port;
  var aHost := rsmConfig.Services.MapServer.IP;

  THorse.Listen(aPort, aHost,
    procedure
    begin
      // Started Listening
      FisRunning := True;
    end,
    procedure
    begin
      // Stopped Listening
      FisRunning := False;
    end);
end;

procedure TdmMapServer.StopServer;
begin
  THorse.StopListen;
end;

end.

