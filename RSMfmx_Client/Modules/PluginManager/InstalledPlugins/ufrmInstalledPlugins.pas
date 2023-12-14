unit ufrmInstalledPlugins;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Objects, FMX.Layouts,
  System.Generics.Collections, System.IOUtils, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo;

type
  TPluginFramework = (pfUnkown, pfuMod, pfCarbonMod);

type
  TInstalledPlugin = record
    Name: string;
    Path: string;
    Framework: TPluginFramework;
  end;

type
  TfrmInstalledPlugins = class(TForm)
    rctnglHeader: TRectangle;
    edtPluginSearch: TEdit;
    btnRefresh: TSpeedButton;
    lytTotalPlugins: TLayout;
    lblTotalPluginsHeader: TLabel;
    lblTotalPluginsValue: TLabel;
    btnClearSearch: TClearEditButton;
    mmo1: TMemo;
    procedure btnRefreshClick(Sender: TObject);
    procedure edtPluginSearchTyping(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lblTotalPluginsValueResized(Sender: TObject);
  private
    { Private declarations }
    FInstalledPlugins: TList<TInstalledPlugin>;
    procedure GetInstalledPlugins;
  public
    { Public declarations }
  end;

var
  frmInstalledPlugins: TfrmInstalledPlugins;

implementation

uses
  RSM.Core;

{$R *.fmx}

procedure TfrmInstalledPlugins.btnRefreshClick(Sender: TObject);
begin
  GetInstalledPlugins;
end;

procedure TfrmInstalledPlugins.edtPluginSearchTyping(Sender: TObject);
begin
  mmo1.Text := '';

  for var aPlugin in FInstalledPlugins do
  begin
    if aPlugin.Name.ToLower.Contains(edtPluginSearch.Text.ToLower) or edtPluginSearch.Text.Trim.IsEmpty then
    begin
      mmo1.Lines.Add('==============================');
      mmo1.Lines.Add('Name: ' + aPlugin.Name);
      mmo1.Lines.Add('Path: ' + aPlugin.Name);

      case aPlugin.Framework of
        pfUnkown:
          mmo1.Lines.Add('Framework: Unknown');
        pfuMod:
          mmo1.Lines.Add('Framework: uMod');
        pfCarbonMod:
          mmo1.Lines.Add('Framework: CarbonMod');
      end;
    end;
  end;
end;

procedure TfrmInstalledPlugins.FormDestroy(Sender: TObject);
begin
  FInstalledPlugins.Free;
end;

procedure TfrmInstalledPlugins.GetInstalledPlugins;
begin
  FInstalledPlugins.Clear;

  // Oxide / uMod
  if TDirectory.Exists(rsmCore.Paths.GetOxidePluginsDir) then
  begin
    var oxidePlugins := TDirectory.GetFiles(rsmCore.Paths.GetOxidePluginsDir, '*.cs');
    for var aPluginPath in oxidePlugins do
    begin
      var plugin: TInstalledPlugin;
      plugin.Name := TPath.GetFileNameWithoutExtension(aPluginPath);
      plugin.Path := aPluginPath;
      plugin.Framework := TPluginFramework.pfuMod;

      FInstalledPlugins.Add(plugin);
    end;
  end;

  // CarbonMod
  if TDirectory.Exists(rsmCore.Paths.GetCarbonModPluginsDir) then
  begin
    var carbonPlugins := TDirectory.GetFiles(rsmCore.Paths.GetCarbonModPluginsDir, '*.cs');
    for var aPluginPath in carbonPlugins do
    begin
      var plugin: TInstalledPlugin;
      plugin.Name := TPath.GetFileNameWithoutExtension(aPluginPath);
      plugin.Path := aPluginPath;
      plugin.Framework := TPluginFramework.pfCarbonMod;

      FInstalledPlugins.Add(plugin);
    end;
  end;
end;

procedure TfrmInstalledPlugins.FormCreate(Sender: TObject);
begin
  FInstalledPlugins := TList<TInstalledPlugin>.Create;
end;

procedure TfrmInstalledPlugins.lblTotalPluginsValueResized(Sender: TObject);
begin
  lytTotalPlugins.Width := lblTotalPluginsHeader.Width + lblTotalPluginsValue.Margins.Left + lblTotalPluginsValue.Width;
end;

end.

