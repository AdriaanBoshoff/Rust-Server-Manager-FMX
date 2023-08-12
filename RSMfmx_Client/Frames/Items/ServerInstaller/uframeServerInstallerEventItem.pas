unit uframeServerInstallerEventItem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Objects;

type
  TframeServerInstallerEventItem = class(TFrame)
    rctnglMain: TRectangle;
    lytDateTime: TLayout;
    lblDateTime: TLabel;
    lytMessage: TLayout;
    lblMessage: TLabel;
    procedure rctnglMainClick(Sender: TObject);
    procedure rctnglMainMouseEnter(Sender: TObject);
    procedure rctnglMainMouseLeave(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function CreateEventItem(const DTM: TDateTime; const aMessage: string; const Owner: TFmxObject): TframeServerInstallerEventItem;
  end;

implementation

uses
  System.DateUtils, uframeMessageBox;

{$R *.fmx}
{ TframeServerInstallerEventItem }

class function TframeServerInstallerEventItem.CreateEventItem(const DTM: TDateTime; const aMessage: string; const Owner: TFmxObject): TframeServerInstallerEventItem;
begin
  var nameCounter := 1;
  const uniqueNamePrefix = 'serverInstallerEvent_';
  var uniqueName := '';

  while True do
  begin
    // Unique Name
    uniqueName := uniqueNamePrefix + nameCounter.ToString;

    // Check if name exists
    if Owner.FindComponent(uniqueName) = nil then
      Break; // Unique Name Found

    Inc(nameCounter);
  end;

  Result := TframeServerInstallerEventItem.Create(Owner);
  Result.Name := uniqueName;
  Result.Parent := Owner;
  Result.Align := TAlignLayout.Top;
  Result.Margins.Top := 10;
  Result.lblDateTime.Text := FormatDateTime('yyyy.mm.dd hh:nn:ss', DTM);
  Result.lblMessage.Text := aMessage;
end;

procedure TframeServerInstallerEventItem.rctnglMainClick(Sender: TObject);
begin
  ShowMessageBox(lblMessage.Text, Format('Server Event - %s', [lblDateTime.Text]), Application.MainForm);
end;

procedure TframeServerInstallerEventItem.rctnglMainMouseEnter(Sender: TObject);
begin
  rctnglMain.Fill.Color := TAlphaColorRec.Darkred;
end;

procedure TframeServerInstallerEventItem.rctnglMainMouseLeave(Sender: TObject);
begin
  rctnglMain.Fill.Color := $FF2C303B;
end;

end.

