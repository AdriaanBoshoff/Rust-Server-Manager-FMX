object dmTrayIcon: TdmTrayIcon
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object trycnMain: TTrayIcon
    BalloonTitle = 'RSM FMX'
    PopupMenu = pmTrayIcon
    Visible = True
    Left = 304
    Top = 224
  end
  object pmTrayIcon: TPopupMenu
    Left = 496
    Top = 216
    object mnitest1: TMenuItem
      Caption = 'test'
    end
  end
end
