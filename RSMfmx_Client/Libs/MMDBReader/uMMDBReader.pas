{ **************************************************************************** }
{                                                                              }
{ uMMDBReader - Delphi reader for the MaxMind DB file format                   }
{                                                                              }
{ Created by Vitaly Yakovlev                                                   }
{ Date: October 22, 2019                                                       }
{ Copyright: (c) 2019 Vitaly Yakovlev                                          }
{ Website: http://optinsoft.net/                                               }
{                                                                              }
{ License: BSD 2-Clause License.                                               }
{                                                                              }
{ Redistribution and use in source and binary forms, with or without           }
{ modification, are permitted provided that the following conditions are met:  }
{                                                                              }
{ 1. Redistributions of source code must retain the above copyright notice,    }
{    this list of conditions and the following disclaimer.                     }
{                                                                              }
{ 2. Redistributions in binary form must reproduce the above copyright notice, }
{    this list of conditions and the following disclaimer in the documentation }
{    and/or other materials provided with the distribution.                    }
{                                                                              }
{ THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"  }
{ AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,        }
{ THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR       }
{ PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR            }
{ CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,        }
{ EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,          }
{ PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;  }
{ OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,     }
{ WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR      }
{ OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF       }
{ ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                                   }
{                                                                              }
{ Last edit by: Vitaly Yakovlev                                                }
{ Date: March 07, 2024                                                         }
{ Version: 1.3                                                                 }
{                                                                              }
{ Changelog:                                                                   }
{                                                                              }
{ v1.3:                                                                        }
{ - added debug exceptions:                                                    }
{     EMMDBException,                                                          }
{     EMMDBNotFoundException                                                   }
{ - TMMDBReader.Find: T raises EMMDBNotFoundException when ipAddress not found }
{                                                                              }
{ v1.2:                                                                        }
{ - added debug macros: DEBUG_OUT, DEBUG_OUT_FILE, DEBUG_OUT_FILTER            }
{ - changed implementation of function TMMDBDecoder.Decode:                    }
{   call "Create" for classes; that allows to make arrays and dictionaries of  }
{   objects.                                                                   }
{                                                                              }
{ v1.1:                                                                        }
{ - added debug parameter: const keyPath: String                               }
{                                                                              }
{ v1.0:                                                                        }
{ - Initial release                                                            }
{                                                                              }
{ **************************************************************************** }

unit uMMDBReader;

interface

uses
  System.SysUtils, System.Classes, Velthuis.BigIntegers,
  System.TypInfo, System.Generics.Collections, System.Rtti, System.DateUtils,
  System.Contnrs, uMMDBIPAddress, System.SyncObjs, System.RegularExpressions;

{$IFDEF DEBUG}
{$DEFINE DEBUG_OUT}
{$DEFINE DEBUG_OUT_FILE}
{$DEFINE DEBUG_OUT_FILTER}
{$ENDIF}

{$IFDEF DEBUG_OUT_FILE}
const DebugOutFile = 'mmdbread.log';
{$ENDIF}

{$IFDEF DEBUG_OUT_FILTER}
const DebugOutFilter = 'WARNING';
{$ENDIF}

type
  TMMDBBuffer = class
  private
    _Length: Integer;
  public
    property Length: Integer read _Length;
  protected
    constructor Create(length: Integer);
  public
    function Read(offset: Int64; count: Integer): TBytes; virtual; abstract;
    function ReadString(offset: Int64; count: Integer): String; virtual; abstract;
    function ReadOne(offset: Int64): Byte; virtual; abstract;
    procedure Copy(offset: Int64; arr: TBytes); virtual; abstract;
    function ReadBigInteger(offset: Int64; size: Integer): BigInteger;
    function ReadDouble(offset: Int64): Double;
    function ReadFloat(offset: Int64): Single;
    function ReadInteger(val: Integer; offset: Int64; size: Integer): Integer;
    function ReadLong(offset: Int64; size: Integer): Int64;
    function ReadULong(offset: Int64; size: Integer): UInt64;
  end;

  TMMDBDecoder = class
  private
    _pointerBase: Int64;
    _database: TMMDBBuffer;
    _followPointers: Boolean;
  public
    type ObjectType =
    (
      otExtended,
      otPointer,
      otUtf8String,
      otDouble,
      otBytes,
      otUint16,
      otUint32,
      otMap,
      otInt32,
      otUint64,
      otUint128,
      otArray,
      otContainer,
      otEndMarker,
      otBoolean,
      otFloat
    );
    constructor Create(ownerObjects: TObjectList; database: TMMDBBuffer; pointerBase: Int64; followPointers: Boolean = True);
    function Decode<T>(offset: Int64; out outOffset: Int64): T; overload;
    procedure Decode<T>(offset: Int64; out outOffset: Int64; var tResult: T); overload;
  private
    function Decode(expectedType: PTypeInfo; offset: Int64; out outOffset: Int64{$IFDEF DEBUG_OUT}; const keyPath: String{$ENDIF}): TValue; overload;
    procedure Decode(expectedType: PTypeInfo; offset: Int64; out outOffset: Int64; var valResult: TValue{$IFDEF DEBUG_OUT}; const keyPath: String{$ENDIF}); overload;
    function CtrlData(offset: Int64; out size: Integer; out outOffset: Int64): ObjectType;
    function DecodeByType(expectedType: PTypeInfo; _type: ObjectType; offset: Int64; size: Integer; out outOffset: Int64{$IFDEF DEBUG_OUT}; const keyPath: String{$ENDIF}): TValue; overload;
    procedure DecodeByType(expectedType: PTypeInfo; _type: ObjectType; offset: Int64; size: Integer; out outOffset: Int64; var valResult: TValue{$IFDEF DEBUG_OUT}; const keyPath: String{$ENDIF}); overload;
    function DecodeBoolean(expectedType: PTypeInfo; size: Integer): Boolean;
    function DecodeDouble(expectedType: PTypeInfo; offset: Int64; size: Integer): Double;
    function DecodeFloat(expectedType: PTypeInfo; offset: Int64; size: Integer): Single;
    function DecodeString(expectedType: PTypeInfo; offset: Int64; size: Integer): String;
    function DecodeBytes(expectedType: PTypeInfo; offset: Int64; size: Integer): TBytes;
    function DecodeMap(expectedType: PTypeInfo; offset: Int64; size: Integer; out outOffset: Int64{$IFDEF DEBUG_OUT}; const keyPath: String{$ENDIF}): TObject; overload;
    procedure DecodeMap(expectedType: PTypeInfo; offset: Int64; size: Integer; out outOffset: Int64; objResult: TObject{$IFDEF DEBUG_OUT}; const keyPath: String{$ENDIF}); overload;
    function DecodeMapToDictionary(expectedType: PTypeInfo; offset: Int64; size: Integer; out outOffset: Int64{$IFDEF DEBUG_OUT}; const keyPath: String{$ENDIF}): TObject; overload;
    procedure DecodeMapToDictionary(expectedType: PTypeInfo; offset: Int64; size: Integer; out outOffset: Int64; objResult: TObject{$IFDEF DEBUG_OUT}; const keyPath: String{$ENDIF}); overload;
    function DecodeMapToType(expectedType: PTypeInfo; offset: Int64; size: Integer; out outOffset: Int64{$IFDEF DEBUG_OUT}; const keyPath: String{$ENDIF}): TObject; overload;
    procedure DecodeMapToType(expectedType: PTypeInfo; offset: Int64; size: Integer; out outOffset: Int64; objResult: TObject{$IFDEF DEBUG_OUT}; const keyPath: String{$ENDIF}); overload;
    function DecodeKey(offset: Int64; out outOffset: Int64): TBytes;
    function DecodeLong(expectedType: PTypeInfo; offset: Int64; size: Integer): Int64;
    function DecodeArray(expectedType: PTypeInfo; size: Integer; offset: Int64; out outOffset: Int64{$IFDEF DEBUG_OUT}; const keyPath: String{$ENDIF}): TObject; overload;
    procedure DecodeArray(expectedType: PTypeInfo; size: Integer; offset: Int64; out outOffset: Int64; objResult: TObject{$IFDEF DEBUG_OUT}; const keyPath: String{$ENDIF}); overload;
    function DecodeUInt64(expectedType: PTypeInfo; offset: Int64; size: Integer): UInt64;
    function DecodeBigInteger(expectedType: PTypeInfo; offset: Int64; size: Integer): BigInteger;
    function DecodePointer(offset: Int64; size: Integer; out outOffset: Int64): Int64;
    function DecodeInteger(expectedType: PTypeInfo; offset: Int64; size: Integer): Integer;
    procedure CheckType(expected, from: PTypeInfo);
    function IsDictType(expected: PTypeInfo): Boolean;
    function GetInstanceTypeMethod(instance: TRttiInstanceType; const methodName: String;
      out method: TRttiMethod; paramCount: Integer = -1): Boolean;
    function NextValueOffset(offset: Int64; numberToSkip: Integer): Int64;
{$IFDEF DEBUG_OUT}
    procedure DebugOutput(const S: String);
  private
    class var FDebugOutCS: TCriticalSection;
    class var FDebugFileStream: TFileStream;
{$IFDEF DEBUG_OUT_FILTER}
    class var FDebugFilterRegEx: TRegEx;
{$ENDIF}
    class constructor Create;
    class destructor Destroy;
{$ENDIF}
  private
    FContext: TRttiContext;
    FOwnerObjects: TObjectList;
  end;

  TMMDBAttribute = class(TCustomAttribute)
  private
    FName: String;
  public
    constructor Create(const AName: String);
    property Name: String read FName write FName;
  end;

  TMMDBMetadata = class
  private
    _BinaryFormatMajorVersion: Integer;
    _BinaryFormatMinorVersion: Integer;
    _BuildEpoch: UInt64;
    _DatabaseType: String;
    _Description: TDictionary<string, string>;
    _IPVersion: Integer;
    _Languages: TList<string>;
    _NodeCount: Int64;
    _RecordSize: Integer;
    function GetBuildDate: TDateTime; inline;
    function GetNodeByteSize: Int64; inline;
    function GetSearchTreeSize: Int64; inline;
  public
    constructor Create;
    destructor Destroy; override;
    //
    [TMMDBAttribute('binary_format_major_version')]
    property BinaryFormatMajorVersion: Integer read _BinaryFormatMajorVersion write _BinaryFormatMajorVersion;
    [TMMDBAttribute('binary_format_minor_version')]
    property BinaryFormatMinorVersion: Integer read _BinaryFormatMinorVersion write _BinaryFormatMinorVersion;
    [TMMDBAttribute('build_epoch')]
    property BuildEpoch: Uint64 read _BuildEpoch write _BuildEpoch;
    [TMMDBAttribute('database_type')]
    property DatabaseType: String read _DatabaseType write _DatabaseType;
    [TMMDBAttribute('description')]
    property Description: TDictionary<string, string> read _Description;
    [TMMDBAttribute('ip_version')]
    property IPVersion: Integer read _IPVersion write _IPVersion;
    [TMMDBAttribute('languages')]
    property Languages: TList<string> read _Languages;
    [TMMDBAttribute('node_count')]
    property NodeCount: Int64 read _NodeCount write _NodeCount;
    [TMMDBAttribute('record_size')]
    property RecordSize: Integer read _RecordSize write _RecordSize;
    //
    property BuildDate: TDateTime read GetBuildDate;
    property NodeByteSize: Int64 read GetNodeByteSize;
    property SearchTreeSize: Int64 read GetSearchTreeSize;
  end;

  TMMDBReader = class; //forward declaration

  TMMDBNetNode = class
  private
    _IPBytes: TBytes;
    _Bit: Integer;
    _Pointer: Integer;
  public
    constructor Create(byteCount: Integer; Pointer: Integer = 0); overload;
    constructor Create(IPBytes: TBytes; Bit, Pointer: Integer); overload;
    destructor Destroy; override;
    property IPBytes: TBytes read _IPBytes;
    property Bit: Integer read _Bit write _Bit;
    property Pointer: Integer read _Pointer write _Pointer;
  end;

  TMMDBIteratorNode<T> = class; //forward declaration

  IMMDBIterator<T> = interface(IInterface)
    function GetNode: TMMDBIteratorNode<T>;
    property Node: TMMDBIteratorNode<T> read GetNode;
  end;

  TMMDBIteratorNode<T> = class(TInterfacedObject, IMMDBIterator<T>)
  private
    _Start: TMMDBIPAddress;
    _Prefix: Integer;
    _Data: T;
  public
    constructor Create(data: T); overload;
    destructor Destroy; override;
    function GetNode: TMMDBIteratorNode<T>;
    property Start: TMMDBIPAddress read _Start;
    property Prefix: Integer read _Prefix;
    property Data: T read _Data;
  end;

  TMMDBEnumerator<T> = class(TInterfacedObject, IEnumerator<IMMDBIterator<T>>)
  private
    _reader: TMMDBReader;
    byteCount: Integer;
    nodes: TList<TMMDBNetNode>;
    node: TMMDBNetNode;
    _iterator: IMMDBIterator<T>;
    _dataCache: TDictionary<Integer, T>;
    function GetCurrentGeneric(): IMMDBIterator<T>;
  public
    constructor Create(reader: TMMDBReader; IPv4Only: Boolean;
      iterator: IMMDBIterator<T>; cacheSize: Integer);
    destructor Destroy; override;
    function getCurrent: TObject;
    function IEnumerator<IMMDBIterator<T>>.GetCurrent = GetCurrentGeneric;
    function MoveNext : boolean;
    procedure Reset;
  end;

  TMMDBEnumerable<T> = class(TInterfacedObject, IEnumerable<IMMDBIterator<T>>)
  private
    _reader: TMMDBReader;
    _IPv4Only: Boolean;
    _iterator: IMMDBIterator<T>;
    _cacheSize: Integer;
    function GetEnumeratorGeneric: IEnumerator<IMMDBIterator<T>>;
  public
    constructor Create(reader: TMMDBReader; IPv4Only: Boolean;
      iterator: IMMDBIterator<T>; cacheSize: Integer);
    destructor Destroy; override;
    function GetEnumerator: IEnumerator;
    function IEnumerable<IMMDBIterator<T>>.GetEnumerator = GetEnumeratorGeneric;
  end;

  TMMDBReader = class
  protected const
    DataSectionSeparatorSize: Integer = 16;
  protected
    _database: TMMDBBuffer;
    _fileName: String;
    _IPv4Start: Integer;
  protected
    function IPv4Start: Integer;
    function StartNode(bitLength: Integer): Integer;
    function FindMetadataStart: Integer;
    function ReadNode(nodeNumber, index: Integer): Integer;
    function ResolveDataPointer<T>(pointer: Integer): T; overload;
    procedure ResolveDataPointer<T>(pointer: Integer; var tResult: T); overload;
    function FindAddressInTree(const address: TMMDBIPAddress; out prefixLength: Integer): Integer;
  public
    constructor Create(const Filename: String);
    destructor Destroy; override;
    function Find<T>(const ipAddress: TMMDBIPAddress; out prefixLength: Integer): T; overload;
    function Find<T>(const ipAddress: TMMDBIPAddress; out prefixLength: Integer; var tResult: T): Boolean; overload;
    function FindAll<T>(IPv4Only: Boolean = False; cacheSize: Integer = 16384): IEnumerable<IMMDBIterator<T>>; overload;
    function FindAll<T>(data: T; IPv4Only: Boolean = False; cacheSize: Integer = 16384): IEnumerable<IMMDBIterator<T>>; overload;
  protected
    FMetadata: TMMDBMetadata;
    FDecoder: TMMDBDecoder;
  public
    property Metadata: TMMDBMetadata read FMetadata;
    property Decoder: TMMDBDecoder read FDecoder;
  private
    FMetaOwnerObjects: TObjectList;
    FFindOwnerObjects: TObjectList;
  end;

  EMMDBException = class(Exception);
  EMMDBNotFoundException = class(EMMDBException);

implementation

uses System.Math, Winapi.Windows, System.StrUtils;

type
  TMMDBArrayBuffer = class(TMMDBBuffer)
  private
    _fileBytes: TBytes;
  public
    constructor Create(const filename: String); overload;
    constructor Create(stream: TStream); overload;
    function Read(offset: Int64; count: Integer): TBytes; override;
    function ReadString(offset: Int64; count: Integer): String; override;
    function ReadOne(offset: Int64): Byte; override;
    procedure Copy(offset: Int64; arr: TBytes); override;
  end;

{ TMMDBBuffer }

constructor TMMDBBuffer.Create(length: Integer);
begin
  _Length := length;
end;

procedure ReverseBytes(Bytes: TBytes);
var
  L, R: Integer;
  tmp: Byte;
begin
  L := 0;
  R := System.Length(Bytes)-1;
  while L < R do
  begin
    tmp := Bytes[L];
    Bytes[L] := Bytes[R];
    Bytes[R] := tmp;
    Inc(L);
    Dec(R);
  end;
end;

function TMMDBBuffer.ReadBigInteger(offset: Int64; size: Integer): BigInteger;
var
  buffer: TBytes;
begin
  // This could be optimized if it ever matters
  buffer := Read(offset, size);
  ReverseBytes(buffer);
  // The integer will always be positive. We need to make sure
  // the last bit is 0.
  if (System.Length(buffer) > 0) and ((buffer[System.Length(buffer) - 1] and $80) > 0) then
    System.SetLength(buffer, System.Length(buffer) + 1);
  Result := BigInteger.Create(buffer);
end;

function TMMDBBuffer.ReadDouble(offset: Int64): Double;
var
  buffer: TBytes;
begin
  buffer := Read(offset, SizeOf(Result));
  ReverseBytes(buffer);
  Move(buffer[0], Result, SizeOf(Result));
end;

function TMMDBBuffer.ReadFloat(offset: Int64): Single;
var
  buffer: TBytes;
begin
  buffer := Read(offset, SizeOf(Result));
  ReverseBytes(buffer);
  Move(buffer[0], Result, SizeOf(Result));
end;

function TMMDBBuffer.ReadInteger(val: Integer; offset: Int64;
  size: Integer): Integer;
var
  i: Integer;
begin
  Result := val;
  for i := 0 to size-1 do
    Result := (Result shl 8) or Integer(ReadOne(offset + i));
end;

function TMMDBBuffer.ReadLong(offset: Int64; size: Integer): Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to size-1 do
    Result := (Result shl 8) or Integer(ReadOne(offset + i));
end;

function TMMDBBuffer.ReadULong(offset: Int64; size: Integer): UInt64;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to size-1 do
    Result := (Result shl 8) or Integer(ReadOne(offset + i));
end;

{ TMMDBArrayBuffer }

constructor TMMDBArrayBuffer.Create(const filename: String);
var
  LStream: TStream;
begin
  LStream := TFileStream.Create(Filename, fmOpenRead or fmShareDenyWrite);
  try
    Create(LStream);
  finally
    FreeAndNil(LStream);
  end;
end;

procedure TMMDBArrayBuffer.Copy(offset: Int64; arr: TBytes);
begin
  System.Move(_fileBytes[offset], arr[0], System.Length(arr));
end;

constructor TMMDBArrayBuffer.Create(stream: TStream);
begin
  inherited Create(stream.Size);
  if stream.Size > 0 then
  begin
    System.SetLength(_fileBytes, stream.Size);
    stream.Position := 0;
    Stream.ReadBuffer(_fileBytes, stream.Size);
  end;
end;

function TMMDBArrayBuffer.Read(offset: Int64; count: Integer): TBytes;
begin
  System.SetLength(Result, count);
  Copy(offset, Result);
end;

function TMMDBArrayBuffer.ReadOne(offset: Int64): Byte;
begin
  Result := _fileBytes[offset];
end;

function TMMDBArrayBuffer.ReadString(offset: Int64; count: Integer): String;
begin
  Result := TEncoding.UTF8.GetString(_fileBytes, offset, count);
end;

{ TMMDBDecoder }

procedure TMMDBDecoder.CheckType(expected, from: PTypeInfo);
begin
  if expected <> from then
  begin
    if expected = TypeInfo(TValue) then Exit;
    raise EMMDBException.Create(Format(
      'Could not convert ''%s'' to ''%s''.',
      [from.Name, expected.Name]));
  end;
end;

constructor TMMDBDecoder.Create(ownerObjects: TObjectList;
  database: TMMDBBuffer; pointerBase: Int64; followPointers: Boolean);
begin
  _pointerBase := pointerBase;
  _database := database;
  _followPointers := followPointers;
  FOwnerObjects := ownerObjects;
end;

{$IFDEF DEBUG_OUT}
class constructor TMMDBDecoder.Create;
begin
  FDebugOutCS := TCriticalSection.Create;
{$IFDEF DEBUG_OUT_FILE}
  FDebugFileStream := TFileStream.Create(ExtractFileDir(ParamStr(0)) + '\' + DebugOutFile, fmCreate or fmShareDenyWrite);
{$ELSE}
  FDebugFileStream := nil;
{$ENDIF}
{$IFDEF DEBUG_OUT_FILTER}
  FDebugFilterRegEx := TRegEx.Create(DebugOutFilter);
{$ENDIF}
end;
{$ENDIF}

function TMMDBDecoder.CtrlData(offset: Int64; out size: Integer;
  out outOffset: Int64): ObjectType;
var
  ctrlByte: Byte;
  _type: ObjectType;
  nextByte: Integer;
  typeNum: Integer;
  bytesToRead: Integer;
  i: Integer;
begin
  if offset >= _database.Length then
    raise EMMDBException.Create(
      'The MaxMind DB file''s data section contains bad data: '
      + 'pointer larger than the database.');
  ctrlByte := _database.ReadOne(offset);
  Inc(offset);
  _type := ObjectType(ctrlByte shr 5);
  if _type = ObjectType.otExtended then
  begin
    nextByte := _database.ReadOne(offset);
    typeNum := nextByte + 7;
    if typeNum < 8 then
      raise EMMDBException.Create(
        'Something went horribly wrong in the decoder. An extended type '
        + 'resolved to a type number < 8 (' + IntToStr(typeNum)
        + ')');
    _type := ObjectType(typeNum);
    Inc(offset);
  end;
  // The size calculation is inlined as it is hot code
  size := ctrlByte and $1f;
  if size >= 29 then
  begin
    bytesToRead := size - 28;
    i := _database.ReadInteger(0, offset, bytesToRead);
    offset := offset + bytesToRead;
    case size of
      29: size := 29 + i;
      30: size := 285 + i;
    else
          size := 65821 + (i and ($0FFFFFFF shr (32 - 8 * bytesToRead)));
    end;
  end;
  outOffset := offset;
  Result := _type;
end;

{$IFDEF DEBUG_OUT}
procedure TMMDBDecoder.DebugOutput(const S: String);
{$IFDEF DEBUG_OUT_FILE}
var
  B: TBytes;
{$ENDIF}
begin
  if Length(S) < 1 then Exit;
{$IFDEF DEBUG_OUT_FILTER}
  if not FDebugFilterRegEx.IsMatch(S) then Exit;
{$ENDIF}
{$IFDEF DEBUG_OUT_FILE}
   FDebugOutCS.Acquire;
   try
     B := TEncoding.UTF8.GetBytes(S + sLineBreak);
     FDebugFileStream.Write(B, Length(B));
   finally
     FDebugOutCS.Release;
   end;
{$ELSE}
  OutputDebugString(PChar(S));
{$ENDIF}
end;
{$ENDIF}

procedure TMMDBDecoder.Decode(expectedType: PTypeInfo; offset: Int64;
  out outOffset: Int64; var valResult: TValue{$IFDEF DEBUG_OUT}; const keyPath: String{$ENDIF});
var
  _type: ObjectType;
  size: Integer;
begin
  _type := CtrlData(offset, size, offset);
  DecodeByType(expectedType, _type, offset, size, outOffset, valResult{$IFDEF DEBUG_OUT}, keyPath{$ENDIF});
end;

procedure TMMDBDecoder.Decode<T>(offset: Int64; out outOffset: Int64;
  var tResult: T);
var
  val: TValue;
begin
  val := TValue.From<T>(tResult);
  Decode(TypeInfo(T), offset, outOffset, val{$IFDEF DEBUG_OUT}, ''{$ENDIF});
end;

function TMMDBDecoder.Decode(expectedType: PTypeInfo; offset: Int64;
  out outOffset: Int64{$IFDEF DEBUG_OUT}; const keyPath: String{$ENDIF}): TValue;
var
  _type: ObjectType;
  size: Integer;
  expectedRttiType: TRttiType;
  et: TRttiInstanceType;
begin
  _type := CtrlData(offset, size, offset);
  if expectedType.Kind = tkClass then
  begin
    expectedRttiType := FContext.GetType(expectedType);
    et := expectedRttiType.AsInstance;
    Result := et.GetMethod('Create').Invoke(et.MetaclassType, []);
    try
      DecodeByType(expectedType, _type, offset, size, outOffset, Result{$IFDEF DEBUG_OUT}, keyPath{$ENDIF});
    except
      raise;
    end;
  end else
    Result := DecodeByType(expectedType, _type, offset, size, outOffset{$IFDEF DEBUG_OUT}, keyPath{$ENDIF});
end;

function TMMDBDecoder.Decode<T>(offset: Int64; out outOffset: Int64): T;
var
  _type: ObjectType;
  size: Integer;
  val: TValue;
begin
  _type := CtrlData(offset, size, offset);
  val := DecodeByType(TypeInfo(T), _type, offset, size, outOffset{$IFDEF DEBUG_OUT}, ''{$ENDIF});
  Result := val.AsType<T>;
end;

function TMMDBDecoder.DecodeArray(expectedType: PTypeInfo; size: Integer;
  offset: Int64; out outOffset: Int64{$IFDEF DEBUG_OUT}; const keyPath: String{$ENDIF}): TObject;
var
  expectedRttiType: TRttiType;
  t: TRttiInstanceType;
begin
  expectedRttiType := FContext.GetType(expectedType);
  t := expectedRttiType.AsInstance;
  Result := t.GetMethod('Create').Invoke(t.MetaclassType, []).AsObject;
  if Assigned(FOwnerObjects) then FOwnerObjects.Add(Result);
  DecodeArray(expectedType, size, offset, outOffset, Result{$IFDEF DEBUG_OUT}, keyPath{$ENDIF});
end;

procedure TMMDBDecoder.DecodeArray(expectedType: PTypeInfo; size: Integer;
  offset: Int64; out outOffset: Int64; objResult: TObject{$IFDEF DEBUG_OUT}; const keyPath: String{$ENDIF});
var
  expectedRttiType: TRttiType;
  t: TRttiInstanceType;
  clearMethod: TRttiMethod;
  addMethod: TRttiMethod;
  addParams: TArray<TRttiParameter>;
  paramValue: TRttiParameter;
  valueType: PTypeInfo;
  val: TValue;
  i: Integer;
begin
  expectedRttiType := FContext.GetType(expectedType);
  t := expectedRttiType.AsInstance;
  if not GetInstanceTypeMethod(t, 'Clear', clearMethod, 0)
    then Exit;
  clearMethod.Invoke(objResult, []);
  if not GetInstanceTypeMethod(t, 'Add', addMethod, 1)
    then Exit;
  addParams := addMethod.GetParameters;
  paramValue := addParams[0];
  valueType := paramValue.ParamType.Handle;
  for i := 0 to size-1 do
  begin
    val := Decode(valueType, offset, offset{$IFDEF DEBUG_OUT}, keyPath + '[' + IntToStr(i) + ']'{$ENDIF});
    addMethod.Invoke(objResult, [val]);
  end;
  outOffset := offset;
end;

function TMMDBDecoder.DecodeBigInteger(expectedType: PTypeInfo; offset: Int64;
  size: Integer): BigInteger;
begin
  raise EMMDBException.Create('Unsupported method: DecodeBigInteger');
end;

function TMMDBDecoder.DecodeBoolean(expectedType: PTypeInfo;
  size: Integer): Boolean;
begin
  CheckType(expectedType, TypeInfo(Boolean));
  case size of
    0: Exit(False);
    1: Exit(True);
  else
    raise EMMDBException.Create('The MaxMind DB file''s data section contains bad data: '
      + 'invalid size of boolean.');
  end;
end;

function TMMDBDecoder.DecodeBytes(expectedType: PTypeInfo; offset: Int64;
  size: Integer): TBytes;
begin
  CheckType(expectedType, TypeInfo(TBytes));
  Result := _database.Read(offset, size);
end;

function TMMDBDecoder.DecodeByType(expectedType: PTypeInfo; _type: ObjectType;
  offset: Int64; size: Integer; out outOffset: Int64{$IFDEF DEBUG_OUT}; const keyPath: String{$ENDIF}): TValue;
begin
  Result := TValue.Empty;
  DecodeByType(expectedType, _type, offset, size, outOffset, Result{$IFDEF DEBUG_OUT}, keyPath{$ENDIF});
end;

procedure TMMDBDecoder.DecodeByType(expectedType: PTypeInfo; _type: ObjectType;
  offset: Int64; size: Integer; out outOffset: Int64; var valResult: TValue
  {$IFDEF DEBUG_OUT}; const keyPath: String{$ENDIF});
var
  pointer: Int64;
  _: Int64;
begin
  outOffset := offset + size;
  case _type of
    ObjectType.otPointer:
      begin
        pointer := DecodePointer(offset, size, offset);
        outOffset := offset;
        if (not _followPointers) then
        begin
          TValue.Make(pointer, expectedType, valResult);
          Exit;
        end;
        Decode(expectedType, Integer(pointer), _, valResult{$IFDEF DEBUG_OUT}, keyPath{$ENDIF});
      end;
    ObjectType.otMap:
      if not valResult.IsEmpty then
        DecodeMap(expectedType, offset, size, outOffset, valResult.AsObject{$IFDEF DEBUG_OUT}, keyPath{$ENDIF})
      else
        valResult := DecodeMap(expectedType, offset, size, outOffset{$IFDEF DEBUG_OUT}, keyPath{$ENDIF});

    ObjectType.otArray:
      if not valResult.IsEmpty then
        DecodeArray(expectedType, size, offset, outOffset, valResult.AsObject{$IFDEF DEBUG_OUT}, keyPath{$ENDIF})
      else
        valResult := DecodeArray(expectedType, size, offset, outOffset{$IFDEF DEBUG_OUT}, keyPath{$ENDIF});

    ObjectType.otBoolean:
      begin
        outOffset := offset;
        valResult := DecodeBoolean(expectedType, size);
      end;

    ObjectType.otUtf8String:
      valResult := DecodeString(expectedType, offset, size);

    ObjectType.otDouble:
      valResult := DecodeDouble(expectedType, offset, size);

    ObjectType.otFloat:
      valResult := DecodeFloat(expectedType, offset, size);

    ObjectType.otBytes:
      valResult := TValue.From<TBytes>(DecodeBytes(expectedType, offset, size));

    ObjectType.otUint16:
      valResult := DecodeInteger(expectedType, offset, size);

    ObjectType.otUint32:
      valResult := DecodeLong(expectedType, offset, size);

    ObjectType.otInt32:
      valResult := DecodeInteger(expectedType, offset, size);

    ObjectType.otUint64:
      valResult := DecodeUInt64(expectedType, offset, size);

    ObjectType.otUint128:
      valResult := TValue.From<BigInteger>(DecodeBigInteger(expectedType, offset, size));

  else
     raise EMMDBException.Create('Unable to handle type:' + IntToStr(Ord(_type)));
  end;
end;

function TMMDBDecoder.DecodeDouble(expectedType: PTypeInfo; offset: Int64;
  size: Integer): Double;
begin
  CheckType(expectedType, TypeInfo(Double));
  if (size <> 8) then
    raise EMMDBException.Create('The MaxMind DB file''s data section contains bad data: '
      + 'invalid size of double.');
  Result := _database.ReadDouble(offset);
end;

function TMMDBDecoder.DecodeFloat(expectedType: PTypeInfo; offset: Int64;
  size: Integer): Single;
begin
  CheckType(expectedType, TypeInfo(Single));
  if (size <> 4) then
    raise EMMDBException.Create('The MaxMind DB file''s data section contains bad data: '
      + 'invalid size of float.');
  Result := _database.ReadFloat(offset);
end;

function TMMDBDecoder.DecodeInteger(expectedType: PTypeInfo; offset: Int64;
  size: Integer): Integer;
begin
  CheckType(expectedType, TypeInfo(Integer));
  Result := _database.ReadInteger(0, offset, size);
end;

function TMMDBDecoder.DecodeKey(offset: Int64; out outOffset: Int64): TBytes;
var
  _type: ObjectType;
  size: Integer;
begin
  _type := CtrlData(offset, size, offset);
  case _type of
    ObjectType.otPointer:
      begin
        offset := DecodePointer(offset, size, outOffset);
        Exit(DecodeKey(offset, offset));
      end;

    ObjectType.otUtf8String:
      begin
        outOffset := offset + size;
        Exit(_database.Read(offset, size));
      end

    else
      raise EMMDBException.Create('Database contains a non-string as map key: '+IntToStr(Ord(_type)));
  end;
end;

function TMMDBDecoder.DecodeLong(expectedType: PTypeInfo; offset: Int64;
  size: Integer): Int64;
begin
  CheckType(expectedType, TypeInfo(Int64));
  Result := _database.ReadLong(offset, size);
end;

procedure TMMDBDecoder.DecodeMap(expectedType: PTypeInfo; offset: Int64;
  size: Integer; out outOffset: Int64; objResult: TObject
  {$IFDEF DEBUG_OUT}; const keyPath: String{$ENDIF});
begin
  if IsDictType(expectedType) then
    DecodeMapToDictionary(expectedType, offset, size, outOffset, objResult{$IFDEF DEBUG_OUT}, keyPath{$ENDIF})
  else
    DecodeMapToType(expectedType, offset, size, outOffset, objResult{$IFDEF DEBUG_OUT}, keyPath{$ENDIF});
end;

function TMMDBDecoder.DecodeMap(expectedType: PTypeInfo; offset: Int64;
  size: Integer; out outOffset: Int64
  {$IFDEF DEBUG_OUT}; const keyPath: String{$ENDIF}): TObject;
begin
  if IsDictType(expectedType) then
    Exit(DecodeMapToDictionary(expectedType, offset, size, outOffset{$IFDEF DEBUG_OUT}, keyPath{$ENDIF}));
  Result := DecodeMapToType(expectedType, offset, size, outOffset{$IFDEF DEBUG_OUT}, keyPath{$ENDIF});
end;

function TMMDBDecoder.DecodeMapToDictionary(expectedType: PTypeInfo;
  offset: Int64; size: Integer; out outOffset: Int64
  {$IFDEF DEBUG_OUT}; const keyPath: String{$ENDIF}): TObject;
var
  expectedRttiType: TRttiType;
  t: TRttiInstanceType;
begin
  expectedRttiType := FContext.GetType(expectedType);
  t := expectedRttiType.AsInstance;
  Result := t.GetMethod('Create').Invoke(t.MetaclassType, [0{ACapacity=0}]).AsObject;
  if Assigned(FOwnerObjects) then FOwnerObjects.Add(Result);
  DecodeMapToDictionary(expectedType, offset, size, outOffset, Result{$IFDEF DEBUG_OUT}, keyPath{$ENDIF});
end;

procedure TMMDBDecoder.DecodeMapToDictionary(expectedType: PTypeInfo;
  offset: Int64; size: Integer; out outOffset: Int64; objResult: TObject
  {$IFDEF DEBUG_OUT}; const keyPath: String{$ENDIF});
var
  expectedRttiType: TRttiType;
  t: TRttiInstanceType;
  clearMethod: TRttiMethod;
  addMethod: TRttiMethod;
  addParams: TArray<TRttiParameter>;
  paramKey: TRttiParameter;
  paramValue: TRttiParameter;
  keyType: PTypeInfo;
  valueType: PTypeInfo;
  key: TValue;
  val: TValue;
  i: Integer;
begin
  expectedRttiType := FContext.GetType(expectedType);
  t := expectedRttiType.AsInstance;
  if not GetInstanceTypeMethod(t, 'Clear', clearMethod, 0)
    then Exit;
  clearMethod.Invoke(objResult, []);
  if not GetInstanceTypeMethod(t, 'Add', addMethod, 2)
    then Exit;
  addParams := addMethod.GetParameters;
  paramKey := addParams[0];
  paramValue := addParams[1];
  keyType := paramKey.ParamType.Handle;
  valueType := paramValue.ParamType.Handle;
  for i := 0 to size-1 do
  begin
    key := Decode(keyType, offset, offset{$IFDEF DEBUG_OUT}, keyPath + '[' + IntToStr(i) + '].key'{$ENDIF});
    val := Decode(valueType, offset, offset{$IFDEF DEBUG_OUT}, keyPath + '[' + IntToStr(i) + '].value'{$ENDIF});
{$IFDEF DEBUG_OUT}
    DebugOutput(expectedRttiType.Name + '.' + key.ToString + ':' + paramValue.ParamType.Name + ' = ' + val.ToString);
{$ENDIF}
    addMethod.Invoke(objResult, [key, val]);
  end;
  outOffset := offset;
end;

procedure TMMDBDecoder.DecodeMapToType(expectedType: PTypeInfo; offset: Int64;
  size: Integer; out outOffset: Int64; objResult: TObject{$IFDEF DEBUG_OUT}; const keyPath: String{$ENDIF});
var
  key: String; //TBytes;
  expectedRttiType: TRttiType;
  p, prop: TRttiProperty;
  ca: TCustomAttribute;
  //attr: TMMDBAttribute;
  val: TValue;
  i: Integer;
begin
  expectedRttiType := FContext.GetType(expectedType);
  for i := 0 to size-1 do
  begin
    key := TEncoding.UTF8.GetString(DecodeKey(offset, offset));
    //prop := expectedRttiType.GetProperty(key);
    prop := nil;
    //attr := nil;
    for p in expectedRttiType.GetProperties do
    begin
      for ca in p.GetAttributes do
      begin
        if (ca is TMMDBAttribute) and
           SameText(TMMDBAttribute(ca).Name, key) then
        begin
          //attr := TMMDBAttribute(ca);
          prop := p;
          Break;
        end;
      end;
      if prop <> nil then Break;
    end;
    if prop <> nil then
    begin
      if prop.IsReadable and
        (prop.PropertyType.TypeKind = tkClass) then
      begin
        val := prop.GetValue(objResult);
        if not val.IsEmpty then
        begin
{$IFDEF DEBUG_OUT}
          DebugOutput(expectedRttiType.Name + '.' + prop.Name + ':' + prop.PropertyType.Name + ' = ' + val.ToString);
{$ENDIF}
          Decode(prop.PropertyType.Handle, offset, offset, val{$IFDEF DEBUG_OUT}, keyPath + '.' + key{$ENDIF});
          Continue;
        end;
      end;
      if prop.IsWritable then
      begin
        val := Decode(prop.PropertyType.Handle, offset, offset{$IFDEF DEBUG_OUT}, keyPath + '.' + key{$ENDIF});
{$IFDEF DEBUG_OUT}
        DebugOutput(expectedRttiType.Name + '.' + prop.Name + ':' + prop.PropertyType.Name + ' = ' + val.ToString);
{$ENDIF}
        prop.SetValue(objResult, val);
        Continue;
      end;
{$IFDEF DEBUG_OUT}
      DebugOutput('WARNING: ' + expectedRttiType.Name + '.' + prop.Name + ' NOT WRITABLE');
{$ENDIF}
    end else
    begin
{$IFDEF DEBUG_OUT}
      DebugOutput('WARNING: ' + expectedRttiType.Name + ' NOT FOUND (' + keyPath + '.' + key +')');
{$ENDIF}
    end;
    offset := NextValueOffset(offset, 1);
  end;
  outOffset := offset;
end;

function TMMDBDecoder.DecodeMapToType(expectedType: PTypeInfo; offset: Int64;
  size: Integer; out outOffset: Int64{$IFDEF DEBUG_OUT}; const keyPath: String{$ENDIF}): TObject;
var
  expectedRttiType: TRttiType;
  t: TRttiInstanceType;
begin
  expectedRttiType := FContext.GetType(expectedType);
  t := expectedRttiType.AsInstance;
  Result := t.GetMethod('Create').Invoke(t.MetaclassType, []).AsObject;
  if Assigned(FOwnerObjects) then FOwnerObjects.Add(Result);
  DecodeMapToType(expectedType, offset, size, outOffset, Result{$IFDEF DEBUG_OUT}, keyPath{$ENDIF});
end;

function TMMDBDecoder.DecodePointer(offset: Int64; size: Integer;
  out outOffset: Int64): Int64;
const
  _pointerValueOffset: TArray<Integer> = [ 0, 0, 1 shl 11, (1 shl 19) + (1 shl 11), 0 ];
var
  pointerSize: Integer;
  b: Integer;
  _packed: Integer;
begin
  pointerSize := ((size shr 3) and $03) + 1;
  b := IfThen(pointerSize = 4, 0, size and $07);
  _packed := _database.ReadInteger(b, offset, pointerSize);
  outOffset := offset + pointerSize;
  Result := _packed + _pointerBase + _pointerValueOffset[pointerSize];
end;

function TMMDBDecoder.DecodeString(expectedType: PTypeInfo; offset: Int64;
  size: Integer): String;
begin
  CheckType(expectedType, TypeInfo(String));
  Result := _database.ReadString(offset, size);
end;

function TMMDBDecoder.DecodeUInt64(expectedType: PTypeInfo; offset: Int64;
  size: Integer): UInt64;
begin
  CheckType(expectedType, TypeInfo(UInt64));
  Result := _database.ReadULong(offset, size);
end;

{$IFDEF DEBUG_OUT}
class destructor TMMDBDecoder.Destroy;
begin
  if Assigned(FDebugFileStream) then
    FDebugFileStream.Free;
  FDebugOutCS.Free;
end;
{$ENDIF}

function TMMDBDecoder.GetInstanceTypeMethod(instance: TRttiInstanceType;
  const methodName: String; out method: TRttiMethod;
  paramCount: Integer): Boolean;
var
  params: TArray<TRttiParameter>;
begin
  method := instance.GetMethod(methodName);
  if not Assigned(method) then
  begin
{$IFDEF DEBUG_OUT}
    DebugOutput(instance.Name+'.'+methodName+' method does not exist.');
{$ENDIF}
    //raise EMMDBException.Create(instance.Name+'.'+methodName+' method does not exist.');
    Exit(False);
  end;
  if paramCount >= 0 then
  begin
    params := method.GetParameters;
    if Length(params) <> paramCount then
    begin
{$IFDEF DEBUG_OUT}
      DebugOutput('Bad '+instance.Name+'.'+methodName+' parameters count.');
{$ENDIF}
      //raise EMMDBException.Create('Bad '+instance.Name+'.'+methodName+' parameters count.');
      Exit(False);
    end;
  end;
  Result := True;
end;

function TMMDBDecoder.IsDictType(expected: PTypeInfo): Boolean;
var
  expectedRttiType: TRttiType;
begin
//  Result :=
//    (expected = TypeInfo(TDictionary<string, string>)) or
//    (expected = TypeInfo(TDictionary<string, TObject>));
  expectedRttiType := FContext.GetType(expected);
  Result := expectedRttiType.Name.StartsWith('TDictionary<');
end;

function TMMDBDecoder.NextValueOffset(offset: Int64;
  numberToSkip: Integer): Int64;
var
  _type: ObjectType;
  size: Integer;
begin
  while true do
  begin
    if numberToSkip = 0 then
    begin
      Exit(offset);
    end;

    _type := CtrlData(offset, size, offset);

    case _type of
      ObjectType.otPointer:
        DecodePointer(offset, size, offset);

      ObjectType.otMap:
        Inc(numberToSkip, 2 * size);

      ObjectType.otArray:
        Inc(numberToSkip, size);

      ObjectType.otBoolean: ;

      else
        Inc(offset, size);
    end;

    numberToSkip := numberToSkip - 1;
  end;
end;

{ TMMDBAttribute }

constructor TMMDBAttribute.Create(const AName: String);
begin
  FName := AName;
end;

{ TMMDBMetadata }

constructor TMMDBMetadata.Create;
begin
  _Description := TDictionary<string, string>.Create;
  _Languages := TList<string>.Create;
end;

destructor TMMDBMetadata.Destroy;
begin
  _Languages.Free;
  _Description.Free;
  inherited;
end;

function TMMDBMetadata.GetBuildDate: TDateTime;
begin
  Result := IncSecond(EncodeDate(1970, 1, 1), _BuildEpoch);
end;

function TMMDBMetadata.GetNodeByteSize: Int64;
begin
  Result := _RecordSize div 4;
end;

function TMMDBMetadata.GetSearchTreeSize: Int64;
begin
  Result := _NodeCount * NodeByteSize;
end;

{ TMMDBNetNode }

constructor TMMDBNetNode.Create(byteCount, Pointer: Integer);
begin
  SetLength(_IPBytes, byteCount);
  FillChar(_IPBytes[0], Length(_IPBytes), 0);
  _Bit := 0;
  _Pointer := Pointer;
end;

constructor TMMDBNetNode.Create(IPBytes: TBytes; Bit, Pointer: Integer);
begin
  SetLength(_IPBytes, Length(IPBytes));
  Move(IPBytes[0], _IPBytes[0], Length(_IPBytes));
  _Bit := Bit;
  _Pointer := Pointer;
end;

destructor TMMDBNetNode.Destroy;
begin

  inherited;
end;

{ TMMDBIteratorNode<T> }

constructor TMMDBIteratorNode<T>.Create(data: T);
begin
  _Data := data;
end;

destructor TMMDBIteratorNode<T>.Destroy;
begin

  inherited;
end;

function TMMDBIteratorNode<T>.GetNode: TMMDBIteratorNode<T>;
begin
  Result := Self;
end;

{ TMMDBEnumerator<T> }

constructor TMMDBEnumerator<T>.Create(reader: TMMDBReader; IPv4Only: Boolean;
  iterator: IMMDBIterator<T>; cacheSize: Integer);
var
  root: TMMDBNetNode;
begin
  inherited Create;
  _reader := reader;
  _iterator := iterator;
  if (_reader.Metadata.IPVersion = 6) and (not IPv4Only) then
    byteCount := 16
  else
    byteCount := 4;
  nodes := TList<TMMDBNetNode>.Create;
  root := TMMDBNetNode.Create(byteCount, _reader.StartNode(byteCount * 8));
  nodes.Add(root);
  node := nil;
  _dataCache := TDictionary<Integer, T>.Create;
end;

destructor TMMDBEnumerator<T>.Destroy;
var
  tmp: TMMDBNetNode;
begin
  _dataCache.Free;
  if node <> nil then
     FreeAndNil(node);
  while nodes.Count > 0 do
  begin
    tmp := nodes[nodes.Count-1];
    nodes.Delete(nodes.Count-1);
    tmp.Free;
  end;
  nodes.Free;
  _iterator := nil;
  inherited;
end;

function TMMDBEnumerator<T>.getCurrent: TObject;
begin
  Result := nil;
end;

function TMMDBEnumerator<T>.GetCurrentGeneric: IMMDBIterator<T>;
begin
  if (node <> nil) and (node.Pointer > _reader.Metadata.NodeCount) then
  begin
    Exit(_iterator);
  end;
  Result := nil;
end;

function TMMDBEnumerator<T>.MoveNext: Boolean;
var
  ipRight: TBytes;
  rightPointer: Integer;
  rightNode: TMMDBNetNode;
  isIPV4: Boolean;
  i: Integer;
begin
  if node <> nil then
    FreeAndNil(node);
  while nodes.Count > 0 do
  begin
    node := nodes[nodes.Count-1];
    nodes.Delete(nodes.Count-1);
    while True do
    begin
      if node.Pointer < _reader.Metadata.NodeCount then
      begin
        SetLength(ipRight, byteCount);
        Move(node.IPBytes[0], ipRight[0], Length(ipRight));
        if Length(ipRight) <= (node.Bit shr 3) then
          raise EMMDBException.Create(Format(
            'Invalid search tree, bad bit %d', [node.Bit]));
        ipRight[node.Bit shr 3] := ipRight[node.Bit shr 3] or
          Byte(1 shl (7 - (node.Bit mod 8)));
        rightPointer := _reader.ReadNode(node.Pointer, 1);
        node.Bit := node.Bit + 1;
        rightNode := TMMDBNetNode.Create(ipRight, node.Bit, rightPointer);
        nodes.Add(rightNode);
        node.Pointer := _reader.ReadNode(node.Pointer, 0);
      end else
      begin
        if node.Pointer > _reader.Metadata.NodeCount then
        begin
          // data node, we are done with this branch
          if _iterator = nil then
          begin
            _iterator := TMMDBIteratorNode<T>.Create;
            _iterator.Node._Data := _reader.ResolveDataPointer<T>(node.Pointer);
          end else
            _reader.ResolveDataPointer<T>(node.Pointer, _iterator.Node._Data);
          isIPV4 := true;
          for i := 0 to Length(node.IPBytes) - 4 do
          begin
            if node.IPBytes[i] = 0 then Continue;
            isIPV4 := False;
            break;
          end;
          if ((not isIPV4) or (Length(node.IPBytes) = 4)) then
          begin
            _iterator.Node._Start := TMMDBIPAddress.Create(node.IPBytes);
            _iterator.Node._Prefix := node._Bit;
          end else
          begin
            _iterator.Node._Start := TMMDBIPAddress.Create(Copy(node.IPBytes, 12, 4));
            _iterator.Node._Prefix := node._Bit - 16;
          end;
          Exit(True);
        end;
        // else node is an empty node (terminator node), we are done with this branch
        Break;
      end;
    end;
    FreeAndNil(node);
  end;
  Result := False;
end;

procedure TMMDBEnumerator<T>.Reset;
var
  tmp, root: TMMDBNetNode;
begin
  if node <> nil then
    FreeAndNil(node);
  while nodes.Count > 0 do
  begin
    tmp := nodes[nodes.Count-1];
    nodes.Delete(nodes.Count-1);
    tmp.Free;
  end;
  root := TMMDBNetNode.Create(byteCount, _reader.StartNode(byteCount * 8));
  nodes.Add(root);
end;

{ TMMDBEnumerable<T> }

constructor TMMDBEnumerable<T>.Create(reader: TMMDBReader; IPv4Only: Boolean;
  iterator: IMMDBIterator<T>; cacheSize: Integer);
begin
  inherited Create;
  _reader := reader;
  _IPv4Only := IPv4Only;
  _iterator := iterator;
  _cacheSize := cacheSize;
end;

destructor TMMDBEnumerable<T>.Destroy;
begin

  inherited;
end;

function TMMDBEnumerable<T>.GetEnumerator: IEnumerator;
begin
  Result := nil;
end;

function TMMDBEnumerable<T>.GetEnumeratorGeneric: IEnumerator<IMMDBIterator<T>>;
begin
  Result := TMMDBEnumerator<T>.Create(_reader, _IPv4Only, _iterator, _cacheSize);
end;

{ TMMDBReader }

constructor TMMDBReader.Create(const Filename: String);
var
  start: Integer;
  metaDecode: TMMDBDecoder;
  _: Int64;
begin
  _fileName := Filename;
  _database := TMMDBArrayBuffer.Create(Filename);
  start := FindMetadataStart;
  FFindOwnerObjects := TObjectList.Create(True);
  FMetaOwnerObjects := TObjectList.Create(True);
  metaDecode := TMMDBDecoder.Create(FMetaOwnerObjects, _database, start);
  try
    //FMetadata := metaDecode.Decode<TMMDBMetadata>(start, _);
    FMetadata := TMMDBMetadata.Create;
    metaDecode.Decode<TMMDBMetadata>(start, _, FMetadata);
    FDecoder := TMMDBDecoder.Create(FFindOwnerObjects, _database, Metadata.SearchTreeSize + DataSectionSeparatorSize);
  finally
    metaDecode.Free;
  end;
end;

destructor TMMDBReader.Destroy;
begin
  if Assigned(FDecoder) then
    FDecoder.Free;
  if Assigned(FMetadata) then
    FMetadata.Free;
  FMetaOwnerObjects.Free;
  FFindOwnerObjects.Free;
  _database.Free;
  inherited;
end;

function TMMDBReader.Find<T>(const ipAddress: TMMDBIPAddress;
  out prefixLength: Integer): T;
var
  pointer: Integer;
begin
  pointer := FindAddressInTree(ipAddress, prefixLength);
  if pointer = 0 then
    raise EMMDBNotFoundException.Create('Not Found');
  Result := ResolveDataPointer<T>(pointer);
end;

function TMMDBReader.Find<T>(const ipAddress: TMMDBIPAddress;
  out prefixLength: Integer; var tResult: T): Boolean;
var
  pointer: Integer;
begin
  pointer := FindAddressInTree(ipAddress, prefixLength);
  if pointer = 0 then Exit(False);
  ResolveDataPointer<T>(pointer, tResult);
  Result := True;
end;

function TMMDBReader.FindAddressInTree(const address: TMMDBIPAddress;
  out prefixLength: Integer): Integer;
var
  rawAddress: TBytes;
  bitLength: Integer;
  _record: Int64;
  nodeCount: Int64;
  i: Integer;
  bit: Byte;
begin
  rawAddress := address.GetAddressBytes;
  bitLength := Length(rawAddress) * 8;
  _record := StartNode(bitLength);
  nodeCount := Metadata.NodeCount;
  for i := 0 to bitLength-1 do
  begin
    if _record >= nodeCount then Break;
    bit := 1 and (rawAddress[i shr 3] shr (7 - (i mod 8)));
    _record := ReadNode(_record, bit);
  end;
  prefixLength := i;
  if _record = Metadata.NodeCount then
  begin
    //record is empty
    Exit(0);
  end;
  if _record > Metadata.NodeCount then
  begin
    //record is a data pointer
    Exit(_record);
  end;
  raise EMMDBException.Create('Something bad happened');
end;

function TMMDBReader.FindAll<T>(data: T; IPv4Only: Boolean;
  cacheSize: Integer): IEnumerable<IMMDBIterator<T>>;
begin
  Result := TMMDBEnumerable<T>.Create(Self, IPv4Only,
    TMMDBIteratorNode<T>.Create(data), cacheSize);
end;

function TMMDBReader.FindAll<T>(IPv4Only: Boolean;
  cacheSize: Integer): IEnumerable<IMMDBIterator<T>>;
begin
  Result := TMMDBEnumerable<T>.Create(Self, IPv4Only, nil, cacheSize);
end;

function TMMDBReader.FindMetadataStart: Integer;
const
  _metadataStartMarker: TBytes =
    [ $AB, $CD, $EF, 77, 97, 120, 77, 105, 110, 100, 46, 99, 111, 109 ];
var
  I: Integer;
  buffer: TBytes;
begin
  System.SetLength(buffer, System.Length(_metadataStartMarker));
  I := _database.Length - System.Length(_metadataStartMarker);
  while I >= 0 do
  begin
    _database.Copy(I, buffer);
    if CompareMem(buffer, _metadataStartMarker, System.Length(_metadataStartMarker)) then
    begin
      Exit(I + System.Length(_metadataStartMarker));
    end;
    Dec(I);
  end;
  raise EMMDBException.Create(
    Format('Could not find a MaxMind Db metadata marker in this file (%s). Is this a valid MaxMind Db file?',
      [_fileName]));
end;

function TMMDBReader.IPv4Start: Integer;
var
  i, node: Integer;
begin
  if (_IPv4Start <> 0) or (Metadata.IPVersion = 4) then
    Exit(_IPv4Start);
  node := 0;
  for i := 0 to 95 do
  begin
    if node >= Metadata.NodeCount
      then Break;
    node := ReadNode(node, 0);
  end;
  _IPv4Start := node;
  Result := node;
end;

function TMMDBReader.ReadNode(nodeNumber, index: Integer): Integer;
var
  baseOffset, offset: Int64;
  size: Integer;
begin
  baseOffset := nodeNumber * Metadata.NodeByteSize;
  size := Metadata.RecordSize;
  case size of
    24:
      begin
        offset := baseOffset + index * 3;
        Exit((Integer(_database.ReadOne(offset)) shl 16) or
          (Integer(_database.ReadOne(offset + 1)) shl 8) or
          Integer(_database.ReadOne(offset + 2)));
      end;
    28:
      begin
        if (index = 0) then
          Exit((Integer(_database.ReadOne(baseOffset + 3) and $F0) shl 20) or
            (Integer(_database.ReadOne(baseOffset)) shl 16) or
            (Integer(_database.ReadOne(baseOffset + 1)) shl 8) or
            Integer(_database.ReadOne(baseOffset + 2)));
        Exit((Integer(_database.ReadOne(baseOffset + 3) and $0F) shl 24) or
          (Integer(_database.ReadOne(baseOffset + 4)) shl 16) or
          (Integer(_database.ReadOne(baseOffset + 5)) shl 8) or
          Integer(_database.ReadOne(baseOffset + 6)));
      end;
    32:
      begin
        offset := baseOffset + index * 4;
        Exit((Integer(_database.ReadOne(offset) shl 24)) or
          (Integer(_database.ReadOne(offset + 1)) shl 16) or
          (Integer(_database.ReadOne(offset + 2)) shl 8) or
          Integer(_database.ReadOne(offset + 3)));
      end;
  end;
  raise EMMDBException.Create(Format('Unknown record size: %d', [size]));
end;

procedure TMMDBReader.ResolveDataPointer<T>(pointer: Integer; var tResult: T);
var
  resolved, _: Int64;
begin
  resolved := pointer - Metadata.NodeCount + Metadata.SearchTreeSize;
  if resolved >= _database.Length then
    raise EMMDBException.Create('The MaxMind Db file''s search tree is corrupt: '
      + 'contains pointer larger than the database.');
  Decoder.Decode<T>(resolved, _, tResult);
end;

function TMMDBReader.ResolveDataPointer<T>(pointer: Integer): T;
var
  resolved, _: Int64;
begin
  resolved := pointer - Metadata.NodeCount + Metadata.SearchTreeSize;
  if resolved >= _database.Length then
    raise EMMDBException.Create('The MaxMind Db file''s search tree is corrupt: '
      + 'contains pointer larger than the database.');
  Exit(Decoder.Decode<T>(resolved, _));
end;

function TMMDBReader.StartNode(bitLength: Integer): Integer;
begin
  if (Metadata.IPVersion = 6) and (bitLength = 32)  then
    Exit(IPv4Start);
  Result := 0;
end;

end.
