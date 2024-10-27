unit ufrmPlayerManager;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  ufrmMain, FMX.Controls.Presentation, FMX.StdCtrls, FMX.TabControl, System.Rtti,
  FMX.Grid.Style, FMX.ScrollBox, FMX.Grid, FMX.Edit, FMX.Menus;

type
  TfrmPlayerManager = class(TForm)
    tbcMain: TTabControl;
    tbtmOnlinePlayers: TTabItem;
    strngrdOnlinePlayers: TStringGrid;
    strngclmnSteamID: TStringColumn;
    strngclmnUsername: TStringColumn;
    strngclmnHealth: TStringColumn;
    strngclmnAddress: TStringColumn;
    strngclmnConnectedSeconds: TStringColumn;
    pnlOnlineHeader: TPanel;
    edtSearch: TEdit;
    btnRefresh: TSpeedButton;
    pmOnlinePlayers: TPopupMenu;
    mniKick: TMenuItem;
    mniBan: TMenuItem;
    procedure btnRefreshClick(Sender: TObject);
    procedure edtSearchTyping(Sender: TObject);
    procedure mniBanClick(Sender: TObject);
    procedure mniKickClick(Sender: TObject);
    procedure pmOnlinePlayersPopup(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadPlayerList(const SearchText: string = '');
  end;

var
  frmPlayerManager: TfrmPlayerManager;

implementation

uses
  RCON.Types, RCON.Commands, RSM.PlayerManager, uHelpers;

{$R *.fmx}

procedure TfrmPlayerManager.btnRefreshClick(Sender: TObject);
begin
  if frmMain.wsClientRcon.Connected then
    TRCON.SendRconCommand(RCON_CMD_PLAYERLIST, RCON_ID_PLAYERLIST, frmMain.wsClientRcon);
end;

procedure TfrmPlayerManager.edtSearchTyping(Sender: TObject);
begin
  LoadPlayerList(edtSearch.Text);
end;

procedure TfrmPlayerManager.LoadPlayerList(const SearchText: string);
begin
  strngrdOnlinePlayers.BeginUpdate;
  try
    strngrdOnlinePlayers.RowCount := 0;

    for var player in playerManager.onlinePlayers.Values do
    begin
      if SearchText.Trim.IsEmpty or player.SteamID.ToLower.Contains(SearchText.ToLower) or player.DisplayName.ToLower.Contains(SearchText.ToLower) or player.Address.Contains(SearchText) then
      begin
        strngrdOnlinePlayers.RowCount := strngrdOnlinePlayers.RowCount + 1;
        var I := strngrdOnlinePlayers.RowCount - 1;

        strngrdOnlinePlayers.Cells[strngclmnSteamID.Index, I] := player.SteamID;
        strngrdOnlinePlayers.Cells[strngclmnUsername.Index, I] := player.DisplayName;
        strngrdOnlinePlayers.Cells[strngclmnHealth.Index, I] := Round(player.Health).ToString + 'hp';
        strngrdOnlinePlayers.Cells[strngclmnAddress.Index, I] := player.Address;
        strngrdOnlinePlayers.Cells[strngclmnConnectedSeconds.Index, I] := player.ConnectedSeconds.ToString + 's';
      end;
    end;
  finally
    strngrdOnlinePlayers.EndUpdate;
  end;
end;

procedure TfrmPlayerManager.mniBanClick(Sender: TObject);
begin
  // Get selected row
  var I := strngrdOnlinePlayers.Row;

  // Check if a row is selected
  if I = -1 then
    Abort;

  // Get steamID and username
  var SteamID := strngrdOnlinePlayers.Cells[strngclmnSteamID.Index, I];
  var Username := strngrdOnlinePlayers.Cells[strngclmnUsername.Index, I];

  // Ban
  TRCON.BanPlayerID(SteamID, Username, 'Banned by admin', 0, frmMain.wsClientRcon);

  // Refresh playerlist
  btnRefreshClick(mniBan);
end;

procedure TfrmPlayerManager.mniKickClick(Sender: TObject);
begin
  // Get selected row
  var I := strngrdOnlinePlayers.Row;

  // Check if a row is selected
  if I = -1 then
    Abort;

  // Get steamID and username
  var SteamID := strngrdOnlinePlayers.Cells[strngclmnSteamID.Index, I];
  var Username := strngrdOnlinePlayers.Cells[strngclmnUsername.Index, I];

  // Kick
  TRCON.KickPlayer(SteamID, 'Kicked by admin', 0, frmMain.wsClientRcon);

  // Refresh playerlist
  btnRefreshClick(mniKick);
end;

procedure TfrmPlayerManager.pmOnlinePlayersPopup(Sender: TObject);
begin
  // Get selected row
  var I := strngrdOnlinePlayers.Row;

  // Check if a row is selected
  if I = -1 then
    Abort;

  // Get Username
  var Username := strngrdOnlinePlayers.Cells[strngclmnUsername.Index, I];

  // Modify Popup with username
  mniKick.Text := 'Kick ' + Username;
  mniBan.Text := 'Ban ' + Username;
end;

end.

