unit uCPUInfo;
(*
   lightweight unit for access to CPU and RAM usage information
   R. Cherepanov, 06.2019
   X64 support
*)

interface
uses
  SysUtils,
  Winapi.PsAPI,
  Winapi.Windows;

type
  TRegisters=record
    case Integer of
      0:(EAX,EBX,ECX,EDX:LongWord);
      1:(Str1,Str2,Str3,Str4:array[0..3] of AnsiChar );
      2:(Str:array[0..15] of AnsiChar );
  end;

  T_CPU_Info= record
    logical_cores: integer;
    physical_cores: integer;
    L1CacheSize: Int64;
    L2CacheSize: Int64;
    L3CacheSize: Int64;
    RAMSize    : Int64;
  end;


  procedure GetCPUID(Param:Cardinal; var Registers:TRegisters); register;
  function IsCPUID_Available:Boolean; register;
  function GetExtendeCPUInfo: AnsiString;
  function GetCPUInfo: T_CPU_Info;
  function GetCPUName: AnsiString;
  function GetCPUUsage: real;

function GetProcessMem: Integer;

implementation

  function NtQuerySystemInformation (
    SystemInformationClass : DWORD;  // information type flag
    SystemInformation : Pointer;     // buffer
    SystemInformationLength : DWORD; // fuffer size
    var ReturnLength : DWORD         // count of bytes to be returned or needed
  ) : DWORD; stdcall; external 'ntdll.dll';

var
  nOldIdleTime : int64 = 0;
  nOldSystemTime : int64 = 0;
  nNewCPUTime : double = 0;
  pmc: PPROCESS_MEMORY_COUNTERS;

  function IsCPUID_Available:Boolean; register;
{$IFDEF CPUX64}
    asm  // x64 version
      // FLAGS register in x64 has 64bits, i.e. QWORD,
      // PUSHFQ/POPFQ instead of PUSHFD/POPFD for DWORD in x32.

      .noframe
      PUSHFQ
      POP    RAX
      MOV    RBX, RAX
      XOR    EAX, $200000;
      PUSH   RAX
      POPFQ
      PUSHFQ
      POP    RAX
      XOR    EAX, EDX
      SETNZ  AL
    end;
{$ELSE}
    asm   // x32 version
      PUSHFD
      POP    EAX
      MOV    EDX, EAX
      XOR    EAX, $200000;
      PUSH   EAX
      POPFD
      PUSHFD
      POP    EAX
      XOR    EAX, EDX
      SETNZ  AL
    end;
{$ENDIF}

  procedure GetCPUID(Param:Cardinal; var Registers:TRegisters); register;
{$IFDEF CPUX64}
    asm  // X64 version
      .noframe
    PUSH   RBX
    PUSH   RDI
    MOV    RDI, Registers
    MOV    EAX, Param
    XOR    EBX, EBX
    XOR    ECX, ECX
    XOR    EDX, EDX
    CPUID
    MOV    TRegisters(EDI).&EAX, EAX
    MOV    TRegisters(EDI).&EBX, EBX
    MOV    TRegisters(EDI).&ECX, ECX
    MOV    TRegisters(EDI).&EDX, EDX
    POP    RDI
    POP    RBX
    end;
{$ELSE}
  asm      // x32 version
    PUSH    EBX
    PUSH    EDI
    MOV    EDI, Registers
    XOR    EBX, EBX
    XOR    ECX, ECX
    XOR    EDX, EDX
    CPUID
    MOV    TRegisters(EDI).&EAX, EAX
    MOV    TRegisters(EDI).&EBX, EBX
    MOV    TRegisters(EDI).&ECX, ECX
    MOV    TRegisters(EDI).&EDX, EDX
    POP    EDI
    POP    EBX
  end;
{$ENDIF}

