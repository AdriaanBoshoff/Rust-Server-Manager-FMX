unit udmDB_ServerInstallerEvents;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.VCLUI.Wait, FireDAC.Comp.UI;

type
  TServerInstallerEventData = record
    ID: Integer;
    DTM: TDateTime;
    EventMessage: string
  end;

type
  TdmDB_ServerInstallerEvents = class(TDataModule)
    fdDriverLinkSQLiteServerInstallerEvents: TFDPhysSQLiteDriverLink;
    conServerInstallerEvents: TFDConnection;
    qryServerInstallerEvents: TFDQuery;
    fdcurNone: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    fs: TFormatSettings;
    FDBPath: string;
    function GetDBPath: string;
    procedure SetupDB;
    // DB Functions
    function TableExists(const TableName: string): Boolean;
  public
    { Public declarations }
    procedure AddEvent(const DTM: TDateTime; const aEventMessage: string);
    function GetAllEvents: TArray<TServerInstallerEventData>;
  end;

var
  dmDB_ServerInstallerEvents: TdmDB_ServerInstallerEvents;

implementation

uses
  System.IOUtils;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TdmDB_ServerInstallerEvents.AddEvent(const DTM: TDateTime; const aEventMessage: string);
begin
  qryServerInstallerEvents.Close;
  qryServerInstallerEvents.SQL.Clear;
  qryServerInstallerEvents.SQL.Add('INSERT INTO "events"');
  qryServerInstallerEvents.SQL.Add('(dtm,message)');
  qryServerInstallerEvents.SQL.Add('VALUES(:dtm,:message)');
  qryServerInstallerEvents.ParamByName('dtm').Value := FormatDateTime('yyyy.mm.dd hh:nn:ss', Now);
  qryServerInstallerEvents.ParamByName('message').Value := aEventMessage;
  qryServerInstallerEvents.ExecSQL;
end;

procedure TdmDB_ServerInstallerEvents.DataModuleCreate(Sender: TObject);
begin
  // Custom Format Settings
  Self.fs.DateSeparator := '.';
  Self.fs.TimeSeparator := ':';
  Self.fs.ShortDateFormat := 'yyyy.mm.dd';

  // Get DB Path
  Self.FDBPath := Self.GetDBPath;

  // Create Data folder if it does not exists
  if not TDirectory.Exists(ExtractFileDir(Self.FDBPath)) then
    ForceDirectories(ExtractFileDir(Self.FDBPath));

  // Setup DB
  Self.SetupDB;
end;

{ TdmDB_ServerInstallerEvents }

function TdmDB_ServerInstallerEvents.GetAllEvents: TArray<TServerInstallerEventData>;
begin
  qryServerInstallerEvents.Close;
  qryServerInstallerEvents.SQL.Clear;
  qryServerInstallerEvents.SQL.Add('SELECT * FROM events');
  qryServerInstallerEvents.SQL.Add('ORDER BY id desc');
  qryServerInstallerEvents.SQL.Add('LIMIT 30');
  qryServerInstallerEvents.Open;

  if not qryServerInstallerEvents.IsEmpty then
  begin
    qryServerInstallerEvents.First;
    SetLength(Result, qryServerInstallerEvents.RecordCount);
    var I := 0;
    while not qryServerInstallerEvents.Eof do
    begin
      Result[I].ID := qryServerInstallerEvents.FieldByName('id').Value;
      Result[I].DTM := StrToDateTime(qryServerInstallerEvents.FieldByName('dtm').AsString, Self.fs);
      Result[I].EventMessage := qryServerInstallerEvents.FieldByName('message').Value;

      Inc(I);
      qryServerInstallerEvents.Next;
    end;
  end;
end;

function TdmDB_ServerInstallerEvents.GetDBPath: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'rsm\data\rsm.serverinstaller.events.db';
end;

procedure TdmDB_ServerInstallerEvents.SetupDB;
begin
  // Set DB Path
  conServerInstallerEvents.Params.Database := Self.FDBPath;
  conServerInstallerEvents.Connected := True;

  // Check if table exists
  if Self.TableExists('events') then
    Exit;


  // Create Events Table
  qryServerInstallerEvents.Close;
  qryServerInstallerEvents.SQL.Clear;
  qryServerInstallerEvents.SQL.Add('CREATE TABLE "events" (');
  qryServerInstallerEvents.SQL.Add('"id"	INTEGER NOT NULL UNIQUE,');
  qryServerInstallerEvents.SQL.Add('"dtm"	TEXT NOT NULL,');
  qryServerInstallerEvents.SQL.Add('"message"	TEXT NOT NULL,');
  qryServerInstallerEvents.SQL.Add('PRIMARY KEY("id" AUTOINCREMENT)');
  qryServerInstallerEvents.SQL.Add(');');
  qryServerInstallerEvents.ExecSQL;
end;

function TdmDB_ServerInstallerEvents.TableExists(const TableName: string): Boolean;
begin
  Result := False;

  qryServerInstallerEvents.Close;
  qryServerInstallerEvents.SQL.Clear;
  qryServerInstallerEvents.SQL.Add('SELECT name FROM sqlite_master');
  qryServerInstallerEvents.SQL.Add('WHERE type=' + QuotedStr('table'));
  qryServerInstallerEvents.SQL.Add('AND name=:tableName');
  qryServerInstallerEvents.ParamByName('tableName').Value := TableName;
  qryServerInstallerEvents.Open;

  Result := not qryServerInstallerEvents.IsEmpty;
end;

end.

