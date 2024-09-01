program RSMfmx_v3_1;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Skia,
  FMX.Dialogs,
  ufrmMain in 'ufrmMain.pas' {frmMain},
  udmStyles in 'DataModules\udmStyles.pas' {dmStyles: TDataModule},
  udmIcons in 'DataModules\udmIcons.pas' {dmIcons: TDataModule},
  XSuperJSON in 'Libs\XSuperObject\XSuperJSON.pas',
  XSuperObject in 'Libs\XSuperObject\XSuperObject.pas',
  uServerConfig in 'Units\Configs\ServerConfig\uServerConfig.pas',
  uframeMessageBox in 'Frames\Dialogs\uframeMessageBox.pas' {frameMessageBox: TFrame},
  udmRSMAPI in 'DataModules\udmRSMAPI.pas' {dmRSMApi: TDataModule},
  RSM.Config in 'Units\Configs\RSMConfig\RSM.Config.pas',
  ufrmServerInstaller in 'Modules\ServerInstaller\ufrmServerInstaller.pas' {frmServerInstaller},
  uSteamCMD in 'Units\uSteamCMD.pas',
  uWinUtils in 'uWinUtils.pas',
  uServerProcess in 'Units\uServerProcess.pas',
  RCON.Types in 'Units\RCON\RCON.Types.pas',
  RCON.Commands in 'Units\RCON\RCON.Commands.pas',
  RCON.Events in 'Units\RCON\RCON.Events.pas',
  RCON.Parser in 'Units\RCON\RCON.Parser.pas',
  uServerInfo in 'Units\uServerInfo.pas',
  RSM.PlayerManager in 'Units\PlayerManager\RSM.PlayerManager.pas',
  ufrmPlayerManager in 'Modules\PlayerManager\ufrmPlayerManager.pas' {frmPlayerManager},
  uframePlayerItem in 'Modules\PlayerManager\FrameItems\uframePlayerItem.pas' {framePlayerItem: TFrame},
  uframePlayerOptions in 'Modules\PlayerManager\FrameItems\uframePlayerOptions.pas' {framePlayerOptions: TFrame},
  uMisc in 'Units\uMisc.pas',
  IPWhoAPI in 'Libs\IPWho\IPWhoAPI.pas',
  ufrmOxide in 'Modules\OxideuMod\ufrmOxide.pas' {frmOxide},
  uframeServerDescriptionEditor in 'Frames\Dialogs\uframeServerDescriptionEditor.pas' {frameServerDescriptionEditor: TFrame},
  ufrmCarbonMod in 'Modules\CarbonMod\ufrmCarbonMod.pas' {frmCarbonMod},
  uframeCarbonModuleItem in 'Modules\CarbonMod\CarbonModuleItem\uframeCarbonModuleItem.pas' {frameCarbonModuleItem: TFrame},
  ufrmPluginManager in 'Modules\PluginManager\ufrmPluginManager.pas' {frmPluginManager},
  ufrmPluginInstaller in 'Modules\PluginManager\PluginInstaller\ufrmPluginInstaller.pas' {frmPluginInstaller},
  ufrmuModStore in 'Modules\PluginManager\PluginInstaller\Stores\uMod\ufrmuModStore.pas' {frmuModStore},
  uModAPI in 'Libs\uMod\uModAPI.pas',
  uModAPI.Types in 'Libs\uMod\uModAPI.Types.pas',
  uframeuModPluginItem in 'Modules\PluginManager\PluginInstaller\Stores\uMod\Items\uframeuModPluginItem.pas' {frameuModPluginItem: TFrame},
  RSM.Core in 'Units\RSM\RSM.Core.pas',
  ufrmInstalledPlugins in 'Modules\PluginManager\InstalledPlugins\ufrmInstalledPlugins.pas' {frmInstalledPlugins},
  uframeInstalledPlugin in 'Modules\PluginManager\InstalledPlugins\Items\uframeInstalledPlugin.pas' {frameInstalledPlugin: TFrame},
  ufrmLicenseManager in 'Modules\LicenseManager\ufrmLicenseManager.pas' {frmLicenseManager},
  uframeToastMessage in 'Frames\ToastMessage\uframeToastMessage.pas' {frameToastMessage: TFrame},
  ufrmAffinitySelect in 'Forms\Affinity Selector\ufrmAffinitySelect.pas' {frmSelectAffinity},
  uHelpers in 'Units\uHelpers.pas',
  udmTrayIcon in 'Modules\TrayIcon\udmTrayIcon.pas' {dmTrayIcon: TDataModule},
  Rust.Manifest in 'Units\RustManifest\Rust.Manifest.pas',
  udmChatDB in 'DataModules\ChatDB\udmChatDB.pas' {dmChatDB: TDataModule},
  ufrmLogs in 'Modules\Logs\ufrmLogs.pas' {frmLogs},
  ufrmServerConsole in 'Forms\Server Console\ufrmServerConsole.pas' {frmServerConsole},
  ufrmAutoServerStartDlg in 'Forms\AutoServerStartDialog\ufrmAutoServerStartDlg.pas' {frmAutoServerStartDlg},
  uEndpointTypes in 'Units\RSM\uEndpointTypes.pas',
  uGlobalConst in 'uGlobalConst.pas',
  ufrmSettings in 'Modules\RSMSettings\ufrmSettings.pas' {frmSettings},
  udmMapServer in 'Modules\Services\udmMapServer.pas' {dmMapServer: TDataModule},
  Horse.Callback in 'Libs\Horse\Horse.Callback.pas',
  Horse.Commons in 'Libs\Horse\Horse.Commons.pas',
  Horse.Constants in 'Libs\Horse\Horse.Constants.pas',
  Horse.Core.Files in 'Libs\Horse\Horse.Core.Files.pas',
  Horse.Core.Group.Contract in 'Libs\Horse\Horse.Core.Group.Contract.pas',
  Horse.Core.Group in 'Libs\Horse\Horse.Core.Group.pas',
  Horse.Core.Param.Config in 'Libs\Horse\Horse.Core.Param.Config.pas',
  Horse.Core.Param.Field.Brackets in 'Libs\Horse\Horse.Core.Param.Field.Brackets.pas',
  Horse.Core.Param.Field in 'Libs\Horse\Horse.Core.Param.Field.pas',
  Horse.Core.Param.Header in 'Libs\Horse\Horse.Core.Param.Header.pas',
  Horse.Core.Param in 'Libs\Horse\Horse.Core.Param.pas',
  Horse.Core in 'Libs\Horse\Horse.Core.pas',
  Horse.Core.Route.Contract in 'Libs\Horse\Horse.Core.Route.Contract.pas',
  Horse.Core.Route in 'Libs\Horse\Horse.Core.Route.pas',
  Horse.Core.RouterTree.NextCaller in 'Libs\Horse\Horse.Core.RouterTree.NextCaller.pas',
  Horse.Core.RouterTree in 'Libs\Horse\Horse.Core.RouterTree.pas',
  Horse.EnvironmentVariables in 'Libs\Horse\Horse.EnvironmentVariables.pas',
  Horse.Exception.Interrupted in 'Libs\Horse\Horse.Exception.Interrupted.pas',
  Horse.Exception in 'Libs\Horse\Horse.Exception.pas',
  Horse.Mime in 'Libs\Horse\Horse.Mime.pas',
  Horse in 'Libs\Horse\Horse.pas',
  Horse.Proc in 'Libs\Horse\Horse.Proc.pas',
  Horse.Provider.Abstract in 'Libs\Horse\Horse.Provider.Abstract.pas',
  Horse.Provider.Apache in 'Libs\Horse\Horse.Provider.Apache.pas',
  Horse.Provider.CGI in 'Libs\Horse\Horse.Provider.CGI.pas',
  Horse.Provider.Console in 'Libs\Horse\Horse.Provider.Console.pas',
  Horse.Provider.Daemon in 'Libs\Horse\Horse.Provider.Daemon.pas',
  Horse.Provider.FPC.Apache in 'Libs\Horse\Horse.Provider.FPC.Apache.pas',
  Horse.Provider.FPC.CGI in 'Libs\Horse\Horse.Provider.FPC.CGI.pas',
  Horse.Provider.FPC.Daemon in 'Libs\Horse\Horse.Provider.FPC.Daemon.pas',
  Horse.Provider.FPC.FastCGI in 'Libs\Horse\Horse.Provider.FPC.FastCGI.pas',
  Horse.Provider.FPC.HTTPApplication in 'Libs\Horse\Horse.Provider.FPC.HTTPApplication.pas',
  Horse.Provider.FPC.LCL in 'Libs\Horse\Horse.Provider.FPC.LCL.pas',
  Horse.Provider.IOHandleSSL.Contract in 'Libs\Horse\Horse.Provider.IOHandleSSL.Contract.pas',
  Horse.Provider.IOHandleSSL in 'Libs\Horse\Horse.Provider.IOHandleSSL.pas',
  Horse.Provider.ISAPI in 'Libs\Horse\Horse.Provider.ISAPI.pas',
  Horse.Provider.VCL in 'Libs\Horse\Horse.Provider.VCL.pas',
  Horse.Request in 'Libs\Horse\Horse.Request.pas',
  Horse.Response in 'Libs\Horse\Horse.Response.pas',
  Horse.Rtti.Helper in 'Libs\Horse\Horse.Rtti.Helper.pas',
  Horse.Rtti in 'Libs\Horse\Horse.Rtti.pas',
  Horse.Session in 'Libs\Horse\Horse.Session.pas',
  Horse.WebModule in 'Libs\Horse\Horse.WebModule.pas' {HorseWebModule: TWebModule},
  ThirdParty.Posix.Syslog in 'Libs\Horse\ThirdParty.Posix.Syslog.pas',
  Web.WebConst in 'Libs\Horse\Web.WebConst.pas';

{$R *.res}

begin
  // Prevent running as admin
//  if IsElevated then
//  begin
//    ShowMessage('RSM cannot be run as admin!');
//    Exit;
//  end;

  GlobalUseSkia := True;
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  Application.Title := 'RSMfmx v3.1 (DEBUG BUILD)';
  {$ENDIF}

  {$IFDEF RELEASE}
  ReportMemoryLeaksOnShutdown := False;
  Application.Title := 'RSMfmx v3.1';
  {$ENDIF}

  Application.Initialize;
  Application.CreateForm(TfrmLicenseManager, frmLicenseManager);
  Application.CreateForm(TdmStyles, dmStyles);
  Application.CreateForm(TdmIcons, dmIcons);
  Application.CreateForm(TdmChatDB, dmChatDB);
  Application.CreateForm(TfrmServerConsole, frmServerConsole);
  Application.Run;
end.

