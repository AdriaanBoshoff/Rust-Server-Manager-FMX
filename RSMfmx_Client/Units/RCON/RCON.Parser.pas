unit RCON.Parser;

interface

uses
  RCON.Types;

type
  TRCONParser = class
    // Parse RAW json from websocket
    class function ParseRconMessage(const Data: string): TRCONMessage;
    // Parse Server Info
    class function ParseServerInfo(const Data: string): TRCONServerInfo;
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

class function TRCONParser.ParseServerInfo(const Data: string): TRCONServerInfo;
begin
  var jData := TJSONObject.ParseJSONValue(Data);
  try

  finally
    jData.Free;
  end;
end;

end.

