unit uframeToastMessage;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.Ani;

type
  TframeToastMessage = class(TFrame)
    rctnglBG: TRectangle;
    lblMessage: TLabel;
    floataniFade: TFloatAnimation;
    lytOverlayControls: TLayout;
    procedure floataniFadeFinish(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowToast(const Text: string; const FadeDuration: Integer = 2; Container: TFmxObject = nil);

implementation

{$R *.fmx}

procedure ShowToast(const Text: string; const FadeDuration: Integer = 2; Container: TFmxObject = nil);
begin
  ///  If no container is provided then use the main form
  ///  as a container.
  if Container = nil then
    Container := Application.MainForm;

  ///  Use a layout container to host the toast
  ///  messages in order to have a stacked view
  ///  if multiple toasts are shown. First check
  ///  if it exists. If it doesn't then create it.
  var toastContainer: TLayout;
  toastContainer := Container.FindComponent(Container.Name + '_toastMsg_Container') as TLayout;
  if toastContainer = nil then
  begin
    // Toast container doesn't exist so let's create it
    toastContainer := TLayout.Create(Container);
    toastContainer.Name := Container.Name + '_toastMsg_Container';
    toastContainer.Parent := Container;
    toastContainer.Align := TAlignLayout.Contents;
  end;

  // Create Toast Message
  var toastFrame := TframeToastMessage.Create(toastContainer);
  toastFrame.Name := Container.Name + '_toastMsg_' + (toastContainer.ComponentCount + 1).ToString;
  toastFrame.Parent := toastContainer;
  toastFrame.lblMessage.Text := Text;
  toastFrame.Align := TAlignLayout.Bottom;
  toastFrame.BringToFront;

  // Fade Animation
  toastFrame.floataniFade.Duration := FadeDuration;
  toastFrame.floataniFade.Start;
end;

procedure TframeToastMessage.floataniFadeFinish(Sender: TObject);
begin
  // When Fade is finished then free toast message
  Self.Release;
end;

end.

