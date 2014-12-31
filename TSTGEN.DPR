program tstgen;

{$APPTYPE CONSOLE}

uses
  DTstGen;

var
  i : integer;
  pagecount : integer;

begin
  pagecount := 0;
  for i := 0 to 999999 do
    begin
      writeln(NumToName(i));
      inc(PageCount);
      if (PageCount = 20) then
        begin
          {readln;}
          PageCount := 0;
        end;
    end;
  readln;
end.
