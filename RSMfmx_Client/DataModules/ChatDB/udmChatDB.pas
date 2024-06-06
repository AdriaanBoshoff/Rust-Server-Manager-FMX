unit udmChatDB;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, Rcon.Types;

type
  TdmChatDB = class(TDataModule)
    driverSQLITE: TFDPhysSQLiteDriverLink;
    conChat: TFDConnection;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    procedure CreateChatsTable;
  public
    { Public declarations }
    procedure InsertChat(const Chat: TRconChat);
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
  conChat.Connected := True;

  CreateChatsTable;
end;

end.

