unit FMX.Trayicon.Win;

interface

{$IFNDEF MSWINDOWS}
  {$HINTS OFF}
{$ENDIF}
uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  {$IFDEF MSWINDOWS}
  FMX.Platform.Win, Winapi.ShellAPI, Winapi.Windows, Winapi.Messages,
  {$ENDIF}
  FMX.Dialogs, FMX.Menus, FMX.Forms, FMX.Objects, System.Messaging;

{$IFDEF MSWINDOWS}
const
  WM_TRAYICON = WM_USER + 1;
{$ENDIF}

type
  TBalloonIconType = (None, Info, Warning, Error, User, BigWarning, BigError);

{$IFNDEF MSWINDOWS}
  HICON = Int64;

  LONG_PTR = Integer;

  TNotifyIconData = record
  end;

  HWND = Integer;
{$ENDIF}

type
  TIcon = HICON;

  TTrayIconNotify = procedure(ID: Integer) of object;

  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidWinNX32 or pidWinARM32)]
  TFMXTrayIcon = class(TComponent)
    type
      TTrayList = class(TList<TFMXTrayIcon>)
        procedure Delete(TrayIcon: TFMXTrayIcon); overload;
        function GetByID(ID: Integer; var TrayIcon: TFMXTrayIcon): Boolean;
      end;
  private
    class var
      TrayList: TTrayList;
      IDs: Integer;
      NeedHook: Boolean;
      OldWndProc: LONG_PTR;
  private
    FIcon: TIcon;
    FHICON: HICON;
    FHint: string;
    FBalloonTitle: string;
    FBalloonText: string;
    FBalloonIconType: TBalloonIconType;
    FNotifyIconData: TNotifyIconData;
    FPopupMenu: TPopupMenu;
    FPopupOffset: Integer;
    FOnClick: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    FOnPopup: TNotifyEvent;
    FShowing: Boolean;
    FAutoShow: Boolean;
    FID: Integer;
    FIconResource: string;
    FShowingPopup: Boolean;
    procedure DoOnClick;
    procedure DoOnDblClick;
    procedure DoOnRightClick;
    procedure DoOnPopup;
    procedure SetAutoShow(const Value: Boolean);
    class procedure Hook(Handle: HWND);
    class procedure InternalTrayIconClick(ID: Integer);
    class procedure InternalTrayIconDblClick(ID: Integer);
    class procedure InternalTrayIconRightClick(ID: Integer);
    procedure SetID(const Value: Integer);
    procedure SetIcon(const Value: TIcon);
    procedure UpdateIcon;
    procedure SetHint(const Value: string);
    procedure UpdateHint;
    procedure SetIconResource(const Value: string);
    function GetWindowHandle: HWND;
    procedure SetPopupMenu(const Value: TPopupMenu);
    procedure FOnPopupForm(const Sender: TObject; const M: TMessage);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Show;
    procedure Hide;
    procedure RecreateIcon(Rehook: Boolean = False);
    procedure ShowBalloonHint; overload;
    procedure ShowBalloonHint(Title, Text: string; BalloonIcon: TBalloonIconType); overload;
    property Icon: TIcon read FIcon write SetIcon;
    procedure LoadIconFromResources(ResourceName: string);
    property WindowHandle: HWND read GetWindowHandle;
  protected
    procedure Loaded; override;
  published
    property Hint: string read FHint write SetHint;
    property BalloonText: string read FBalloonText write FBalloonText;
    property BalloonTitle: string read FBalloonTitle write FBalloonTitle;
    property BalloonIconType: TBalloonIconType read FBalloonIconType write FBalloonIconType default TBalloonIconType.None;
    property PopupOffset: Integer read FPopupOffset write FPopupOffset default 0;
    property PopupMenu: TPopupMenu read FPopupMenu write SetPopupMenu;
    property AutoShow: Boolean read FAutoShow write SetAutoShow default True;
    property ID: Integer read FID write SetID;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnPopup: TNotifyEvent read FOnPopup write FOnPopup;
    property IconResource: string read FIconResource write SetIconResource;
  end;

implementation

uses
  FMX.Types, FMX.Controls;

{$IFDEF MSWINDOWS}
function HookWndProc(HWND: HWND; Msg: UINT; WParam: WParam; LParam: LParam): LRESULT; stdcall;
begin
  try
    if Msg = WM_TRAYICON then
    begin
      case LParam of
        WM_LBUTTONDBLCLK:
          TFMXTrayIcon.InternalTrayIconDblClick(WParam);
        WM_LBUTTONUP:
          TFMXTrayIcon.InternalTrayIconClick(WParam);
        WM_RBUTTONUP:
          TFMXTrayIcon.InternalTrayIconRightClick(WParam);
      end;
    end;
  except
  end;
  Result := CallWindowProc(Ptr(TFMXTrayIcon.OldWndProc), HWND, Msg, WParam, LParam);
