object dmMapServer: TdmMapServer
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object idhttpserverMapServer: TIdHTTPServer
    Bindings = <>
    DefaultPort = 3000
    OnCommandGet = idhttpserverMapServerCommandGet
    Left = 312
    Top = 256
  end
end
