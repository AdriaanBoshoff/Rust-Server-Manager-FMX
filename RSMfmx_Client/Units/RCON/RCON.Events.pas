unit RCON.Events;

interface

uses
  RCON.Types;

type
  TRCONEvents = class
  { Private Methods }
    procedure OnServerInfo(const serverInfo: TRCONServerInfo);
  { Public Methods }
  public
    procedure OnRconMessage(const rconMessage: TRCONMessage);
  end;

var
  rconEvents: TRCONEvents;

implementation

{ TRCONEvents }

procedure TRCONEvents.OnRconMessage(const rconMessage: TRCONMessage);
begin
  // All messages received from rcon will be processed here.

  // ServerInfo
end;

procedure TRCONEvents.OnServerInfo(const serverInfo: TRCONServerInfo);
begin
//
end;

initialization
begin
  rconEvents := TRCONEvents.Create;
end;


finalization
begin
  rconEvents.Free;
end;

end.

