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

  // playerlist
  RCON_ID_PLAYERLIST = 2;
  RCON_CMD_PLAYERLIST = 'playerlist';

  // Reload Carbonmod Modules
  RCON_ID_Carbon_ReloadModules = 3;
  RCON_CMD_Carbon_ReloadModules = 'c.reloadmodules';

  // Load Module Config
  RCON_ID_Carbon_LoadModuleConfig = 4;
  RCON_CMD_Carbon_LoadModuleConfig = 'c.loadmoduleconfig';

  // Server Manifest
  RCON_ID_MANIFEST = 5;
  RCON_CMD_PRINTMANIFEST = 'manifest.printmanifestraw';

implementation

end.

