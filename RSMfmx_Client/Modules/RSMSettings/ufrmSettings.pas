unit ufrmSettings;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.TreeView, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.TabControl, FMX.Edit;

type
  TfrmSettings = class(TForm)
    tvNav: TTreeView;
    tbcNav: TTabControl;
    tviAPISettings: TTreeViewItem;
    tviSteamAPI: TTreeViewItem;
    tviRustMapsAPI: TTreeViewItem;
    tviModAPI: TTreeViewItem;
    pnlFooter: TPanel;
    tbtmAPISettings: TTabItem;
    btnSave: TButton;
    btnCancel: TButton;
    tviRSMLicense: TTreeViewItem;
    tbtmSteamAPI: TTabItem;
    tbtmRustMapsAPI: TTabItem;
    tbtmuModAPI: TTabItem;
    tbtmRSMLicense: TTabItem;
    lblSteamAPIDescription: TLabel;
    lytSteamAPIKey: TLayout;
    lblSteamAPIKeyHeader: TLabel;
    edtSteamAPIKeyValue: TEdit;
    btnGetSteamAPIKey: TButton;
    lytSteamAPICallCount: TLayout;
    lblSteamAPICallCountHeader: TLabel;
    lblSteamAPICallCountValue: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure tvNavChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.fmx}

procedure TfrmSettings.btnCancelClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TfrmSettings.btnSaveClick(Sender: TObject);
begin
  Self.ModalResult := mrOk;
end;

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  { Main Nav }
  //tbcNav.TabPosition := TTabPosition.None;

  { API Settings }
 // tbcAPISettings.TabPosition := TTabPosition.None;
end;

procedure TfrmSettings.tvNavChange(Sender: TObject);
begin
  for var I := 0 to tbcNav.TabCount - 1 do
  begin
    if tvNav.Selected.GlobalIndex = tbcNav.Tabs[I].Index then
    begin
      tbcNav.ActiveTab := tbcNav.Tabs[I];
      Break;
    end;
  end;

end;

end.

