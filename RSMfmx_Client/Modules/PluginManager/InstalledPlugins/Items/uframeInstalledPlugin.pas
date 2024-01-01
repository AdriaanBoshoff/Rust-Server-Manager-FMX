unit uframeInstalledPlugin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, udmStyles, FMX.Layouts,
  ufrmInstalledPlugins;

type
  TframeInstalledPlugin = class(TFrame)
    rctnglHeader: TRectangle;
    lytPluginInfo: TLayout;
    lytPluginControls: TLayout;
    lblPluginTitle: TLabel;
    lytPluginInfoBottom: TLayout;
    lblFrameworkHeader: TLabel;
    lblFrameworkValue: TLabel;
    btnUninstall: TButton;
    btnOpenConfig: TButton;
    procedure btnOpenConfigClick(Sender: TObject);
    procedure btnUninstallClick(Sender: TObject);
    procedure rctnglHeaderMouseEnter(Sender: TObject);
    procedure rctnglHeaderMouseLeave(Sender: TObject);
  private
    { Private Const }
    const
      UI_COLOR_DEFAULT = $FF1F222A;
      UI_COLOR_HOVER = $FF6F0000;
      UI_COLOR_SELECTED = $FF900000;
  private
    { Private declarations }
    FPluginInfo: TInstalledPlugin;
    procedure SetPluginInfo(const Value: TInstalledPlugin);
  public
    { Public declarations }
  published
    { Published Properties }
    property PluginInfo: TInstalledPlugin read FPluginInfo write SetPluginInfo;
  end;

implementation

uses
  System.IOUtils, uWinUtils;

{$R *.fmx}

procedure TframeInstalledPlugin.btnOpenConfigClick(Sender: TObject);
begin
  if TFile.Exists(FPluginInfo.Path) then
    OpenURL(FPluginInfo.Path);
end;

procedure TframeInstalledPlugin.btnUninstallClick(Sender: TObject);
begin
  TFile.Delete(FPluginInfo.Path);
  frmInstalledPlugins.lblTotalPluginsValue.Text := (frmInstalledPlugins.flwlytInstalledPlugins.ChildrenCount - 1).ToString;
  Self.Release;
end;

procedure TframeInstalledPlugin.rctnglHeaderMouseEnter(Sender: TObject);
begin
  rctnglHeader.Fill.Color := UI_COLOR_HOVER;
end;

procedure TframeInstalledPlugin.rctnglHeaderMouseLeave(Sender: TObject);
begin
  rctnglHeader.Fill.Color := UI_COLOR_DEFAULT;
end;

{ TframeInstalledPlugin }

procedure TframeInstalledPlugin.SetPluginInfo(const Value: TInstalledPlugin);
begin
  FPluginInfo := Value;

  lblPluginTitle.Text := Value.Name;

  case Value.Framework of
    pfUnkown:
      lblFrameworkValue.Text := 'UNKNOWN';
    pfuMod:
      lblFrameworkValue.Text := 'Oxide / uMod';
    pfCarbonMod:
      lblFrameworkValue.Text := 'CarbonMod';
  end;
end;

end.