function GetCPUInfo: T_CPU_Info;
var
    sysinfo : _SYSTEM_INFO;
    Buffer : PSYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX;
    current_info :  PSYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX;
    ByteCount : WinApi.Windows.DWORD;
    RelationshipType: LOGICAL_PROCESSOR_RELATIONSHIP;
    offset : integer;
    res: boolean;
    statex: MEMORYSTATUSEX;

begin

  statex.dwLength := sizeof(statex);
  GlobalMemoryStatusEx(statex);
  Result.RAMSize := statex.ullTotalPhys;

  Result.logical_cores  := 0;
  Result.physical_cores := 0;
  Result.L1CacheSize := 0;
  Result.L2CacheSize := 0;
  Result.L3CacheSize := 0;

//  RelationshipType := RelationProcessorCore;
//  RelationshipType := RelationNumaNode;
//  RelationshipType := RelationCache;
//  RelationshipType := RelationProcessorPackage;
//  RelationshipType := RelationGroup;
  RelationshipType := RelationAll;

  res := GetLogicalProcessorInformationEx(
    RelationshipType,
    nil,
    @ByteCount
  );

  GetMem(Buffer, ByteCount);

  res := GetLogicalProcessorInformationEx(
    RelationshipType,
    @(Buffer^),
    @ByteCount
  );

  offset := 0;

  while (offset < ByteCount) do
  begin
    current_info := PSYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX( UInt64(buffer) + offset);
    offset := offset + current_info^.size;

    if Current_info.Relationship = RelationProcessorCore
    then
      inc(Result.physical_cores);

    if current_info.Relationship = RelationCache then
    begin
      case current_info.Cache.Level of
      1: Result.L1CacheSize := Result.L1CacheSize + current_info.Cache.CacheSize;
      2: Result.L2CacheSize := Result.L2CacheSize + current_info.Cache.CacheSize;
      3: Result.L3CacheSize := Result.L3CacheSize + current_info.Cache.CacheSize;
      end; // of CASE
    end;

  end;

  GetSystemInfo(sysinfo);
  Result.logical_cores :=  sysinfo.dwNumberOfProcessors;

end;

function GetCPUName: AnsiString;
var
  Registers:TRegisters;
  _EAX: LongWord;
  FamilyID, ExtFamilyID, ModelID, ExtModelID, ProcType, Stepping: LongWord;
begin
  Result:='';

  if not IsCPUID_Available then begin
    Result := 'CPUID not supported';
    Exit;
  end;

  // get general CPU info
  GetCPUID( $00000000,Registers );

  // Its fantastic! general info stored at mixed order:  EBX:EDX:ECX
  Result := Result + Registers.Str2+Registers.Str4+Registers.Str3 + ': ';

  // Get extended info string
  for _EAX := $80000002 to $80000004 do
  begin
    GetCPUID( _EAX ,Registers);
    Result := Result + Registers.Str;
  end;
end;

function GetExtendeCPUInfo: AnsiString;
var
  Registers:TRegisters;
  MaxEAX,_EAX: LongWord;
  FamilyID, ExtFamilyID, ModelID, ExtModelID, ProcType, Stepping: LongWord;
begin
  // get Family, Model and Stepping of CPU
  Result:='';
  if not IsCPUID_Available then begin
    Result := 'CPUID not supported';
    Exit;
  end;

  // steppings are stored at $00000001 "offset"
  GetCPUID($00000001,Registers);

  Stepping    := (Registers.EAX shr 0 ) and  $0F;
  ModelID     := (Registers.EAX shr 4 ) and  $0F;
  FamilyID    := (Registers.EAX shr 8 ) and  $0F;
  ProcType    := (Registers.EAX shr 12) and  $03;
  ExtModelID  := (Registers.EAX shr 16) and $0F;
  ExtFamilyID := (Registers.EAX shr 20) and $FF;

  Result := Result + Format('Family %x(%x), Model %x(%x), ID %x, Stepping %x',
                            [FamilyID, ExtFamilyID, ModelID, ExtModelID,
                             ProcType, Stepping]  )
