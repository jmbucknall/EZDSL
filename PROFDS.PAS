program Profile;

{$DEFINE DEBUG}
{$I BP7DIREC.INC}
uses
  JTimes,
  Objects,
  DS;


type
  PMyQueue = ^TMyQueue;
  TMyQueue = object(TQueue)
    procedure DisposeData(aData : pointer); virtual;
  end;

procedure TMyQueue.DisposeData(aData : pointer);
  begin
    {nothing}
  end;


var
  Queue : PMyQueue;

  i : integer;

  StartMA,
  MaxMem,
  Value : longint;
  T     : ttime;

begin

  T := TimeNow;
  StartMA := MemAvail;

  writeln('Queue TEST');
  Queue := New(PMyQueue, Init);

  for i := 1 to 20000 do
    begin
      Value := Random(1000);
      Queue^.Put(pointer(Value));
    end;

  MaxMem := MemAvail;

  while not Queue^.IsEmpty do
    Value := longint(Queue^.Pop);

  Dispose(Queue, Done);

  writeln('Start time: ', TimeStr(T, tfFull));
  writeln('       End: ', TimeStr(TimeNow, tfFull));

  writeln('Start mem: ', StartMA);
  writeln(' used mem: ', MaxMem);
  writeln('  end mem: ', MemAvail);
end.