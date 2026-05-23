unit ufrmAutoWipe;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Generics.Collections, System.DateUtils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.DialogService, udmStyles,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TabControl, ufrmAutoWipeItem,
  uAutoWipeManager;

type
  TfrmAutoWipe = class(TForm)
    statFooter: TStatusBar;
    tlbHeader: TToolBar;
    lblHeader: TLabel;
    btnCancel: TButton;
    btnSave: TButton;
    tbcAutoWipes: TTabControl;
    btnAddAutoWipe: TButton;
    btnDeleteAutoWipe: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnAddAutoWipeClick(Sender: TObject);
    procedure btnDeleteAutoWipeClick(Sender: TObject);
  private
    FWipeItems: TList<TfrmAutoWipeItem>;
    procedure LoadFromManager;
    procedure SaveToManager;
    procedure AddWipeTab(const aWipe: TAutoWipe);
    function ActiveWipeIndex: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.fmx}

const
  NO_DESCR = 'NO DESCR';

constructor TfrmAutoWipe.Create(AOwner: TComponent);
begin
  inherited;
  FWipeItems := TList<TfrmAutoWipeItem>.Create;
  LoadFromManager;
end;

destructor TfrmAutoWipe.Destroy;
begin
  FWipeItems.Free;
  inherited;
end;

function TfrmAutoWipe.ActiveWipeIndex: Integer;
begin
  Result := tbcAutoWipes.TabIndex;
end;

procedure TfrmAutoWipe.AddWipeTab(const aWipe: TAutoWipe);
var
  tab: TTabItem;
  wipeItem: TfrmAutoWipeItem;
  tabText: string;
begin
  tab := tbcAutoWipes.Add;

  tabText := aWipe.description.Trim;
  if tabText.IsEmpty then
    tabText := NO_DESCR;
  tab.Text := tabText;

  // Create item form owned by the tab; reparent its visual children to the tab
  wipeItem := TfrmAutoWipeItem.Create(tab);
  while wipeItem.ChildrenCount > 0 do
    wipeItem.Children[0].Parent := tab;

  wipeItem.SetParentTab(tab);
  wipeItem.LoadWipe(aWipe);
  FWipeItems.Add(wipeItem);
end;

procedure TfrmAutoWipe.LoadFromManager;
var
  I: Integer;
begin
  FWipeItems.Clear;
  while tbcAutoWipes.TabCount > 0 do
    tbcAutoWipes.Delete(0);

  for I := 0 to High(autoWipeManager.wipes) do
    AddWipeTab(autoWipeManager.wipes[I]);
end;

procedure TfrmAutoWipe.SaveToManager;
var
  I: Integer;
begin
  SetLength(autoWipeManager.wipes, FWipeItems.Count);
  for I := 0 to FWipeItems.Count - 1 do
    FWipeItems[I].SaveWipe(autoWipeManager.wipes[I]);

  autoWipeManager.Save;
end;

procedure TfrmAutoWipe.btnAddAutoWipeClick(Sender: TObject);
var
  newWipe: TAutoWipe;
begin
  newWipe.enabled := False;
  newWipe.description := '';
  newWipe.wipeType := awtWeekly;
  newWipe.wipeDay := 3;  // Thursday
  newWipe.wipeTime := EncodeTime(5, 0, 0, 0);
  newWipe.nextWipe := IncWeek(Now) + EncodeTime(5, 0, 0, 0);
  newWipe.WipeBlueprints := False;
  newWipe.DeleteSavFiles := True;
  SetLength(newWipe.wipeDirs, 0);
  SetLength(newWipe.wipeFiles, 0);
  newWipe.newMap.ChangeMap := False;
  newWipe.newMap.MapTypeIndex := 0;
  newWipe.newMap.MapSeed := 0;
  newWipe.newMap.MapSize := 3500;
  newWipe.newMap.CustomMapURL := '';

  AddWipeTab(newWipe);

  // Switch to the newly added tab
  tbcAutoWipes.TabIndex := tbcAutoWipes.TabCount - 1;
end;

procedure TfrmAutoWipe.btnDeleteAutoWipeClick(Sender: TObject);
var
  idx: Integer;
  tabName: string;
begin
  idx := ActiveWipeIndex;
  if (idx < 0) or (idx >= FWipeItems.Count) then
    Exit;

  tabName := tbcAutoWipes.Tabs[idx].Text;

  if MessageDlg('Delete wipe "' + tabName + '"?' + sLineBreak + 'This cannot be undone.',
    TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) <> mrYes then
    Exit;

  // Remove from list first so no dangling pointer remains after Delete frees the tab+form
  FWipeItems.Delete(idx);

  // Deleting the tab also frees the owned TfrmAutoWipeItem and all its controls
  tbcAutoWipes.Delete(idx);
end;

procedure TfrmAutoWipe.btnCancelClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TfrmAutoWipe.btnSaveClick(Sender: TObject);
begin
  SaveToManager;
  Self.ModalResult := mrOk;
end;

end.
