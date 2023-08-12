unit uframeMessageBox;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts;

type
  TframeMessageBox = class(TFrame)
    rctnglBG: TRectangle;
    rctnglMain: TRectangle;
    lblHeader: TLabel;
    lytButtons: TLayout;
    btnClose: TButton;
    lblMessageValue: TLabel;
    btnCopyMessage: TSpeedButton;
    procedure btnCloseClick(Sender: TObject);
    procedure OnTextResized(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure ShowMessageBox(const aMessage, aTitle: string; const aContainer: TFmxObject);
  end;

implementation

{$R *.fmx}

procedure TframeMessageBox.btnCloseClick(Sender: TObject);
begin
  Self.Free;
end;

procedure TframeMessageBox.OnTextResized(Sender: TObject);
begin
  var caclHeight := 0.0;
  // Title
  caclHeight := caclHeight + lblHeader.Height;
  // Message Value top margin
  caclHeight := caclHeight + lblMessageValue.Margins.Top;
  // Message Value height
  caclHeight := caclHeight + lblMessageValue.Height;
  // Extra spacing between message value and buttons
  caclHeight := caclHeight + 20;
  // Layout buttons height
  caclHeight := caclHeight + lytButtons.Height;
  // Layout buttons bottom margin
  caclHeight := caclHeight + lytButtons.Margins.Bottom;

  rctnglMain.Height := caclHeight;
end;

class procedure TframeMessageBox.ShowMessageBox(const aMessage, aTitle: string; const aContainer: TFmxObject);
begin
  var aFrame := TframeMessageBox.Create(aContainer);
  aFrame.Parent := aContainer;
  aFrame.Align := TAlignLayout.Contents;
  aFrame.BringToFront;
  aFrame.lblHeader.Text := aTitle;
  aFrame.lblMessageValue.Text := aMessage;
end;

end.

