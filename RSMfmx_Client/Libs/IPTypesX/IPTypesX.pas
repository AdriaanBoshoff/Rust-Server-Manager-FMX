{ *************************************************************************** }
{                                                                             }
{ IPTypes  -  www.nldelphi.com Open Source Delphi runtime library             }
{                                                                             }
{ Initiator: Albert de Weerd (aka NGLN)                                       }
{ License: Free to use, free to modify                                        }
{ Website: None                                                               }
{ SVN path: http://svn.nldelphi.com/nldelphi/opensource/ngln/                 }
{                                                                             }
{ *************************************************************************** }
{                                                                             }
{ Last edit by: Albert de Weerd                                               }
{ Date: August 27, 2010                                                       }
{ Version: 1.2                                                                }
{                                                                             }
{ Modified by Vitaly Yakovlev                                                 }
{ Website: http://optinsoft.net/                                              }
{ Date: October 22, 2019                                                      }
{                                                                             }
{ *************************************************************************** }

unit IPTypesX;

interface

uses
  Classes, SysUtils, StrUtils, Windows, Math;

const
  IPv4BitSize = SizeOf(Byte) * 4 * 8;
  IPv6BitSize = SizeOf(Word) * 8 * 8;
  DefPortNumber = 80;
  DefProtocol = 'http';

type
  T4 = 0..3;
  T8 = 0..7;
  TIPv4ByteArray = array[T4] of Byte;
  TIPv6WordArray = array[T8] of Word;
  TIPv6CardinalArray = array[T4] of Cardinal;

  TIPv4 = packed record
    case Integer of
      0: (D, C, B, A: Byte);
      1: (Groups: TIPv4ByteArray);
      2: (Value: Cardinal);
  end;

  TIPv6 = packed record
    case Integer of
      0: (H, G, F, E, D, C, B, A: Word);
      1: (Groups: TIPv6WordArray);
      2: (Values: TIPv6CardinalArray);
  end;

  TCharCase = (ccUpperCase, ccLowerCase);

  EIPv4Error = class(Exception);
  EIPv6Error = class(Exception);

function IsValidIPv4(const S: String): Boolean; //Vitaly 22.10.2019
function StrToIPv4(const S: String): TIPv4;
function TryStrToIPv4(const S: String; ARaiseErrors: Boolean; out AValidIP: Boolean): TIPv4; //Vitaly 22.10.2019

function IPv4Compare(const AIPv41, AIPv42: TIPv4): Integer;
procedure IPv4ToBits(const AIPv4: TIPv4; ABits: TBits);
function IPv4ToIPv6(const AIPv4: TIPv4): TIPv6;
function IPv4ToStr(const AIPv4: TIPv4): String;
function IPv4ToStrHex(const AIPv4: TIPv4): String;
function IPv4ToStrOutwr(const AIPv4: TIPv4): String;
function IPv4ToURL(const AIPv4: TIPv4; const Protocol: String = DefProtocol;
  const PortNumber: Word = DefPortNumber): String;

function IsValidIPv6(const S: String): Boolean; //Vitaly 22.10.2019
function StrToIPv6(const S: String): TIPv6;
function TryStrToIPv6(const S: String; ARaiseErrors: Boolean; out AValidIP: Boolean): TIPv6; //Vitaly 22.10.2019

function IPv6Compare(const AIPv61, AIPv62: TIPv6): Integer;
procedure IPv6ToBits(const AIPv6: TIPv6; ABits: TBits);
function IPv6ToIPv4(const AIPv6: TIPv6): TIPv4;
function IPv6ToStr(const AIPv6: TIPv6): String;
function IPv6ToStrCompr(const AIPv6: TIPv6): String;
function IPv6ToStrOutwr(const AIPv6: TIPv6): String;
function IPv6ToURL(const AIPv6: TIPv6; const Protocol: String = DefProtocol;
  const PortNumber: Word = DefPortNumber): String;

function IPv6AddOp(const Left, Right: TIPv6): TIPv6;
function IPv6AndOp(const Left, Right: TIPv6): TIPv6;
function IPv6OrOp(const Left, Right: TIPv6): TIPv6;
function IPv6SubtractOp(const Left, Right: TIPv6): TIPv6;
function IPv6XorOp(const Left, Right: TIPv6): TIPv6;

const
  ZeroIPv4: TIPv4 = (D: 0; C: 0; B: 0; A: 0);
  ZeroIPv6: TIPv6 = (H: 0; G: 0; F: 0; E: 0; D: 0; C: 0; B: 0; A: 0);

var
  IPCharCase: TCharCase = ccUpperCase;

implementation

const
  SInvalidIPv4Value = '''%s'' is not a valid IPv4 address';
  SInvalidIPv4FormatType = 'Invalid format type for IPv4';
  SInvalidIPv6Value = '''%s'' is not a valid IPv6 address';
  SInvalidIPv6FormatType = 'Invalid format type for IPv6';

procedure IPv4Error(const Message: String);
begin
  raise EIPv4Error.Create(Message);
end;

procedure IPv4ErrorFmt(const Message, IPv4AsString: String);
begin
  raise EIPv4Error.Create(Format(Message, [IPv4AsString]));
end;

procedure IPv6Error(const Message: String);
begin
  raise EIPv6Error.Create(Message);
end;

procedure IPv6ErrorFmt(const Message, IPv6AsString: String);
begin
  raise EIPv6Error.Create(Format(Message, [IPv6AsString]));
end;

{ Utility routines }

procedure CheckCase(var S: String);
begin
  if IPCharCase = ccLowerCase then
    S := LowerCase(S);
end;

function IsValidIPv4(const S: String): Boolean; //Vitaly 22.10.2019
begin
  TryStrToIPv4(S, False, Result);
end;

function StrToIPv4(const S: String): TIPv4;
  //Vitaly 22.10.2019
var
  LValidIP: Boolean;
begin
  Result := TryStrToIPv4(S, True, LValidIP);
end;

function TryStrToIPv4(const S: String; ARaiseErrors: Boolean; out AValidIP: Boolean): TIPv4; //Vitaly 22.10.2019
var
  SIP: String;
  Start: Integer;
  I: T4;
  Index: Integer;
  Count: Integer;
  SGroup: String;
  G: Integer;
begin
  AValidIP := True;
  SIP := S + '.';
  Start := 1;
  for I := High(T4) downto Low(T4) do
  begin
    Index := PosEx('.', SIP, Start);
    if Index = 0 then
    begin
      AValidIP := False;
      if ARaiseErrors then
        IPv4ErrorFmt(SInvalidIPv4Value, S);
      Exit;
    end;
    Count := Index - Start + 1;
    SGroup := Copy(SIP, Start, Count - 1);
    if TryStrToInt(SGroup, G) and (G >= Low(Word)) and (G <= High(Word)) then
        Result.Groups[I] := G
      else
        Result.Groups[I] := 0;
    Inc(Start, Count);
  end;
end;

function IPv4Compare(const AIPv41, AIPv42: TIPv4): Integer;
begin
  if AIPv41.Value = AIPv42.Value then
    Result := 0
  else if AIPv41.Value < AIPv42.Value then
    Result := -1
  else
    Result := 1;
end;

procedure IPv4ToBits(const AIPv4: TIPv4; ABits: TBits);
var
  I: Integer;
begin
  if ABits <> nil then
  begin
    ABits.Size := IPv4BitSize;
    for I := 0 to IPv4BitSize - 1 do
      ABits[IPv4BitSize - I - 1] := AIPv4.Value and (1 shl I) <> 0;
  end;
end;

function IPv4ToIPv6(const AIPv4: TIPv4): TIPv6;
begin
  FillChar(Result.E, 5 * SizeOf(Word), 0);
  Result.F := $FFFF;
  Result.G := AIPv4.A shl 8 + AIPv4.B;
  Result.H := AIPv4.C shl 8 + AIPv4.D;
end;

function IPv4ToStr(const AIPv4: TIPv4): String;
begin
  with AIPv4 do
    Result := Format('%d.%d.%d.%d', [A, B, C, D]);
end;

function IPv4ToStrHex(const AIPv4: TIPv4): String;
begin
  with AIPv4 do
    Result := Format('%.2x.%.2x.%.2x.%.2x', [A, B, C, D]);
  CheckCase(Result);
end;

function IPv4ToStrOutwr(const AIPv4: TIPv4): String;
begin
  with AIPv4 do
    Result := Format('%.3d.%.3d.%.3d.%.3d', [A, B, C, D]);
end;

function IPv4ToURL(const AIPv4: TIPv4; const Protocol: String = DefProtocol;
  const PortNumber: Word = DefPortNumber): String;
begin
  Result := IPv4ToStr(AIPv4);
  if (PortNumber <> DefPortNumber) or (Protocol <> DefProtocol) then
    Result := Protocol + '://' + Result + ':' + IntToStr(PortNumber) + '/'
  else
    Result := Protocol + '://' + Result + '/';
end;

function IsValidIPv6(const S: String): Boolean; //Vitaly 22.10.2019
begin
  TryStrToIPv6(S, False, Result);
end;

function StrToIPv6(const S: String): TIPv6;
  //Vitaly 22.10.2019
var
  LValidIP: Boolean;
begin
  Result := TryStrToIPv6(S, True, LValidIP);
end;

function TryStrToIPv6(const S: String; ARaiseErrors: Boolean; out AValidIP: Boolean): TIPv6; //Vitaly 22.10.2019
{ Valid examples for S:
  2001:0db8:85a3:0000:0000:8a2e:0370:7334
  2001:db8:85a3:0:0:8a2e:370:7334
  2001:db8:85a3::8a2e:370:7334
  ::8a2e:370:7334
  2001:db8:85a3::
  ::1
  ::
  ::ffff:c000:280
  ::ffff:192.0.2.128 }
var
  ZeroPos: Integer;
  DotPos: Integer;
  SIP: String;
  Start: Integer;
  Index: Integer;
  Count: Integer;
  SGroup: String;
  G: Integer;

  procedure NormalNotation;
  var
    I: T8;
  begin
    SIP := S + ':';
    Start := 1;
    for I := High(T8) downto Low(T8) do
    begin
      Index := PosEx(':', SIP, Start);
      if Index = 0 then
      begin
        AValidIP := False;
        if ARaiseErrors then
          IPv6ErrorFmt(SInvalidIPv6Value, S);
        Exit;
      end;
      Count := Index - Start + 1;
      SGroup := '$' + Copy(SIP, Start, Count - 1);
      if not TryStrToInt(SGroup, G) or (G > High(Word)) or (G < 0) then
      begin
        AValidIP := False;
        if ARaiseErrors then
          IPv6ErrorFmt(SInvalidIPv6Value, S);
        Exit;
      end;
      Result.Groups[I] := G;
      Inc(Start, Count);
    end;
  end;

  procedure CompressedNotation;
  var
    I: T8;
    A: array of Word;
  begin
    SIP := S + ':';
    Start := 1;
    I := High(T8);
    while Start < ZeroPos do
    begin
      Index := PosEx(':', SIP, Start);
      if Index = 0 then
      begin
        AValidIP := False;
        if ARaiseErrors then
          IPv6ErrorFmt(SInvalidIPv6Value, S);
        Exit;
      end;
      Count := Index - Start + 1;
      SGroup := '$' + Copy(SIP, Start, Count - 1);
      if not TryStrToInt(SGroup, G) or (G > High(Word)) or (G < 0) then
      begin
        AValidIP := False;
        if ARaiseErrors then
          IPv6ErrorFmt(SInvalidIPv6Value, S);
        Exit;
      end;
      Result.Groups[I] := G;
      Inc(Start, Count);
      Dec(I);
    end;
    FillChar(Result.H, (I + 1) * SizeOf(Word), 0);
    if ZeroPos < (Length(S) - 1) then
    begin
      SetLength(A, I + 1);
      Start := ZeroPos + 2;
      repeat
        Index := PosEx(':', SIP, Start);
        if Index > 0 then
        begin
          Count := Index - Start + 1;
          SGroup := '$' + Copy(SIP, Start, Count - 1);
          if not TryStrToInt(SGroup, G) or (G > High(Word)) or (G < 0) then
          begin
            AValidIP := False;
            if ARaiseErrors then
              IPv6ErrorFmt(SInvalidIPv6Value, S);
            Exit;
          end;
          A[I] := G;
          Inc(Start, Count);
          Dec(I);
        end;
      until Index = 0;
      Inc(I);
      Count := Length(A) - I;
      Move(A[I], Result.H, Count * SizeOf(Word));
    end;
  end;

  procedure DottedQuadNotation;
  var
    I: T4;
  begin
    if UpperCase(Copy(S, ZeroPos + 2, 4)) <> 'FFFF' then
    begin
      AValidIP := False;
      if ARaiseErrors then
        IPv6ErrorFmt(SInvalidIPv6Value, S);
      Exit;
    end;
    FillChar(Result.E, 5 * SizeOf(Word), 0);
    Result.F := $FFFF;
    SIP := S + '.';
    Start := ZeroPos + 7;
    for I := Low(T4) to High(T4) do
    begin
      Index := PosEx('.', SIP, Start);
      if Index = 0 then
      begin
        AValidIP := False;
        if ARaiseErrors then
          IPv6ErrorFmt(SInvalidIPv6Value, S);
        Exit;
      end;
      Count := Index - Start + 1;
      SGroup := Copy(SIP, Start, Count - 1);
      if not TryStrToInt(SGroup, G) or (G > High(Byte)) or (G < 0) then
      begin
        AValidIP := False;
        if ARaiseErrors then
          IPv6ErrorFmt(SInvalidIPv6Value, S);
        Exit;
      end;
      case I of
        0: Result.G := G shl 8;
        1: Inc(Result.G, G);
        2: Result.H := G shl 8;
        3: Inc(Result.H, G);
      end;
      Inc(Start, Count);
    end;
  end;

begin
  AValidIP := True;
  ZeroPos := Pos('::', S);
  if ZeroPos = 0 then
    NormalNotation
  else
  begin
    DotPos := Pos('.', S);
    if DotPos = 0 then
      CompressedNotation
    else
      DottedQuadNotation;
  end;
end;

function IPv6Compare(const AIPv61, AIPv62: TIPv6): Integer;
var
  I: T8;
begin
  Result := 0;
  for I := High(T8) downto Low(T8) do
    if AIPv61.Groups[I] <> AIPv62.Groups[I] then
    begin
      if AIPv61.Groups[I] < AIPv62.Groups[I] then
        Result := -1
      else
        Result := 1;
      Break;
    end;
end;

procedure IPv6ToBits(const AIPv6: TIPv6; ABits: TBits);
var
  I: Integer;
  GroupBitSize: Integer;
begin
  if ABits <> nil then
  begin
    ABits.Size := IPv6BitSize;
    GroupBitSize := IPv6BitSize div Length(AIPv6.Groups);
    for I := 0 to IPv6BitSize - 1 do
      ABits[IPv6BitSize - I - 1] :=
        AIPv6.Groups[I div GroupBitSize] and (1 shl (I mod GroupBitSize)) <> 0;
  end;
end;

function IPv6ToIPv4(const AIPv6: TIPv6): TIPv4;
begin
  with AIPv6 do
    if (A > 0) or (B > 0) or (C > 0) or (D > 0) or (E > 0) or (F < $FFFF) then
      IPv6Error(SInvalidIPv6FormatType);
  Move(AIPv6.G, Result, 2 * SizeOf(Word));
end;

function IPv6ToStr(const AIPv6: TIPv6): String;
begin
  with AIPv6 do
    Result := Format('%x:%x:%x:%x:%x:%x:%x:%x', [A, B, C, D, E, F, G, H]);
  CheckCase(Result);
end;

function IPv6ToStrCompr(const AIPv6: TIPv6): String;
var
  Zeroed: Boolean;
  I: T8;
begin
  Result := '';
  Zeroed := False;
  for I := High(T8) downto Low(T8) do
  begin
    if AIPv6.Groups[I] = 0 then
    begin
      if (I = Low(T8)) then
        Result := Result + ':';
      if not Zeroed then
      begin
        Result := Result + ':';
        Zeroed := True;
      end;
    end
    else
      if (I = High(T8)) and not Zeroed then
        Result := Result + Format('%x', [AIPv6.Groups[I]])
      else
        Result := Result + Format(':%x', [AIPv6.Groups[I]]);
  end;
  CheckCase(Result);
end;

function IPv6ToStrOutwr(const AIPv6: TIPv6): String;
begin
  with AIPv6 do
    Result := Format('%.4x:%.4x:%.4x:%.4x:%.4x:%.4x:%.4x:%.4x', [A, B, C, D,
      E, F, G, H]);
  CheckCase(Result);
end;

function IPv6ToURL(const AIPv6: TIPv6; const Protocol: String = DefProtocol;
  const PortNumber: Word = DefPortNumber): String;
begin
  Result := IPv6ToStr(AIPv6);
  CheckCase(Result);
  if (PortNumber <> DefPortNumber) or (Protocol <> DefProtocol) then
    Result := Protocol + '://[' + Result + ']:' + IntToStr(PortNumber) + '/'
  else
    Result := Protocol + '://[' + Result + ']/';
end;

function IPv6AddOp(const Left, Right: TIPv6): TIPv6;
var
  I: T8;
  Sum: Integer;
  Remain: Word;
begin
  Remain :=  0;
  for I := Low(T8) to High(T8) do
  begin
    Sum := Remain + Left.Groups[I] + Right.Groups[I];
    Result.Groups[I] := Sum mod (High(Word) + 1);
    Remain := Sum div (High(Word) + 1);
  end;
end;

function IPv6AndOp(const Left, Right: TIPv6): TIPv6;
var
  I: T8;
begin
  for I := Low(T8) to High(T8) do
    Result.Groups[I] := Left.Groups[I] and Right.Groups[I];
end;

function IPv6OrOp(const Left, Right: TIPv6): TIPv6;
var
  I: T8;
begin
  for I := Low(T8) to High(T8) do
    Result.Groups[I] := Left.Groups[I] or Right.Groups[I];
end;

function IPv6SubtractOp(const Left, Right: TIPv6): TIPv6;
var
  I: T8;
  Sum: Integer;
  Lost: Word;
begin
  Lost := 0;
  for I := Low(T8) to High(T8) do
  begin
    Sum := Left.Groups[I] - Right.Groups[I] - Lost;
    if Sum < 0 then
    begin
      Inc(Sum, High(Word) + 1);
      Lost := 1;
    end
    else
      Lost := 0;
    Result.Groups[I] := Sum;
  end;
  if Lost > 0 then
    Result := ZeroIPv6;
end;

function IPv6XorOp(const Left, Right: TIPv6): TIPv6;
var
  I: T8;
begin
  for I := Low(T8) to High(T8) do
    Result.Groups[I] := Left.Groups[I] xor Right.Groups[I];
end;

end.
