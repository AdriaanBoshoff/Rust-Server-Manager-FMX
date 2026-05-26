unit ufrmAutoWipeItem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.DateUtils, System.Math,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  FMX.DateTimeCtrls, FMX.Objects, System.Rtti, FMX.Grid.Style, FMX.ScrollBox,
  FMX.Grid, FMX.TabControl,
  uAutoWipeManager;

type
  TfrmAutoWipeItem = class(TForm)
    lblDescription: TLabel;
    edtDescrpiton: TEdit;
    lytIntervalType: TLayout;
    rbIntervalOnce: TRadioButton;
    rbIntervalDaily: TRadioButton;
    rbIntervalWeekly: TRadioButton;
    rbIntervalBiWeekly: TRadioButton;
    rbIntervalMonthly: TRadioButton;
    lytIntervalDay: TLayout;
    rbIntervalMon: TRadioButton;
    rbIntervalTue: TRadioButton;
    rbIntervalWed: TRadioButton;
    rbIntervalThur: TRadioButton;
    rbIntervalFri: TRadioButton;
    rbIntervalSat: TRadioButton;
    rbIntervalSun: TRadioButton;
    lytIntervalTime: TLayout;
    lblIntervalTime: TLabel;
    tmdtInterval: TTimeEdit;
    vrtscrlbxClient: TVertScrollBox;
    rctnglEnabled: TRectangle;
    swtchEnabled: TSwitch;
    lblEnabledHeader: TLabel;
    rctnglInterval: TRectangle;
    lblInterval: TLabel;
    rctnglWipeOptions: TRectangle;
    lblWipeOptionsHeader: TLabel;
    lytWipeBlueprints: TLayout;
    swtchWipeBlueprints: TSwitch;
    lblWipeBlueprintsDescription: TLabel;
    lytDeleteSavFiles: TLayout;
    swtchDeleteSavFiles: TSwitch;
    lblDeleteSavFilesDescription: TLabel;
    rctnglDeleteFilesDirs: TRectangle;
    lblDeleteFilesDirsHeader: TLabel;
    lytGridButtons: TLayout;
    btnAddFile: TButton;
    btnAddFolder: TButton;
    btnRemoveFilePath: TButton;
    strngrdDeleteFilesDirs: TStringGrid;
    strngclmnFileName: TStringColumn;
    strngclmnFilePath: TStringColumn;
    procedure OnIntervalChange(Sender: TObject);
    procedure edtDescriptionChange(Sender: TObject);
    procedure btnAddFileClick(Sender: TObject);
    procedure btnAddFolderClick(Sender: TObject);
    procedure btnRemoveFileClick(Sender: TObject);
  private
    FParentTab: TTabItem;
    function GetSelectedWipeDay: Integer;
    function ComputeNextWipe(wipeType: TAutoWipeType; wipeDay: Integer;
      const wipeTime: TTime): TDateTime;
    function BrowseForFolder: string;
    procedure AddPathToGrid(const aPath: string);
  public
    procedure SetParentTab(tab: TTabItem);
    procedure LoadWipe(const aWipe: TAutoWipe);
    procedure SaveWipe(var aWipe: TAutoWipe);
  end;

var
  frmAutoWipeItem: TfrmAutoWipeItem;

implementation

uses
  Winapi.Windows, Winapi.ShlObj, Winapi.ActiveX;

{$R *.fmx}

const
  NO_DESCR = 'NO DESCR';

{ TfrmAutoWipeItem }

procedure TfrmAutoWipeItem.SetParentTab(tab: TTabItem);
begin
  FParentTab := tab;
end;

procedure TfrmAutoWipeItem.edtDescriptionChange(Sender: TObject);
begin
  if not Assigned(FParentTab) then
    Exit;

  var txt := edtDescrpiton.Text.Trim;
  if txt.IsEmpty then
    FParentTab.Text := NO_DESCR
  else
    FParentTab.Text := txt;
end;

procedure TfrmAutoWipeItem.OnIntervalChange(Sender: TObject);
begin
  lytIntervalDay.Enabled := False;

  if Sender = rbIntervalOnce then
  begin
    // no day row needed
  end
  else if Sender = rbIntervalDaily then
  begin
    // no day row needed
  end
  else if Sender = rbIntervalWeekly then
    lytIntervalDay.Enabled := True
  else if Sender = rbIntervalBiWeekly then
    lytIntervalDay.Enabled := True
  else if Sender = rbIntervalMonthly then
  begin
    // no specific day row needed
  end
  else
    raise Exception.Create('[TfrmAutoWipeItem.OnIntervalChange] Unknown Sender.');
end;

