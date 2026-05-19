unit ufrmAutoWipeItem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.DateUtils, System.Math,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  FMX.DateTimeCtrls, FMX.Objects, System.Rtti, FMX.Grid.Style, FMX.ScrollBox,
  FMX.Grid,
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
    strngrdDeleteFilesDirs: TStringGrid;
    strngclmnFileName: TStringColumn;
    strngclmnFilePath: TStringColumn;
    procedure OnIntervalChange(Sender: TObject);
  private
    function GetSelectedWipeDay: Integer;
    function ComputeNextWipe(wipeType: TAutoWipeType; wipeDay: Integer;
      const wipeTime: TTime): TDateTime;
  public
    procedure LoadWipe(const aWipe: TAutoWipe);
    procedure SaveWipe(var aWipe: TAutoWipe);
  end;

var
  frmAutoWipeItem: TfrmAutoWipeItem;

implementation

{$R *.fmx}

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
  begin
    lytIntervalDay.Enabled := True;
  end
  else if Sender = rbIntervalBiWeekly then
  begin
    lytIntervalDay.Enabled := True;
  end
  else if Sender = rbIntervalMonthly then
  begin
    // no specific day row needed
  end
  else
  begin
    raise Exception.Create('[TfrmAutoWipeItem.OnIntervalChange] Unknown Sender.');
  end;
end;

function TfrmAutoWipeItem.GetSelectedWipeDay: Integer;
begin
  if rbIntervalMon.IsChecked  then Result := 0
  else if rbIntervalTue.IsChecked  then Result := 1
  else if rbIntervalWed.IsChecked  then Result := 2
  else if rbIntervalThur.IsChecked then Result := 3
  else if rbIntervalFri.IsChecked  then Result := 4
  else if rbIntervalSat.IsChecked  then Result := 5
  else                                   Result := 6; // Sun default
end;

function TfrmAutoWipeItem.ComputeNextWipe(wipeType: TAutoWipeType;
  wipeDay: Integer; const wipeTime: TTime): TDateTime;
var
  nowWipeDay, daysAhead: Integer;
begin
  case wipeType of
    awtOnce, awtDaily:
      begin
        // Next occurrence of this time: today if still in the future, else tomorrow
        Result := Today + wipeTime;
        if Result <= Now then
          Result := Result + 1;
      end;
    awtWeekly, awtBiWeekly:
      begin
        // Convert DayOfWeek (1=Sun..7=Sat) to our scheme (0=Mon..6=Sun)
        nowWipeDay := (DayOfWeek(Now) + 5) mod 7;
        daysAhead := wipeDay - nowWipeDay;
        if (daysAhead < 0) or ((daysAhead = 0) and (wipeTime <= TimeOf(Now))) then
          Inc(daysAhead, 7);
        Result := IncDay(Today, daysAhead) + wipeTime;
      end;
    awtMonthly:
      begin
        // Same time next month (or this month if still in the future today)
        Result := Today + wipeTime;
        if Result <= Now then
          Result := IncMonth(Result);
      end;
  else
    Result := Now + 1;
  end;
end;

procedure TfrmAutoWipeItem.LoadWipe(const aWipe: TAutoWipe);
var
  I, rowCount: Integer;
begin
  swtchEnabled.IsChecked := aWipe.enabled;
  edtDescrpiton.Text := aWipe.description;

  // Interval type
  case aWipe.wipeType of
    awtOnce:     rbIntervalOnce.IsChecked := True;
    awtDaily:    rbIntervalDaily.IsChecked := True;
    awtWeekly:   rbIntervalWeekly.IsChecked := True;
    awtBiWeekly: rbIntervalBiWeekly.IsChecked := True;
    awtMonthly:  rbIntervalMonthly.IsChecked := True;
  end;

  // Day of week (relevant for weekly/biweekly)
  case aWipe.wipeDay of
    0: rbIntervalMon.IsChecked  := True;
    1: rbIntervalTue.IsChecked  := True;
    2: rbIntervalWed.IsChecked  := True;
    3: rbIntervalThur.IsChecked := True;
    4: rbIntervalFri.IsChecked  := True;
    5: rbIntervalSat.IsChecked  := True;
    6: rbIntervalSun.IsChecked  := True;
  end;

  // Wipe time
  if aWipe.wipeTime > 0 then
    tmdtInterval.Time := aWipe.wipeTime
  else
    tmdtInterval.Time := EncodeTime(5, 0, 0, 0); // default 05:00

  // Shortcut options
  swtchWipeBlueprints.IsChecked := aWipe.WipeBlueprints;
  swtchDeleteSavFiles.IsChecked := aWipe.DeleteSavFiles;

  // Populate grid with custom delete paths (wipeFiles; wipeDirs are treated the same)
  rowCount := Max(5, Length(aWipe.wipeFiles) + Length(aWipe.wipeDirs));
  strngrdDeleteFilesDirs.RowCount := rowCount;

  // Clear all rows first
  for I := 0 to rowCount - 1 do
  begin
    strngrdDeleteFilesDirs.Cells[0, I] := '';
    strngrdDeleteFilesDirs.Cells[1, I] := '';
  end;

  // Fill from wipeFiles
  for I := 0 to High(aWipe.wipeFiles) do
  begin
    strngrdDeleteFilesDirs.Cells[0, I] := ExtractFileName(aWipe.wipeFiles[I]);
    strngrdDeleteFilesDirs.Cells[1, I] := aWipe.wipeFiles[I];
  end;

  // Append wipeDirs below wipeFiles
  for I := 0 to High(aWipe.wipeDirs) do
  begin
    var row := Length(aWipe.wipeFiles) + I;
    strngrdDeleteFilesDirs.Cells[0, row] := ExtractFileName(aWipe.wipeDirs[I]);
    strngrdDeleteFilesDirs.Cells[1, row] := aWipe.wipeDirs[I];
  end;

  // Update day row visibility
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

  // Interval type
  if rbIntervalOnce.IsChecked          then selectedType := awtOnce
  else if rbIntervalDaily.IsChecked    then selectedType := awtDaily
  else if rbIntervalWeekly.IsChecked   then selectedType := awtWeekly
  else if rbIntervalBiWeekly.IsChecked then selectedType := awtBiWeekly
  else                                      selectedType := awtMonthly;

  aWipe.wipeType := selectedType;

  // Day of week
  selectedDay := GetSelectedWipeDay;
  aWipe.wipeDay := selectedDay;

  // Wipe time
  aWipe.wipeTime := tmdtInterval.Time;

  // Shortcut options
  aWipe.WipeBlueprints := swtchWipeBlueprints.IsChecked;
  aWipe.DeleteSavFiles := swtchDeleteSavFiles.IsChecked;

  // Compute the next wipe DateTime from the current settings
  aWipe.nextWipe := ComputeNextWipe(selectedType, selectedDay, aWipe.wipeTime);

  // Collect non-empty paths from grid into wipeFiles
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

  // Grid covers both files and dirs; clear wipeDirs to avoid double-deletion
  SetLength(aWipe.wipeDirs, 0);

  // newMap defaults — leave untouched so existing map settings are preserved
end;

end.
