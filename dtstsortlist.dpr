program Dtstsortlist;
  {-Test program for sorting single/double/skip lists}

{$I EZDSLDEF.INC}
{---Place any compiler options you require here-----------------------}


{---------------------------------------------------------------------}
{$I EZDSLOPT.INC}

{$IFDEF Win32}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  {$IFDEF Win32}
  Windows,
  {$ELSE}
  WinProcs,
  WinTypes,
  {$ENDIF}
  SysUtils,
  EZDSLCts in 'EZDSLCTS.PAS',
  EZDSLBse in 'EZDSLBSE.PAS',
  EZDSLLst in 'EZDSLLST.PAS',
  EZDSLDbl in 'EZDSLDBL.PAS',
  EZDSLSkp in 'EZDSLSKP.PAS',
  EZDSLSup in 'EZDSLSUP.PAS',
  DTstGen in 'DTstGen.pas';

function PrintStrs(C : TAbstractContainer;
                   aData : pointer;
                   ExtraData : pointer) : boolean; far;
  var
    S : PEZString absolute aData;
  begin
    Result := true;
    WriteLog(S^);
  end;

function StrCompRev(Data1, Data2 : pointer) : integer; far;
begin
  Result := EZStrCompare(Data2, Data1);
end;

var
  i : integer;
  LinkList, NewLinkList : TLinkList;
  DList, NewDList : TDList;
  SkipList, NewSkipList : TSkipList;
  S : PEZString;
  SavedS : string;
  Cursor    : TListCursor;
begin
  OpenLog;
  try
    WriteLog('Starting tests');

    WriteLog('-----------SINGLE LINKED LIST (unsorted)-----------');
    LinkList := nil;
    try
      WriteLog('First test: insertion & deletion');
      LinkList := TLinkList.Create(true);
      with LinkList do
        begin
          DupData := EZStrDupData;
          DisposeData := EZStrDisposeData;
          WriteLog('...inserting names of numbers');
          for i := 1 to 30 do
            InsertAfter(EZStrNew(NumToName(i)));
          WriteLog('...iterating them (should read ten..one)');
          Iterate(PrintStrs, false, nil);
          WriteLog('...setting the compare method to for a sort');
          Compare := EZStrCompare;
          WriteLog('...iterating them (should read ten..one, sorted)');
          Iterate(PrintStrs, false, nil);
          WriteLog('...iterating them backwards (should read ten..one, sorted)');
          Iterate(PrintStrs, true, nil);
          Empty;
          Iterate(PrintStrs, false, nil);
          WriteLog('...end of test 1');
        end;
    finally
      LinkList.Free;
    end;


    WriteLog('-----------DOUBLY LINKED LIST (unsorted)-----------');
    DList := nil;
    try
      WriteLog('First test: insertion & deletion');
      DList := TDList.Create(true);
      with DList do
        begin
          DupData := EZStrDupData;
          DisposeData := EZStrDisposeData;
          WriteLog('...inserting names of numbers');
          for i := 1 to 30 do
            InsertAfter(SetBeforeFirst, EZStrNew(NumToName(i)));
          WriteLog('...iterating them (should read ten..one)');
          Iterate(PrintStrs, false, nil);
          WriteLog('...setting the compare method to for a sort');
          Compare := EZStrCompare;
          WriteLog('...iterating them (should read ten..one, sorted)');
          Iterate(PrintStrs, false, nil);
          WriteLog('...iterating them backwards (should read ten..one, sorted)');
          Iterate(PrintStrs, true, nil);
          Empty;
          Iterate(PrintStrs, false, nil);
          WriteLog('...end of test 2');
        end;
    finally
      DList.Free;
    end;


    WriteLog('-----------SKIPLIST (sorted)-----------');
    SkipList := nil;
    try
      WriteLog('First test: insertion & deletion');
      SkipList := TSkipList.Create(true);
      with SkipList do
        begin
          DupData := EZStrDupData;
          DisposeData := EZStrDisposeData;
          Compare := EZStrCompare;
          WriteLog('...inserting names of numbers');
          for i := 1 to 30 do
            Insert(Cursor, EZStrNew(NumToName(i)));
          WriteLog('...iterating them (should read ten..one, sorted)');
          Iterate(PrintStrs, false, nil);
          WriteLog('...setting the compare method to for a sort');
          Compare := StrCompRev;
          WriteLog('...iterating them (should read ten..one, reverse sorted)');
          Iterate(PrintStrs, false, nil);
          WriteLog('...iterating them backwards (should read ten..one, sorted)');
          Iterate(PrintStrs, true, nil);
          WriteLog('...inserting names of numbers + x');
          for i := 1 to 30 do
            Insert(Cursor, EZStrNew(NumToName(i)+'x'));
          WriteLog('...iterating them (should read ten..one, reverse sorted)');
          Iterate(PrintStrs, false, nil);
          Empty;
          Iterate(PrintStrs, false, nil);
          WriteLog('...end of test 3');
        end;
    finally
      LinkList.Free;
    end;

  finally
    CloseLog;
  end;
end.

