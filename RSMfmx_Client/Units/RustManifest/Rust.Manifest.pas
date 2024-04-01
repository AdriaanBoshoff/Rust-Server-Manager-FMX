unit Rust.Manifest;

interface

uses
  System.JSON, System.Threading, Rest.Client, Rest.Types, System.SysUtils,
  ufrmMain, uframeMessageBox, System.Classes;

type
  TRustManifest = class
  private
    type
      TAdministrator = record
        UserID: string;
        Level: string;
      end;
  public
    BannedIPs: TArray<string>;
    Administrators: TArray<TAdministrator>;
    BlockedServers: TArray<string>;
    procedure ParseManifest(const Data: string);
    procedure CheckIfServerIsBlocked;
  end;

var
  rustManifest: TRustManifest;

implementation

{ TRustManifest }

procedure TRustManifest.CheckIfServerIsBlocked;
begin
  TTask.Run(
    procedure
    begin
      var myIP: string;
      var serverBanned := False;
      var serverBlocked := False;
      var bannedValue: string;
      var blockedValue: string;

      var rest := TRESTRequest.Create(nil);
      try
        rest.Client := TRESTClient.Create(rest);
        rest.Response := TRESTResponse.Create(rest);
        rest.Client.RaiseExceptionOn500 := False;

        rest.Client.BaseURL := 'http://myip.expert/api/';

        rest.Execute;

        if not (rest.Response.StatusCode = 200) then
          Exit;

        myIP := rest.Response.JSONValue.GetValue<string>('userIp');
      finally
        rest.Free;
      end;

      // Check BannedIPs
      for var banned in BannedIPs do
      begin
        if banned.Contains(myIP) then
        begin
          serverBanned := True;
          bannedValue := banned;
          Break;
        end;
      end;

      // Checked Blocked Servers
      for var blocked in BlockedServers do
      begin
        if blocked.Contains(myIP) then
        begin
          serverBlocked := True;
          blockedValue := blocked;
          Break;
        end;
      end;

      TThread.Synchronize(TThread.Current,
        procedure
        begin
          // Server Is banned
          if serverBanned then
          begin
            ShowMessageBox(Format('''
              Your IP has been found in the Banned section in the Rust Manifest.

              Your server will most likely not show in the server list and players might be prevented from joining your server.

              Banned Value: %s
              ''', [bannedValue]), 'Server Banned', frmMain);
          end;

          // Server Is Blocked
          if serverBlocked then
          begin
            ShowMessageBox(Format('''
              Your IP has been found in the BlockedServers section in the Rust Manifest.

              Your server will most likely not show in the server list and players might be prevented from joinging your server.

              BlockedServer Value: %s
              ''', [blockedValue]), 'Server Banned', frmMain);
          end;
        end);
    end);
end;

procedure TRustManifest.ParseManifest(const Data: string);
begin
  var jdata := TJSONObject.ParseJSONValue(Data);
  try
    SetLength(BannedIPs, (jdata.FindValue('Servers.Banned') as TJSONArray).Count);
    SetLength(Administrators, (jdata.FindValue('Administrators') as TJSONArray).Count);
    SetLength(BlockedServers, (jdata.FindValue('Metadata.BlockedServers') as TJSONArray).Count);

    var I := 0;
    for var aIP in (jdata.FindValue('Servers.Banned') as TJSONArray) do
    begin
      BannedIPs[I] := aIP.GetValue<string>;
      Inc(I);
    end;

    I := 0;
    for var aAdmin in (jdata.FindValue('Administrators') as TJSONArray) do
    begin
      var admin: TAdministrator;
      admin.UserID := aAdmin.GetValue<string>('UserId');
      admin.Level := aAdmin.GetValue<string>('Level');
      Administrators[I] := admin;
      Inc(I);
    end;

    I := 0;
    for var aIP in (jdata.FindValue('Metadata.BlockedServers') as TJSONArray) do
    begin
      BlockedServers[I] := aIP.GetValue<string>;
      Inc(I);
    end;
  finally
    jdata.Free;
  end;

  Self.CheckIfServerIsBlocked;
end;

initialization
  rustManifest := TRustManifest.Create;


finalization
  rustManifest.Free;

end.

