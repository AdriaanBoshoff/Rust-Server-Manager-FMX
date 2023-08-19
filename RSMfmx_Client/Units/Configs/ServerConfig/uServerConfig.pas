unit uServerConfig;

interface

uses
  System.Classes;

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
      end;

    type
      TServerConfigGameMode = record // Game Mode settings
        Index: Integer;
        GameModeName: string;
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
    FServerCFG: TStringList;
  private
      { Private Methods }
    function GetConfigFile: string;
    function GetServerCFGFile: string;
    function GetServerCFGText: string;
    procedure SetServerCFGText(const Value: string);
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
    GameMode: TServerConfigGameMode;
    constructor Create;
    destructor Destroy; override;
    procedure SaveConfig;
    procedure LoadConfig;
    property ServerCFGText: string read GetServerCFGText write SetServerCFGText;
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

  // GameMode
  Self.GameMode.Index := 0;
  Self.GameMode.GameModeName := 'vanilla';

  // Setup Methods
  Self.FConfigFile := Self.GetConfigFile;

  // ServerCFG - Used for server.cfg file
  FServerCFG := TStringList.Create;
  FServerCFG.NameValueSeparator := ' ';

  // Load Config
  Self.LoadConfig;
end;

destructor TServerConfig.Destroy;
begin
  // ServerCFG - Used for server.cfg file
  FServerCFG.Free;

  inherited;
end;

function TServerConfig.GetConfigFile: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'rsm\cfg\serverConfig.json';
end;

function TServerConfig.GetServerCFGFile: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'server\rsm\cfg\server.cfg';
end;

function TServerConfig.GetServerCFGText: string;
begin
  Result := Self.FServerCFG.Text;
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

  // server.cfg file
  if TFile.Exists(GetServerCFGFile) then
    Self.FServerCFG.LoadFromFile(GetServerCFGFile, TEncoding.UTF8);

  // Save Config again after loading to populate new properties in the file.
  Self.SaveConfig;
end;

procedure TServerConfig.SaveConfig;
begin
  // serverConfig.json dir
  if not TDirectory.Exists(ExtractFileDir(Self.FConfigFile)) then
    ForceDirectories(ExtractFileDir(Self.FConfigFile));

  // server.cfg dir
  if not TDirectory.Exists(ExtractFileDir(Self.GetServerCFGFile)) then
    ForceDirectories(ExtractFileDir(Self.GetServerCFGFile));

  // Modify server.cfg file
  // Hostname
  if Self.FServerCFG.IndexOfName('server.hostname') <> -1 then
    self.FServerCFG.Delete(Self.FServerCFG.IndexOfName('server.hostname'));
  Self.FServerCFG.AddPair('server.hostname', Self.Hostname.QuotedString('"'));
  // Tags
  if Self.FServerCFG.IndexOfName('server.tags') <> -1 then
    self.FServerCFG.Delete(Self.FServerCFG.IndexOfName('server.tags'));
  Self.FServerCFG.AddPair('server.tags', Self.Tags.QuotedString('"'));
  // Description
  if Self.FServerCFG.IndexOfName('server.description') <> -1 then
    self.FServerCFG.Delete(Self.FServerCFG.IndexOfName('server.description'));
  Self.FServerCFG.AddPair('server.description', Self.Description.QuotedString('"'));
  // Server URL
  if Self.FServerCFG.IndexOfName('server.url') <> -1 then
    self.FServerCFG.Delete(Self.FServerCFG.IndexOfName('server.url'));
  Self.FServerCFG.AddPair('server.url', Self.ServerURL.QuotedString('"'));
  // Server Header
  if Self.FServerCFG.IndexOfName('server.headerimage') <> -1 then
    self.FServerCFG.Delete(Self.FServerCFG.IndexOfName('server.headerimage'));
  Self.FServerCFG.AddPair('server.headerimage', Self.ServerBannerURL.QuotedString('"'));
  // Server logo image Rust+ App
  if Self.FServerCFG.IndexOfName('server.logoimage') <> -1 then
    self.FServerCFG.Delete(Self.FServerCFG.IndexOfName('server.logoimage'));
  Self.FServerCFG.AddPair('server.logoimage', Self.AppLogoURL.QuotedString('"'));

  // server.cfg File
  Self.FServerCFG.SaveToFile(GetServerCFGFile, TEncoding.UTF8);

  // Write Data
  TFile.WriteAllText(Self.FConfigFile, Self.AsJSON(True), TEncoding.UTF8);
end;

procedure TServerConfig.SetServerCFGText(const Value: string);
begin
  Self.FServerCFG.Text := Value;
end;

end.

