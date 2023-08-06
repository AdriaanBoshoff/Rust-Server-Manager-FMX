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
  { Private Types }
    type
      TServerConfigMap = record // Map Settings
        MapName: string;
        MapIndex: Integer;
        CustomMapURL: string;
        MapSize: Integer;
        MapSeed: Int64;
      end;

    type
      TServerConfigMisc = record // Misc Settings
        MaxPlayers: Integer;
        CensorPlayerList: Boolean;
        GameMode: string;
      end;

    type
      TServerConfigNetworking = record // Networking Settings
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
  private
      { Private Variables }
    FConfigFile: string;
  private
      { Private Methods }
    function GetConfigFile: string;
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
    constructor Create;
    procedure SaveConfig;
    procedure LoadConfig;
  end;

var
  serverConfig: TServerConfig;

implementation

uses
  XSuperObject, System.SysUtils, System.IOUtils;

{ TServerConfig }

constructor TServerConfig.Create;
begin
  { Default Config }
  // General
  Self.Hostname := 'My Rust Server';
  Self.Tags := '';
  Self.Description := 'Welcome to my Rust Server\nThis is a new line\nThis is another new line';
  Self.ServerURL := 'https://rustservermanager.com';
  Self.ServerBannerURL := 'https://rustservermanager.com/banner.png';
  Self.AppLogoURL := 'https://rustservermanager.com/app-logo.png';

  // Map
  Self.Map.MapName := 'Procedural Map';
  Self.Map.MapIndex := 0;
  Self.Map.CustomMapURL := 'https://rustservermanager.com/maps/myCustomMap.map';
  Self.Map.MapSize := 3500;
  Self.Map.MapSeed := 352165132;

  // Misc
  Self.Misc.MaxPlayers := 50;
  Self.Misc.CensorPlayerList := True;
  Self.Misc.GameMode := '';

  // Networking
  Self.Networking.ServerIP := '0.0.0.0';
  Self.Networking.ServerPort := 28015; // UDP
  Self.Networking.ServerQueryPort := 28016; // UDP
  Self.Networking.RconIP := '0.0.0.0';
  Self.Networking.RconPort := 28017; // TCP
  Self.Networking.RconPassword := 'ChangeMe';
  Self.Networking.AppIP := '0.0.0.0';
  Self.Networking.AppPort := 28018; // TCP
  Self.Networking.AppPublicIP := '';

  // Setup Methods
  Self.FConfigFile := Self.GetConfigFile;

  // Load Config
  Self.LoadConfig;
end;

function TServerConfig.GetConfigFile: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'rsm\cfg\serverConfig.json';
end;

procedure TServerConfig.LoadConfig;
begin
  // Check if config file exists
  if not TFile.Exists(Self.FConfigFile) then
  begin
    Self.SaveConfig;
    Exit;
  end;

  // Load Config
  Self.AssignFromJSON(TFile.ReadAllText(Self.FConfigFile, TEncoding.UTF8));

  // Save Config again after loading to populate new properties in the file.
  Self.SaveConfig;
end;

procedure TServerConfig.SaveConfig;
begin
  if not TDirectory.Exists(ExtractFileDir(Self.FConfigFile)) then
    ForceDirectories(ExtractFilePath(Self.FConfigFile));

  TFile.WriteAllText(Self.FConfigFile, Self.AsJSON(True), TEncoding.UTF8);
end;

end.