end;
{$ENDIF}

class procedure TFMXTrayIcon.Hook;
begin
{$IFDEF MSWINDOWS}
  if NeedHook then
  begin
    OldWndProc := GetWindowLongPtr(Handle, GWL_WNDPROC);
    SetWindowLongPtr(Handle, GWL_WNDPROC, LONG_PTR(@HookWndProc));
    NeedHook := False;
  end;
{$ENDIF}
end;

class procedure TFMXTrayIcon.InternalTrayIconClick(ID: Integer);
var
  Tray: TFMXTrayIcon;
begin
  if TrayList.GetByID(ID, Tray) then
    Tray.DoOnClick;
end;

class procedure TFMXTrayIcon.InternalTrayIconDblClick(ID: Integer);
var
  Tray: TFMXTrayIcon;
begin
  if TrayList.GetByID(ID, Tray) then
    Tray.DoOnDblClick;
end;

class procedure TFMXTrayIcon.InternalTrayIconRightClick(ID: Integer);
var
  Tray: TFMXTrayIcon;
begin
  if TrayList.GetByID(ID, Tray) then
    Tray.DoOnRightClick;
end;

constructor TFMXTrayIcon.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FShowingPopup := False;
  TMessageManager.DefaultManager.SubscribeToMessage(TFormBeforeShownMessage, FOnPopupForm);
  Inc(IDs);
  FID := IDs;
  FShowing := False;
  FAutoShow := True;
  FPopupOffset := 0;
  {$IFDEF MSWINDOWS}
  FHICON := GetClassLong(WindowHandle, GCL_HICONSM);
  {$ENDIF}
  //
  TrayList.Add(Self);
end;

procedure TFMXTrayIcon.SetAutoShow(const Value: Boolean);
begin
  FAutoShow := Value;
end;

procedure TFMXTrayIcon.SetHint(const Value: string);
begin
  FHint := Value;
  if FShowing then
    UpdateHint;
end;

procedure TFMXTrayIcon.SetIcon(const Value: TIcon);
begin
  FIcon := Value;
  {$IFDEF MSWINDOWS}
  if FIcon <> 0 then
    FHICON := FIcon
  else
    FHICON := GetClassLong(WindowHandle, GCL_HICONSM);
  if FShowing then
    UpdateIcon;
  {$ENDIF}
end;

procedure TFMXTrayIcon.SetIconResource(const Value: string);
begin
  FIconResource := Value;
  LoadIconFromResources(Value);
end;

procedure TFMXTrayIcon.SetID(const Value: Integer);
begin
  FID := Value;
end;

procedure TFMXTrayIcon.SetPopupMenu(const Value: TPopupMenu);
begin
  FPopupMenu := Value;
end;

procedure TFMXTrayIcon.RecreateIcon;
begin
  {$IFDEF MSWINDOWS}
  if Rehook then
    TFMXTrayIcon.NeedHook := True;

  FShowing := True;
  with FNotifyIconData do
  begin
    cbSize := SizeOf;
    Wnd := WindowHandle;
    uID := FID;
    uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
    dwInfoFlags := NIIF_NONE;
    uCallbackMessage := WM_TRAYICON;
    hIcon := FHICON;
    StrLCopy(szTip, PChar(FHint), High(szTip));
  end;
  Shell_NotifyIcon(NIM_ADD, @FNotifyIconData);
  if Owner is TForm then
    Hook(WindowHandle);
  {$ENDIF}
end;

procedure TFMXTrayIcon.Show;
begin
  {$IFDEF MSWINDOWS}
  if FShowing then
    Exit;
  RecreateIcon;
  {$ENDIF}
end;

procedure TFMXTrayIcon.ShowBalloonHint;
begin
  {$IFDEF MSWINDOWS}
  with FNotifyIconData do
  begin
    StrLCopy(szInfo, PChar(FBalloonText), High(szInfo));
    StrLCopy(szInfoTitle, PChar(FBalloonTitle), High(szInfoTitle));
    dwInfoFlags := Ord(FBalloonIconType);
    uFlags := NIF_INFO;
  end;
  Shell_NotifyIcon(NIM_MODIFY, @FNotifyIconData);
  {$ENDIF}
