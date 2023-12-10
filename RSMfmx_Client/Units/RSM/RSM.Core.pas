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
      public
      { TRSMCorePaths Public Class Functions }
        class function GetRootDir: string;
        class function GetRootPath: string;
        class function GetRSMDataDir: string;
        class function GetRSMDataPath: string;
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
  System.SysUtils;

{ TRSMCore.TRSMCorePaths }

class function TRSMCore.TRSMCorePaths.GetRootDir: string;
begin
  Result := ExtractFileDir(ParamStr(0));
end;

class function TRSMCore.TRSMCorePaths.GetRootPath: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

class function TRSMCore.TRSMCorePaths.GetRSMDataDir: string;
begin
  Result := Self.GetRootPath + FOLDER_RSM;
end;

class function TRSMCore.TRSMCorePaths.GetRSMDataPath: string;
begin
  Result := Self.GetRootPath + FOLDER_RSM + '\';
end;

{ TRSMCore }

constructor TRSMCore.Create;
begin
  inherited;

  Self.Paths := TRSMCorePaths.Create;
end;

destructor TRSMCore.Destroy;
begin
  Self.Paths.Free;

  inherited;
end;

initialization
begin
  rsmCore := TRSMCore.Create;
end;


finalization
begin
  rsmCore.Free;
end;

end.

