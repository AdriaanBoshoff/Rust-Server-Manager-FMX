unit uModAPI;

interface

uses
  Rest.Client, Rest.Types, System.JSON, uModAPI.Types, System.SysUtils;

type
  TuModAPI = class
  private
  { Private Const }
    const
      API_URL = 'https://umod.org';
      API_PATH_PluginSearch = 'plugins/search.json';
  private
  { Private Methods }
    function SetupRest(const APIPath: string = ''): TRESTRequest;
  public
  { Public Methods }
    function SearchPlugins(const SearchText: string; const Page: Integer): TuModSearchPluginResponse;
  end;

implementation

{ TuModAPI }

function TuModAPI.SearchPlugins(const SearchText: string; const Page: Integer): TuModSearchPluginResponse;
begin

  var rest := Self.SetupRest(API_PATH_PluginSearch);
  try
    rest.AddParameter('sort', 'downloads', TRESTRequestParameterKind.pkQUERY);
    rest.AddParameter('categories', 'universal,rust', TRESTRequestParameterKind.pkQUERY);
    rest.AddParameter('page', Page.ToString, TRESTRequestParameterKind.pkQUERY);

    if not SearchText.IsEmpty then
      rest.AddParameter('query', SearchText, TRESTRequestParameterKind.pkQUERY);

    rest.Execute;

    // Response Code & Text
    Result.ResponseCode := rest.Response.StatusCode;
    Result.ResponseText := rest.Response.StatusText;

    if rest.Response.StatusCode = 200 then
    begin
      // Rate Limit
      Result.rateLimit.total := rest.Response.Headers.Values['x-ratelimit-limit'].ToInteger;
      Result.rateLimit.remaining := rest.Response.Headers.Values['x-ratelimit-remaining'].ToInteger;

      // Response Info
      Result.currentPage := rest.Response.JSONValue.GetValue<integer>('current_page');
      Result.lastPage := rest.Response.JSONValue.GetValue<integer>('last_page');
      Result.totalPlugins := rest.Response.JSONValue.GetValue<integer>('total');

      SetLength(Result.plugins, (rest.Response.JSONValue.FindValue('data') as TJSONArray).Count);
      var pluginIndex := 0;
      for var jPlugin in rest.Response.JSONValue.FindValue('data') as TJSONArray do
      begin
        Result.plugins[pluginIndex].name := jPlugin.GetValue<string>('name');
        Result.plugins[pluginIndex].title := jPlugin.GetValue<string>('title');
        Result.plugins[pluginIndex].description := jPlugin.GetValue<string>('description');
        Result.plugins[pluginIndex].watcherCount := jPlugin.GetValue<integer>('watchers');
        Result.plugins[pluginIndex].downloadCount := jPlugin.GetValue<integer>('downloads');
        Result.plugins[pluginIndex].downloadsShortened := jPlugin.GetValue<string>('downloads_shortened');
        Result.plugins[pluginIndex].downloadURL := jPlugin.GetValue<string>('download_url');
        Result.plugins[pluginIndex].donateURL := jPlugin.GetValue<string>('donate_url');
        Result.plugins[pluginIndex].iconURL := jPlugin.GetValue<string>('icon_url');
        Result.plugins[pluginIndex].slug := jPlugin.GetValue<string>('slug');
        Result.plugins[pluginIndex].authorName := jPlugin.GetValue<string>('author');
        Result.plugins[pluginIndex].authorIconURL := jPlugin.GetValue<string>('author_icon_url');
        Result.plugins[pluginIndex].url := jPlugin.GetValue<string>('url');
        Result.plugins[pluginIndex].jsonURL := jPlugin.GetValue<string>('json_url');
        Result.plugins[pluginIndex].version := jPlugin.GetValue<string>('latest_release_version');
        Result.plugins[pluginIndex].createdDTM := jPlugin.GetValue<string>('published_at');
        Result.plugins[pluginIndex].updatedDTM := jPlugin.GetValue<string>('latest_release_at');

        Inc(pluginIndex);
      end;
    end;
  finally
    rest.Free;
  end;
end;

function TuModAPI.SetupRest(const APIPath: string): TRESTRequest;
begin
  // Create Rest Client
  Result := TRESTRequest.Create(nil);
  Result.Response := TRESTResponse.Create(Result);
  Result.Client := TRESTClient.Create(Result);

  // Options
  Result.Client.BaseURL := API_URL;
  Result.Resource := APIPath;
  Result.Client.RaiseExceptionOn500 := False;
end;

end.

