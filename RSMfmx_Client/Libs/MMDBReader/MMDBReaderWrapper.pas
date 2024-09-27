unit MMDBReaderWrapper;

interface

type
  TCountryInfo = record
  private
    type
      TCountryName = record
        Name: string;
        LangCode: string;
      end;
  public
    NameEN: string;
    Names: TArray<TCountryName>;
    ISOCode: string;
  end;

type
  TMMDBWrapper = class
  private
    FDBFilePath: string;
  public
    function isValidIPv4(const IPv4Address: string): Boolean;
    function isValidIPv6(const IPv6Address: string): Boolean;
    function ipExistsInDB(const IPAddress: string): Boolean;
    function GetCountryInfo(const IPAddress: string): TCountryInfo;
    function GetDBBuildDate: TDateTime;
  published
    property DBFilePath: string read FDBFilePath write FDBFilePath;
  end;

implementation

uses
  uMMDBReader, uMMDBInfo, uMMDBIPAddress, IPTypesX, System.SysUtils;

{ TMMDBWrapper }

function TMMDBWrapper.GetCountryInfo(const IPAddress: string): TCountryInfo;
var
  iTrash: Integer;
begin
  if not FileExists(FDBFilePath) then
    raise Exception.Create(Format('The provided MMDB file path "%s" does not exists. Hint: Check the DBFilePath property.', [DBFilePath]));

  SetLength(Result.Names, 0);

  var reader := TMMDBReader.Create(FDBFilePath);
  var countryInfo := TMMDBIPCountryInfoEx.Create;
  try
    var aIP := TMMDBIPAddress.Parse(IPAddress);

    if reader.Find<TMMDBIPCountryInfoEx>(aIP, iTrash, countryInfo) then
    begin
      // ISO Code / Country Code
      Result.ISOCode := countryInfo.Country.ISOCode;
      // Names
      for var aName in countryInfo.Country.Names do
      begin
        var aCountryName: TCountryInfo.TCountryName;
        aCountryName.Name := aName.Value;
        aCountryName.LangCode := aName.Key;

        // Add to result array
        SetLength(Result.Names, Length(Result.Names) + 1);
        Result.Names[High(Result.Names)] := aCountryName;

        // English name
        if aName.Key.ToLower = 'en' then
          Result.NameEN := aName.Value;
      end;
    end
    else
      raise Exception.Create(Format('IP Address "%s" was not found in the local DB. DB Build Date: ' + DateTimeToStr(reader.Metadata.BuildDate), [IPAddress]));
  finally
    countryInfo.Free;
    reader.Free;
  end;
end;

function TMMDBWrapper.GetDBBuildDate: TDateTime;
begin
  var reader := TMMDBReader.Create(FDBFilePath);
  try
    Result := reader.Metadata.BuildDate;
  finally
    reader.Free;
  end;
end;

function TMMDBWrapper.ipExistsInDB(const IPAddress: string): Boolean;
var
  iTrash: Integer;
begin
  Result := False;

  var reader := TMMDBReader.Create(FDBFilePath);
  var countryInfo := TMMDBIPCountryInfoEx.Create;
  try
    var aIP := TMMDBIPAddress.Parse(IPAddress);

    Result := reader.Find<TMMDBIPCountryInfoEx>(aIP, iTrash, countryInfo);
  finally
    countryInfo.Free;
    reader.Free;
  end;
end;

function TMMDBWrapper.isValidIPv4(const IPv4Address: string): Boolean;
begin
  Result := IPTypesX.IsValidIPv4(IPv4Address);
end;

function TMMDBWrapper.isValidIPv6(const IPv6Address: string): Boolean;
begin
  Result := IPTypesX.IsValidIPv6(IPv6Address);
end;

end.

