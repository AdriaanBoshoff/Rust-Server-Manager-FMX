unit ufrmAffinitySelect;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, ufrmMain, FMX.Layouts, FMX.ListBox,
  System.Skia, FMX.Skia, udmStyles, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView;

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
    lblInfo: TLabel;
    vrtscrlbxAffinity: TVertScrollBox;
    lytCheckboxContainer: TLayout;
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
end;

procedure TfrmSelectAffinity.btnCancelClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TfrmSelectAffinity.btnOkClick(Sender: TObject);
begin
  var arrSelected: TArray<Integer>;

  for var control in lytCheckboxContainer.Controls do
  begin
    if not (control is TCheckBox) then
      Continue;

    if (control as TCheckBox).IsChecked then
      TAppender<Integer>.Append(arrSelected, control.Tag);
  end;

//  for var I := 0 to lstAffinity.Count - 1 do
//  begin
//    if lstAffinity.ListItems[I].IsChecked then
//      TAppender<Integer>.Append(arrSelected, I);
//  end;
//
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
  lytCheckboxContainer.BeginUpdate;
  try
    for var I := 0 to GetNumberOfProcessors - 1 do
    begin
      var aItem := TCheckBox.Create(lytCheckboxContainer);
      aItem.Parent := lytCheckboxContainer;
      aItem.Align := TAlignLayout.Bottom;
      aItem.Name := 'chkCPU' + I.ToString;
      aItem.Text := 'CPU ' + I.ToString;
      aItem.Tag := I;
      aItem.CanFocus := False;
      aItem.Margins.Top := 3;

      for var selectedCPU in serverConfig.ServerAffinity do
      begin
        if I = selectedCPU then
          aItem.IsChecked := True;
      end;
    end;
  finally
    lytCheckboxContainer.EndUpdate;
  end;

  // Resize Scrollbox
  var totalHeight := 0.0;
  for var control in lytCheckboxContainer.Controls do
  begin
    if control is TCheckBox then
    begin
      totalHeight := totalHeight + control.Height;
      totalHeight := totalHeight + control.Margins.Top;
    end;
  end;

  lytCheckboxContainer.Height := totalHeight;
end;

{ TAppender<T> }

class procedure TAppender<T>.Append(var Arr: TArray<T>; Value: T);
begin
  SetLength(Arr, Length(Arr) + 1);
  Arr[High(Arr)] := Value;
end;

end.

