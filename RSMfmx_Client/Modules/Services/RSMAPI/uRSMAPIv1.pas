unit uRSMAPIv1;

interface

uses
  Horse, System.SysUtils, System.IOUtils;

type
  Tv1RSMAPIEndpoints = class
  public
    // serverConfig
    class procedure v1GETserverConfig(Req: THorseRequest; Res: THorseResponse);
    class procedure v1PUTserverConfig(Req: THorseRequest; Res: THorseResponse);

    // serverStatus
    class procedure v1GETserverStatus(Req: THorseRequest; Res: THorseResponse);

    // startServer
    class procedure v1GETstartServer(Req: THorseRequest; Res: THorseResponse);
    // stopServer
    class procedure v1GETstopServer(Req: THorseRequest; Res: THorseResponse);
    class procedure v1GETforceStopServer(Req: THorseRequest; Res: THorseResponse);
  end;

implementation

uses
  RSM.Config, uServerConfig, XSuperObject, ufrmMain, RCON.Types, uServerProcess,
  ufrmServerInstaller;

{ Tv1RSMAPIEndpoints }

class procedure Tv1RSMAPIEndpoints.v1GETserverStatus(Req: THorseRequest; Res: THorseResponse);
begin
  // Provide Data
  try
    Res.ContentType('application/json').Status(THTTPStatus.OK).Send(serverProcess.AsJSON(True));
  except
    // Provide Exception
    on E: Exception do
    begin
      Res.Status(THTTPStatus.InternalServerError).Send(E.ClassName + ': ' + E.Message);
    end;
  end;
end;

class procedure Tv1RSMAPIEndpoints.v1GETstartServer(Req: THorseRequest; Res: THorseResponse);
begin
   // Provide Data
  try
    // Check if server is already running
    if serverProcess.isRunning then
    begin
      Res.Status(403).Send('Server is already running!');
      Exit;
    end;

    // Check if server is installed
    var rustDedicatedExe := ExtractFilePath(ParamStr(0)) + 'RustDedicated.exe';

    // Check if server is installed
    if not TFile.Exists(rustDedicatedExe) then
    begin
      Res.Status(403).Send('Server not installed!');
      Exit;
    end;

    // Check if server is being installed
    if frmServerInstaller.FIsInstallingServer then
    begin
      Res.Status(403).Send('Server is being installed');
      Exit;
    end;

    // Check Execute Before Server Start path
    if rsmConfig.Misc.ExecuteBeforeServerStart then
    begin
      if not TFile.Exists(rsmConfig.Misc.ExecuteBeforeServerStartFilePath) then
      begin
        Res.Status(403).Send('File "' + rsmConfig.Misc.ExecuteBeforeServerStartFilePath + '" does not exists. Cannot execute before server start.');
        Exit;
      end;
    end;

    // Start server
    frmMain.btnStartServerClick(nil);

    Res.Status(200).Send('Starting Server...');
  except
    // Provide Exception
    on E: Exception do
    begin
      Res.Status(THTTPStatus.InternalServerError).Send(E.ClassName + ': ' + E.Message);
    end;
  end;
end;

class procedure Tv1RSMAPIEndpoints.v1GETstopServer(Req: THorseRequest; Res: THorseResponse);
begin
  // Provide Data
  try
    // Check if server is running
    if not serverProcess.isRunning then
    begin
      Res.Status(403).Send('Server is not running!');
      Exit;
    end;

    // Check for active rcon connection
    if not frmMain.wsClientRcon.Connected then
    begin
      Res.Status(403).Send('RSM has no RCON connection to the server. Usually this is because the server is still booting, stuck or your rcon password contains symbols. Use GET - /v1/forceStopServer');
      Exit;
    end;

    // Send quit command
    TRCON.SendRconCommand('quit', 0, frmMain.wsClientRcon);

    Res.Status(200).Send('"quit" command sent to server...');
  except
    // Provide Exception
    on E: Exception do
    begin
      Res.Status(THTTPStatus.InternalServerError).Send(E.ClassName + ': ' + E.Message);
    end;
  end;
end;

class procedure Tv1RSMAPIEndpoints.v1GETforceStopServer(Req: THorseRequest; Res: THorseResponse);
begin
  // Provide Data
  try
    // Check if server is running
    if not serverProcess.isRunning then
    begin
      Res.Status(403).Send('Server is not running!');
      Exit;
    end;

    //kill Server process
    serverProcess.KillProcess;

    // Wait 1.5 seconds
    Sleep(1500);

    // Check if server is still running
    if serverProcess.isRunning then
    begin
      Res.Status(500).Send('RSM attempted to kill the server process but failed for some unknown reason.');
      Exit;
    end;

    Res.Status(200).Send('Server Process Killed');
  except
    // Provide Exception
    on E: Exception do
    begin
      Res.Status(THTTPStatus.InternalServerError).Send(E.ClassName + ': ' + E.Message);
    end;
  end;
end;

class procedure Tv1RSMAPIEndpoints.v1GETserverConfig(Req: THorseRequest; Res: THorseResponse);
begin
  // Provide Data
  try
    Res.ContentType('application/json').Status(THTTPStatus.OK).Send(serverConfig.AsJSON(True));
  except
    // Provide Exception
    on E: Exception do
    begin
      Res.Status(THTTPStatus.InternalServerError).Send(E.ClassName + ': ' + E.Message);
    end;
  end;
end;

class procedure Tv1RSMAPIEndpoints.v1PUTserverConfig(Req: THorseRequest; Res: THorseResponse);
begin
  // Provide Data
  try
    serverConfig.AssignFromJSON(Req.Body);

    // Apply Map Name from main combobox
    serverConfig.Map.MapName := frmMain.cbbServerMap.ListItems[serverConfig.Map.MapIndex].ItemData.Detail;

    // Game Mode
    serverConfig.GameMode.GameModeName := frmMain.cbbServerGamemodeValue.ListItems[serverConfig.GameMode.Index].ItemData.Detail;

    serverConfig.SaveConfig;
    serverConfig.LoadConfig;

    frmMain.PopulateServerConfigUI;

    TRCON.SendRconCommand('server.readcfg', 0, frmMain.wsClientRcon);

    Res.Status(THTTPStatus.OK).Send('{ "message": "Server Config Applied. Some Changes will only take effect after a server restart." }');
  except
    // Provide Exception
    on E: Exception do
    begin
      serverConfig.LoadConfig;
      Res.Status(THTTPStatus.InternalServerError).Send(E.ClassName + ': ' + E.Message);
    end;
  end;
end;

end.