function TfrmAutoWipeItem.GetSelectedWipeDay: Integer;
begin
  if rbIntervalMon.IsChecked       then Result := 0
  else if rbIntervalTue.IsChecked  then Result := 1
  else if rbIntervalWed.IsChecked  then Result := 2
  else if rbIntervalThur.IsChecked then Result := 3
  else if rbIntervalFri.IsChecked  then Result := 4
  else if rbIntervalSat.IsChecked  then Result := 5
  else                                   Result := 6; // Sun
end;

function TfrmAutoWipeItem.ComputeNextWipe(wipeType: TAutoWipeType;
  wipeDay: Integer; const wipeTime: TTime): TDateTime;
var
  nowWipeDay, daysAhead: Integer;
begin
  case wipeType of
    awtOnce, awtDaily:
      begin
        Result := Today + wipeTime;
        if Result <= Now then
          Result := Result + 1;
      end;
    awtWeekly, awtBiWeekly:
      begin
        // DayOfWeek: 1=Sun..7=Sat → our scheme: 0=Mon..6=Sun
        nowWipeDay := (DayOfWeek(Now) + 5) mod 7;
        daysAhead := wipeDay - nowWipeDay;
        if (daysAhead < 0) or ((daysAhead = 0) and (wipeTime <= TimeOf(Now))) then
          Inc(daysAhead, 7);
        Result := IncDay(Today, daysAhead) + wipeTime;
      end;
    awtMonthly:
      begin
        Result := Today + wipeTime;
        if Result <= Now then
          Result := IncMonth(Result);
      end;
  else
    Result := Now + 1;
  end;
end;

function TfrmAutoWipeItem.BrowseForFolder: string;
var
  bi: TBrowseInfo;
  pidl: PItemIDList;
  buffer: array[0..MAX_PATH - 1] of Char;
begin
  Result := '';
  FillChar(bi, SizeOf(bi), 0);
  bi.hwndOwner := 0;
  bi.pszDisplayName := buffer;
  bi.lpszTitle := 'Select Folder to Delete on Wipe';
  bi.ulFlags := BIF_RETURNONLYFSDIRS or BIF_NEWDIALOGSTYLE;
  pidl := SHBrowseForFolder(bi);
  if Assigned(pidl) then
  try
    if SHGetPathFromIDList(pidl, buffer) then
      Result := buffer;
  finally
    CoTaskMemFree(pidl);
  end;
end;

procedure TfrmAutoWipeItem.AddPathToGrid(const aPath: string);
var
  row, emptyRow, I: Integer;
begin
  // Try to find an empty row first
  emptyRow := -1;
  for I := 0 to strngrdDeleteFilesDirs.RowCount - 1 do
  begin
    if strngrdDeleteFilesDirs.Cells[1, I].Trim.IsEmpty then
    begin
      emptyRow := I;
      Break;
    end;
  end;

  if emptyRow >= 0 then
    row := emptyRow
  else
  begin
    // All rows occupied — add a new row
    row := strngrdDeleteFilesDirs.RowCount;
    strngrdDeleteFilesDirs.RowCount := row + 1;
  end;

  strngrdDeleteFilesDirs.Cells[0, row] := ExtractFileName(aPath);
  strngrdDeleteFilesDirs.Cells[1, row] := aPath;
end;

procedure TfrmAutoWipeItem.btnAddFileClick(Sender: TObject);
var
  dlg: TOpenDialog;
begin
  dlg := TOpenDialog.Create(Self);
  try
    dlg.Title := 'Select File to Delete on Wipe';
    dlg.Options := [TOpenOption.ofDontAddToRecent, TOpenOption.ofFileMustExist];
    dlg.Filter := 'All Files (*.*)|*.*';
    if dlg.Execute then
      AddPathToGrid(dlg.FileName);
  finally
    dlg.Free;
  end;
end;

procedure TfrmAutoWipeItem.btnAddFolderClick(Sender: TObject);
var
  folder: string;
begin
  folder := BrowseForFolder;
  if not folder.IsEmpty then
    AddPathToGrid(folder);
end;

procedure TfrmAutoWipeItem.btnRemoveFileClick(Sender: TObject);
var
  selRow, I: Integer;
begin
  if strngrdDeleteFilesDirs.RowCount = 0 then
    Exit;

  selRow := strngrdDeleteFilesDirs.Row;

  // Shift rows up from the deleted row onward
  for I := selRow to strngrdDeleteFilesDirs.RowCount - 2 do
  begin
    strngrdDeleteFilesDirs.Cells[0, I] := strngrdDeleteFilesDirs.Cells[0, I + 1];
    strngrdDeleteFilesDirs.Cells[1, I] := strngrdDeleteFilesDirs.Cells[1, I + 1];
  end;

  // Remove the last (now-duplicate) row only if we have more than the minimum 5
  if strngrdDeleteFilesDirs.RowCount > 5 then
    strngrdDeleteFilesDirs.RowCount := strngrdDeleteFilesDirs.RowCount - 1
  else
  begin
    // Clear the last row instead of shrinking below minimum
    strngrdDeleteFilesDirs.Cells[0, strngrdDeleteFilesDirs.RowCount - 1] := '';
    strngrdDeleteFilesDirs.Cells[1, strngrdDeleteFilesDirs.RowCount - 1] := '';
  end;
