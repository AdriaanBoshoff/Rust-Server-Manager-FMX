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
    OnPopup = pmTrayIconPopup
    Left = 496
    Top = 216
    object mniServerStatusValue: TMenuItem
      Caption = 'Server Status'
      Enabled = False
    end
    object mniSep: TMenuItem
      Caption = '-'
    end
    object mniStartServer: TMenuItem
      Caption = 'Start Server'
      OnClick = mniStartServerClick
    end
    object mniStopServer: TMenuItem
      Caption = 'Stop Server'
      OnClick = mniStopServerClick
    end
  end
end
