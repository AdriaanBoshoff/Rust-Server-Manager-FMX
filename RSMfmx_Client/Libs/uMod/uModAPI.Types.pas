unit uModAPI.Types;

interface

type
  TuModRateLimit = record
    total: Integer;
    remaining: Integer;
  end;

type
  TuModSearchPlugin = record
    name: string;
    title: string;
    description: string;
    watcherCount: Integer;
    downloadCount: Integer;
    downloadsShortened: string;
    downloadURL: string;
    donateURL: string;
    iconURL: string;
    slug: string;
    authorName: string;
    authorIconURL: string;
    url: string;
    jsonURL: string;
    version: string;
    createdDTM: string;
    updatedDTM: string;
    tags: string;
  end;

type
  TuModSearchPluginResponse = record
    plugins: TArray<TuModSearchPlugin>;
    currentPage: Integer;
    lastPage: Integer;
    totalPlugins: Integer;
    ResponseCode: Integer;
    ResponseText: string;
    rateLimit: TuModRateLimit;
  end;

implementation

end.

