object dmChatDB: TdmChatDB
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 480
  Width = 640
  object driverSQLITE: TFDPhysSQLiteDriverLink
    DriverID = 'SQLite'
    Left = 184
    Top = 56
  end
  object conChat: TFDConnection
    Params.Strings = (
      'OpenMode=CreateUTF16'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 104
    Top = 48
  end
  object sqliteValidateChats: TFDSQLiteValidate
    DriverLink = driverSQLITE
    Left = 304
    Top = 48
  end
  object sqliteBackupChats: TFDSQLiteBackup
    DriverLink = driverSQLITE
    Catalog = 'MAIN'
    DestCatalog = 'MAIN'
    Left = 304
    Top = 224
  end
end