end;

procedure TfrmAutoWipeItem.LoadWipe(const aWipe: TAutoWipe);
var
  I, rowCount: Integer;
begin
  swtchEnabled.IsChecked := aWipe.enabled;
  edtDescrpiton.Text := aWipe.description;

  case aWipe.wipeType of
    awtOnce:     rbIntervalOnce.IsChecked := True;
    awtDaily:    rbIntervalDaily.IsChecked := True;
    awtWeekly:   rbIntervalWeekly.IsChecked := True;
    awtBiWeekly: rbIntervalBiWeekly.IsChecked := True;
    awtMonthly:  rbIntervalMonthly.IsChecked := True;
  end;

  case aWipe.wipeDay of
    0: rbIntervalMon.IsChecked  := True;
    1: rbIntervalTue.IsChecked  := True;
    2: rbIntervalWed.IsChecked  := True;
    3: rbIntervalThur.IsChecked := True;
    4: rbIntervalFri.IsChecked  := True;
    5: rbIntervalSat.IsChecked  := True;
    6: rbIntervalSun.IsChecked  := True;
  end;

  if aWipe.wipeTime > 0 then
    tmdtInterval.Time := aWipe.wipeTime
  else
    tmdtInterval.Time := EncodeTime(5, 0, 0, 0);

  swtchWipeBlueprints.IsChecked := aWipe.WipeBlueprints;
  swtchDeleteSavFiles.IsChecked := aWipe.DeleteSavFiles;

  rowCount := Max(5, Length(aWipe.wipeFiles) + Length(aWipe.wipeDirs));
  strngrdDeleteFilesDirs.RowCount := rowCount;

  for I := 0 to rowCount - 1 do
  begin
    strngrdDeleteFilesDirs.Cells[0, I] := '';
    strngrdDeleteFilesDirs.Cells[1, I] := '';
  end;

  for I := 0 to High(aWipe.wipeFiles) do
  begin
    strngrdDeleteFilesDirs.Cells[0, I] := ExtractFileName(aWipe.wipeFiles[I]);
    strngrdDeleteFilesDirs.Cells[1, I] := aWipe.wipeFiles[I];
  end;

  for I := 0 to High(aWipe.wipeDirs) do
  begin
    var row := Length(aWipe.wipeFiles) + I;
    strngrdDeleteFilesDirs.Cells[0, row] := ExtractFileName(aWipe.wipeDirs[I]);
    strngrdDeleteFilesDirs.Cells[1, row] := aWipe.wipeDirs[I];
  end;

  lytIntervalDay.Enabled :=
    rbIntervalWeekly.IsChecked or rbIntervalBiWeekly.IsChecked;
end;

procedure TfrmAutoWipeItem.SaveWipe(var aWipe: TAutoWipe);
var
  I, count: Integer;
  path: string;
  selectedType: TAutoWipeType;
  selectedDay: Integer;
begin
  aWipe.enabled := swtchEnabled.IsChecked;
  aWipe.description := edtDescrpiton.Text;

  if rbIntervalOnce.IsChecked          then selectedType := awtOnce
  else if rbIntervalDaily.IsChecked    then selectedType := awtDaily
  else if rbIntervalWeekly.IsChecked   then selectedType := awtWeekly
  else if rbIntervalBiWeekly.IsChecked then selectedType := awtBiWeekly
  else                                      selectedType := awtMonthly;

  aWipe.wipeType := selectedType;

  selectedDay := GetSelectedWipeDay;
  aWipe.wipeDay := selectedDay;
  aWipe.wipeTime := tmdtInterval.Time;

  aWipe.WipeBlueprints := swtchWipeBlueprints.IsChecked;
  aWipe.DeleteSavFiles := swtchDeleteSavFiles.IsChecked;

  aWipe.nextWipe := ComputeNextWipe(selectedType, selectedDay, aWipe.wipeTime);

  SetLength(aWipe.wipeFiles, strngrdDeleteFilesDirs.RowCount);
  count := 0;
  for I := 0 to strngrdDeleteFilesDirs.RowCount - 1 do
  begin
    path := strngrdDeleteFilesDirs.Cells[1, I].Trim;
    if not path.IsEmpty then
    begin
      aWipe.wipeFiles[count] := path;
      Inc(count);
    end;
  end;
  SetLength(aWipe.wipeFiles, count);
  SetLength(aWipe.wipeDirs, 0);
end;

end.
