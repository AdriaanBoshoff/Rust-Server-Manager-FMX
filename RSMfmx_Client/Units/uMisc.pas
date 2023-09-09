unit uMisc;

interface

function ConvertBytes(Bytes: Int64): string;

function GetDirSize(dir: string; subdir: Boolean): Int64;

implementation

uses
  System.SysUtils, System.Math;

function GetDirSize(dir: string; subdir: Boolean): Int64;
var
  rec: TSearchRec;
  found: Integer;
begin
  Result := 0;
  if dir[Length(dir)] <> '\' then
    dir := dir + '\';
  found := FindFirst(dir + '*.*', faAnyFile, rec);
  while found = 0 do
  begin
    Inc(Result, rec.Size);
    if (rec.Attr and faDirectory > 0) and (rec.Name[1] <> '.') and (subdir = True) then
      Inc(Result, GetDirSize(dir + rec.Name, True));
    found := FindNext(rec);
  end;
  FindClose(rec);
end;

function ConvertBytes(Bytes: Int64): string;
const
  Description: array[0..8] of string = ('B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB');
var
  i: Int64;
begin
  i := 0;

  while Bytes > Power(1024, i + 1) do
    Inc(i);

  Result := FormatFloat('###0.##', Bytes / IntPower(1024, i)) + ' ' + Description[i];
end;

end.

