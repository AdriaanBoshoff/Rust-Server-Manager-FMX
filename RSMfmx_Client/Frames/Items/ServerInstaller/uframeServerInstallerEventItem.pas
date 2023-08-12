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
  private
    { Private declarations }
  public
    { Public declarations }
    class function CreateEventItem(const DTM: TDateTime; const aMessage: string; const Owner: TFmxObject): TframeServerInstallerEventItem;
  end;

implementation

uses
  System.DateUtils;

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

end.

