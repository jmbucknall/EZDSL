program TstHash;

{$IFDEF Win32}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  EZDSLBse,
  ezdslHsh in 'ezdslHsh.pas';

var
  Hash : Cardinal;
  S : string;

begin
  S := 'the cat sat on the mat';
  Hash := HashPJW(S[1], length(S));
  writeln(Hash);
end.
