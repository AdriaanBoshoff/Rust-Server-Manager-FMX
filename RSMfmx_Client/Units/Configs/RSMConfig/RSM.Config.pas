unit RSM.Config;

interface

type
  TRSMConfig = class
  private
  { Private Types }
    type
      TRSMConfigAPI = record
        Enabled: boolean;
      end;
  public
    { Public Variables }
    API: TRSMConfigAPI;
  public
    { Public Methods }
  end;

var
  rsmConfig: TRSMConfig;

implementation

uses
  XSuperObject, System.SysUtils, System.IOUtils;

end.

