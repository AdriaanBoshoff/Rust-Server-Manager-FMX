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
    // Parse PlayerList
    class function ParsePlayerList(const Data: string): TArray<TRCONPlayerListPlayer>;
  end;

implementation

uses
  System.JSON, System.SysUtils, System.Classes, System.DateUtils;

{ TRCONParser }

class function TRCONParser.ParsePlayerList(const Data: string): TArray<TRCONPlayerListPlayer>;
begin
  var jPlayers := TJSONObject.ParseJSONValue(Data);
  try
    SetLength(Result, (jPlayers as TJSONArray).Count);
    var I := 0;
    for var jPlayer in jPlayers as TJSONArray do
    begin
      // SteamID
      if not jPlayer.TryGetValue<string>('SteamID', Result[I].SteamID) then
        Result[I].SteamID := 'MISSING FIELD';

      // OwnerSteamID
      if not jPlayer.TryGetValue<string>('OwnerSteamID', Result[I].OwnerSteamID) then
        Result[I].OwnerSteamID := 'MISSING FIELD';

      // DisplayName
      if not jPlayer.TryGetValue<string>('DisplayName', Result[I].DisplayName) then
        Result[I].DisplayName := 'MISSING FIELD';

      // Ping
      if not jPlayer.TryGetValue<Integer>('Ping', Result[I].Ping) then
        Result[I].Ping := -1;

      // Address
      if not jPlayer.TryGetValue<string>('Address', Result[I].Address) then
        Result[I].Address := 'MISSING FIELD:-1';

      // Get IP and Port from address
      if not Result[I].Address.Trim.IsEmpty then
      begin
        var slAddress := TStringList.Create;
        try
          slAddress.StrictDelimiter := True;
          slAddress.Delimiter := ':';
          slAddress.DelimitedText := Result[I].Address;

          // IP
          Result[I].IP := slAddress[0];

          // Port
          Result[I].Port := slAddress[1].ToInteger;
        finally
          slAddress.Free;
        end;
      end
      else
      begin
        // IP
        Result[I].IP := 'MISSING FIELD';

        // Port
        Result[I].Port := -1;
      end;

      // Connected Seconds
      if not jPlayer.TryGetValue<Integer>('ConnectedSeconds', Result[I].ConnectedSeconds) then
        Result[I].ConnectedSeconds := -1;

      // Health
      if not jPlayer.TryGetValue<Double>('Health', Result[I].Health) then
        Result[I].Health := -1;

      Inc(I);
    end;
  finally
    jPlayers.Free;
  end;
end;

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

