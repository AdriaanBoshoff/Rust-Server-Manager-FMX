unit RCON.Types;

interface

uses
  Ics.Fmx.OverbyteIcsWebSocketCli;

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
  TRconChat = record
    Channel: Integer;
    Message: string;
    UserID: string;
    Username: string;
    Color: string;
    DTM: TDateTime;
    isBetterChat: Boolean;
    BetterChatUsername: string;
  end;

type
  TRCON = class
    class procedure SendRconCommand(const Command: string; const Identifier: Integer; const rconClient: TSslWebSocketCli);
    class procedure KickPlayer(const SteamID, Reason: string; const Identifier: Integer; const rconClient: TSslWebSocketCli);
    class procedure BanPlayerID(const SteamID, Username, Reason: string; const Identifier: Integer; const rconClient: TSslWebSocketCli);
    class procedure SetAuthLevel(const SteamID, Username, Reason: string; const AuthLevel: Integer; const rconClient: TSslWebSocketCli);
  end;

implementation

uses
  System.JSON, System.SysUtils;

{ TRCON }

class procedure TRCON.BanPlayerID(const SteamID, Username, Reason: string; const Identifier: Integer; const rconClient: TSslWebSocketCli);
begin
  Self.SendRconCommand(Format('banid %s "%s" "%s"', [SteamID, Username, Reason]), Identifier, rconClient);
end;

class procedure TRCON.KickPlayer(const SteamID, Reason: string; const Identifier: Integer; const rconClient: TSslWebSocketCli);
begin
  Self.SendRconCommand(Format('kick %s "%s"', [SteamID, Reason]), Identifier, rconClient);
end;

class procedure TRCON.SendRconCommand(const Command: string; const Identifier: Integer; const rconClient: TSslWebSocketCli);
begin
  if not rconClient.Connected then
    Exit;

  var jCommand := TJSONObject.Create;
  try
    jCommand.AddPair('Message', Command);
    jCommand.AddPair('Identifier', Identifier);

    rconClient.WSSendText(nil, jCommand.ToJSON);
  finally
    jCommand.Free;
  end;
end;

class procedure TRCON.SetAuthLevel(const SteamID, Username, Reason: string; const AuthLevel: Integer; const rconClient: TSslWebSocketCli);
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

