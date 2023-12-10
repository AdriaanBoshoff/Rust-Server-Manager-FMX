unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Winapi.WebView2, Winapi.ActiveX, Vcl.Edge;

type
  TfrmMain = class(TForm)
    browser: TEdgeBrowser;
    procedure FormCreate(Sender: TObject);
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
    browser.Navigate(ParamStr(1));
  end;
end;

end.

