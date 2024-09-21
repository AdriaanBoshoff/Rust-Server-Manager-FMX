unit uAutoWipeManager;

interface

uses
  System.IOUtils, System.DateUtils, System.SysUtils;

type
  TAutoWipeType = (awrOnce, awtDaily, awtWeekly, awtBiWeekly);

type
  TAutoWipeNewMap = record
  public
    ChangeMap: boolean;
    MapTypeIndex: Integer;
    MapSeed: Integer;
    MapSize: Integer;
    CustomMapURL: string;
  end;

type
  TAutoWipe = record
  public
    enabled: Boolean;
    wipeType: TAutoWipeType;
    nextWipe: TDateTime;
    wipeDirs: TArray<string>;
    wipeFiles: TArray<string>;
    wipeLog: TArray<string>;
    newMap: TAutoWipeNewMap;
  end;

type
  TAutoWipeManager = class
  private
    const
      AutoWipeTypeString: TArray<string> = ['Once off', 'Daily', 'Weekly', 'Monthly'];
  private
    function SaveFilePath: string;
  public
    wipes: TArray<TAutoWipe>;
  public
    constructor Create;
    procedure DoWipe(var autoWipe: TAutoWipe);
    procedure LogWipe(var autoWipe: TAutoWipe; const LogText: string);
    function GetAutoWipeTypeString(const aType: TAutoWipeType): string;
    procedure Load;
    procedure Save;
  end;

var
  autoWipeManager: TAutoWipeManager;

implementation

uses
  XSuperObject, RSM.Core;

{ TAutoWipeManager }

constructor TAutoWipeManager.Create;
begin
  SetLength(wipes, 0);
end;

procedure TAutoWipeManager.DoWipe(var autoWipe: TAutoWipe);
begin
  if not autoWipe.enabled then
  begin
    LogWipe(autoWipe, 'Skipping... Wipe not enabled.');
    Exit;
  end;

  case autoWipe.wipeType of
    awrOnce:
      begin
        LogWipe(autoWipe, 'Doing Once off Wipe');
      end;
    awtDaily:
      begin
        LogWipe(autoWipe, 'Doing Daily Wipe');
      end;
    awtWeekly:
      begin
        LogWipe(autoWipe, 'Doing Weekly Wipe');
      end;
    awtBiWeekly:
      begin
        LogWipe(autoWipe, 'Doing BiWeekly Wipe');
      end;
  end;

  // Delete Dirs
  for var aDir in autoWipe.wipeDirs do
  begin
    try
      if TDirectory.Exists(aDir) then
      begin
        LogWipe(autoWipe, 'Deleting "' + aDir + '"');
        TDirectory.Delete(aDir);
        LogWipe(autoWipe, 'Deleted.');
      end
      else
      begin
        LogWipe(autoWipe, 'Skipping... Directory does not exists.');
      end;
    except
      on E: Exception do
      begin
        LogWipe(autoWipe, 'Delete Failed: ' + E.ClassName + ': ' + E.Message);

        raise E;
      end;
    end;
  end;

  // Delete Files
  for var aFile in autoWipe.wipeFiles do
  begin
    try
      if TFile.Exists(aFile) then
      begin
        LogWipe(autoWipe, 'Deleting "' + aFile + '"');
        TFile.Delete(aFile);
        LogWipe(autoWipe, 'Deleted.');
      end
      else
      begin
        LogWipe(autoWipe, 'Skipping... File does not exists.');
      end;
    except
      on E: Exception do
      begin
        LogWipe(autoWipe, 'Delete Failed: ' + E.ClassName + ': ' + E.Message);

        raise E;
      end;
    end;
  end;

  // Increment Next Wipe
  try
    case autoWipe.wipeType of
      awrOnce:
        begin
          autoWipe.nextWipe := IncDay(autoWipe.nextWipe);
        end;
      awtDaily:
        begin
          autoWipe.nextWipe := IncDay(autoWipe.nextWipe);
        end;
      awtWeekly:
        begin
          autoWipe.nextWipe := IncWeek(autoWipe.nextWipe);
        end;
      awtBiWeekly:
        begin
          autoWipe.nextWipe := IncWeek(autoWipe.nextWipe, 2);
        end;
    end;

    // Change Map Settings
    if autoWipe.newMap.ChangeMap then
    begin
      // TODO: Auto Wipe change server config.
    end;

    if autoWipe.enabled then
      LogWipe(autoWipe, 'Wipe Complete. Next Wipe: ' + autoWipe.nextWipe.ToString)
    else
      LogWipe(autoWipe, 'Wipe Complete. Next Wipe: Disabled');
  except
    on E: Exception do
    begin
      LogWipe(autoWipe, 'Setting Next Wipe Schedule Failed: ' + E.ClassName + ': ' + E.Message);

      raise E;
    end;
  end;

  try
    Self.Save;
  except
    LogWipe(autoWipe, 'Failed to save next wipe schedule');
  end;
end;

function TAutoWipeManager.GetAutoWipeTypeString(const aType: TAutoWipeType): string;
begin
  Result := AutoWipeTypeString[Ord(aType)];
end;

procedure TAutoWipeManager.Load;
begin
  if TFile.Exists(Self.SaveFilePath) then
    Self.AssignFromJSON(Self.SaveFilePath);

  Self.Save;
end;

procedure TAutoWipeManager.LogWipe(var autoWipe: TAutoWipe; const LogText: string);
begin
  SetLength(autoWipe.wipeLog, Length(autoWipe.wipeLog) + 1);
  autoWipe.wipeLog[High(autoWipe.wipeLog)] := Format('[%s] %s', [FormatDateTime('hh:nn:ss', Now), LogText]);
end;

procedure TAutoWipeManager.Save;
begin
  TFile.WriteAllText(Self.SaveFilePath, Self.AsJSON(True));
end;

function TAutoWipeManager.SaveFilePath: string;
begin
  Result := TPath.Combine([rsmCore.Paths.GetRSMDataDir, 'autowipe.json']);
end;

end.

