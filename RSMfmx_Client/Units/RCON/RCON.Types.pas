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
    MemoryUsageSystem: Int64;
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
    class procedure KickPlayer(const SteamID, Reason: string; const Identifier: Integer; const rconClient: TsgcWebSocketClient);
    class procedure BanPlayerID(const SteamID, Username, Reason: string; const Identifier: Integer; const rconClient: TsgcWebSocketClient);
    class procedure SetAuthLevel(const SteamID, Username, Reason: string; const AuthLevel: Integer; const rconClient: TsgcWebSocketClient);
  end;

implementation

uses
  System.JSON, System.SysUtils;

{ TRCON }

class procedure TRCON.BanPlayerID(const SteamID, Username, Reason: string; const Identifier: Integer; const rconClient: TsgcWebSocketClient);
begin
  Self.SendRconCommand(Format('banid %s "%s" "%s"', [SteamID, Username, Reason]), Identifier, rconClient);
end;

class procedure TRCON.KickPlayer(const SteamID, Reason: string; const Identifier: Integer; const rconClient: TsgcWebSocketClient);
begin
  Self.SendRconCommand(Format('kick %s "%s"', [SteamID, Reason]), Identifier, rconClient);
end;

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

class procedure TRCON.SetAuthLevel(const SteamID, Username, Reason: string; const AuthLevel: Integer; const rconClient: TsgcWebSocketClient);
begin
  case AuthLevel of
    2:
      begin
        Self.SendRconCommand(Format('ownerid %s "%s" "%s"', [SteamID, Username, Reason]), 0, rconClient);
      end;
    1:
      begin
        Self.SendRconCommand(Format('moderatorid %s "%s" "%s"', [SteamID, Username, Reason]), 0, rconClient);
      end;
    0:
      begin
        Self.SendRconCommand(Format('removeowner %s', [SteamID]), 0, rconClient);
        Self.SendRconCommand(Format('removemoderator %s', [SteamID]), 0, rconClient);
      end;
  end;
end;

end.

