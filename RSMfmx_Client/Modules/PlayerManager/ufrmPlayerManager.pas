unit ufrmPlayerManager;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.TabControl, FMX.Layouts, FMX.ListBox, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, System.UIConsts;

type
  TfrmPlayerManager = class(TForm)
    tbcMain: TTabControl;
    tbtmOnlinePlayers: TTabItem;
    vrtscrlbxOnlinePlayers: TVertScrollBox;
    flwlytOnlinePlayers: TFlowLayout;
    rctnglOnlinePlayerControls: TRectangle;
    btnRefreshOnlinePlayers: TSpeedButton;
    lblSearchOnlinePlayersHeader: TLabel;
    edtSearchOnlinePlayers: TEdit;
    procedure btnRefreshOnlinePlayersClick(Sender: TObject);
    procedure edtSearchOnlinePlayersTyping(Sender: TObject);
    procedure flwlytOnlinePlayersResized(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ReCalcOnlinePlayersItemSizes;
    procedure ClearOnlinePlayersUI;
    procedure SearchOnlinePlayersUI(const Text: string = '');
  end;

var
  frmPlayerManager: TfrmPlayerManager;

implementation

uses
  uframePlayerItem, RCON.Types, RCON.Commands, ufrmMain, RSM.PlayerManager;

{$R *.fmx}

procedure TfrmPlayerManager.btnRefreshOnlinePlayersClick(Sender: TObject);
begin
  TRCON.SendRconCommand(RCON_CMD_PLAYERLIST, RCON_ID_PLAYERLIST, frmMain.wsClientRcon);
end;

procedure TfrmPlayerManager.ClearOnlinePlayersUI;
begin
  for var I := flwlytOnlinePlayers.ChildrenCount - 1 downto 0 do
  begin
    if flwlytOnlinePlayers.Children[I] is TframePlayerItem then
      (flwlytOnlinePlayers.Children[I] as TframePlayerItem).Free;
  end;

  ReCalcOnlinePlayersItemSizes;
end;

procedure TfrmPlayerManager.edtSearchOnlinePlayersTyping(Sender: TObject);
begin
  SearchOnlinePlayersUI(edtSearchOnlinePlayers.Text);
end;

procedure TfrmPlayerManager.flwlytOnlinePlayersResized(Sender: TObject);
begin
  ReCalcOnlinePlayersItemSizes;
end;

procedure TfrmPlayerManager.ReCalcOnlinePlayersItemSizes;
begin
  var newSize: single := 0;

  for var aControl in flwlytOnlinePlayers.Controls do
  begin
    aControl.Width := flwlytOnlinePlayers.Width;

    if aControl is TframePlayerItem then
    begin
      newSize := newSize + aControl.Height + flwlytOnlinePlayers.VerticalGap;
    end;
  end;

  flwlytOnlinePlayers.Height := newSize;
end;

procedure TfrmPlayerManager.SearchOnlinePlayersUI(const Text: string);
begin
  // Clear Online Players UI
  ClearOnlinePlayersUI;

  // Loop Through Playerlist
  for var aPlayer in PlayerManager.onlinePlayers do
  begin
    // Check Search
    if Text.Trim.IsEmpty or aPlayer.Value.SteamID.Contains(Text) or aPlayer.Value.DisplayName.ToLower.Contains(Text.ToLower) or aPlayer.Value.Address.ToLower.Contains(Text.ToLower) then
    begin
      // Build UI Item
      var playerItem := TframePlayerItem.Create(flwlytOnlinePlayers);
      playerItem.Name := 'onlinePlayerItem_' + aPlayer.Value.SteamID;
      playerItem.Parent := flwlytOnlinePlayers;
      playerItem.playerData := aPlayer.Value;

      // Assign UI Values
      playerItem.lblDisplayName.Text := aPlayer.Value.DisplayName;
      playerItem.lblSteamID.Text := aPlayer.Value.SteamID;

      // Health
      playerItem.lblHealth.Text := Format('%f HP', [aPlayer.Value.Health]);
      // Health Color
      // Calculate the colors based on health value
      var redColor := Round(255 * (1 - aPlayer.Value.Health / 100));
      var greenColor := Round(200 + 55 * (aPlayer.Value.Health / 100));
      playerItem.lblHealth.FontColor := MakeColor(redColor, greenColor, 0);

      // Latency (Ping)
      playerItem.lblPing.Text := Format('%d ms', [aPlayer.Value.Ping]);
      // Latency Color
      // Calculate the colors based on latency value
      redColor := Round(255 * (aPlayer.Value.Ping / 120));
      greenColor := Round(200 - 150 * (aPlayer.Value.Ping / 120));
      // Prevents range check error
      if redColor > 255 then
        redColor := 255;
      if greenColor > 255 then
        greenColor := 255;
      playerItem.lblPing.FontColor := MakeColor(redColor, greenColor, 0);

      playerItem.lblIPValue.Text := aPlayer.Value.IP;

      playerItem.LoadSteamAvatar(aPlayer.Value.SteamID);
    end;
  end;

  // Recalc Player List UI Items
  ReCalcOnlinePlayersItemSizes;
end;

end.

