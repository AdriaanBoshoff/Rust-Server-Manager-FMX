unit uframeToastMessage;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.Ani;

type
  TframeToastMessage = class(TFrame)
    lytContainer: TLayout;
    rctnglBG: TRectangle;
    lblMessage: TLabel;
    floataniFade: TFloatAnimation;
    procedure floataniFadeFinish(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowToast(const Text: string);

implementation

{$R *.fmx}

procedure ShowToast(const Text: string);
begin
  var toastFrame := TframeToastMessage.Create(Application.MainForm);
  toastFrame.Name := 'toastMsg_' + (Application.MainForm.ComponentCount + 1).ToString;
  toastFrame.Parent := Application.MainForm;
  toastFrame.Align := TAlignLayout.Contents;
  toastFrame.BringToFront;

  toastFrame.floataniFade.Start;
end;

procedure TframeToastMessage.floataniFadeFinish(Sender: TObject);
begin
  Self.Release;
end;

end.

