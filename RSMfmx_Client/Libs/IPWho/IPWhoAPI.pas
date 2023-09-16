unit IPWhoAPI;

interface

type
  TIPWhoFlag = record
    imgURL: string;
    emoji: string;
    emojiUnicode: string;
  end;

type
  TIPWhoConnection = record
    asn: integer;
    org: string;
    isp: string;
    domain: string;
  end;

type
  TIPWhoTimezone = record
    id: string;
    abbr: string;
    isDST: boolean;
    offset: integer;
    utc: string;
    currentTime: TDateTime;
  end;

type
  TIPWhoInfo = record
    ip: string;
    success: boolean;
    ipType: string;
    continent: string;
    continentCode: string;
    country: string;
    countryCode: string;
    region: string;
    regionCode: string;
    city: string;
    latitude: Double;
    longitude: Double;
    isEU: Boolean;
    postal: string;
    callingCode: string;
    capital: string;
    borders: string;
    flag: TIPWhoFlag;
    connection: TIPWhoConnection;
    timezone: TIPWhoTimezone;
    rawData: string;
  end;

type
  TIPWho = class
  private
    const
      API_URL = 'https://ipwho.is/';
  public
    class function GetIPInfo(const IP: string = ''): TIPWhoInfo;
  end;

implementation

uses
  System.JSON, System.DateUtils, Rest.Client, Rest.Types;

{ TIPWho }

class function TIPWho.GetIPInfo(const IP: string): TIPWhoInfo;
begin
  Result.rawData := '';

  var rest := TRESTRequest.Create(nil);
  try
    // Setup Rest Request
    rest.Client := TRESTClient.Create(rest);
    rest.Response := TRESTResponse.Create(rest);
    rest.Client.BaseURL := API_URL;
    // Pass IP address
    rest.Resource := IP;
    // Execute
    rest.Execute;

    // Parse values if status code is 200
    if rest.Response.StatusCode = 200 then
    begin
      // Raw Data
      Result.rawData := rest.Response.Content;

      // IP
      if not rest.Response.JSONValue.TryGetValue<string>('ip', Result.ip) then
        Result.ip := '';

      // Success
      if not rest.Response.JSONValue.TryGetValue<boolean>('success', Result.success) then
        Result.success := False;

      // Type
      if not rest.Response.JSONValue.TryGetValue<string>('type', Result.ipType) then
        Result.ipType := '';

      // Continent
      if not rest.Response.JSONValue.TryGetValue<string>('continent', Result.continent) then
        Result.continent := '';

      // Continent Code
      if not rest.Response.JSONValue.TryGetValue<string>('continent_code', Result.continentCode) then
        Result.continentCode := '';

      // Country
      if not rest.Response.JSONValue.TryGetValue<string>('country', Result.country) then
        Result.country := '';

      // Country Code
      if not rest.Response.JSONValue.TryGetValue<string>('country_code', Result.countryCode) then
        Result.countryCode := '';

      // Region
      if not rest.Response.JSONValue.TryGetValue<string>('region', Result.region) then
        Result.region := '';

      // Region Code
      if not rest.Response.JSONValue.TryGetValue<string>('region_code', Result.regionCode) then
        Result.regionCode := '';

      // City
      if not rest.Response.JSONValue.TryGetValue<string>('city', Result.city) then
        Result.city := '';

      // Latitude
      if not rest.Response.JSONValue.TryGetValue<Double>('latitude', Result.latitude) then
        Result.latitude := -1;

      // Longitude
      if not rest.Response.JSONValue.TryGetValue<Double>('longitude', Result.longitude) then
        Result.longitude := -1;

      // Is EU
      if not rest.Response.JSONValue.TryGetValue<boolean>('is_eu', Result.isEU) then
        Result.isEU := False;

      // Postal
      if not rest.Response.JSONValue.TryGetValue<string>('postal', Result.postal) then
        Result.postal := '';

      // Calling Code
      if not rest.Response.JSONValue.TryGetValue<string>('calling_code', Result.callingCode) then
        Result.callingCode := '';

      // Capital
      if not rest.Response.JSONValue.TryGetValue<string>('capital', Result.capital) then
        Result.capital := '';

      // Borders
      if not rest.Response.JSONValue.TryGetValue<string>('borders', Result.borders) then
        Result.borders := '';

      { Flag Info }
      // Flag Image URL
      if not rest.Response.JSONValue.TryGetValue<string>('flag.img', Result.flag.imgURL) then
        Result.flag.imgURL := '';
      // Flag Emoji
      if not rest.Response.JSONValue.TryGetValue<string>('flag.emoji', Result.flag.emoji) then
        Result.flag.emoji := '';
      // Flag Unicode
      if not rest.Response.JSONValue.TryGetValue<string>('flag.emoji_unicode', Result.flag.emojiUnicode) then
        Result.flag.emojiUnicode := '';

      { Connection Info }
      // ASN
      if not rest.Response.JSONValue.TryGetValue<integer>('connection.asn', Result.connection.asn) then
        Result.connection.asn := -1;
      // ORG
      if not rest.Response.JSONValue.TryGetValue<string>('connection.org', Result.connection.org) then
        Result.connection.org := '';
      // ISP
      if not rest.Response.JSONValue.TryGetValue<string>('connection.isp', Result.connection.isp) then
        Result.connection.isp := '';
      // Domain
      if not rest.Response.JSONValue.TryGetValue<string>('connection.domain', Result.connection.domain) then
        Result.connection.domain := '';

      { Timezone }
      // ID
      if not rest.Response.JSONValue.TryGetValue<string>('timezone.id', Result.timezone.id) then
        Result.timezone.id := '';
      // Abbr
      if not rest.Response.JSONValue.TryGetValue<string>('timezone.abbr', Result.timezone.abbr) then
        Result.timezone.abbr := '';
      // Is DST
      if not rest.Response.JSONValue.TryGetValue<Boolean>('timezone.is_dst', Result.timezone.isDST) then
        Result.timezone.isDST := False;
      // Offset
      if not rest.Response.JSONValue.TryGetValue<integer>('timezone.offset', Result.timezone.offset) then
        Result.timezone.offset := -1;
      // UTC
      if not rest.Response.JSONValue.TryGetValue<string>('timezone.utc', Result.timezone.utc) then
        Result.timezone.utc := '';
      // Current DateTime
      var tmpDateTime: string;
      if not rest.Response.JSONValue.TryGetValue<string>('timezone.current_time', tmpDateTime) then
        Result.timezone.currentTime := 0
      else
        Result.timezone.currentTime := ISO8601ToDate(tmpDateTime, False);
    end;
  finally
    rest.Free;
  end;
end;

end.

