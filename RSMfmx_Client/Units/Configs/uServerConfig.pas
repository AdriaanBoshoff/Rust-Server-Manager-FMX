unit uServerConfig;

interface

//////////////////////////////////////////////////////////////
///                      *** Changes ***
///  =========================================================
///
///
//////////////////////////////////////////////////////////////

type
  TServerConfig = class
  private
    // Map Settings
    type
      TServerConfigMap = record
        MapName: string;
        MapIndex: Integer;
        CustomMapURL: string;
        MapSize: Integer;
        MapSeed: Int64;
      end;

    // Misc Settings
    type
      TServerConfigMisc = record
        MaxPlayers: Integer;
        CensorPlayerList: Boolean;
        GameMode: string;
      end;

    // Networking Settings
    type
      TServerConfigNetworking = record
        ServerIP: string;
        ServerPort: Integer;
        ServerQueryPort: Integer;
        RconIP: string;
        RconPort: Integer;
        RconPassword: string;
        AppIP: string;
        AppPort: Integer;
        AppPublicIP: string;
      end;
  public
    // General Settings
    Hostname: string;
    Tags: string;
    Description: string;
    ServerURL: string;
    ServerBannerURL: string;
    AppLogoURL: string;
    // Record Settings
    Map: TServerConfigMap;
    Misc: TServerConfigMisc;
    Networking: TServerConfigNetworking;
  end;

var
  serverConfig: TServerConfig;

implementation

end.

