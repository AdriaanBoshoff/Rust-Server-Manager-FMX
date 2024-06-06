unit RCON.Events;

interface

uses
  RCON.Types, RCON.Commands, System.Generics.Collections;

type
  TRCONEvents = class
    { Private Variables }
  private
    { Private Methods }
  private
    // Server Info
    procedure OnServerInfo(const serverInfo: TRCONServerInfo);
    // Player Count Changed. Gets called in OnServerInfo()
    procedure OnPlayerCountChanged(const OldCount, NewCount: Integer);
    // On Playerlist
    procedure OnPlayerList(const PlayerList: TArray<TRCONPlayerListPlayer>);
    // On Server Manifest
    procedure OnServerManifest(const Data: string);
    // On Chat
    procedure OnChat(const Chat: TRconChat);
    { Public Methods }
  public
    procedure OnRconMessage(const rconMessage: TRCONMessage);

  end;

var
  rconEvents: TRCONEvents;

implementation

uses
  RCON.Parser, ufrmMain, System.SysUtils, System.DateUtils, uServerInfo,
  RSM.PlayerManager, uframePlayerItem, ufrmPlayerManager, uMisc,
  uframeMessageBox, Rust.Manifest, udmChatDB;

{ TRCONEvents }

procedure TRCONEvents.OnChat(const Chat: TRconChat);
begin
  // On Chat. Fires when Identity is "-1" and Type is "Chat"
  dmChatDB.InsertChat(Chat);
end;

procedure TRCONEvents.OnPlayerCountChanged(const OldCount, NewCount: Integer);
begin
  // Player Count Changed. Request new playerlist
  TRCON.SendRconCommand(RCON_CMD_PLAYERLIST, RCON_ID_PLAYERLIST, frmMain.wsClientRcon);

  // frmMain.lblAppVersionValue.Text := Format('OLD: %d  NEW: %d', [OldCount, NewCount]);
end;

procedure TRCONEvents.OnPlayerList(const PlayerList: TArray<TRCONPlayerListPlayer>);
begin
  // Populate Player Manager
  PlayerManager.LoadOnlinePlayersFromArray(PlayerList);

  // Populate UI
  frmPlayerManager.SearchOnlinePlayersUI(frmPlayerManager.edtSearchOnlinePlayers.Text);
end;

procedure TRCONEvents.OnRconMessage(const rconMessage: TRCONMessage);
begin
  // All messages received from rcon will be processed here.

  // Identifier = -1
  if rconMessage.aIdentifier = -1 then
  begin
    // Type is "Chat"
    if rconMessage.aType = 'Chat' then
    begin
      OnChat(TRCONParser.ParseChat(rconMessage.aMessage));
    end;

    Exit;
  end;

  // Identifier = 0
  if rconMessage.aIdentifier = 0 then
  begin


    Exit;
  end;


  // ServerInfo
  if rconMessage.aIdentifier = RCON_ID_SERVERINFO then
  begin
    var serverInfo := TRCONParser.ParseServerInfo(rconMessage.aMessage);
    OnServerInfo(serverInfo);

    // Player Count Change
    if serverInfoCurrent.Players <> serverInfo.Players then
      OnPlayerCountChanged(serverInfoCurrent.Players, serverInfo.Players);

    // Assign Global Server info variable
    serverInfoCurrent := serverInfo;

    Exit;
  end;

  // PlayerList
  if rconMessage.aIdentifier = RCON_ID_PLAYERLIST then
  begin
    OnPlayerList(TRCONParser.ParsePlayerList(rconMessage.aMessage));

    Exit;
  end;

  // Server Manifest
  if rconMessage.aIdentifier = RCON_ID_MANIFEST then
  begin
    OnServerManifest(rconMessage.aMessage);

    Exit;
  end;
end;

procedure TRCONEvents.OnServerInfo(const serverInfo: TRCONServerInfo);
begin
  try
    // Players
    frmMain.lblPlayerCountValue.Text := Format('%d / %d', [serverInfo.Players, serverInfo.MaxPlayers]);
    frmMain.lblStatPlayerCountValue.Text := frmMain.lblPlayerCountValue.Text;

    // Queued
    frmMain.lblQueuedValue.Text := serverInfo.Queued.ToString;

    // Joining
    frmMain.lblJoiningValue.Text := serverInfo.Joining.ToString;

    // Network Out
    frmMain.lblNetworkOutValue.Text := Format('%s/s ↑', [ConvertBytes(serverInfo.NetworkOut)]);

    // Network In
    frmMain.lblNetworkInValue.Text := Format('%s/s ↓', [ConvertBytes(serverInfo.NetworkIn)]);

    // FPS
    frmMain.lblServerFPSValue.Text := serverInfo.FPS.ToString;
    frmMain.lblStatServerFPSValue.Text := serverInfo.FPS.ToString;

    // Entity Count
    frmMain.lblServerEntityCountValue.Text := serverInfo.EntityCount.ToString;

    // Protocol
    frmMain.lblServerProtocolValue.Text := serverInfo.Protocol;

    // Ram Usage
    frmMain.lblServerMemoryUsageValue.Text := ConvertBytes(serverInfo.MemoryUsageSystem * 1000000); //serverInfo.MemoryUsageSystem.ToString + ' MB';

    // Last Wipe
    frmMain.lblLastWipeValue.Text := FormatDateTime('yyyy/mm/dd hh:nn:ss', serverInfo.SaveCreatedTime);
  except
    on E: Exception do
    begin
      frmMain.tmrServerInfo.Enabled := False;
      ShowMessageBox('Error parsing server info. Disabling server info. Please report this on the discord server.' + sLineBreak + E.Message, 'Server Info Error', frmMain);
    end;
  end;
end;

procedure TRCONEvents.OnServerManifest(const Data: string);
begin
  rustManifest.ParseManifest(Data);
end;

initialization
begin
  rconEvents := TRCONEvents.Create;
end;


finalization
begin
  rconEvents.Free;
end;

end.

