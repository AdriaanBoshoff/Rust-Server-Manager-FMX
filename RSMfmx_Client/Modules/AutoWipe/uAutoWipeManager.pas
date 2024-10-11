unit uAutoWipeManager;

interface

uses
  System.IOUtils, System.DateUtils, System.SysUtils;

type
  TAutoWipeType = (awtOnce, awtDaily, awtWeekly, awtBiWeekly);

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
    newMap: TAutoWipeNewMap;
  end;

type
  TAutoWipeManager = class
  private
    const
      AutoWipeTypeString: TArray<string> = ['Once', 'Daily', 'Weekly', 'Bi-Weekly'];
  private
    function SaveFilePath: string;
  public
    wipes: TArray<TAutoWipe>;
  public
    constructor Create;
    procedure DoWipe(var autoWipe: TAutoWipe);
    function GetAutoWipeTypeString(const aType: TAutoWipeType): string;
    procedure Load;
    procedure Save;
  end;

var
  autoWipeManager: TAutoWipeManager;

implementation

uses
  XSuperObject, RSM.Core, uServerConfig, ufrmMain;

{ TAutoWipeManager }

constructor TAutoWipeManager.Create;
begin
  SetLength(wipes, 0);
end;

procedure TAutoWipeManager.DoWipe(var autoWipe: TAutoWipe);
begin
  if not autoWipe.enabled then
  begin
    Exit;
  end;

  case autoWipe.wipeType of
    awtOnce:
      begin
        // TODO: Handle Auto Wipe
      end;
    awtDaily:
      begin
        // TODO: Handle Auto Wipe
      end;
    awtWeekly:
      begin
        // TODO: Handle Auto Wipe
      end;
    awtBiWeekly:
      begin
       // TODO: Handle Auto Wipe
      end;
  end;

  // Delete Dirs
  for var aDir in autoWipe.wipeDirs do
  begin
    try
      if TDirectory.Exists(aDir) then
      begin
        TDirectory.Delete(aDir);
      end;
    except
      on E: Exception do
      begin
        // TODO: Handle Auto Wipe exception when deleting dirs

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
        TFile.Delete(aFile);
      end;
    except
      on E: Exception do
      begin
        // TODO: Handle Auto Wipe exception when deleting files
        raise E;
      end;
    end;
  end;

  // Increment Next Wipe
  try
    case autoWipe.wipeType of
      awtOnce:
        begin
          autoWipe.nextWipe := IncYear(autoWipe.nextWipe, 99);
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
      serverConfig.Map.MapIndex := autoWipe.newMap.MapTypeIndex;
      serverConfig.Map.MapName := frmMain.cbbServerMap.ListItems[serverConfig.Map.MapIndex].ItemData.Detail;
      serverConfig.Map.MapSize := autoWipe.newMap.MapSize;
      serverConfig.Map.MapSeed := autoWipe.newMap.MapSeed;
      serverConfig.Map.CustomMapURL := autoWipe.newMap.CustomMapURL;

      serverConfig.SaveConfig;
      frmMain.PopulateServerConfigUI;
    end;

  except
    on E: Exception do
    begin
      // TODO: Handle Auto Wipe exception when inc next wipe

      raise E;
    end;
  end;

  try
    Self.Save;
  except
    on E: Exception do
    begin
      // TODO: Handle Auto Wipe exception when saving class
    end;
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

procedure TAutoWipeManager.Save;
begin
  TFile.WriteAllText(Self.SaveFilePath, Self.AsJSON(True));
end;

function TAutoWipeManager.SaveFilePath: string;
begin
  Result := TPath.Combine([rsmCore.Paths.GetRSMDataDir, 'autowipe.json']);
end;

end.

