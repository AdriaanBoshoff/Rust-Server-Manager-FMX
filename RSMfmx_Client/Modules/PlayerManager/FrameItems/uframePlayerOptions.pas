unit uframePlayerOptions;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, RCON.Types, FMX.Controls.Presentation, FMX.Layouts;

type
  TframePlayerOptions = class(TFrame)
    rctnglBG: TRectangle;
    lytHeader: TLayout;
    rctnglHeader: TRectangle;
    lytHeaderLine1: TLayout;
    lytHeaderLine2: TLayout;
    lblDisplayName: TLabel;
    lblSteamID: TLabel;
    lytHeaderControls: TLayout;
    btnClose: TSpeedButton;
    crclAvatar: TCircle;
    lytMain: TLayout;
    rctnglMain: TRectangle;
    btnKickPlayer: TButton;
    btnBanPlayer: TButton;
    procedure btnBanPlayerClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnKickPlayerClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetupColors;
  public
    { Public declarations }
    playerData: TRCONPlayerListPlayer;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  ufrmPlayerManager, ufrmMain;

{$R *.fmx}

{ TframePlayerOptions }

procedure TframePlayerOptions.btnCloseClick(Sender: TObject);
begin
  Self.Release;
end;

constructor TframePlayerOptions.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // Setup Option Colors
  Self.SetupColors;
end;

procedure TframePlayerOptions.btnBanPlayerClick(Sender: TObject);
begin
  TRCON.BanPlayerID(playerData.SteamID, playerData.DisplayName, 'Banned by admin', 0, frmMain.wsClientRcon);

  Self.Release;
end;

procedure TframePlayerOptions.btnKickPlayerClick(Sender: TObject);
begin
  TRCON.KickPlayer(Self.playerData.SteamID, 'Kicked by admin', 0, frmMain.wsClientRcon);

  Self.Release;
end;

procedure TframePlayerOptions.SetupColors;
begin
  // Kick Button
  Self.btnKickPlayer.StyleLookup := 'tintedbutton';
  Self.btnKickPlayer.TintColor := $FFC44B00;

  // Ban Button
  Self.btnBanPlayer.StyleLookup := 'tintedbutton';
  Self.btnBanPlayer.TintColor := TAlphaColorRec.Darkred;
end;

end.

