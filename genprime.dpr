program GenPrime;

uses
  SysUtils;

const
  PrimeLimit = 9999;

var
  Primes : array [1..PrimeLimit] of boolean;
  i, j, Count, PrimeCount, MaxPrime : integer;
  NewLine : boolean;
  F : text;
begin
  FillChar(Primes, sizeof(Primes), 1);
  Primes[1] := false;
  for i := 2 to PrimeLimit do begin
    if Primes[i] then begin
      j := i+i;
      while j <= PrimeLimit do begin
        Primes[j] := false;
        inc(j, i);
      end;
    end;
  end;
  PrimeCount := 0;
  for i := 1 to PrimeLimit do
    if Primes[i] then
      inc(PrimeCount);

  assign(F, 'EZPrimes.Inc');
  rewrite(F);
  writeln(F, '{*********************************************************}');
  writeln(F, '{* EZPrimes.INC                                          *}');
  writeln(F, '{* Copyright (c) Julian M Bucknall 1997-2015             *}');
  writeln(F, '{* All rights reserved.                                  *}');
  writeln(F, '{* Version: 3.10                                         *}');
  writeln(F, '{*********************************************************}');
  writeln(F, '{* Prime number array include file (auto-generated)      *}');
  writeln(F, '{*********************************************************}');
  writeln(F);
  writeln(F, 'const');
  writeln(F, '  PrimeCount = ', PrimeCount, ';');
  writeln(F, 'const');
  writeln(F, '  Primes : array [0..pred(PrimeCount)] of word = (');
  NewLine := true;
  j := 0;
  Count := 0;
  for i := 1 to PrimeLimit do begin
    if NewLine then begin
      write(F, '     ');
      NewLine := false;
    end;
    if Primes[i] then begin
      inc(Count);
      if (Count = PrimeCount) then begin
        write(F, i:4);
        MaxPrime := i;
      end
      else
        write(F, i:4, ', ');
      inc(j);
      if (j = 10) then begin
        writeln(F);
        j := 0;
        NewLine := true;
      end;
    end;
  end;
  if not NewLine then
    writeln(F);
  writeln(F, '    );');
  writeln(F, 'const');
  writeln(F, '  MaxPrime = ', MaxPrime, ';');
  close(F);
end.
