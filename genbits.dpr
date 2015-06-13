program genbits;

uses
  SysUtils;

var
  b : byte;
  i, j, count, items : integer;
  F : text;

begin
  Assign(F, 'EZBitCnt.INC');
  Rewrite(F);
  writeln(F, '{*********************************************************}');
  writeln(F, '{* EZBITCNT.INC                                          *}');
  writeln(F, '{* Copyright (c) Julian M Bucknall 1998-2015             *}');
  writeln(F, '{* All rights reserved.                                  *}');
  writeln(F, '{* Version: 3.10                                         *}');
  writeln(F, '{*********************************************************}');
  writeln(F, '{* Counts of set bits in bytes (auto-generated)          *}');
  writeln(F, '{*********************************************************}');
  writeln(F);
  writeln(F, 'type');
  writeln(F, '  TBitCountArray = array [byte] of byte;');
  writeln(F, 'const');
  writeln(F, '  BitCount : TBitCountArray = (');
  items := 0;
  for i := 0 to 255 do begin
    if items = 0 then
      write(F, '     ');
    b := i;
    count := 0;
    for j := 1 to 8 do begin
      inc(count, b and 1);
      b := b shr 1;
    end;
    if i = 255 then
      write(F, count, ');')
    else
      write(F, count, ', ');
    inc(Items);
    if items = 16 then begin
      items := 0;
      writeln(F);
    end;
  end;
  Close(F);
end.
