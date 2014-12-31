program Project1;

{$IFDEF Win32}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
{$IFDEF Win32}
  Windows,
{$ELSE}
  Wincrt, wintypes, winprocs,
{$ENDIF}
  SysUtils,
  Classes;

procedure HashElf(var Digest : LongInt; const Buf;  BufSize : LongInt);
var
  Bytes : TByteArray absolute Buf;
  I, X  : LongInt;
begin
  Digest := 0;
  for I := 0 to BufSize - 1 do begin
    Digest := (Digest shl 4) + Bytes[I];
    X := Digest and $F0000000;
    if (X <> 0) then
      Digest := Digest xor (X shr 24);
    Digest := Digest and (not X);
  end;
end;

function StringHashElf(const Str : string) : LongInt;
begin
  HashElf(Result, Str[1], Length(Str));
end;

function HashELFJ(const S : string) : longint;
{Note: this hash function is described in "Practical Algorithms For
       Programmers" by Andrew Binstock and John Rex, Addison Wesley,
       with modifications in Dr Dobbs Journal, April 1996}
var
  G : longint;
  i : integer;
begin
  Result := 0;
  for i := 1 to length(S) do begin
    Result := (Result shl 4) + ord(S[i]);
    G := Result and $F0000000;
    if (G <> 0) then
      Result := Result xor (G shr 24);
    Result := Result and (not G);
  end;
end;

function RandomString : string;
var
  i : integer;
begin
  Result := '';
  for i := 1 to Random(10) + 5 do
    Result := Result + char(ord('A') + random(26));
end;

var
  i,j : integer;
  S : TStringList;
  StartTime : longint;

begin
  writeln('Creating strings');
  S := TStringList.Create;
  try
    for i := 0 to 999 do
      S.Add(RandomString);
    writeln('Doing tests...');
    StartTime := GetTickCount;
    for j := 1 to 2000 do
      for i := 0 to 999 do
        HashElfJ(S[i]);
    writeln(GetTickCount - StartTime);
    StartTime := GetTickCount;
    for j := 1 to 2000 do
      for i := 0 to 999 do
        StringHashElf(S[i]);
    writeln(GetTickCount - StartTime);
  finally
    S.Free;
  end;
  readln;
end.
