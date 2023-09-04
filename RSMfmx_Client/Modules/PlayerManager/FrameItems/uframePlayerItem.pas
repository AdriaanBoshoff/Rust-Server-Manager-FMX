unit uframePlayerItem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.Controls.Presentation, System.IOUtils,
  System.Threading, RCON.Types, ufrmPlayerManager;

type
  TframePlayerItem = class(TFrame)
    lytAvatar: TLayout;
    crclAvatar: TCircle;
    lytLine1: TLayout;
    lytLine2: TLayout;
    lblDisplayName: TLabel;
    lblSteamID: TLabel;
    rctnglBG: TRectangle;
    lblHealth: TLabel;
    lblPing: TLabel;
    lytHealth: TLayout;
    lytIPAddress: TLayout;
    lblIPHeader: TLabel;
    lblIPValue: TLabel;
    procedure rctnglBGClick(Sender: TObject);
    procedure rctnglBGMouseEnter(Sender: TObject);
    procedure rctnglBGMouseLeave(Sender: TObject);
  private
    { Private declarations }
    function GetAvatarIconFromXML(xml: string): string;
    function LoadAvatarFromCache(const steamID: string): boolean;
  public
    { Public declarations }
    playerData: TRCONPlayerListPlayer;
    procedure LoadSteamAvatar(const steamID: string);
  end;

implementation

uses
  Rest.Client, Rest.Types, Xml.XMLDoc, Xml.XMLIntf, ActiveX, uframePlayerOptions;

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

function TframePlayerItem.LoadAvatarFromCache(const steamID: string): boolean;
begin
  Result := False;

  // Cache file
  var avatarCacheFile := ExtractFilePath(ParamStr(0)) + 'rsm\cache\players\avatars\' + steamID + '.png';

  if TFile.Exists(avatarCacheFile) then
  begin
    crclAvatar.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
    crclAvatar.Fill.Bitmap.Bitmap.LoadFromFile(avatarCacheFile);

    Result := True;
  end
  else
  begin
    Result := False;
    ForceDirectories(ExtractFileDir(avatarCacheFile));
  end;
end;

procedure TframePlayerItem.LoadSteamAvatar(const steamID: string);
begin
  // Load from cache then exit code
  if LoadAvatarFromCache(steamID) then
    Exit;


  // Download Avatar if not cached
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
          // Cache file
          var avatarCacheFile := ExtractFilePath(ParamStr(0)) + 'rsm\cache\players\avatars\' + steamID + '.png';

          var memStream := TMemoryStream.Create;
          try
            CoInitialize(nil);
            var avatarURL := GetAvatarIconFromXML(rest.Response.Content);
            CoUninitialize;

            if not avatarURL.Trim.IsEmpty then
            begin
              TDownloadURL.DownloadRawBytes(avatarURL, memStream);

              // Save to cache
              ForceDirectories(ExtractFileDir(avatarCacheFile));
              memStream.SaveToFile(avatarCacheFile);

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

procedure TframePlayerItem.rctnglBGClick(Sender: TObject);
begin
  // Frame Options
  var playerOptionsFrame := TframePlayerOptions.Create(Self);
  playerOptionsFrame.Parent := frmPlayerManager.tbtmOnlinePlayers;
  playerOptionsFrame.Align := TAlignLayout.Contents;
  playerOptionsFrame.playerData := Self.playerData;
  playerOptionsFrame.crclAvatar.Fill := Self.crclAvatar.Fill;
  playerOptionsFrame.BringToFront;
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

