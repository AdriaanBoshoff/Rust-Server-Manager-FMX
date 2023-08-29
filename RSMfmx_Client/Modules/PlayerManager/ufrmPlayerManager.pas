unit ufrmPlayerManager;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.TabControl, FMX.Layouts, FMX.ListBox, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit;

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
    procedure flwlytOnlinePlayersResized(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ReCalcOnlinePlayersItemSizes;
    procedure ClearOnlinePlayersUI;
  end;

var
  frmPlayerManager: TfrmPlayerManager;

implementation

uses
  uframePlayerItem, RCON.Types, RCON.Commands, ufrmMain;

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
      flwlytOnlinePlayers.Children[I].Free;
  end;

  ReCalcOnlinePlayersItemSizes;
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

end.

