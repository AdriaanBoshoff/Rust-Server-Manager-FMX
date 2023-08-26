unit RCON.Types;

interface

uses
  sgcWebSocket;

type
  TRCONMessage = record
    aMessage: string;
    aIdentifier: Integer;
    aType: string;
  end;

type
  TRCONServerInfo = record
    Hostname: string;
    MaxPlayers: Integer;
    Players: Integer;
    Queued: Integer;
    Joining: Integer;
    EntityCount: Integer;
    GameTime: TDateTime;
    UpTime: Integer;
    Map: string;
    FPS: Integer;
    Memory: Integer;
    MemoryUsageSystem: Integer;
    Collections: Integer;
    NetworkIn: Integer;
    NetworkOut: Integer;
    Restarting: Boolean;
    SaveCreatedTime: TDateTime;
    Version: Integer;
    Protocol: string;
  end;

type
  TRCONPlayerListPlayer = record
    SteamID: string;
    OwnerSteamID: string;
    DisplayName: string;
    Ping: Integer;
    Address: string;
    IP: string;
    Port: Integer;
    ConnectedSeconds: Integer;
    Health: Double;
  end;

type
  TRCON = class
    class procedure SendRconCommand(const Command: string; const Identifier: Integer; const rconClient: TsgcWebSocketClient);
  end;

implementation

uses
  System.JSON;

{ TRCON }

class procedure TRCON.SendRconCommand(const Command: string; const Identifier: Integer; const rconClient: TsgcWebSocketClient);
begin
  if not rconClient.Active then
    Exit;

  var jCommand := TJSONObject.Create;
  try
    jCommand.AddPair('Message', Command);
    jCommand.AddPair('Identifier', Identifier);

    rconClient.WriteData(jCommand.ToJSON);
  finally
    jCommand.Free;
  end;
end;

end.