end;

function GetCPUUsage: real;
type
  SYSTEM_BASIC_INFORMATION = {$IFDEF WIN32}packed {$ENDIF} record
    AlwaysZero : ULONG;
    uKeMaximumIncrement : ULONG;
    uPageSize : ULONG;
    uMmNumberOfPhysicalPages : ULONG;
    uMmLowestPhysicalPage : ULONG;
    uMmHighestPhysicalPage : ULONG;
    uAllocationGranularity : ULONG;
    pLowestUserAddress : POINTER;
    pMmHighestUserAddress : POINTER;
    uKeActiveProcessors : POINTER;
    bKeNumberProcessors : byte;
    Filler : array [0..2] of byte;
  end;

  SYSTEM_TIME_INFORMATION = {$IFDEF WIN32}packed {$ENDIF} record
    nKeBootTime : int64;
    nKeSystemTime : int64;
    nExpTimeZoneBias : int64;
    uCurrentTimeZoneId : ULONG;
    dwReserved : DWORD;
  end;

  SYSTEM_PERFORMANCE_INFORMATION = {$IFDEF WIN32}packed {$ENDIF} record
    nIdleTime : int64;
    dwSpare : array [0..75] of DWORD;
  end;

const
  SystemBasicInformation = 0;
  SystemTimeOfDayInformation = 3;
  SystemPerformanceInformation = 2;
var
  SBI : SYSTEM_BASIC_INFORMATION;
  STI : SYSTEM_TIME_INFORMATION;
  SPI : SYSTEM_PERFORMANCE_INFORMATION;
  ERROR_CODE: cardinal;
  dummy : DWORD;
begin
  result := -1.0;

  ERROR_CODE :=  NTQuerySystemInformation (SystemBasicInformation,
                              @SBI,
                              SizeOf (SYSTEM_BASIC_INFORMATION),
                              dummy);
  if ERROR_CODE <> NO_ERROR then exit;

  ERROR_CODE := NTQuerySystemInformation (SystemTimeOfDayInformation,
                                @STI,
                                SizeOf (SYSTEM_TIME_INFORMATION),
                                dummy);

  if ERROR_CODE <> NO_ERROR then exit;

  ERROR_CODE := NTQuerySystemInformation (SystemPerformanceInformation,
                                @SPI,
                                SizeOf (SYSTEM_PERFORMANCE_INFORMATION),
                                dummy);

  if ERROR_CODE <> NO_ERROR then exit;

  if (nOldIdleTime <> 0) then
  begin
    nNewCPUTime :=  1.0 -
       (SPI.nIdleTime - nOldIdleTime) /
        ( (STI.nKeSystemTime - nOldSystemTime) * SBI.bKeNumberProcessors ) ;

    if (nNewCPUTime <> nOldIdleTime) then
      result := nNewCPUTIME;
    if result < 0.0 then result := 0.0;

  end;

  nOldIdleTime := SPI.nIdleTime;
  nOldSystemTime := STI.nKeSystemTime;
end;

function GetProcessMem: Integer;
var cb: cardinal;
    ProcHandle : THandle;
    i: integer;
    CurrUsage: double;
begin

///  add  Winapi.PsAPI to "uses" list
///  pmc: PPROCESS_MEMORY_COUNTERS; declared as global var
///
///  add to initialization code
///  *******
///  cb := SizeOf(_PROCESS_MEMORY_COUNTERS);
///  GetMem(pmc, cb);
///  pmc^.cb := cb;
///  ****

  cb := SizeOf(_PROCESS_MEMORY_COUNTERS);
  if pmc = nil then begin
    GetMem(pmc, cb);
    pmc^.cb := cb;
  end;

  ProcHandle := GetCurrentProcess();

  if GetProcessMemoryInfo( ProcHandle, pmc, cb) then
    result := pmc^.WorkingSetSize
  else
    Result := -1;
end;

end.
