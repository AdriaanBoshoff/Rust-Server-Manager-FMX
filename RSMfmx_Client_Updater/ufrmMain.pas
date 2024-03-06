unit ufrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.WebBrowser,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects;

type
  TfrmMain = class(TForm)
    stylbkStyle: TStyleBook;
    wbChangelog: TWebBrowser;
    lytControls: TLayout;
    btnUpdate: TButton;
    btnClose: TButton;
    lytLoading: TLayout;
    rctnglLoadingBG: TRectangle;
    lblLoadingMessage: TLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure wbChangelogDidFailLoadWithError(ASender: TObject);
    procedure wbChangelogDidFinishLoad(ASender: TObject);
    procedure wbChangelogDidStartLoad(ASender: TObject);
  private
    { Private declarations }
    const
      DOWNLOAD_URL = 'https://api.rustservermanager.com/v1/download';
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  Rest.Client, Rest.Types, System.Zip, System.Threading, uWinUtils;

{$R *.fmx}

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmMain.btnUpdateClick(Sender: TObject);
begin
  TTask.Run(
    procedure
    begin
      try
        TThread.Synchronize(TThread.Current,
          procedure
          begin
            lytLoading.Visible := True;
            lytLoading.BringToFront;
            lblLoadingMessage.Text := 'Downloading Latest Version...';
          end);

        var memStream := TMemoryStream.Create;
        try
          TDownloadURL.DownloadRawBytes(DOWNLOAD_URL, memStream);
          memStream.SaveToFile('.\RSMfmxv3_latest.zip');
        finally
          memStream.Free;
        end;

        TThread.Synchronize(TThread.Current,
          procedure
          begin
            lytLoading.Visible := True;
            lytLoading.BringToFront;
            lblLoadingMessage.Text := 'Extracting...';
          end);

        try
          TZipFile.ExtractZipFile('.\RSMfmxv3_latest.zip', '');

          TThread.Synchronize(TThread.Current,
            procedure
            begin
              OpenURL('.\RSMfmx_v3_1.exe');
              Self.Close;
            end);
        except
          on E: Exception do
          begin
            TThread.Synchronize(TThread.Current,
              procedure
              begin
                ShowMessage(E.ClassName + ': ' + E.Message);
              end);
          end;
        end;

      finally
        TThread.Synchronize(TThread.Current,
          procedure
          begin
            lytLoading.Visible := False;
            lytLoading.SendToBack;
            lblLoadingMessage.Text := '';
          end);
      end;
    end);
end;

procedure TfrmMain.wbChangelogDidFailLoadWithError(ASender: TObject);
begin
  lytLoading.Visible := True;
  lytLoading.BringToFront;
  lblLoadingMessage.Text := 'Changelog Unavailible';
end;

procedure TfrmMain.wbChangelogDidFinishLoad(ASender: TObject);
begin
  lytLoading.Visible := False;
  lytLoading.SendToBack;
  lblLoadingMessage.Text := '';
end;

procedure TfrmMain.wbChangelogDidStartLoad(ASender: TObject);
begin
  lytLoading.Visible := True;
  lytLoading.BringToFront;
  lblLoadingMessage.Text := 'Loading Changelog...';
end;

end.

