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
    lytLeft: TLayout;
    lytRight: TLayout;
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    playerData: TRCONPlayerListPlayer;
    procedure Close;
  end;

implementation

uses
  ufrmPlayerManager;

{$R *.fmx}

procedure TframePlayerOptions.btnCloseClick(Sender: TObject);
begin
  Self.Release;
end;

{ TframePlayerOptions }

procedure TframePlayerOptions.Close;
begin
  Self.Release;
end;

end.

