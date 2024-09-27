{ **************************************************************************** }
{                                                                              }
{ uMMDBInfo - This module is a part of the MMDB Reader project                 }
{                                                                              }
{ Created by Vitaly Yakovlev                                                   }
{ Date: October 22, 2019                                                       }
{ Copyright: (c) 2019 Vitaly Yakovlev                                          }
{ Website: http://optinsoft.net/                                               }
{                                                                              }
{ License: BSD 2-Clause License.                                               }
{                                                                              }
{ Redistribution and use in source and binary forms, with or without           }
{ modification, are permitted provided that the following conditions are met:  }
{                                                                              }
{ 1. Redistributions of source code must retain the above copyright notice,    }
{    this list of conditions and the following disclaimer.                     }
{                                                                              }
{ 2. Redistributions in binary form must reproduce the above copyright notice, }
{    this list of conditions and the following disclaimer in the documentation }
{    and/or other materials provided with the distribution.                    }
{                                                                              }
{ THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"  }
{ AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,        }
{ THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR       }
{ PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR            }
{ CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,        }
{ EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,          }
{ PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;  }
{ OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,     }
{ WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR      }
{ OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF       }
{ ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                                   }
{                                                                              }
{ Last edit by: Vitaly Yakovlev                                                }
{ Date: March 07, 2024                                                         }
{ Version: 1.5                                                                 }
{                                                                              }
{ Changelog:                                                                   }
{                                                                              }
{ v1.5:                                                                        }
{ - added debug exceptions:                                                    }
{     EMMDBDebugSubdivisionException,                                          }
{     EMMDBDebugIPCountryCityInfoException,                                    }
{     EMMDBDebugIPCountryCityInfoExException                                   }
{                                                                              }
{ v1.4:                                                                        }
{ - added TMMDBPostal                                                          }
{ - added TMMDBSubdivision amd TMMDBSubdivisionEx                              }
{ - added TMMDBRepresentedCountryInfoEx                                        }
{ - added TMMDBASN                                                             }
{ - added TMMDBISP                                                             }
{ - added TMMDBAnonymousIP                                                     }
{ - added TMMDBDomain                                                          }
{                                                                              }
{ v1.3:                                                                        }
{ - added TMMDBIPCountryCityInfo.Location                                      }
{                                                                              }
{ v1.2:                                                                        }
{ - added TMMDBLocation                                                        }
{ - added TMMDBIPCountryCityInfoEx.Location                                    }
{                                                                              }
{ v1.1:                                                                        }
{ - TMMDBIPInfo renamed to TMMDBIPCountryInfo                                  }
{ - TMMDBIPInfoEx renamed to TMMDBIPCountryInfoEx                              }
{ - added TMMDBCityInfo                                                        }
{ - added TMMDBCityInfoEx                                                      }
{ - added TMMDBIPCountryCityInfo                                               }
{ - added TMMDBIPCountryCityInfoEx                                             }
{                                                                              }
{ v1.0:                                                                        }
{ - Initial release                                                            }
{                                                                              }
{ **************************************************************************** }

unit uMMDBInfo;

interface

{$IFDEF DEBUG}
{.$DEFINE DEBUG_TMMDBSubdivision}
{.$DEFINE DEBUG_TMMDBIPCountryCityInfo}
{.$DEFINE DEBUG_TMMDBIPCountryCityInfoEx}
{$ENDIF}

uses
{$IF Defined(DEBUG_TMMDBSubdivision) or Defined(DEBUG_TMMDBIPCountryCityInfo) or Defined(DEBUG_TMMDBIPCountryCityInfoEx)}
  WinApi.Windows, System.SysUtils,
{$ENDIF}
  System.Generics.Collections, uMMDBReader;

type
  TMMDBContinentInfo = class(TObject)
  private
    _code: String;
    _geoname_id: Int64;
  public
    [TMMDBAttribute('code')]
    property Code: String read _code write _code;
    [TMMDBAttribute('geoname_id')]
    property GeonameId: Int64 read _geoname_id write _geoname_id;
  end;

  TMMDBCountryInfo = class(TObject)
  private
    _geoname_id: Int64;
    _iso_code: String;
    _is_in_european_union: Boolean;
  public
    [TMMDBAttribute('geoname_id')]
    property GeonameId: Int64 read _geoname_id write _geoname_id;
    [TMMDBAttribute('iso_code')]
    property ISOCode: String read _iso_code write _iso_code;
    [TMMDBAttribute('is_in_european_union')]
    property IsInEuropeanUnion: Boolean read _is_in_european_union write _is_in_european_union;
  end;

  TMMDBRepresentedCountryInfo = class(TMMDBCountryInfo)
  private
    _type: String;
  public
    [TMMDBAttribute('type')]
    property RType: String read _type write _type;
  end;

  TMMDBTraitsInfo = class(TObject)
  private
    _is_anonymous_proxy: Boolean;
    _is_satellite_provider: Boolean;
  public
    [TMMDBAttribute('is_anonymous_proxy')]
    property IsAnonymousProxy: Boolean read _is_anonymous_proxy write _is_anonymous_proxy;
    [TMMDBAttribute('is_satellite_provider')]
    property IsSatelliteProvider: Boolean read _is_satellite_provider write _is_satellite_provider;
  end;

  TMMDBIPCountryInfo = class(TObject)
  private
    _continent: TMMDBContinentInfo;
    _country: TMMDBCountryInfo;
    _registered_country: TMMDBCountryInfo;
    _represented_country: TMMDBRepresentedCountryInfo;
    _traits: TMMDBTraitsInfo;
  public
    constructor Create;
    destructor Destroy; override;
    //
    [TMMDBAttribute('continent')]
    property Continent: TMMDBContinentInfo read _continent;
    [TMMDBAttribute('country')]
    property Country: TMMDBCountryInfo read _country;
    [TMMDBAttribute('registered_country')]
    property RegisteredCountry: TMMDBCountryInfo read _registered_country;
    [TMMDBAttribute('represented_country')]
    property RepresentedCountry: TMMDBRepresentedCountryInfo read _represented_country;
    [TMMDBAttribute('traits')]
    property Traits: TMMDBTraitsInfo read _traits;
  end;

  TMMDBCityInfo = class(TObject)
  private
    _geoname_id: Int64;
  public
    constructor Create;
    destructor Destroy; override;
    [TMMDBAttribute('geoname_id')]
    property GeonameId: Int64 read _geoname_id write _geoname_id;
  end;

  TMMDBLocation = class(TObject)
  private
    _accuracy_radius: Integer;
    _latitude: Double;
    _longitude: Double;
    _metro_code: Integer;
    _time_zone: String;
  public
    [TMMDBAttribute('accuracy_radius')]
    property Accuracy: Integer read _accuracy_radius write _accuracy_radius;
    [TMMDBAttribute('latitude')]
    property Latitude: Double read _latitude write _latitude;
    [TMMDBAttribute('longitude')]
    property Longitude: Double read _longitude write _longitude;
    [TMMDBAttribute('metro_code')]
    property MetroCode: Integer read _metro_code write _metro_code;
    [TMMDBAttribute('time_zone')]
    property TimeZone: String read _time_zone write _time_zone;
  end;

  TMMDBPostal = class(TObject)
  private
    _code: String;
  public
    [TMMDBAttribute('code')]
    property Code: String read _code write _code;
  end;

  TMMDBSubdivision = class(TMMDBCountryInfo)
  end;

  TMMDBIPCountryCityInfo = class(TMMDBIPCountryInfo)
  private
    _city: TMMDBCityInfo;
    _location: TMMDBLocation;
    _postal: TMMDBPostal;
    _subdivisions: TList<TMMDBSubdivision>;
  public
    constructor Create;
    destructor Destroy; override;
    //
    [TMMDBAttribute('city')]
    property City: TMMDBCityInfo read _city;
    [TMMDBAttribute('location')]
    property Location: TMMDBLocation read _location;
    [TMMDBAttribute('postal')]
    property Postal: TMMDBPostal read _postal;
    [TMMDBAttribute('subdivisions')]
    property Subdivisions: TList<TMMDBSubdivision> read _subdivisions;
  end;

  TMMDBContinentInfoEx = class(TMMDBContinentInfo)
  private
    _names: TDictionary<string, string>;
  public
    constructor Create;
    destructor Destroy; override;
    //
    [TMMDBAttribute('names')]
    property Names: TDictionary<string, string> read _names;
  end;

  TMMDBCountryInfoEx = class(TMMDBCountryInfo)
  private
    _names: TDictionary<string, string>;
  public
    constructor Create;
    destructor Destroy; override;
    //
    [TMMDBAttribute('names')]
    property Names: TDictionary<string, string> read _names;
  end;

  TMMDBRepresentedCountryInfoEx = class(TMMDBCountryInfoEx)
  private
    _type: String;
  public
    [TMMDBAttribute('type')]
    property RType: String read _type write _type;
  end;

  TMMDBIPCountryInfoEx = class(TObject)
  private
    _continent: TMMDBContinentInfoEx;
    _country: TMMDBCountryInfoEx;
    _registered_country: TMMDBCountryInfoEx;
    _represented_country: TMMDBRepresentedCountryInfoEx;
    _traits: TMMDBTraitsInfo;
  public
    constructor Create;
    destructor Destroy; override;
    //
    [TMMDBAttribute('continent')]
    property Continent: TMMDBContinentInfoEx read _continent;
    [TMMDBAttribute('country')]
    property Country: TMMDBCountryInfoEx read _country;
    [TMMDBAttribute('registered_country')]
    property RegisteredCountry: TMMDBCountryInfoEx read _registered_country;
    [TMMDBAttribute('represented_country')]
    property RepresentedCountry: TMMDBRepresentedCountryInfoEx read _represented_country;
    [TMMDBAttribute('traits')]
    property Traits: TMMDBTraitsInfo read _traits;
  end;

  TMMDBCityInfoEx = class(TMMDBCityInfo)
  private
    _names: TDictionary<string, string>;
  public
    constructor Create;
    destructor Destroy; override;
    //
    [TMMDBAttribute('names')]
    property Names: TDictionary<string, string> read _names;
  end;

  TMMDBSubdivisionEx = class(TMMDBCountryInfoEx)
{$IFDEF DEBUG_TMMDBSubdivision}
  public
    constructor Create;
    destructor Destroy; override;
{$ENDIF}
  end;

  TMMDBIPCountryCityInfoEx = class(TMMDBIPCountryInfoEx)
  private
    _city: TMMDBCityInfoEx;
    _location: TMMDBLocation;
    _postal: TMMDBPostal;
    _subdivisions: TObjectList<TMMDBSubdivisionEx>;
  public
    constructor Create;
    destructor Destroy; override;
    //
    [TMMDBAttribute('city')]
    property City: TMMDBCityInfoEx read _city;
    [TMMDBAttribute('location')]
    property Location: TMMDBLocation read _location;
    [TMMDBAttribute('postal')]
    property Postal: TMMDBPostal read _postal;
    [TMMDBAttribute('subdivisions')]
    property Subdivisions: TObjectList<TMMDBSubdivisionEx> read _subdivisions;
  end;

  TMMDBASN = class(TObject)
  private
    _autonomous_system_number: Int64;
    _autonomous_system_organization: String;
  public
    [TMMDBAttribute('autonomous_system_number')]
    property AutonomousSystemNumber: Int64 read _autonomous_system_number write _autonomous_system_number;
    [TMMDBAttribute('autonomous_system_organization')]
    property AutonomousSystemOrganization: String read _autonomous_system_organization write _autonomous_system_organization;
  end;

  TMMDBISP = class(TMMDBASN)
  private
    _isp: String;
    _organization: String;
  public
    [TMMDBAttribute('isp')]
    property ISP: String read _isp write _isp;
    [TMMDBAttribute('organization')]
    property Organization: String read _organization write _organization;
  end;

  TMMDBAnonymousIP = class(TObject)
  private
    _is_anonymous: Boolean;
    _is_anonymous_vpn: Boolean;
    _is_hosting_provider: Boolean;
    _is_public_proxy: Boolean;
    _is_residential_proxy: Boolean;
    _is_tor_exit_node: Boolean;
  public
    [TMMDBAttribute('is_anonymous')]
    property IsAnonymous: Boolean read _is_anonymous write _is_anonymous;
    [TMMDBAttribute('is_anonymous_vpn')]
    property IsAnonymousVPN: Boolean read _is_anonymous_vpn write _is_anonymous_vpn;
    [TMMDBAttribute('is_hosting_provider')]
    property IsHostingProvider: Boolean read _is_hosting_provider write _is_hosting_provider;
    [TMMDBAttribute('is_public_proxy')]
    property IsPublicProxy: Boolean read _is_public_proxy write _is_public_proxy;
    [TMMDBAttribute('is_residential_proxy')]
    property IsResidentialProxy: Boolean read _is_residential_proxy write _is_residential_proxy;
    [TMMDBAttribute('is_tor_exit_node')]
    property IsTorExitNode: Boolean read _is_tor_exit_node write _is_tor_exit_node;
  end;

  TMMDBDomain = class(TObject)
  private
    _domain: String;
  public
    [TMMDBAttribute('domain')]
    property Domain: String read _domain write _domain;
  end;

{$IF Defined(DEBUG_TMMDBSubdivision) or Defined(DEBUG_TMMDBIPCountryCityInfo) or Defined(DEBUG_TMMDBIPCountryCityInfoEx)}
  EMMDBDebugException = class(Exception);
  EMMDBDebugSubdivisionException = class(EMMDBDebugException);
  EMMDBDebugIPCountryCityInfoException = class(EMMDBDebugException);
  EMMDBDebugIPCountryCityInfoExException = class(EMMDBDebugException);
{$ENDIF}

implementation

{ TMMDBIPCountryInfo }

constructor TMMDBIPCountryInfo.Create;
begin
  _continent := TMMDBContinentInfo.Create;
  _country := TMMDBCountryInfo.Create;
  _registered_country := TMMDBCountryInfo.Create;
  _represented_country := TMMDBRepresentedCountryInfo.Create;
  _traits := TMMDBTraitsInfo.Create;
end;

destructor TMMDBIPCountryInfo.Destroy;
begin
  _traits.Free;
  _represented_country.Free;
  _registered_country.Free;
  _country.Free;
  _continent.Free;
  inherited;
end;

{ TMMDBContinentInfoEx }

constructor TMMDBContinentInfoEx.Create;
begin
  inherited;
  _names := TDictionary<string, string>.Create;
end;

destructor TMMDBContinentInfoEx.Destroy;
begin
  _names.Free;
  inherited;
end;

{ TMMDBCountryInfoEx }

constructor TMMDBCountryInfoEx.Create;
begin
  inherited;
  _names := TDictionary<string, string>.Create;
end;

destructor TMMDBCountryInfoEx.Destroy;
begin
  _names.Free;
  inherited;
end;

{ TMMDBIPCountryInfoEx }

constructor TMMDBIPCountryInfoEx.Create;
begin
  _continent := TMMDBContinentInfoEx.Create;
  _country := TMMDBCountryInfoEx.Create;
  _registered_country := TMMDBCountryInfoEx.Create;
  _represented_country := TMMDBRepresentedCountryInfoEx.Create;
  _traits := TMMDBTraitsInfo.Create;
end;

destructor TMMDBIPCountryInfoEx.Destroy;
begin
  _traits.Free;
  _represented_country.Free;
  _registered_country.Free;
  _country.Free;
  _continent.Free;
  inherited;
end;

{ TMMDBCityInfo }

constructor TMMDBCityInfo.Create;
begin

end;

destructor TMMDBCityInfo.Destroy;
begin

  inherited;
end;

{ TMMDBIPCountryCityInfo }

{$IFDEF DEBUG_TMMDBIPCountryCityInfo}
var
  TMMDBIPCountryCityInfo_Count: Integer = 0;
{$ENDIF}

constructor TMMDBIPCountryCityInfo.Create;
begin
  inherited;
  _city := TMMDBCityInfo.Create;
  _location := TMMDBLocation.Create;
  _postal := TMMDBPostal.Create;
  _subdivisions := TList<TMMDBSubdivision>.Create;
{$IFDEF DEBUG_TMMDBIPCountryCityInfo}
  OutputDebugString(PChar('TMMDBIPCountryCityInfo_Count: '+IntToStr(
    InterlockedIncrement(TMMDBIPCountryCityInfo_Count))));
{$ENDIF}
end;

destructor TMMDBIPCountryCityInfo.Destroy;
begin
{$IFDEF DEBUG_TMMDBIPCountryCityInfo}
  OutputDebugString(PChar('TMMDBIPCountryCityInfo_Count: '+IntToStr(
    InterlockedDecrement(TMMDBIPCountryCityInfo_Count))));
{$ENDIF}
  _subdivisions.Free;
  _postal.Free;
  _location.Free;
  _city.Free;
  inherited;
end;

{ TMMDBCityInfoEx }

constructor TMMDBCityInfoEx.Create;
begin
  inherited;
  _names := TDictionary<string, string>.Create;
end;

destructor TMMDBCityInfoEx.Destroy;
begin
  _names.Free;
  inherited;
end;

{ TMMDBIPCountryCityInfoEx }

{$IFDEF DEBUG_TMMDBIPCountryCityInfoEx}
var
  TMMDBIPCountryCityInfoEx_Count: Integer = 0;
{$ENDIF}

constructor TMMDBIPCountryCityInfoEx.Create;
begin
  inherited;
  _city := TMMDBCityInfoEx.Create;
  _location := TMMDBLocation.Create;
  _postal := TMMDBPostal.Create;
  _subdivisions := TObjectList<TMMDBSubdivisionEx>.Create(True);
{$IFDEF DEBUG_TMMDBIPCountryCityInfoEx}
  OutputDebugString(PChar('TMMDBIPCountryCityInfoEx_Count: '+IntToStr(
    InterlockedIncrement(TMMDBIPCountryCityInfoEx_Count))));
{$ENDIF}
end;

destructor TMMDBIPCountryCityInfoEx.Destroy;
begin
{$IFDEF DEBUG_TMMDBIPCountryCityInfoEx}
  OutputDebugString(PChar('TMMDBIPCountryCityInfoEx_Count: '+IntToStr(
    InterlockedDecrement(TMMDBIPCountryCityInfoEx_Count))));
{$ENDIF}
  _subdivisions.Free;
  _postal.Free;
  _location.Free;
  _city.Free;
  inherited;
end;

{$IFDEF DEBUG_TMMDBSubdivision}

{ TMMDBSubdivisionEx }

var
  TMMDBSubdivisionEx_Count: Integer = 0;

constructor TMMDBSubdivisionEx.Create;
begin
  inherited;
  OutputDebugString(PChar('TMMDBSubdivisionEx_Count: '+IntToStr(
    InterlockedIncrement(TMMDBSubdivisionEx_Count))));
end;

destructor TMMDBSubdivisionEx.Destroy;
begin
  OutputDebugString(PChar('TMMDBSubdivisionEx_Count: '+IntToStr(
    InterlockedDecrement(TMMDBSubdivisionEx_Count))));
  inherited;
end;

{$ENDIF}

{$IF Defined(DEBUG_TMMDBSubdivision) or Defined(DEBUG_TMMDBIPCountryCityInfo) or Defined(DEBUG_TMMDBIPCountryCityInfoEx)}
initialization

finalization
{$IFDEF DEBUG_TMMDBSubdivision}
  if TMMDBSubdivisionEx_Count <> 0 then
    raise EMMDBDebugSubdivisionException.Create('DEBUG_TMMDBSubdivision');
{$ENDIF}
{$IFDEF DEBUG_TMMDBIPCountryCityInfo}
  if TMMDBIPCountryCityInfo_Count <> 0 then
    raise EMMDBDebugIPCountryCityInfoException.Create('DEBUG_TMMDBIPCountryCityInfo');
{$ENDIF}
{$IFDEF DEBUG_TMMDBIPCountryCityInfoEx}
  if TMMDBIPCountryCityInfoEx_Count <> 0 then
    raise EMMDBDebugIPCountryCityInfoExException.Create('DEBUG_TMMDBIPCountryCityInfoEx');
{$ENDIF}

{$ENDIF}

end.
