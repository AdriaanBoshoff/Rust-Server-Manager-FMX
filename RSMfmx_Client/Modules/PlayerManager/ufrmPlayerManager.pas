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
    btn1: TButton;
    btn2: TButton;
    btnRefreshOnlinePlayers: TSpeedButton;
    lblSearchOnlinePlayersHeader: TLabel;
    edtSearchOnlinePlayers: TEdit;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure flwlytOnlinePlayersResized(Sender: TObject);
  private
    { Private declarations }
    procedure ReCalcOnlinePlayersItemSizes;
  public
    { Public declarations }
  end;

var
  frmPlayerManager: TfrmPlayerManager;

implementation

uses
  uframePlayerItem;

{$R *.fmx}

procedure TfrmPlayerManager.btn1Click(Sender: TObject);
begin
  for var I := flwlytOnlinePlayers.ChildrenCount - 1 downto 0 do
  begin
    if flwlytOnlinePlayers.Children[I] is TframePlayerItem then
      flwlytOnlinePlayers.Children[I].Free;
  end;

  ReCalcOnlinePlayersItemSizes;
end;

procedure TfrmPlayerManager.btn2Click(Sender: TObject);
begin
  for var I := 1 to 10 do
  begin
    var playerItem := TframePlayerItem.Create(flwlytOnlinePlayers);
    playerItem.Name := playerItem.Name + '_' + flwlytOnlinePlayers.ChildrenCount.ToString;
    playerItem.Parent := flwlytOnlinePlayers;
    playerItem.lblDisplayName.Text := playerItem.lblDisplayName.Text + ' #' + flwlytOnlinePlayers.ChildrenCount.ToString;
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

