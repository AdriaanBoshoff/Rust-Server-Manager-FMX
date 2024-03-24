unit ufrmAffinitySelect;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, ufrmMain, FMX.Layouts, FMX.ListBox,
  System.Skia, FMX.Skia, udmStyles;

type
  TAppender<T> = class
    class procedure Append(var Arr: TArray<T>; Value: T);
  end;

type
  TfrmSelectAffinity = class(TForm)
    tlbHeader: TToolBar;
    lblHeader: TSkLabel;
    pnlFooter: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    lstAffinity: TListBox;
    lblInfo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }

    procedure PopulateCPUs;
  public
    { Public declarations }
    procedure GetSavedAffinity;
  end;

  // var
  // frmSelectAffinity: TfrmSelectAffinity;

implementation

uses
  uHelpers, uServerConfig;

{$R *.fmx}

procedure TfrmSelectAffinity.FormCreate(Sender: TObject);
begin
  PopulateCPUs;
  GetSavedAffinity;
end;

procedure TfrmSelectAffinity.GetSavedAffinity;
begin
  var arrAffinity := serverConfig.ServerAffinity;

  for var I := Low(arrAffinity) to High(arrAffinity) do
  begin
    if lstAffinity.Items.Count >= I then
      lstAffinity.ListItems[arrAffinity[I]].IsChecked := True;
  end;
end;

procedure TfrmSelectAffinity.btnCancelClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TfrmSelectAffinity.btnOkClick(Sender: TObject);
begin
  var arrSelected: TArray<Integer>;

  for var I := 0 to lstAffinity.Count - 1 do
  begin
    if lstAffinity.ListItems[I].IsChecked then
      TAppender<Integer>.Append(arrSelected, I);
  end;

  serverConfig.ServerAffinity := arrSelected;
  serverConfig.SaveConfig;

  Self.ModalResult := mrOk;
end;

procedure TfrmSelectAffinity.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TfrmSelectAffinity.PopulateCPUs;
begin
  lstAffinity.BeginUpdate;
  try
    for var I := 0 to GetNumberOfProcessors - 1 do
    begin
      var aItem := TListBoxItem.Create(lstAffinity);
      aItem.Text := 'CPU ' + I.ToString;
      aItem.Selectable := False;
      aItem.CanFocus := False;

      lstAffinity.AddObject(aItem);
    end;
  finally
    lstAffinity.EndUpdate;
  end;
end;

{ TAppender<T> }

class procedure TAppender<T>.Append(var Arr: TArray<T>; Value: T);
begin
  SetLength(Arr, Length(Arr) + 1);
  Arr[High(Arr)] := Value;
end;

end.

