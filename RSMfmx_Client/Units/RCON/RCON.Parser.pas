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
  System.JSON, System.SysUtils, System.DateUtils;

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
  // Format Settings
  var fs: TFormatSettings;
  fs.DateSeparator := '/';
  fs.TimeSeparator := ':';
  fs.ShortDateFormat := 'mm/dd/yyyy';
  fs.ShortTimeFormat := 'hh:nn:ss';
  fs.DecimalSeparator := '.';

  var jData := TJSONObject.ParseJSONValue(Data);
  try
    // Hostname
    if not jData.TryGetValue<string>('Hostname', Result.Hostname) then
      Result.Hostname := 'MISSING FIELD';

    // Max Players
    if not jData.TryGetValue<Integer>('MaxPlayers', Result.MaxPlayers) then
      Result.MaxPlayers := -1;

    // Players
    if not jData.TryGetValue<Integer>('Players', Result.Players) then
      Result.Players := -1;

    // Queued
    if not jData.TryGetValue<Integer>('Queued', Result.Queued) then
      Result.Queued := -1;

    // Joining
    if not jData.TryGetValue<Integer>('Joining', Result.Joining) then
      Result.Joining := -1;

    // Entity Count
    if not jData.TryGetValue<Integer>('EntityCount', Result.EntityCount) then
      Result.EntityCount := -1;

    // Game Time
    var tempGameTime: string;
    if jData.TryGetValue<string>('GameTime', tempGameTime) then
    begin
      Result.GameTime := StrToDateTime(tempGameTime, fs);
    end;

    // Uptime
    if not jData.TryGetValue<Integer>('Uptime', Result.UpTime) then
      Result.UpTime := -1;

    // Map
    if not jData.TryGetValue<string>('Map', Result.Map) then
      Result.Map := 'MISSING FIELD';

    // FPS
    var tempFPS: Double;
    if jData.TryGetValue<Double>('Framerate', tempFPS) then
      Result.FPS := Round(tempFPS)
    else
      Result.FPS := -1;

    // Memory
    if not jData.TryGetValue<Integer>('Memory', Result.Memory) then
      Result.Memory := -1;

    // Memory Usage System
    if not jData.TryGetValue<Integer>('MemoryUsageSystem', Result.MemoryUsageSystem) then
      Result.MemoryUsageSystem := -1;

    // Collections
    if not jData.TryGetValue<Integer>('Collections', Result.Collections) then
      Result.Collections := -1;

    // NetworkIn
    if not jData.TryGetValue<Integer>('NetworkIn', Result.NetworkIn) then
      Result.NetworkIn := -1;

    // NetworkOut
    if not jData.TryGetValue<Integer>('NetworkOut', Result.NetworkOut) then
      Result.NetworkOut := -1;

    // Restarting
    if not jData.TryGetValue<Boolean>('Restarting', Result.Restarting) then
      Result.Restarting := False;

    // Save Created Time
    var tempSaveCreatedTime: string;
    if jData.TryGetValue<string>('SaveCreatedTime', tempSaveCreatedTime) then
    begin
      Result.SaveCreatedTime := StrToDateTime(tempSaveCreatedTime, fs);
    end;

    // Version
    if not jData.TryGetValue<Integer>('Version', Result.Version) then
      Result.Version := -1;

    // Protocol
    if not jData.TryGetValue<string>('Protocol', Result.Protocol) then
      Result.Protocol := 'MISSING FIELD';
  finally
    jData.Free;
  end;
end;

end.

