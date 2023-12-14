unit ufrmuModStore;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Edit, FMX.Layouts,
  FMX.EditBox, FMX.NumberBox, uModAPI, uModAPI.Types, System.Threading;

type
  TfrmuModStore = class(TForm)
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
    procedure nmbrbxCurrentPageKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
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
  frmuModStore: TfrmuModStore;

implementation

uses
  uframeuModPluginItem;

{$R *.fmx}

procedure TfrmuModStore.btnNextPageClick(Sender: TObject);
begin
  if (FuModResponse.currentPage + 1) > FuModResponse.lastPage then
    Exit;

  TTask.Run(
    procedure
    begin
      FuModResponse := uModAPI.SearchPlugins(edtPluginSearch.Text, FuModResponse.currentPage + 1);

      TThread.Synchronize(TThread.Current,
        procedure
        begin
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
            pluginItem.Name := aPlugin.name;
            pluginItem.Parent := flwlytPlugins;
            pluginItem.PluginInfo := aPlugin;
            pluginItem.LoadAvatar;
          end;

          ReCalcPluginSize;
        end);
    end);
end;

procedure TfrmuModStore.btnPreviousPageClick(Sender: TObject);
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
    pluginItem.Parent := flwlytPlugins;
    pluginItem.PluginInfo := aPlugin;
    pluginItem.LoadAvatar;
  end;

  ReCalcPluginSize;
end;

procedure TfrmuModStore.btnSearchPluginClick(Sender: TObject);
begin
  TTask.Run(
    procedure
    begin
      FuModResponse := uModAPI.SearchPlugins(edtPluginSearch.Text, 1);

      TThread.Synchronize(TThread.Current,
        procedure
        begin
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
            pluginItem.Name := aPlugin.name;
            pluginItem.Parent := flwlytPlugins;
            pluginItem.PluginInfo := aPlugin;
            pluginItem.LoadAvatar;
          end;

          ReCalcPluginSize;
        end);
    end);
end;

procedure TfrmuModStore.ReCalcPluginSize;
begin
  var newSize: single := 0;
  var prevYPos: single := 0;
  for var aControl in flwlytPlugins.Controls do
  begin
    if aControl is TframeuModPluginItem then
    begin
      if aControl.Position.Y > prevYPos then
      begin
        prevYPos := aControl.Position.Y;

        newSize := newSize + aControl.Height + flwlytPlugins.VerticalGap;
      end;

      // Disable Help button if no url availible
      var pluginItem := TframeuModPluginItem(aControl);
      pluginItem.btnHelp.Visible := (not pluginItem.PluginInfo.url.Trim.IsEmpty);
    end;
  end;

  flwlytPlugins.Height := newSize;
end;

procedure TfrmuModStore.ClearPlugins;
begin
  for var I := flwlytPlugins.ChildrenCount - 1 downto 0 do
  begin
    if flwlytPlugins.Children[I] is TframeuModPluginItem then
      (flwlytPlugins.Children[I] as TframeuModPluginItem).Free;
  end;
end;

procedure TfrmuModStore.edtPluginSearchKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    btnSearchPluginClick(btnSearchPlugin);
  end;
end;

procedure TfrmuModStore.flwlytPluginsResized(Sender: TObject);
begin
  ReCalcPluginSize;
end;

procedure TfrmuModStore.FormDestroy(Sender: TObject);
begin
  uModAPI.Free;
end;

procedure TfrmuModStore.FormCreate(Sender: TObject);
begin
  uModAPI := TuModAPI.Create;
  btnSearchPluginClick(btnSearchPlugin);
end;

procedure TfrmuModStore.nmbrbxCurrentPageKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    FuModResponse := uModAPI.SearchPlugins(edtPluginSearch.Text, Round(nmbrbxCurrentPage.Value));

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
      pluginItem.Parent := flwlytPlugins;
      pluginItem.PluginInfo := aPlugin;
      pluginItem.LoadAvatar;
    end;

    ReCalcPluginSize;
  end;
end;

end.

