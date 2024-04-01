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
  CompilerAndRTLVersions in 'Libs\DelphiBigNumbers\CompilerAndRTLVersions.pas',
  Velthuis.BigDecimals in 'Libs\DelphiBigNumbers\Velthuis.BigDecimals.pas',
  Velthuis.BigIntegers in 'Libs\DelphiBigNumbers\Velthuis.BigIntegers.pas',
  Velthuis.BigIntegers.Primes in 'Libs\DelphiBigNumbers\Velthuis.BigIntegers.Primes.pas',
  Velthuis.BigRationals in 'Libs\DelphiBigNumbers\Velthuis.BigRationals.pas',
  Velthuis.ExactFloatStrings in 'Libs\DelphiBigNumbers\Velthuis.ExactFloatStrings.pas',
  Velthuis.FloatUtils in 'Libs\DelphiBigNumbers\Velthuis.FloatUtils.pas',
  Velthuis.Loggers in 'Libs\DelphiBigNumbers\Velthuis.Loggers.pas',
  Velthuis.Numerics in 'Libs\DelphiBigNumbers\Velthuis.Numerics.pas',
  Velthuis.RandomNumbers in 'Libs\DelphiBigNumbers\Velthuis.RandomNumbers.pas',
  Velthuis.Sizes in 'Libs\DelphiBigNumbers\Velthuis.Sizes.pas',
  Velthuis.StrConsts in 'Libs\DelphiBigNumbers\Velthuis.StrConsts.pas',
  Velthuis.XorShifts in 'Libs\DelphiBigNumbers\Velthuis.XorShifts.pas',
  IPTypesX in 'Libs\MMDBReader\IPTypesX.pas',
  uMMDBInfo in 'Libs\MMDBReader\uMMDBInfo.pas',
  uMMDBIPAddress in 'Libs\MMDBReader\uMMDBIPAddress.pas',
  uMMDBReader in 'Libs\MMDBReader\uMMDBReader.pas',
  ufrmLicenseManager in 'Modules\LicenseManager\ufrmLicenseManager.pas' {frmLicenseManager},
  uframeToastMessage in 'Frames\ToastMessage\uframeToastMessage.pas' {frameToastMessage: TFrame},
  ufrmAffinitySelect in 'Forms\Affinity Selector\ufrmAffinitySelect.pas' {frmSelectAffinity},
  uHelpers in 'Units\uHelpers.pas',
  udmTrayIcon in 'Modules\TrayIcon\udmTrayIcon.pas' {dmTrayIcon: TDataModule},
  FMX.Trayicon.Win in 'Modules\TrayIcon\FMX.Trayicon.Win.pas',
  Rust.Manifest in 'Units\RustManifest\Rust.Manifest.pas';

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
  Application.Run;
end.

