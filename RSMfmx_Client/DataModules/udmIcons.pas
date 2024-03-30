unit udmIcons;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, FMX.ImgList;

type
  TdmIcons = class(TDataModule)
    ilMenuIcons_24: TImageList;
    ilTrayIcon: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmIcons: TdmIcons;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