end;

procedure TFMXTrayIcon.ShowBalloonHint(Title, Text: string; BalloonIcon: TBalloonIconType);
begin
  FBalloonText := Text;
  FBalloonTitle := Title;
  FBalloonIconType := BalloonIcon;
  ShowBalloonHint;
end;

procedure TFMXTrayIcon.UpdateIcon;
begin
  {$IFDEF MSWINDOWS}
  with FNotifyIconData do
  begin
    hIcon := FHICON;
    uFlags := NIF_ICON;
  end;
  Shell_NotifyIcon(NIM_MODIFY, @FNotifyIconData);
  {$ENDIF}
end;

procedure TFMXTrayIcon.UpdateHint;
begin
  {$IFDEF MSWINDOWS}
  with FNotifyIconData do
  begin
    StrLCopy(szTip, PChar(FHint), High(szTip));
    uFlags := NIF_TIP;
  end;
  Shell_NotifyIcon(NIM_MODIFY, @FNotifyIconData);
  {$ENDIF}
end;

procedure TFMXTrayIcon.Hide;
begin
  FShowing := False;
  {$IFDEF MSWINDOWS}
  Shell_NotifyIcon(NIM_DELETE, @FNotifyIconData);
  {$ENDIF}
end;

procedure TFMXTrayIcon.Loaded;
begin
  inherited;
  if not (csDesigning in ComponentState) then
  begin
    if FAutoShow then
      Show;
  end;
end;

procedure TFMXTrayIcon.LoadIconFromResources(ResourceName: string);
begin
  {$IFDEF MSWINDOWS}
  Icon := LoadIcon(hInstance, PChar(ResourceName));
  {$ENDIF}
end;

destructor TFMXTrayIcon.Destroy;
begin
  TMessageManager.DefaultManager.Unsubscribe(TFormBeforeShownMessage, FOnPopupForm);
  if FShowing then
    Hide;
  TrayList.Delete(Self);
  inherited;
end;

procedure TFMXTrayIcon.DoOnClick;
begin
  if Assigned(FOnClick) then
    FOnClick(Self);
end;

procedure TFMXTrayIcon.DoOnDblClick;
begin
  if Assigned(FOnDblClick) then
    FOnDblClick(Self);
end;

procedure TFMXTrayIcon.DoOnPopup;
{$IFDEF MSWINDOWS}
var
  CurPos: TPoint;
begin
 // SetForegroundWindow(ApplicationHWND);
  GetCursorPos(CurPos);
  if Assigned(FPopupMenu) then
  begin
    FPopupMenu.CloseMenu;
    FShowingPopup := True;
    try
      FPopupMenu.Popup(CurPos.X, CurPos.Y - FPopupOffset);
    finally
      FShowingPopup := False;
    end;
  end;
  {$ELSE}
begin
  {$ENDIF}
end;

procedure TFMXTrayIcon.DoOnRightClick;
begin
  if Assigned(FOnPopup) then
    FOnPopup(Self)
  else
    DoOnPopup;
end;

procedure TFMXTrayIcon.FOnPopupForm(const Sender: TObject; const M: TMessage);
var
  Msg: TFormBeforeShownMessage absolute M;
begin
  if FShowingPopup and (Msg.Value is TCustomPopupForm) then
  begin
    SetWindowPos(
        FormToHWND(Msg.Value),
        HWND_TOPMOST, 0, 0, 0, 0,
        SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE
    );
  end;
end;

function TFMXTrayIcon.GetWindowHandle: HWND;
begin
  Result := FmxHandleToHWND((Owner as TForm).Handle);
end;

{ TTrayIcon.TTrayList }

procedure TFMXTrayIcon.TTrayList.Delete(TrayIcon: TFMXTrayIcon);
var
  i: Integer;
begin
  for i := 0 to Self.Count - 1 do
    if Self[i] = TrayIcon then
    begin
      Self.Delete(i);
      Break;
    end;
end;

function TFMXTrayIcon.TTrayList.GetByID(ID: Integer; var TrayIcon: TFMXTrayIcon): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to Self.Count - 1 do
  begin
    if Self[i].ID = ID then
    begin
      Result := True;
      TrayIcon := Self[i];
      Exit;
    end;
  end;
end;

initialization
  TFMXTrayIcon.TrayList := TFMXTrayIcon.TTrayList.Create;
  TFMXTrayIcon.NeedHook := True;
  TFMXTrayIcon.IDs := 0;

finalization
  TFMXTrayIcon.TrayList.Free;

end.

