unit ufrmInstalledPlugins;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Objects, FMX.Layouts,
  System.Generics.Collections, System.IOUtils, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo, FMX.ListBox;

type
  TPluginFramework = (pfUnkown, pfuMod, pfCarbonMod);

type
  TInstalledPlugin = record
    Name: string;
    Path: string;
    ConfigPath: string;
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
    vrtscrlbxInstalledPlugins: TVertScrollBox;
    flwlytInstalledPlugins: TFlowLayout;
    cbbFilterMode: TComboBox;
    lstFilterAll: TListBoxItem;
    lstFilteruMod: TListBoxItem;
    lstFilterCarbonMod: TListBoxItem;
    procedure btnRefreshClick(Sender: TObject);
    procedure cbbFilterModeChange(Sender: TObject);
    procedure edtPluginSearchTyping(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lblTotalPluginsValueResized(Sender: TObject);
    procedure vrtscrlbxInstalledPluginsResized(Sender: TObject);
  private
    { Private declarations }
    FInstalledPlugins: TList<TInstalledPlugin>;
    procedure GetInstalledPlugins;
    procedure RecalcInstalledPluginsSize;
    procedure PopulateInstalledPlugins(searchText: string = '');
    procedure ClearPluginsUI;
  public
    { Public declarations }
    procedure OnTabActivated(const Sender: TObject); // Executes on tab for parent form
  end;

var
  frmInstalledPlugins: TfrmInstalledPlugins;

implementation

uses
  RSM.Core, uframeInstalledPlugin;

{$R *.fmx}

procedure TfrmInstalledPlugins.btnRefreshClick(Sender: TObject);
begin
  GetInstalledPlugins;
  PopulateInstalledPlugins;
end;

procedure TfrmInstalledPlugins.cbbFilterModeChange(Sender: TObject);
begin
  PopulateInstalledPlugins(edtPluginSearch.Text);
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
      plugin.ConfigPath := TPath.Combine([rsmCore.Paths.GetOxidePluginsConfigDir, plugin.Name + '.json']);
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

  lblTotalPluginsValue.Text := FInstalledPlugins.Count.ToString;
end;

procedure TfrmInstalledPlugins.ClearPluginsUI;
begin
  flwlytInstalledPlugins.BeginUpdate;
  try
    for var I := flwlytInstalledPlugins.ChildrenCount - 1 downto 0 do
    begin
      if flwlytInstalledPlugins.Children[I] is TframeInstalledPlugin then
        (flwlytInstalledPlugins.Children[I] as TframeInstalledPlugin).Free;
    end;
  finally
    flwlytInstalledPlugins.EndUpdate;
  end;
end;

procedure TfrmInstalledPlugins.edtPluginSearchTyping(Sender: TObject);
begin
  PopulateInstalledPlugins(edtPluginSearch.Text);
end;

procedure TfrmInstalledPlugins.FormCreate(Sender: TObject);
begin
  FInstalledPlugins := TList<TInstalledPlugin>.Create;
end;

procedure TfrmInstalledPlugins.lblTotalPluginsValueResized(Sender: TObject);
begin
  lytTotalPlugins.Width := lblTotalPluginsHeader.Width + lblTotalPluginsValue.Margins.Left + lblTotalPluginsValue.Width;
end;

procedure TfrmInstalledPlugins.OnTabActivated(const Sender: TObject);
begin
  // Refresh Plugins by pressing the refresh button
  btnRefreshClick(btnRefresh);
end;

procedure TfrmInstalledPlugins.PopulateInstalledPlugins(searchText: string);
begin
  searchText := searchText.ToLower.Trim;

  ClearPluginsUI;

  flwlytInstalledPlugins.BeginUpdate;
  try
    for var aPlugin in FInstalledPlugins do
    begin
      if searchText.IsEmpty or aPlugin.Name.ToLower.Contains(searchText) then
      begin
        if (cbbFilterMode.ItemIndex = lstFilteruMod.Index) and not (aPlugin.Framework = TPluginFramework.pfuMod) then
        begin
          Continue;
        end;

        if (cbbFilterMode.ItemIndex = lstFilterCarbonMod.Index) and not (aPlugin.Framework = TPluginFramework.pfCarbonMod) then
        begin
          Continue;
        end;

        var pluginItem := TframeInstalledPlugin.Create(flwlytInstalledPlugins);
        pluginItem.Name := 'installedPlugin_' + aPlugin.Name + Ord(aPlugin.Framework).ToString;
        pluginItem.Parent := flwlytInstalledPlugins;
        pluginItem.Width := flwlytInstalledPlugins.Width;
        pluginItem.PluginInfo := aPlugin;
      end;
    end;
  finally
    flwlytInstalledPlugins.EndUpdate;
    RecalcInstalledPluginsSize;
  end;
end;

procedure TfrmInstalledPlugins.RecalcInstalledPluginsSize;
begin
  var newSize: single := 0;
  var prevYPos: single := 0;
  for var aControl in flwlytInstalledPlugins.Controls do
  begin
    if aControl is TframeInstalledPlugin then
    begin
      if aControl.Position.Y > prevYPos then
      begin
        prevYPos := aControl.Position.Y;

        newSize := newSize + aControl.Height + flwlytInstalledPlugins.VerticalGap;
      end;

      aControl.Width := flwlytInstalledPlugins.Width;
      // Disable Help button if no url availible
    //  var pluginItem := TframeInstalledPlugin(aControl);
     // pluginItem.btnHelp.Visible := (not pluginItem.PluginInfo.url.Trim.IsEmpty);
    end;
  end;

  flwlytInstalledPlugins.Height := newSize + 10;
end;

procedure TfrmInstalledPlugins.vrtscrlbxInstalledPluginsResized(Sender: TObject);
begin
  RecalcInstalledPluginsSize;
end;

end.

