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
          FOLDER_RSM = 'RSM';
          FOLDER_Cache = 'Cache';
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
      end;
  public
  { TRSMCore Public Variables }
    Paths: TRSMCorePaths;
  public
  { TRSMCore Public Methods }
    constructor Create;
    destructor Destroy; override;
  end;

var
  rsmCore: TRSMCore;

implementation

uses
  System.SysUtils, System.IOUtils;

{ TRSMCore.TRSMCorePaths }

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

class function TRSMCore.TRSMCorePaths.GetRSMDataDir: string;
begin
  // Get Program Data Folder dir
  Result := Self.GetRootPath + FOLDER_RSM;
end;

class function TRSMCore.TRSMCorePaths.GetRSMDataPath: string;
begin
  // Get Program Data Folder Path
  Result := Self.GetRootPath + FOLDER_RSM + '\';
end;

{ TRSMCore }

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

