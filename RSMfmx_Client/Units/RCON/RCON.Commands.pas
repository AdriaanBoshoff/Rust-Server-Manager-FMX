unit RCON.Commands;

interface

const
  { Types }
  // RCON Types
  RCON_TYPE_GENERIC = 'Generic';
  RCON_TYPE_ERROR = 'Error';
  RCON_TYPE_WARNING = 'Warning';
  RCON_TYPE_Chat = 'Chat';

  { Server IDs }
  RCON_ID_CHAT = -1; // Chat ID
  RCON_ID_GENERAL = 0;  // Broadcast ID

  { IDs and Commands }
  // serverinfo
  RCON_ID_SERVERINFO = 1;
  RCON_CMD_SERVERINFO = 'serverinfo';

implementation

end.
