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

  var response := '';

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
        try
          rest.Client := TRESTClient.Create(rest);
          rest.Response := TRESTResponse.Create(rest);

          rest.Client.BaseURL := 'https://rsm.rustservermanager.com';
          rest.Resource := '/rsm/v3/licensecheck';
          rest.Method := TRESTRequestMethod.rmGET;
          rest.Client.RaiseExceptionOn500 := False;
          rest.Client.UserAgent := 'RSMfmxv3';

          rest.Params.AddItem('key', edtLicenseKey.Text, TRESTRequestParameterKind.pkQUERY);

          rest.Execute;

          response := rest.Response.Content;

          TThread.Synchronize(TThread.Current,
            procedure
            begin
              // Bad Gateway - API Server is offline but nginx is online
              if rest.Response.StatusCode = 502 then
              begin
                ShowMessage('Auth Server offline... Please join the discord to see the status');
                Exit;
              end;

              // 401 - Unauthorised
              if rest.Response.StatusCode = 401 then
              begin
                ShowMessage(rest.Response.JSONValue.GetValue<string>('message'));

                Exit;
              end;

              // Response is OK so check the actual data returned from the server
              if rest.Response.StatusCode = 200 then
              begin
                // License is valid
                if rest.Response.JSONValue.GetValue<boolean>('result') then
                begin
                  TFile.WriteAllText(FLicenseFile, edtLicenseKey.Text.Trim);

                  Application.CreateForm(TfrmMain, frmMain);
                  Application.MainForm := frmMain;
                  frmMain.Show;

                  Self.Close;

                  Exit;
                end
                else
                begin
                  // Invalid License. Show returned message from server
                  ShowMessage(rest.Response.JSONValue.GetValue<string>('message'));

                  Exit;
                end;
              end
              else
              begin
                // Unhandled status code. Show full result
                ShowMessage('ERROR: Unhandled Status code: ' + rest.Response.StatusCode.ToString + ' - ' + rest.Response.StatusText + sLineBreak + rest.Response.Content);

                Exit;
              end;
            end);
        finally
          rest.Free;

          edtLicenseKey.Enabled := True;
          btnCheck.Enabled := True;
        end;
      except
        on E: Exception do
        begin
          TThread.Synchronize(TThread.Current,
            procedure
            begin
              ShowMessage(E.ClassName + ': ' + E.Message + sLineBreak + response);
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

