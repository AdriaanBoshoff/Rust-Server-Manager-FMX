unit ufrmServerConsole;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo, FMX.Layouts;

type
  TfrmServerConsole = class(TForm)
    statFooter: TStatusBar;
    tlbHeader: TToolBar;
    btnEmbed: TButton;
    btnEject: TButton;
    lytConsole: TLayout;
    lblExperimentalWarning: TLabel;
    procedure btnEmbedClick(Sender: TObject);
    procedure btnEjectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lytConsoleResized(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    var
      consoleHandle: UInt64;
  public
    { Public declarations }
  end;

var
  frmServerConsole: TfrmServerConsole;

//procedure ServerConsoleLog(const Text: string; const IncludeDTM: Boolean = True);

implementation

uses
  FMX.Platform.Win, WinAPI.Windows, WinAPI.Messages, uServerProcess,
  uServerConfig;

{$R *.fmx}


//procedure ServerConsoleLog(const Text: string; const IncludeDTM: Boolean = True);
//begin
//  frmServerConsole.mmoServerConsole.BeginUpdate;
//  try
//    var logText := Text;
//
//    if IncludeDTM then
//      logText := Format('[%s] %s', [FormatDateTime('yyyy-mm-dd', Now), logText]);
//
//    frmServerConsole.mmoServerConsole.Lines.Add(logText);
//
//    if frmServerConsole.mmoServerConsole.Lines.Count > 200 then
//      frmServerConsole.mmoServerConsole.Lines.Delete(0);
//  finally
//    frmServerConsole.mmoServerConsole.EndUpdate;
//  end;
//
//  if frmServerConsole.chkAutoScroll.IsChecked then
//    frmServerConsole.mmoServerConsole.GoToTextEnd;
//end;

procedure TfrmServerConsole.btnEmbedClick(Sender: TObject);
begin
  if ConsoleHandle = 0 then
    ConsoleHandle := WinAPI.Windows.FindWindow(nil, PWideChar(serverConfig.Hostname));

  if ConsoleHandle = 0 then
  begin
    ShowMessage('Unable to find server console window');
    Exit;
  end;

   // Get the current window style
  var Style := GetWindowLong(ConsoleHandle, GWL_STYLE);

  // Remove the window borders, title bar, and resizing border
  Style := Style and not (WS_CAPTION or WS_THICKFRAME or WS_BORDER or WS_SYSMENU);

  // Set the new style
  SetWindowLong(ConsoleHandle, GWL_STYLE, Style);

  // Apply the style changes immediately
  SetWindowPos(ConsoleHandle, 0, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER or SWP_FRAMECHANGED);

  // Embed
  WinAPI.Windows.SetParent(ConsoleHandle, FMX.platform.Win.FormToHWND(Self));

  // Resize
  MoveWindow(ConsoleHandle, 0, 40, Trunc(lytConsole.Width), Trunc(lytConsole.Height), True);

  //CloseHandle(externalHWND);
end;

procedure TfrmServerConsole.btnEjectClick(Sender: TObject);
begin
  // Remove from RSM
  WinAPI.Windows.SetParent(ConsoleHandle, 0);

  // Restore window to original state
  ShowWindow(ConsoleHandle, SW_RESTORE);

  // Get the current window style
  var Style := GetWindowLong(ConsoleHandle, GWL_STYLE);

  // Restore the window borders, title bar, and resizing border
  Style := Style or WS_CAPTION or WS_THICKFRAME or WS_BORDER or WS_SYSMENU;

  // Set the new style
  SetWindowLong(ConsoleHandle, GWL_STYLE, Style);

  // Apply the style changes immediately
  SetWindowPos(ConsoleHandle, 0, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER or SWP_FRAMECHANGED);

  // Resize
  MoveWindow(ConsoleHandle, 0, 40, 700, 400, True);

  CloseHandle(ConsoleHandle);

  ConsoleHandle := 0;
end;

procedure TfrmServerConsole.FormCreate(Sender: TObject);
begin
  ConsoleHandle := 0;
end;

procedure TfrmServerConsole.FormDestroy(Sender: TObject);
begin
  btnEjectClick(nil);
end;

procedure TfrmServerConsole.lytConsoleResized(Sender: TObject);
begin
  MoveWindow(ConsoleHandle, 0, 40, Trunc(lytConsole.Width), Trunc(lytConsole.Height), True);
end;

end.

