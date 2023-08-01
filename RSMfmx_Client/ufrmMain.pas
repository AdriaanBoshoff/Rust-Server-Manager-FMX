unit ufrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, udmStyles,
  FMX.Menus, FMX.StdCtrls, FMX.MultiView, FMX.Controls.Presentation, FMX.Layouts,
  FMX.TabControl, FMX.Ani, FMX.Objects, FMX.ListBox;

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
    tbtmNavServerControls: TTabItem;
    tbcServerInfo: TTabControl;
    tbtmServerInfo: TTabItem;
    btnShowHideServerInfo: TSpeedButton;
    fltnmtnServerInfoExpand: TFloatAnimation;
    lstNav: TListBox;
    lstServerControls: TListBoxItem;
    lblServerControls: TLabel;
    imgServerControls: TImage;
    procedure btnShowHideServerInfoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstNavChange(Sender: TObject);
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

procedure TfrmMain.btnShowHideServerInfoClick(Sender: TObject);
begin
  // Expand
  if lytServerInfo.Width = 0 then
  begin
    fltnmtnServerInfoExpand.StartValue := 0;
    fltnmtnServerInfoExpand.StopValue := 200;

    fltnmtnServerInfoExpand.Start;

    btnShowHideServerInfo.StyleLookup := 'nexttoolbutton';

    Exit;
  end;

  // Collapse
  if lytServerInfo.Width = 200 then
  begin
    fltnmtnServerInfoExpand.StartValue := 200;
    fltnmtnServerInfoExpand.StopValue := 0;

    fltnmtnServerInfoExpand.Start;

    btnShowHideServerInfo.StyleLookup := 'priortoolbutton';

    Exit;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // Change UI Layout for redistribution
  ModifyUIForRelease;
end;

procedure TfrmMain.lstNavChange(Sender: TObject);
begin
  // Check for -1 Indexes
  if lstNav.ItemIndex < -1 then
    Exit;

  // Switch to tab
  tbcNav.TabIndex := lstNav.ItemIndex;
  lblNavHeader.Text := tbcNav.Tabs[tbcNav.TabIndex].Text;
end;

{ TfrmMain }

procedure TfrmMain.ModifyUIForRelease;
begin
  {$IFDEF RELEASE}
  // Set Default Nav Items
  tbcNav.TabPosition := TTabPosition.None;
  tbcNav.TabIndex := tbtmNavServerControls.Index;
  lstNav.ItemIndex := lstServerControls.Index;
  {$ENDIF}
end;

end.

