unit ufrmLogs;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.TabControl, FMX.Controls.Presentation, FMX.StdCtrls, FMX.DateTimeCtrls,
  FMX.Edit, System.Rtti, FMX.Grid.Style, FMX.Grid, FMX.ScrollBox;

type
  TfrmLogs = class(TForm)
    tbcLogs: TTabControl;
    tbtmChatLogs: TTabItem;
    tlbChatLogsHeader: TToolBar;
    lblChatLogsFromDTM: TLabel;
    edtDateChatLogsFrom: TDateEdit;
    lblChatLogsToDTM: TLabel;
    edtDateChatLogsTo: TDateEdit;
    lblChatLogsSteamID: TLabel;
    edtChatLogsSteamID: TEdit;
    btnClearChatLogsSteamID: TClearEditButton;
    btnApply: TButton;
    strngrdChatLogs: TStringGrid;
    strngclmnChatLogsUserID: TStringColumn;
    strngclmnChatLogsUsername: TStringColumn;
    strngclmnChatLogsChannel: TStringColumn;
    strngclmnChatLogsCreatedDTM: TStringColumn;
    strngclmnChatLogsMessage: TStringColumn;
    procedure FormCreate(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogs: TfrmLogs;

implementation

uses
  udmChatDB;

{$R *.fmx}

procedure TfrmLogs.FormCreate(Sender: TObject);
begin
  edtDateChatLogsFrom.DateTime := Now;
  edtDateChatLogsTo.DateTime := Now;
end;

procedure TfrmLogs.btnApplyClick(Sender: TObject);
begin
  var chats := dmChatDB.GetChats(edtDateChatLogsFrom.DateTime, edtDateChatLogsTo.DateTime, edtChatLogsSteamID.Text.Trim);

  var indexSteamID := strngclmnChatLogsUserID.Index;
  var indexUsername := strngclmnChatLogsUsername.Index;
  var indexChannel := strngclmnChatLogsChannel.Index;
  var indexDTM := strngclmnChatLogsCreatedDTM.Index;
  var indexMessage := strngclmnChatLogsMessage.Index;

  strngrdChatLogs.BeginUpdate;
  try
    strngrdChatLogs.RowCount := 0;

    for var aChat in chats do
    begin
      strngrdChatLogs.RowCount := strngrdChatLogs.RowCount + 1;
      var row := strngrdChatLogs.RowCount - 1;

      strngrdChatLogs.Cells[indexSteamID, row] := aChat.UserID;
      strngrdChatLogs.Cells[indexUsername, row] := aChat.Username;
      case aChat.ChannelID of
        0:
          strngrdChatLogs.Cells[indexChannel, row] := 'Global';
        1:
          strngrdChatLogs.Cells[indexChannel, row] := 'Team';
      else
        strngrdChatLogs.Cells[indexChannel, row] := aChat.ChannelID.ToString;
      end;

      strngrdChatLogs.Cells[indexDTM, row] := DateTimeToStr(aChat.CreatedDTM);
      strngrdChatLogs.Cells[indexMessage, row] := aChat.Message;
    end;
  finally
    strngrdChatLogs.EndUpdate;
  end;
end;

end.

