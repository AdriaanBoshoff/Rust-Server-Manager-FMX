unit ufrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Menus, FMX.StdCtrls, FMX.MultiView, FMX.Controls.Presentation, FMX.Layouts,
  FMX.TabControl;

type
  TfrmMain = class(TForm)
    mnbrMain: TMenuBar;
    statMain: TStatusBar;
    mltvwNav: TMultiView;
    tlbHeader: TToolBar;
    btnNavBurger: TSpeedButton;
    lblNavHeader: TLabel;
    lytMain: TLayout;
    lytServerInfo: TLayout;
    mniFile: TMenuItem;
    tbcNav: TTabControl;
    tbtmNavServerConfig: TTabItem;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure ModifyUIForRelease;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  ModifyUIForRelease;
end;

{ TfrmMain }

procedure TfrmMain.ModifyUIForRelease;
begin
  {$IFDEF RELEASE}
  tbcNav.TabPosition := TTabPosition.None;
  {$ENDIF}
end;

end.

