unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Winapi.WebView2, Winapi.ActiveX, Vcl.Edge, Vcl.ToolWin, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmMain = class(TForm)
    browser: TEdgeBrowser;
    procedure browserNavigationCompleted(Sender: TCustomEdgeBrowser; IsSuccess: Boolean; WebErrorStatus: TOleEnum);
    procedure browserNavigationStarting(Sender: TCustomEdgeBrowser; Args: TNavigationStartingEventArgs);
    procedure FormCreate(Sender: TObject);
    procedure browserNewWindowRequested(Sender: TCustomEdgeBrowser; Args: TNewWindowRequestedEventArgs);
    procedure browserCreateWebViewCompleted(Sender: TCustomEdgeBrowser; AResult: HRESULT);
    procedure browserDownloadStarting(Sender: TCustomEdgeBrowser; Args: TDownloadStartingEventArgs);
    procedure browserFrameNavigationStarting(Sender: TCustomEdgeBrowser; Args:
        TNavigationStartingEventArgs);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  System.IOUtils;

{$R *.dfm}

procedure TfrmMain.browserCreateWebViewCompleted(Sender: TCustomEdgeBrowser; AResult: HRESULT);
begin
  browser.DevToolsEnabled := False;
end;

procedure TfrmMain.browserDownloadStarting(Sender: TCustomEdgeBrowser; Args: TDownloadStartingEventArgs);
begin
  // Prevent Downloads
  Abort;
end;

procedure TfrmMain.browserFrameNavigationStarting(Sender: TCustomEdgeBrowser;
    Args: TNavigationStartingEventArgs);
begin
  //Abort;
end;

procedure TfrmMain.browserNavigationCompleted(Sender: TCustomEdgeBrowser; IsSuccess: Boolean; WebErrorStatus: TOleEnum);
begin
  if IsSuccess then
  begin
    // Delete Download buttons etc.
    var slJS := TStringList.Create;
    try
      // Remove Header Buttons
      slJS.Add('const headerItems = Array.from(document.getElementsByClassName("collapse navbar-collapse"));');
      slJS.Add('headerItems.forEach(item => {');
      slJS.Add('  item.remove();');
      slJS.Add('});');

      // Buttons
      slJS.Add('const buttons = Array.from(document.getElementsByClassName("card-body text-center"));');
      slJS.Add('buttons.forEach(item => {');
      slJS.Add('  item.remove();');
      slJS.Add('});');

      // Plugins by author
//      slJS.Add('const plugins = Array.from(document.getElementsByClassName("col-lg-3 col-md-12 pl-lg-0"));');
//      slJS.Add('plugins.forEach(item => {');
//      slJS.Add('  item.remove();');
//      slJS.Add('});');

      // Footer
      slJS.Add('const footerItems = Array.from(document.getElementsByClassName("py-4"));');
      slJS.Add('footerItems.forEach(item => {');
      slJS.Add('  item.remove();');
      slJS.Add('});');

      browser.ExecuteScript(slJS.Text);
    finally
      slJS.Free;
    end;
  end;
end;

procedure TfrmMain.browserNavigationStarting(Sender: TCustomEdgeBrowser; Args: TNavigationStartingEventArgs);
begin
  var uri: PWideChar;
  Args.ArgsInterface.Get_uri(uri);

  // Prevent from navigating off the page
  if string(uri) <> ParamStr(1) then
    Abort;
end;

procedure TfrmMain.browserNewWindowRequested(Sender: TCustomEdgeBrowser; Args: TNewWindowRequestedEventArgs);
begin
  Abort;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // Browser Data Folder
  browser.UserDataFolder := ExtractFilePath(ParamStr(0)) + 'rsmWebHelper';

  if not TFile.Exists(ExtractFilePath(ParamStr(0)) + 'WebView2Loader.dll') then
  begin
    ShowMessage('WebView2Loader.dll is missing. Please redownload RSM');
    Application.Terminate;
  end
  else
  begin
    // Navigate to supplied URL
    Self.Caption := '[RSM] ' + ParamStr(1);
    browser.Navigate(ParamStr(1));
  end;
end;

end.

