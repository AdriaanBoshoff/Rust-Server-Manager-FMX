unit uframeuModPluginItem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Objects, uModAPI.Types,
  System.Threading, Rest.Client, System.IOUtils, System.Hash;

type
  TframeuModPluginItem = class(TFrame)
    rctnglHeader: TRectangle;
    rctnglOxideModNavImage: TRectangle;
    lytHeaderInfo: TLayout;
    lytTitle: TLayout;
    lytDescription: TLayout;
    lblDescription: TLabel;
    lblPluginTitle: TLabel;
    lblAuthor: TLabel;
    lytDownloads: TLayout;
    imgDownloadsIcon: TImage;
    lblDownloadsCount: TLabel;
    lytVersion: TLayout;
    imgVersionIcon: TImage;
    lblVersion: TLabel;
    lytInfo: TLayout;
    lytControls: TLayout;
    btnInstall: TButton;
    btnHelp: TButton;
    lnHeader: TLine;
    imgDonate: TImage;
    imgWarning: TImage;
    imgError: TImage;
    procedure btnHelpClick(Sender: TObject);
    procedure btnInstallClick(Sender: TObject);
    procedure imgDonateClick(Sender: TObject);
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
    FPluginInfo: TuModSearchPlugin;
    procedure SetPluginInfo(const Value: TuModSearchPlugin);
    function GetPluginSHA1: string;
  public
    { Public declarations }
    procedure LoadAvatar;
  published
    property PluginInfo: TuModSearchPlugin read FPluginInfo write SetPluginInfo;
  end;

implementation

uses
  uWinUtils;

{$R *.fmx}

{ TframeuModPluginItem }

procedure TframeuModPluginItem.btnHelpClick(Sender: TObject);
begin
  // Open plugin page
  OpenURL(FPluginInfo.url);
end;

procedure TframeuModPluginItem.btnInstallClick(Sender: TObject);
begin
  var pluginFolder := ExtractfilePath(ParamStr(0)) + 'oxide\plugins\';
  var memStream := TMemoryStream.Create;
  try
    TDownloadURL.DownloadRawBytes(FPluginInfo.downloadURL, memStream);

    if not TDirectory.Exists(pluginFolder) then
      ForceDirectories(pluginFolder);

    memStream.SaveToFile(TPath.Combine(pluginFolder, FPluginInfo.name + '.cs'));

    btnInstall.Text := 'Installed';
    btnInstall.StyleLookup := 'tintedbutton';
    btnInstall.TintColor := TAlphaColorRec.Green;
  finally
    memStream.Free;
  end;
end;

function TframeuModPluginItem.GetPluginSHA1: string;
begin
  Result := '';

  var pluginFolder := ExtractfilePath(ParamStr(0)) + 'oxide\plugins\';
  var pluginPath := TPath.Combine(pluginFolder, FPluginInfo.name + '.cs');

  if not TFile.Exists(pluginPath) then
    Exit;

  var aFile := TFileStream.Create(pluginPath, fmOpenRead, fmShareDenyNone);
  try
    Result := THashSHA1.GetHashString(aFile);
  finally
    aFile.Free;
  end;
end;

procedure TframeuModPluginItem.imgDonateClick(Sender: TObject);
begin
  // Open donate page for plugin author
  OpenURL(FPluginInfo.donateURL);
end;

procedure TframeuModPluginItem.LoadAvatar;
begin
  TTask.Run(
    procedure
    begin
      var memStream := TMemoryStream.Create;
      try
        try
          TDownloadURL.DownloadRawBytes(FPluginInfo.iconURL, memStream);

          TThread.Synchronize(TThread.Current,
            procedure
            begin
              rctnglOxideModNavImage.Fill.Bitmap.Bitmap.LoadFromStream(memStream);
            end);
        except
          // Dont show any errors when trying to load avatar
        end;
      finally
        memStream.Free;
      end;
    end);
end;

procedure TframeuModPluginItem.rctnglHeaderMouseEnter(Sender: TObject);
begin
  rctnglHeader.Fill.Color := UI_COLOR_HOVER;
end;

procedure TframeuModPluginItem.rctnglHeaderMouseLeave(Sender: TObject);
begin
  rctnglHeader.Fill.Color := UI_COLOR_DEFAULT;
end;

procedure TframeuModPluginItem.SetPluginInfo(const Value: TuModSearchPlugin);
begin
  FPluginInfo := Value;

  var pluginFolder := ExtractfilePath(ParamStr(0)) + 'oxide\plugins\';
  var pluginPath := TPath.Combine(pluginFolder, FPluginInfo.name + '.cs');

  // Info
  Self.lblPluginTitle.Text := FPluginInfo.title;
  Self.lblDescription.Text := FPluginInfo.description;
  Self.lblVersion.Text := 'v' + FPluginInfo.version;
  Self.lblDownloadsCount.Text := FPluginInfo.downloadsShortened;

  // Plugin is unmaintained
  if FPluginInfo.authorName.Trim.IsEmpty then
  begin
    Self.lblAuthor.Text := '---';
    imgWarning.Visible := True;
    imgWarning.Hint := 'This plugin is unmaintained!';
  end
  else
  begin
    Self.lblAuthor.Text := 'by ' + FPluginInfo.authorName;
    imgWarning.Visible := False;
  end;

  // Marked as broken
  if FPluginInfo.tags.ToLower.Contains('broken') then
  begin
    imgError.Visible := True;
    imgError.Hint := 'This plugin is broken!';
  end
  else
  begin
    imgError.Visible := False;
  end;

  // Install Button
  if TFile.Exists(pluginPath) then
  begin
    // Check if plugin is up to date
    if FPluginInfo.latestChecksum <> GetPluginSHA1 then
    begin
      btnInstall.Text := 'Update';
      btnInstall.StyleLookup := 'tintedbutton';
      btnInstall.TintColor := TAlphaColorRec.Orangered;
    end
    else
    begin
      btnInstall.Text := 'Reinstall';
      btnInstall.StyleLookup := 'tintedbutton';
      btnInstall.TintColor := TAlphaColorRec.Green;
    end;
  end;

  // Donate Button
  imgDonate.Visible := (not FPluginInfo.donateURL.Trim.IsEmpty);
end;

end.

