unit uframePlayerItem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.Controls.Presentation;

type
  TframePlayerItem = class(TFrame)
    lytAvatar: TLayout;
    crclAvatar: TCircle;
    lytLine1: TLayout;
    lytLine2: TLayout;
    lblDisplayName: TLabel;
    lblSteamID: TLabel;
    rctnglBG: TRectangle;
    btnManage: TSpeedButton;
    lblHealth: TLabel;
    lblPing: TLabel;
    lytHealth: TLayout;
    lytPing: TLayout;
    lytIPAddress: TLayout;
    lblIPHeader: TLabel;
    lblIPValue: TLabel;
    lytVacBans: TLayout;
    lblVacBansHeader: TLabel;
    lblVacBansValue: TLabel;
    lytGameBans: TLayout;
    lblGameBansHeader: TLabel;
    lblGameBansValue: TLabel;
    procedure lblHealthResized(Sender: TObject);
    procedure lblIPValueResized(Sender: TObject);
    procedure lblPingResized(Sender: TObject);
    procedure rctnglBGMouseEnter(Sender: TObject);
    procedure rctnglBGMouseLeave(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TframePlayerItem.lblHealthResized(Sender: TObject);
begin
  lytHealth.Width := lblHealth.Width;
end;

procedure TframePlayerItem.lblIPValueResized(Sender: TObject);
begin
  lytIPAddress.Width := lblIPHeader.Width + lblIPValue.Margins.Left + lblIPValue.Width;
end;

procedure TframePlayerItem.lblPingResized(Sender: TObject);
begin
  lytPing.Width := lblPing.Width;
end;

procedure TframePlayerItem.rctnglBGMouseEnter(Sender: TObject);
begin
  rctnglBG.Fill.Color := $FF79303C;
end;

procedure TframePlayerItem.rctnglBGMouseLeave(Sender: TObject);
begin
  rctnglBG.Fill.Color := $FF1F222A;
end;

end.

