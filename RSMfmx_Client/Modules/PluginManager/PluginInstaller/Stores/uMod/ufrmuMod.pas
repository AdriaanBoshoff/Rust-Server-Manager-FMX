unit ufrmuMod;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Edit, FMX.Layouts,
  FMX.EditBox, FMX.NumberBox, uModAPI, uModAPI.Types;

type
  TfrmuMod = class(TForm)
    rctnglHeader: TRectangle;
    edtPluginSearch: TEdit;
    lytPage: TLayout;
    btnSearchPlugin: TEditButton;
    btnNextPage: TButton;
    nmbrbxCurrentPage: TNumberBox;
    btnPreviousPage: TButton;
    lblPageOf: TLabel;
    vrtscrlbxPlugins: TVertScrollBox;
    flwlytPlugins: TFlowLayout;
    procedure btnNextPageClick(Sender: TObject);
    procedure btnPreviousPageClick(Sender: TObject);
    procedure btnSearchPluginClick(Sender: TObject);
    procedure edtPluginSearchKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure flwlytPluginsResized(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FuModResponse: TuModSearchPluginResponse;
    uModAPI: TuModAPI;
    procedure ReCalcPluginSize;
    procedure ClearPlugins;
  public
    { Public declarations }
  end;

var
  frmuMod: TfrmuMod;

implementation

uses
  uframeuModPluginItem;

{$R *.fmx}

procedure TfrmuMod.btnNextPageClick(Sender: TObject);
begin
  if (FuModResponse.currentPage + 1) > FuModResponse.lastPage then
    Exit;

  FuModResponse := uModAPI.SearchPlugins(edtPluginSearch.Text, FuModResponse.currentPage + 1);

  if FuModResponse.ResponseCode = 429 then
  begin
    ShowMessage('uMod Rate Limit Reached. Please try again in 1 minute.');
    Exit;
  end;

  lblPageOf.Text := '/ ' + FuModResponse.lastPage.ToString;
  nmbrbxCurrentPage.Max := FuModResponse.lastPage;
  nmbrbxCurrentPage.Value := FuModResponse.currentPage;

  ClearPlugins;

  for var aPlugin in FuModResponse.plugins do
  begin
    var pluginItem := TframeuModPluginItem.Create(flwlytPlugins);
   // pluginItem.Align := TAlignLayout.Top;
    pluginItem.Name := aPlugin.name;
    pluginItem.lblPluginTitle.Text := aPlugin.title;
    pluginItem.lblDescription.Text := aPlugin.description;
    pluginItem.lblAuthor.Text := 'by ' + aPlugin.authorName;
    pluginItem.lblVersion.Text := 'v' + aPlugin.version;
    pluginItem.lblDownloadsCount.Text := aPlugin.downloadsShortened;
    pluginItem.Parent := flwlytPlugins;
    pluginItem.FPluginInfo := aPlugin;
    pluginItem.LoadAvatar;
  end;

  ReCalcPluginSize;
end;

procedure TfrmuMod.btnPreviousPageClick(Sender: TObject);
begin
  if (FuModResponse.currentPage - 1) < 0 then
    Exit;

  FuModResponse := uModAPI.SearchPlugins(edtPluginSearch.Text, FuModResponse.currentPage - 1);

  if FuModResponse.ResponseCode = 429 then
  begin
    ShowMessage('uMod Rate Limit Reached. Please try again in 1 minute.');
    Exit;
  end;

  lblPageOf.Text := '/ ' + FuModResponse.lastPage.ToString;
  nmbrbxCurrentPage.Max := FuModResponse.lastPage;
  nmbrbxCurrentPage.Value := FuModResponse.currentPage;

  ClearPlugins;

  for var aPlugin in FuModResponse.plugins do
  begin
    var pluginItem := TframeuModPluginItem.Create(flwlytPlugins);
   // pluginItem.Align := TAlignLayout.Top;
    pluginItem.Name := aPlugin.name;
    pluginItem.lblPluginTitle.Text := aPlugin.title;
    pluginItem.lblDescription.Text := aPlugin.description;
    pluginItem.lblAuthor.Text := 'by ' + aPlugin.authorName;
    pluginItem.lblVersion.Text := 'v' + aPlugin.version;
    pluginItem.lblDownloadsCount.Text := aPlugin.downloadsShortened;
    pluginItem.Parent := flwlytPlugins;
    pluginItem.FPluginInfo := aPlugin;
    pluginItem.LoadAvatar;
  end;

  ReCalcPluginSize;
end;

procedure TfrmuMod.btnSearchPluginClick(Sender: TObject);
begin
  FuModResponse := uModAPI.SearchPlugins(edtPluginSearch.Text, 1);

  if FuModResponse.ResponseCode = 429 then
  begin
    ShowMessage('uMod Rate Limit Reached. Please try again in 1 minute.');
    Exit;
  end;

  lblPageOf.Text := '/ ' + FuModResponse.lastPage.ToString;
  nmbrbxCurrentPage.Max := FuModResponse.lastPage;
  nmbrbxCurrentPage.Value := FuModResponse.currentPage;

  ClearPlugins;

  for var aPlugin in FuModResponse.plugins do
  begin
    var pluginItem := TframeuModPluginItem.Create(flwlytPlugins);
   // pluginItem.Align := TAlignLayout.Top;
    pluginItem.Name := aPlugin.name;
    pluginItem.lblPluginTitle.Text := aPlugin.title;
    pluginItem.lblDescription.Text := aPlugin.description;
    pluginItem.lblAuthor.Text := 'by ' + aPlugin.authorName;
    pluginItem.lblVersion.Text := 'v' + aPlugin.version;
    pluginItem.lblDownloadsCount.Text := aPlugin.downloadsShortened;
    pluginItem.Parent := flwlytPlugins;
    pluginItem.FPluginInfo := aPlugin;
    pluginItem.LoadAvatar;
  end;

  ReCalcPluginSize;
end;

procedure TfrmuMod.ReCalcPluginSize;
begin
  var newSize: single := 0;
  var prevYPos: single := 0;
  for var aControl in flwlytPlugins.Controls do
  begin
   // aControl.Width := flwlytPlugins.Width;

    if aControl is TframeuModPluginItem then
    begin
      if aControl.Position.Y > prevYPos then
      begin
        prevYPos := aControl.Position.Y;

        newSize := newSize + aControl.Height + flwlytPlugins.VerticalGap;
      end;
    end;
  end;

  flwlytPlugins.Height := newSize;
end;

procedure TfrmuMod.ClearPlugins;
begin
  for var I := flwlytPlugins.ChildrenCount - 1 downto 0 do
  begin
    if flwlytPlugins.Children[I] is TframeuModPluginItem then
      (flwlytPlugins.Children[I] as TframeuModPluginItem).Free;
  end;
end;

procedure TfrmuMod.edtPluginSearchKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    btnSearchPluginClick(btnSearchPlugin);
  end;
end;

procedure TfrmuMod.flwlytPluginsResized(Sender: TObject);
begin
  ReCalcPluginSize;
end;

procedure TfrmuMod.FormDestroy(Sender: TObject);
begin
  uModAPI.Free;
end;

procedure TfrmuMod.FormCreate(Sender: TObject);
begin
  uModAPI := TuModAPI.Create;
  FuModResponse := uModAPI.SearchPlugins(edtPluginSearch.Text, 1);
  lblPageOf.Text := '/ ' + FuModResponse.lastPage.ToString;
  nmbrbxCurrentPage.Max := FuModResponse.lastPage;
  nmbrbxCurrentPage.Value := FuModResponse.currentPage;
end;

end.

