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
    procedure FormCreate(Sender: TObject);
    procedure btnCheckClick(Sender: TObject);
    procedure btnDiscordClick(Sender: TObject);
    procedure edtLicenseKeyKeyUp(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FLicenseFile: string;
  public
    { Public declarations }
  end;

type
  TProtectedURLRequest = class(TURLRequest);

var
  frmLicenseManager: TfrmLicenseManager;

implementation

uses
  ufrmMain, RSM.Core, Rest.Client, Rest.Types, System.JSON.Types,
  System.JSON.Writers, uWinUtils, uEndpointTypes, XSuperObject;

{$R *.fmx}

procedure TfrmLicenseManager.FormCreate(Sender: TObject);
begin
  FLicenseFile := TPath.Combine([rsmCore.Paths.GetRootDir, 'rsm.lic']);

  edtLicenseKey.SetFocus;

  if TFile.Exists(FLicenseFile) then
  begin
    edtLicenseKey.Text := TFile.ReadAllText(FLicenseFile, TEncoding.UTF8);
    btnCheckClick(btnCheck);
  end;
end;

procedure TfrmLicenseManager.btnCheckClick(Sender: TObject);
begin
  // Bypass License in Debug Mode
//  {$IFDEF DEBUG}
//  Application.CreateForm(TfrmMain, frmMain);
//  Application.MainForm := frmMain;
//  frmMain.Show;
//
//  Self.Close;
//  Exit;
//  {$ENDIF}


  if edtLicenseKey.Text.Trim.IsEmpty then
    Exit;


  // Check License Key
  TTask.Run(
    procedure
    begin
      try
        TThread.Synchronize(TThread.Current,
          procedure
          begin
            edtLicenseKey.Enabled := False;
            btnCheck.Enabled := False;
          end);

        var rest := TRESTRequest.Create(Self);
        var licenseResp := Tv1CheckLicenseResp.Create;
        var licenseReq := Tv1CheckLicenseReq.Create;
        try
          rest.Client := TRESTClient.Create(rest);
          rest.Response := TRESTResponse.Create(rest);

          rest.Client.BaseURL := 'https://api.rustservermanager.com';
          rest.Resource := '/v1/checkLicense';
          rest.Method := TRESTRequestMethod.rmGET;
          rest.Client.RaiseExceptionOn500 := False;

          licenseReq.LicenseKey := edtLicenseKey.Text.Trim;

          rest.Body.Add(licenseReq.AsJSON(True), TRestContentType.ctAPPLICATION_JSON);

          try
            rest.Execute;
          except
            on E: Exception do
            begin
              TThread.Synchronize(TThread.Current,
                procedure
                begin
                  ShowMessage('EXCEPTION: ' + sLineBreak + e.ClassName + ': ' + E.Message);
                  edtLicenseKey.Enabled := True;
                  btnCheck.Enabled := True;
                end);

              Exit;
            end;
          end;

          if not rest.Response.StatusCode = 200 then
          begin
            TThread.Synchronize(TThread.Current,
              procedure
              begin
                ShowMessage('Unable to verify License Key' + sLineBreak + rest.Response.StatusCode.ToString + ' - ' + rest.Response.StatusText);
                edtLicenseKey.Enabled := True;
                btnCheck.Enabled := True;
              end);
            Exit;
          end;

          licenseResp.FromJSON(rest.Response.Content);

          if not licenseResp.Valid then
          begin
            TThread.Synchronize(TThread.Current,
              procedure
              begin
                ShowMessage(licenseResp.Message);
                edtLicenseKey.Enabled := True;
                btnCheck.Enabled := True;
              end);

            Exit;
          end;

          TThread.Synchronize(TThread.Current,
            procedure
            begin
              TFile.WriteAllText(FLicenseFile, edtLicenseKey.Text.Trim);

              Application.CreateForm(TfrmMain, frmMain);
              Application.MainForm := frmMain;
              frmMain.Show;

              Self.Close;
            end);
        finally
          licenseReq.Free;
          licenseResp.Free;
          rest.Free;
        end;
      except
        on E: Exception do
        begin
          TThread.Synchronize(TThread.Current,
            procedure
            begin
              ShowMessage(E.ClassName + ': ' + E.Message);

              edtLicenseKey.Enabled := True;
              btnCheck.Enabled := True;
            end);
        end;
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

