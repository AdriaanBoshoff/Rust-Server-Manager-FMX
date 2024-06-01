unit ufrmLicenseManager;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Layouts, FMX.Objects,
  System.IOUtils, System.Threading, System.Net.URLClient;

type
  TfrmLicenseManager = class(TForm)
    tlbHeader: TToolBar;
    lblHeader: TLabel;
    lytLicenseKey: TLayout;
    edtLicenseKey: TEdit;
    lytControls: TLayout;
    btnCheck: TButton;
    btnDiscord: TButton;
    lytLoading: TLayout;
    rctnglLoadingBG: TRectangle;
    lblLoadingText: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnCheckClick(Sender: TObject);
    procedure btnDiscordClick(Sender: TObject);
    procedure edtLicenseKeyKeyUp(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FLicenseFile: string;
    procedure ValidateCert(const Sender: TObject; const ARequest: TURLRequest; const Certificate: TCertificate; var Accepted: Boolean);
  public
    { Public declarations }
  end;

var
  frmLicenseManager: TfrmLicenseManager;

implementation

uses
  ufrmMain, RSM.Core, Rest.Client, Rest.Types, System.JSON.Types,
  System.JSON.Writers, uWinUtils;

{$R *.fmx}

procedure TfrmLicenseManager.FormCreate(Sender: TObject);
begin
  {$IFDEF DEBUG}
  btnCheckClick(btnCheck);
  Exit;
  {$ENDIF}

  FLicenseFile := TPath.Combine([rsmCore.Paths.GetRootDir, 'rsm.lic']);

  edtLicenseKey.SetFocus;

  if TFile.Exists(FLicenseFile) then
  begin
    edtLicenseKey.Text := TFile.ReadAllText(FLicenseFile, TEncoding.UTF8);
    btnCheckClick(btnCheck);
  end;
end;

procedure TfrmLicenseManager.ValidateCert(const Sender: TObject; const ARequest: TURLRequest; const Certificate: TCertificate; var Accepted: Boolean);
begin
//  TThread.Synchronize(TThread.Current,
//    procedure
//    begin
//      ShowMessage(Certificate.PublicKey);
//    end);

  Accepted := True;
end;

procedure TfrmLicenseManager.btnCheckClick(Sender: TObject);
begin
  // Bypass License in Debug Mode
  {$IFDEF DEBUG}
  Application.CreateForm(TfrmMain, frmMain);
  Application.MainForm := frmMain;
  frmMain.Show;

  Self.Close;
  Exit;
  {$ENDIF}


  if edtLicenseKey.Text.Trim.IsEmpty then
    Exit;

  TTask.Run(
    procedure
    begin
      var rest := TRESTRequest.Create(Self);
      try
        TThread.Synchronize(TThread.Current,
          procedure
          begin
            lytLoading.Visible := True;
            lytLoading.BringToFront;
            lblLoadingText.Text := 'Checking License...';
          end);

        rest.Client := TRESTClient.Create(rest);
        rest.Response := TRESTResponse.Create(rest);

        rest.Timeout := 10000;

        rest.Client.BaseURL := 'https://api.rustservermanager.com';
        rest.Resource := '/v1/auth';

        var strWriter := TStringWriter.Create;
        var writer := TJsonTextWriter.Create(strWriter);
        try
          try
            writer.WriteStartObject;
            writer.WritePropertyName('licenseKey');
            writer.WriteValue(edtLicenseKey.Text);
            writer.WriteEndObject;

            rest.Body.Add(strWriter.ToString, TRestContentType.ctAPPLICATION_JSON);

            rest.Method := TRESTRequestMethod.rmGET;

            rest.Client.OnValidateCertificate := ValidateCert;
            rest.SynchronizedEvents := False;

            rest.Execute;

            if rest.Response.JSONValue.GetValue<Boolean>('Valid') then
            begin
              TThread.Synchronize(TThread.Current,
                procedure
                begin
                  TFile.WriteAllText(FLicenseFile, edtLicenseKey.Text, TEncoding.UTF8);

                  Application.CreateForm(TfrmMain, frmMain);
                  Application.MainForm := frmMain;
                  frmMain.Show;

                  Self.Close;
                end);
            end
            else if not rest.Response.JSONValue.GetValue<string>('Message').Trim.IsEmpty then
            begin
              TThread.Synchronize(TThread.Current,
                procedure
                begin
                  ShowMessage(rest.Response.JSONValue.GetValue<string>('Message'));
                end);
            end
            else
            begin
              TThread.Synchronize(TThread.Current,
                procedure
                begin
                  ShowMessage('Invalid License');
                end);
            end;
          except
            on E: Exception do
            begin
              TThread.Synchronize(TThread.Current,
                procedure
                begin
                  ShowMessage('[TfrmLicenseManager.btnCheckClick] ' + E.ClassName + ': ' + E.Message);
                end);
            end;
          end;
        finally
          writer.Free;
          strWriter.Free;
        end;
      finally
        rest.Free;

        TThread.Synchronize(TThread.Current,
          procedure
          begin
            lytLoading.Visible := False;
            lytLoading.SendToBack;
          end);
      end;
    end);
end;

procedure TfrmLicenseManager.btnDiscordClick(Sender: TObject);
begin
  OpenURL('https://discord.gg/U7jsFBrgFh');
end;

procedure TfrmLicenseManager.edtLicenseKeyKeyUp(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    btnCheckClick(btnCheck);
  end;
end;

procedure TfrmLicenseManager.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

end.

