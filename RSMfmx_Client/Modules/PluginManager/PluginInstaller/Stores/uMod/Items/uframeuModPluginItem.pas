unit uframeuModPluginItem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Objects, uModAPI.Types,
  System.Threading, Rest.Client;

type
  TframeuModPluginItem = class(TFrame)
    rctnglHeader: TRectangle;
    rctnglOxideModNavImage: TRectangle;
    lytHeaderInfo: TLayout;
    lytTitle: TLayout;
    lytDescription: TLayout;
    lblDescription: TLabel;
    lblPluginTitle: TLabel;
    lytControls: TLayout;
    lblAuthor: TLabel;
    lytDownloads: TLayout;
    imgDownloadsIcon: TImage;
    lblDownloadsCount: TLabel;
    lytVersion: TLayout;
    imgVersionIcon: TImage;
    lblVersion: TLabel;
    btnHelp: TButton;
    btnDownload: TButton;
    procedure rctnglHeaderMouseEnter(Sender: TObject);
    procedure rctnglHeaderMouseLeave(Sender: TObject);
  private
    { Private Const }
    const
      UI_COLOR_DEFAULT = $FF1F222A;
      UI_COLOR_HOVER = $FF6F0000;
      UI_COLOR_SELECTED = $FF900000;
  private
    { Private declarations }
  public
    { Public declarations }
    FPluginInfo: TuModSearchPlugin;
    procedure LoadAvatar;
  end;

implementation

{$R *.fmx}

{ TframeuModPluginItem }

procedure TframeuModPluginItem.LoadAvatar;
begin
  TTask.Run(
    procedure
    begin
      var memStream := TMemoryStream.Create;
      try
        try
          TDownloadURL.DownloadRawBytes(FPluginInfo.iconURL, memStream);

          TThread.Synchronize(TThread.Current,
            procedure
            begin
              rctnglOxideModNavImage.Fill.Bitmap.Bitmap.LoadFromStream(memStream);
            end);
        except

        end;
      finally
        memStream.Free;
      end;
    end);
end;

procedure TframeuModPluginItem.rctnglHeaderMouseEnter(Sender: TObject);
begin
  rctnglHeader.Fill.Color := UI_COLOR_HOVER;
end;

procedure TframeuModPluginItem.rctnglHeaderMouseLeave(Sender: TObject);
begin
  rctnglHeader.Fill.Color := UI_COLOR_DEFAULT;
end;

end.

