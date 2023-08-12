object dmDB_ServerInstallerEvents: TdmDB_ServerInstallerEvents
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object fdDriverLinkSQLiteServerInstallerEvents: TFDPhysSQLiteDriverLink
    DriverID = 'SQLite'
    Left = 256
    Top = 32
  end
  object conServerInstallerEvents: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 56
    Top = 32
  end
  object qryServerInstallerEvents: TFDQuery
    Connection = conServerInstallerEvents
    Left = 56
    Top = 112
  end
  object fdcurNone: TFDGUIxWaitCursor
    Provider = 'Forms'
    ScreenCursor = gcrDefault
    Left = 304
    Top = 224
  end
end
