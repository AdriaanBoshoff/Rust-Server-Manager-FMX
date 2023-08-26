unit RSM.PlayerManager;

interface

uses
  System.Generics.Collections, RCON.Types;

type
  TPlayerManager = class
  public
  { Public Variables }
    onlinePlayers: TDictionary<string, TRCONPlayerListPlayer>;
  public
  { Public Methods }
    constructor Create;
    destructor Destroy; override;
    procedure LoadOnlinePlayersFromArray(const PlayerList: TArray<TRCONPlayerListPlayer>);
  end;

var
  playerManager: TPlayerManager;

implementation

{ TPlayerManager }

constructor TPlayerManager.Create;
begin
  inherited;
  onlinePlayers := TDictionary<string, TRCONPlayerListPlayer>.Create;
end;

destructor TPlayerManager.Destroy;
begin
  onlinePlayers.Free;
  inherited;
end;

procedure TPlayerManager.LoadOnlinePlayersFromArray(const PlayerList: TArray<TRCONPlayerListPlayer>);
begin
  self.onlinePlayers.Clear;

  for var aPlayer in PlayerList do
    self.onlinePlayers.Add(aPlayer.SteamID, aPlayer);
end;

initialization
begin
  playerManager := TPlayerManager.Create;
end;


finalization
begin
  playerManager.Free;
end;

end.

