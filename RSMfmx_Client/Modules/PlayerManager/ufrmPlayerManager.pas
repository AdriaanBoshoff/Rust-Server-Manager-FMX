unit ufrmPlayerManager;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  ufrmMain, FMX.Controls.Presentation, FMX.StdCtrls, FMX.TabControl, System.Rtti,
  FMX.Grid.Style, FMX.ScrollBox, FMX.Grid, FMX.Edit;

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
    procedure btnRefreshClick(Sender: TObject);
    procedure edtSearchTyping(Sender: TObject);
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
      if SearchText.Trim.IsEmpty
        or player.SteamID.ToLower.Contains(SearchText.ToLower)
        or player.DisplayName.ToLower.Contains(SearchText.ToLower)
        or player.Address.Contains(SearchText) then
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

end.

