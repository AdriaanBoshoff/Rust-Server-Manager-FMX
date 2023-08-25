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
  TRCON = class
    class procedure SendRconCommand(const Command: string; const Identifier: Integer; const rconClient: TsgcWebSocketClient);
  end;

type
  TRCONParser = class
    class function ParseRconMessage(const Data: string): TRCONMessage;
  end;

implementation

uses
  System.JSON;

{ TRCONParser }

class function TRCONParser.ParseRconMessage(const Data: string): TRCONMessage;
begin
  var jData := TJSONObject.ParseJSONValue(Data);
  try
    Result.aMessage := jData.GetValue<string>('Message');
    Result.aIdentifier := jData.GetValue<Integer>('Identifier');
    Result.aType := jData.GetValue<string>('Type');
  finally
    jData.Free;
  end;
end;

{ TRCON }

class procedure TRCON.SendRconCommand(const Command: string; const Identifier: Integer; const rconClient: TsgcWebSocketClient);
begin
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

