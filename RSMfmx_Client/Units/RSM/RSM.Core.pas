unit RSM.Core;

interface

type
  TRSMCore = class
  private
    { TRSMCore Private Types }
    type
      TRSMCorePaths = class
      private
      { TRSMCorePaths Private Const }
        const
          { RSM }
          FOLDER_RSM = 'RSM';
          FOLDER_CACHE = 'Cache';
          FOLDER_CONFIG = 'cfg';
          { uMod / Oxide }
          FOLDER_OXIDE = 'oxide';
          FOLDER_OXIDE_PLUGINS = 'plugins';
        const
          FILE_CONFIG = 'config.json';
      public
      { TRSMCorePaths Public Class Functions }
        { Program Root }
        class function GetRootDir: string;
        class function GetRootPath: string;
        { RSM Data Folder }
        class function GetRSMDataDir: string;
        class function GetRSMDataPath: string;
        { RSM Cache Folder }
        class function GetRSMCacheDir: string;
        class function GetRSMCachePath: string;
        { RSM Config Folder & File }
        class function GetRSMConfigDir: string;
        class function GetRSMConfigPath: string;
        class function GetRSMConfigFilePath: string;
        { uMod / Oxide Folders }
        class function GetOxideRootDir: string;
        class function GetOxideRootPath: string;
        class function GetOxidePluginsDir: string;
        class function GetOxidePluginsPath: string;
      end;
  public
  { TRSMCore Public Variables }
    Paths: TRSMCorePaths;
  public
  { TRSMCore Public Methods }
    constructor Create;
    destructor Destroy; override;
  public
  { TRSMCore Public Methods }
    procedure ClearRSMCache;
  end;

var
  rsmCore: TRSMCore;

implementation

uses
  System.SysUtils, System.IOUtils, uWinUtils;

{ TRSMCore.TRSMCorePaths }

class function TRSMCore.TRSMCorePaths.GetOxidePluginsDir: string;
begin
  // Oxide Plugins Folder
  Result := TPath.Combine([Self.GetOxideRootDir, Self.FOLDER_OXIDE_PLUGINS]);
end;

class function TRSMCore.TRSMCorePaths.GetOxidePluginsPath: string;
begin
  // Oxide Plugins Folder with separator
  Result := TPath.Combine([Self.GetOxideRootDir, Self.FOLDER_OXIDE_PLUGINS]) + tpath.DirectorySeparatorChar;
end;

class function TRSMCore.TRSMCorePaths.GetOxideRootDir: string;
begin
  // Oxide Root Folder
  Result := TPath.Combine([Self.GetRootPath, Self.FOLDER_OXIDE]);
end;

class function TRSMCore.TRSMCorePaths.GetOxideRootPath: string;
begin
// Oxide root Folder with separator
  Result := TPath.Combine([Self.GetRootPath, Self.FOLDER_OXIDE]) + TPath.DirectorySeparatorChar;
end;

class function TRSMCore.TRSMCorePaths.GetRootDir: string;
begin
  // Get Program Root Dir
  Result := ExtractFileDir(ParamStr(0));
end;

class function TRSMCore.TRSMCorePaths.GetRootPath: string;
begin
 // Get Program Root Path
  Result := ExtractFilePath(ParamStr(0));
end;

class function TRSMCore.TRSMCorePaths.GetRSMCacheDir: string;
begin
  Result := TPath.Combine(Self.GetRSMDataDir, FOLDER_Cache) + TPath.DirectorySeparatorChar;

  // Remove dir separator if exists
  if Result[High(Result)] = TPath.DirectorySeparatorChar then
    Delete(Result, High(Result), 1);
end;

class function TRSMCore.TRSMCorePaths.GetRSMCachePath: string;
begin
  Result := TPath.Combine(Self.GetRSMDataDir, FOLDER_Cache);

  // Add Dir separator if not exists
  if Result[High(Result)] <> TPath.DirectorySeparatorChar then
    Result := Result + TPath.DirectorySeparatorChar;
end;

class function TRSMCore.TRSMCorePaths.GetRSMConfigDir: string;
begin
  Result := Self.GetRSMDataPath + FOLDER_CONFIG;
end;

class function TRSMCore.TRSMCorePaths.GetRSMConfigFilePath: string;
begin
  Result := Self.GetRSMConfigPath + FILE_CONFIG;
end;

class function TRSMCore.TRSMCorePaths.GetRSMConfigPath: string;
begin
  Result := Self.GetRSMDataPath + FOLDER_CONFIG + TPath.DirectorySeparatorChar;
end;

class function TRSMCore.TRSMCorePaths.GetRSMDataDir: string;
begin
  // Get Program Data Folder dir
  Result := Self.GetRootPath + FOLDER_RSM;
end;

class function TRSMCore.TRSMCorePaths.GetRSMDataPath: string;
begin
  // Get Program Data Folder Path
  Result := Self.GetRootPath + FOLDER_RSM + TPath.DirectorySeparatorChar;
end;

{ TRSMCore }

procedure TRSMCore.ClearRSMCache;
begin
  if TDirectory.Exists(Self.Paths.GetRSMCacheDir) then
    TDirectory.Delete(Self.Paths.GetRSMCacheDir, True);
end;

constructor TRSMCore.Create;
begin
  inherited;

  // Create Paths
  Self.Paths := TRSMCorePaths.Create;
end;

destructor TRSMCore.Destroy;
begin
  // Free Paths
  Self.Paths.Free;

  inherited;
end;

initialization
begin
  // Create rsmCore variable when unit is loaded
  rsmCore := TRSMCore.Create;
end;


finalization
begin
  // Free rsmCore when unit is released
  rsmCore.Free;
end;

end.

