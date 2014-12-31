program tstdslrnd;

{$APPTYPE CONSOLE}

uses
  EZDSLRnd;

type
  PLA = ^TLA;
  TLA = array [0..1023] of longint;

var
  RG : TEZRandomGenerator;
  F  : file;
  i,j  : longint;
  LA : PLA;

begin
  Assign(F, 'test.dat');
  Rewrite(F, 1);
  try
    New(LA);
    RG := TEZRandomGenerator.Create;
    try
      RG.SetSeed(12);
      for i := 1 to 3000 do begin
        for j := 0 to 1023 do begin
          LA[j] := RG.RandomDWord;
        end;
        BlockWrite(F, LA^, sizeof(LA^));
      end;
    finally
      RG.Free;
      Dispose(LA);
    end;
  finally
    Close(F);
  end;
end.
