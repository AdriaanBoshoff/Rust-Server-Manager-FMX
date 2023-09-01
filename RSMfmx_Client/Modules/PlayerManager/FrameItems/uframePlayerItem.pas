unit uframePlayerItem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.Controls.Presentation, System.IOUtils,
  System.Threading;

type
  TframePlayerItem = class(TFrame)
    lytAvatar: TLayout;
    crclAvatar: TCircle;
    lytLine1: TLayout;
    lytLine2: TLayout;
    lblDisplayName: TLabel;
    lblSteamID: TLabel;
    rctnglBG: TRectangle;
    btnManage: TSpeedButton;
    lblHealth: TLabel;
    lblPing: TLabel;
    lytHealth: TLayout;
    lytPing: TLayout;
    lytIPAddress: TLayout;
    lblIPHeader: TLabel;
    lblIPValue: TLabel;
    lytVacBans: TLayout;
    lblVacBansHeader: TLabel;
    lblVacBansValue: TLabel;
    lytGameBans: TLayout;
    lblGameBansHeader: TLabel;
    lblGameBansValue: TLabel;
    procedure lblHealthResized(Sender: TObject);
    procedure lblPingResized(Sender: TObject);
    procedure rctnglBGMouseEnter(Sender: TObject);
    procedure rctnglBGMouseLeave(Sender: TObject);
  private
    { Private declarations }
    function GetAvatarIconFromXML(xml: string): string;
  public
    { Public declarations }
    procedure LoadSteamAvatar(const steamID: string);
  end;

implementation

uses
  Rest.Client, Rest.Types, Xml.XMLDoc, Xml.XMLIntf, ActiveX;

{$R *.fmx}

function TframePlayerItem.GetAvatarIconFromXML(xml: string): string;
var
  XMLDoc: IXMLDocument;
  Node: IXMLNode;
begin
  Result := '';

  XMLDoc := TXMLDocument.Create(nil);
  try
    XMLDoc.LoadFromXML(xml);

    Node := XMLDoc.DocumentElement.ChildNodes.FindNode('avatarMedium');
    if Assigned(Node) then
      Result := Node.Text;
  finally
    XMLDoc := nil;
  end;
end;

procedure TframePlayerItem.lblHealthResized(Sender: TObject);
begin
  lytHealth.Width := lblHealth.Width;
end;

procedure TframePlayerItem.lblPingResized(Sender: TObject);
begin
  lytPing.Width := lblPing.Width;
end;

procedure TframePlayerItem.LoadSteamAvatar(const steamID: string);
begin
  TTask.Run(
    procedure
    begin
      var rest := TRESTRequest.Create(Self);
      try
        rest.Client := TRESTClient.Create(rest);
        rest.Method := TRESTRequestMethod.rmGET;
        rest.Response := TRESTResponse.Create(rest);
        rest.Client.BaseURL := 'https://steamcommunity.com/profiles';
        rest.Resource := steamID;
        rest.Params.AddItem('xml', '1', TRESTRequestParameterKind.pkQUERY);
        rest.Execute;

        if (rest.Response.StatusCode = 200) and not rest.Response.Content.IsEmpty then
        begin
          var memStream := TMemoryStream.Create;
          try
            CoInitialize(nil);
            var avatarURL := GetAvatarIconFromXML(rest.Response.Content);
            CoUninitialize;

            if not avatarURL.Trim.IsEmpty then
            begin
              TDownloadURL.DownloadRawBytes(avatarURL, memStream);

              TThread.Synchronize(TThread.Current,
                procedure
                begin
                  try
                    crclAvatar.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
                    crclAvatar.Fill.Bitmap.Bitmap.LoadFromStream(memStream);
                  except
                    on E: Exception do
                    begin
                      Exit;
                    end;
                  end;
                end);
            end;
          finally
            memStream.Free;
          end;
        end;
      finally
        rest.Free;
      end;
    end);
end;

procedure TframePlayerItem.rctnglBGMouseEnter(Sender: TObject);
begin
  rctnglBG.Fill.Color := $FF79303C;
end;

procedure TframePlayerItem.rctnglBGMouseLeave(Sender: TObject);
begin
  rctnglBG.Fill.Color := $FF1F222A;
end;

end.

