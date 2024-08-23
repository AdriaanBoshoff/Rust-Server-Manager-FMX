object dmTrayIcon: TdmTrayIcon
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object trycnMain: TTrayIcon
    BalloonTitle = 'RSM FMX'
    Visible = True
    Left = 304
    Top = 224
  end
end
