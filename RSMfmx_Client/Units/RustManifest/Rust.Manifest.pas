unit Rust.Manifest;

interface

uses
  System.JSON;

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
  end;

var
  rustManifest: TRustManifest;

implementation

{ TRustManifest }

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
end;

initialization
  rustManifest := TRustManifest.Create;


finalization
  rustManifest.Free;

end.

