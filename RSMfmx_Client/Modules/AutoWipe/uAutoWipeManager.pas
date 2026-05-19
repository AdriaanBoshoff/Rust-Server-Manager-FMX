unit uAutoWipeManager;

interface

uses
  System.IOUtils, System.DateUtils, System.SysUtils, System.Threading,
  System.Classes;

type
  TAutoWipeType = (awtOnce, awtDaily, awtWeekly, awtBiWeekly, awtMonthly);

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
    description: string;
    wipeType: TAutoWipeType;
    wipeDay: Integer;        // 0=Mon..6=Sun; relevant for weekly/biweekly display
    wipeTime: TTime;         // time of day stored for display/recompute
    nextWipe: TDateTime;
    WipeBlueprints: Boolean;
    DeleteSavFiles: Boolean;
    wipeDirs: TArray<string>;
    wipeFiles: TArray<string>;
    newMap: TAutoWipeNewMap;
  end;

type
  TAutoWipeManager = class
  private
    const
      AutoWipeTypeString: TArray<string> = ['Once', 'Daily', 'Weekly', 'Bi-Weekly', 'Monthly'];
  private
    FWipeInProgress: Boolean;
    function SaveFilePath: string;
    procedure AdvanceNextWipe(var autoWipe: TAutoWipe);
  public
    wipes: TArray<TAutoWipe>;
  public
    constructor Create;
    procedure CheckDueWipes;
    procedure DoWipe(const autoWipe: TAutoWipe);
    function GetAutoWipeTypeString(const aType: TAutoWipeType): string;
    procedure Load;
    procedure Save;
  end;

var
  autoWipeManager: TAutoWipeManager;

implementation

uses
  XSuperObject, RSM.Core, uServerConfig, uServerProcess, ufrmMain;

{ TAutoWipeManager }

constructor TAutoWipeManager.Create;
begin
  SetLength(wipes, 0);
  FWipeInProgress := False;
  Load;
end;

procedure TAutoWipeManager.AdvanceNextWipe(var autoWipe: TAutoWipe);
begin
  case autoWipe.wipeType of
    awtOnce:     autoWipe.nextWipe := IncYear(autoWipe.nextWipe, 99);
    awtDaily:    autoWipe.nextWipe := IncDay(autoWipe.nextWipe);
    awtWeekly:   autoWipe.nextWipe := IncWeek(autoWipe.nextWipe);
    awtBiWeekly: autoWipe.nextWipe := IncWeek(autoWipe.nextWipe, 2);
    awtMonthly:  autoWipe.nextWipe := IncMonth(autoWipe.nextWipe);
  end;
end;

procedure TAutoWipeManager.CheckDueWipes;
begin
  if FWipeInProgress then
    Exit;

  for var I := 0 to High(wipes) do
  begin
    if not wipes[I].enabled then
      Continue;
    if Now < wipes[I].nextWipe then
      Continue;

    // Advance before launching so a second timer tick can't re-trigger
    AdvanceNextWipe(wipes[I]);
    Save;

    DoWipe(wipes[I]);
    Break; // Only one wipe at a time; next check will catch any others
  end;
end;

procedure TAutoWipeManager.DoWipe(const autoWipe: TAutoWipe);
var
  localWipe: TAutoWipe;
begin
  localWipe := autoWipe;
  FWipeInProgress := True;

  TTask.Run(
    procedure
    var
      serverIdentityDir: string;
    begin
      try
        // Stop server if running
        if serverProcess.isRunning then
        begin
          serverProcess.KillProcess;
          var waitSecs := 30;
          while serverProcess.isRunning and (waitSecs > 0) do
          begin
            Sleep(1000);
            Dec(waitSecs);
          end;
        end;

        // Brief pause so the OS can release file handles
        Sleep(2000);

        serverIdentityDir := TPath.Combine([rsmCore.Paths.GetRootDir, 'server', 'rsm']);

        // Delete blueprint .db files
        if localWipe.WipeBlueprints and TDirectory.Exists(serverIdentityDir) then
        begin
          try
            for var f in TDirectory.GetFiles(serverIdentityDir, '*.db') do
              try TFile.Delete(f); except end;
          except
          end;
        end;

        // Delete .sav and .map files
        if localWipe.DeleteSavFiles and TDirectory.Exists(serverIdentityDir) then
        begin
          try
            for var f in TDirectory.GetFiles(serverIdentityDir, '*.sav') do
              try TFile.Delete(f); except end;
            for var f in TDirectory.GetFiles(serverIdentityDir, '*.map') do
              try TFile.Delete(f); except end;
          except
          end;
        end;

        // Delete configured directories
        for var aDir in localWipe.wipeDirs do
          try
            if TDirectory.Exists(aDir) then
              TDirectory.Delete(aDir, True);
          except
          end;

        // Delete configured files (falls back to dir delete if path is a directory)
        for var aFile in localWipe.wipeFiles do
          try
            if TFile.Exists(aFile) then
              TFile.Delete(aFile)
            else if TDirectory.Exists(aFile) then
              TDirectory.Delete(aFile, True);
          except
          end;

        // Apply map change on the main thread
        if localWipe.newMap.ChangeMap then
          TThread.Synchronize(nil,
            procedure
            begin
              serverConfig.Map.MapIndex := localWipe.newMap.MapTypeIndex;
              if localWipe.newMap.MapTypeIndex < frmMain.cbbServerMap.Count then
                serverConfig.Map.MapName :=
                  frmMain.cbbServerMap.ListItems[localWipe.newMap.MapTypeIndex].ItemData.Detail;
              serverConfig.Map.MapSize := localWipe.newMap.MapSize;
              serverConfig.Map.MapSeed := localWipe.newMap.MapSeed;
              serverConfig.Map.CustomMapURL := localWipe.newMap.CustomMapURL;
              serverConfig.SaveConfig;
              frmMain.PopulateServerConfigUI;
            end);

        // Start the server on the main thread
        TThread.Synchronize(nil,
          procedure
          begin
            frmMain.btnStartServerClick(frmMain.btnStartServer);
          end);

      finally
        FWipeInProgress := False;
      end;
    end);
end;

function TAutoWipeManager.GetAutoWipeTypeString(const aType: TAutoWipeType): string;
begin
  Result := AutoWipeTypeString[Ord(aType)];
end;

procedure TAutoWipeManager.Load;
begin
  if TFile.Exists(Self.SaveFilePath) then
    Self.AssignFromJSON(TFile.ReadAllText(Self.SaveFilePath, TEncoding.UTF8));

  Self.Save;
end;

procedure TAutoWipeManager.Save;
var
  path: string;
begin
  path := Self.SaveFilePath;

  if not TDirectory.Exists(TPath.GetDirectoryName(path)) then
    ForceDirectories(TPath.GetDirectoryName(path));

  TFile.WriteAllText(path, Self.AsJSON(True));
end;

function TAutoWipeManager.SaveFilePath: string;
begin
  Result := TPath.Combine([rsmCore.Paths.GetRSMDataDir, 'autowipe.json']);
end;

end.
