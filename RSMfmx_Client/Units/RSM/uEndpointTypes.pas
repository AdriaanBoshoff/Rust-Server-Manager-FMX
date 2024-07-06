unit uEndpointTypes;

interface

// v1 - Check License Response and Request

type // v1 Check License Request
  Tv1CheckLicenseReq = class
  public
    LicenseKey: string;
  end;

type  // v1 Check License Response
  Tv1CheckLicenseResp = class
  public
    Valid: boolean;
    Message: string;
  end;

implementation

end.

