unit udmChatDB;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, Rcon.Types, System.DateUtils;

type
  TDBChat = record
    ID: Integer;
    Username: string;
    UserID: string;
    BetterChatUsername: string;
    CreatedDTM: TDateTime;
    ChannelID: Integer;
    Message: string;
  end;

type
  TdmChatDB = class(TDataModule)
    driverSQLITE: TFDPhysSQLiteDriverLink;
    conChat: TFDConnection;
    sqliteValidateChats: TFDSQLiteValidate;
    sqliteBackupChats: TFDSQLiteBackup;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    procedure CreateChatsTable;
  public
    { Public declarations }
    procedure Backup;
    procedure OptimizeDB;
    procedure InsertChat(const Chat: TRconChat);
    function GetChats(const fromDTM, toDTM: TDateTime; const SteamID: string = ''; const DescendingOrder: Boolean = True): TArray<TDBChat>;
  end;

var
  dmChatDB: TdmChatDB;

implementation

uses
  RSM.Core;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TdmChatDB.DataModuleDestroy(Sender: TObject);
begin
  conChat.Connected := False;
end;

function TdmChatDB.GetChats(const fromDTM, toDTM: TDateTime; const SteamID: string; const DescendingOrder: Boolean): TArray<TDBChat>;
begin
  SetLength(Result, 0);

  var qry := TFDQuery.Create(Self);
  try
    qry.Connection := conChat;

    qry.SQL.Add('SELECT * FROM Chats');

    // Filter DTM
    qry.SQL.Add('WHERE DATE(CreatedDTM) BETWEEN DATE(:fromDTM) AND DATE(:toDTM)');

    // Filter SteamID
    if not SteamID.Trim.IsEmpty then
      qry.SQL.Add('AND UserID = :steamID');

    // Order
    if DescendingOrder then
      qry.SQL.Add('ORDER BY CreatedDTM DESC')
    else
      qry.SQL.Add('ORDER BY CreatedDTM ASC');

    // Provide Params
    qry.ParamByName('fromDTM').Value := fromDTM;
    qry.ParamByName('toDTM').Value := IncDay(toDTM);
    if not SteamID.Trim.IsEmpty then
      qry.ParamByName('steamID').Value := SteamID;

    qry.Open;

    SetLength(Result, qry.RecordCount);
    var I := 0;
    while not qry.Eof do
    begin
      Result[I].ID := qry.FieldByName('ID').Value;
      Result[I].Username := qry.FieldByName('Username').Value;
      Result[I].UserID := qry.FieldByName('UserID').Value;
      Result[I].BetterChatUsername := qry.FieldByName('BetterChatUsername').Value;
      Result[I].CreatedDTM := qry.FieldByName('CreatedDTM').Value;
      Result[I].ChannelID := qry.FieldByName('ChannelID').Value;
      Result[I].Message := qry.FieldByName('Message').Value;

      qry.Next;
      Inc(I);
    end;
  finally
    qry.Free;
  end;
end;

procedure TdmChatDB.InsertChat(const Chat: TRconChat);
begin
  var qry := TFDQuery.Create(Self);
  try
    qry.Connection := conChat;

    qry.SQL.Add('INSERT INTO Chats (Username, UserID, BetterChatUsername, CreatedDTM, ChannelID, Message)');
    qry.SQL.Add('VALUES(:Username, :UserID, :BCUsername, :CreatedDTM, :ChannelID, :Message)');

    qry.ParamByName('Username').Value := Chat.Username;
    qry.ParamByName('UserID').Value := Chat.UserID;
    qry.ParamByName('BCUsername').Value := Chat.BetterChatUsername;
    qry.ParamByName('CreatedDTM').Value := Chat.DTM;
    qry.ParamByName('ChannelID').Value := Chat.Channel;
    qry.ParamByName('Message').Value := Chat.Message;

    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

procedure TdmChatDB.OptimizeDB;
begin
  conChat.Connected := False;
  sqliteValidateChats.Sweep;
  sqliteValidateChats.Analyze;
end;

procedure TdmChatDB.Backup;
begin
  sqliteBackupChats.Database := rsmCore.Paths.GetRSM_DB_Chats_Path;
  sqliteBackupChats.Database := rsmCore.Paths.GetRSM_DB_Chats_Path + '.' + FormatDateTime('yyyy_mm_dd', Now);
  conChat.Connected := False;
  sqliteBackupChats.Backup;
end;

procedure TdmChatDB.CreateChatsTable;
begin
  var qry := TFDQuery.Create(Self);
  try
    qry.Connection := conChat;

    qry.SQL.Text := 'SELECT name FROM sqlite_master WHERE type="table" AND name="Chats";';

    qry.Open;

    if not qry.IsEmpty then
      Exit;

    var sql := '''
              CREATE TABLE "Chats" (
              "ID"	INTEGER NOT NULL UNIQUE,
              "Username"	TEXT NOT NULL,
              "UserID"	TEXT NOT NULL,
              "BetterChatUsername"	TEXT,
              "CreatedDTM"	DATETIME NOT NULL,
              "ChannelID" INTEGER NOT NULL,
              "Message"	TEXT NOT NULL,
              PRIMARY KEY("ID" AUTOINCREMENT)
              );
            ''';

    qry.SQl.Text := sql;

    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

procedure TdmChatDB.DataModuleCreate(Sender: TObject);
begin
  if not DirectoryExists(rsmCore.Paths.GetRSM_DB_Dir) then
    ForceDirectories(rsmCore.Paths.GetRSM_DB_Dir);

  conChat.Params.Database := rsmCore.Paths.GetRSM_DB_Chats_Path;

  CreateChatsTable;
end;

end.

