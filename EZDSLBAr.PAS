{===EZDSLBAR==========================================================

Part of the EZ Delphi Structures Library--the boolean array

EZDSLBAR is Copyright (c) 1999-2011 by  Julian M. Bucknall

VERSION HISTORY
02Jul11 JMB 3.04 Release for Delphi XE
12Feb02 JMB 3.03 Release for Delphi 6
24Oct99 JMB 3.02 Release for Delphi 4 & 5
14May98 JMB 3.01 Initial release
=====================================================================}
{ Copyright (c) 1993-2002, Julian M. Bucknall. All Rights Reserved   }

unit EzdslBar;

{$I EzdslDef.inc}
{---Place any compiler options you require here----------------------}


{--------------------------------------------------------------------}
{$I EzdslOpt.inc}

interface

uses
  SysUtils,
  {$IFDEF Windows}
  WinTypes,
  WinProcs,
  {$ENDIF}
  {$IFDEF Win32}
  Windows,
  {$ENDIF}
  {$IFDEF Linux}
  Types,
  Libc,
  {$ENDIF}
  Classes,
  {$IFDEF ThreadsExist}
  EzdslThd,
  {$ENDIF}
  EzdslCts,
  EzdslSup,
  EzdslBse;

type
  TezBooleanArray = class;

  TezBooleanArrayIterator = function(C : TezBooleanArray;
                                     aIndex : longint;
                                     ExtraData : pointer) : boolean;

  TezBooleanArray = class(TPersistent)
    {-BooleanArray}
    private
      baArray      : PByteArray;
      baArrayOwner : boolean;
      baArraySize  : longint;
      baCapacity   : longint;
      baCount      : longint;
      baCleanMask  : byte;                                     {!!.03}

    protected
      function baGetFlag(aInx : longint) : boolean;
      procedure baSetFlag(aInx : longint; aValue : boolean);
      procedure baSetCapacity(aCapacity : longint);

      procedure baCalcCleanMask;
      function baIterateFwd(aFromInx   : longint;
                            aValue     : boolean;
                            aAction    : TezBooleanArrayIterator;
                            aExtraData : pointer) : longint;
      function baIterateBkwd(aFromInx   : longint;
                             aValue     : boolean;
                             aAction    : TezBooleanArrayIterator;
                             aExtraData : pointer) : longint;
      procedure baRecount;
    public
      constructor Create(aCapacity : longint);
        {-create a new boolean array, aCapacity is the number of
          boolean values in the array}
      destructor Destroy; override;
        {-destroy the boolean array}

      procedure SwitchArrays(aNewArray   : PByteArray;
                             aCapacity   : longint);
        {-make the boolean array use another memory block for its
          values, of aCapacity bits}

      procedure AndArray(aArray : TezBooleanArray);
        {-OR a boolean array with this one}
      procedure OrArray(aArray : TezBooleanArray);
        {-AND a boolean array with this one}
      procedure XorArray(aArray : TezBooleanArray);
        {-XOR a boolean array with this one}

      function Iterate(aAction    : TezBooleanArrayIterator;
                       aValue     : boolean;
                       aBackwards : boolean;
                       aExtraData : pointer) : longint;
        {-iterate through the true booleans (aValue = true) or false
          ones, forwards or not (aBackwards), calling aAction for
          each, passing aExtraDatato the action function. Returns
          either the first boolean index for which the action function
          returned false, or -1 if none did}

      function FirstFalse : longint;
        {-return the index of the first false boolean}
      function FirstTrue : longint;
        {-return the index of the first true boolean}
      function LastFalse : longint;
        {-return the index of the last false boolean}
      function LastTrue : longint;
        {-return the index of the last true boolean}
      function NextFalse(aFromInx : longint) : longint;
        {-return the index of the next false boolean from the given
          boolean}
      function NextTrue(aFromInx : longint) : longint;
        {-return the index of the next true boolean from the given
          boolean}
      function PrevFalse(aFromInx : longint) : longint;
        {-return the index of the previous false boolean from the
          given boolean}
      function PrevTrue(aFromInx : longint) : longint;
        {-return the index of the previous true boolean from the given
          boolean}
      procedure SetAllFalse;
        {-set all booleans in array to false}
      procedure SetAllTrue;
        {-set all booleans in array to true}
      function Toggle(aInx : longint) : boolean;
        {-toggle the given boolean from false to true or vice versa}
      procedure ToggleAll;
        {-toggle all booleans from false to true or vice versa}

      property Flag[aInx : longint] : boolean read baGetFlag write baSetFlag; default;
        {-the array of booleans}
      property Count : longint read baCount;
        {-the number of true booleans}
      property Capacity : longint read baCapacity write baSetCapacity;
        {-the total number of booleans in the array}
  end;

{$IFDEF ThreadsExist}
type
  TezThreadsafeBooleanArray = class
    protected {private}
      baBooleanArray  : TezBooleanArray;
      baResLock : TezResourceLock;
    protected
    public
      constructor Create(aCapacity : longint);
      destructor Destroy; override;

      function AcquireAccess : TezBooleanArray;
      procedure ReleaseAccess;
  end;
{$ENDIF}

{Compatibility types}
type
  TBooleanArray = TezBooleanArray;
  {$IFDEF ThreadsExist}
  TThreadsafeBooleanArray = TezThreadsafeBooleanArray;
  {$ENDIF}

implementation

const
  Mask : array [0..7] of byte =
         ($01, $02, $04, $08, $10, $20, $40, $80);

{===Handy iterators==================================================}
function AlwaysStop(C : TezBooleanArray;
                    aIndex : longint;
                    ExtraData : pointer) : boolean; far;
begin
  Result := false;
end;
{====================================================================}


{===TezBooleanArray==================================================}
constructor TezBooleanArray.Create(aCapacity : longint);
begin
  inherited Create;
  if (aCapacity <> 0) then
    baSetCapacity(aCapacity);
end;
{--------}
destructor TezBooleanArray.Destroy;
begin
  if baArrayOwner and (baArray <> nil) then
    baSetCapacity(0);
  inherited Destroy;
end;
{--------}
procedure TezBooleanArray.AndArray(aArray : TezBooleanArray);
var
  i : integer;
begin
  {$IFDEF DEBUG}
  EZAssert(aArray <> nil, ascNilArray);
  EZAssert(Capacity = aArray.Capacity, ascNotSameSize);
  {$ENDIF}
  for i := 0 to pred(baArraySize) do
    baArray^[i] := baArray^[i] and aArray.baArray^[i];
  baArray^[pred(baArraySize)] :=                               {!!.03}
    baArray^[pred(baArraySize)] and baCleanMask;               {!!.03}
  baRecount;                                                   {!!.03}
end;
{--------}                                                 {new !!.03}
procedure TezBooleanArray.baCalcCleanMask;
var
  i : integer;
begin
  {calculate the "clean" mask for the last byte; we shall use this to
   clean up the bits in the last byte, ensuring that any unused bits
   are clear; this makes baRecount as fast as possible}
  if (baCapacity = 0) then
    baCleanMask := 0
  else if ((baCapacity mod 8) = 0) then
    baCleanMask := $FF
  else begin
    baCleanMask := 0;
    for i := 0 to pred(baCapacity mod 8) do
      inc(baCleanMask, Mask[i]);
  end;
end;
{--------}
function TezBooleanArray.baGetFlag(aInx : longint) : boolean;
begin
  if (aInx < 0) or (aInx >= Capacity) then
    RaiseError(escBadBooleanInx);
  if (baArray = nil) then
    Result := false
  else                                                         {!!.03}
    Result := (baArray^[aInx div 8] and Mask[aInx mod 8]) <> 0;{!!.03}
end;
{--------}
function TezBooleanArray.baIterateFwd(aFromInx   : longint;
                                      aValue     : boolean;
                                      aAction    : TezBooleanArrayIterator;
                                      aExtraData : pointer) : longint;
var
  FullBytes : longint;
  ByteStart : longint;
  FirstBits : integer;
  Bit       : longint;
  i         : longint;
  CurByte   : byte;
begin
  {do the first 1 to 7 booleans first}
  ByteStart := (aFromInx+7) shr 3;
  FirstBits := aFromInx and $7;
  if (FirstBits <> 0) then begin
    for Bit := aFromInx to (aFromInx - FirstBits + 7) do
      if (Flag[Bit] = aValue) then
        if not aAction(Self, Bit, aExtraData) then begin
          Result := Bit;
          Exit;
        end;
  end;
  {do the complete bytes next}
  FullBytes := Capacity shr 3;
  for i := ByteStart to pred(FullBytes) do begin
    CurByte := baArray^[i];
    if (aValue and (CurByte <> 0)) or
       ((not aValue) and (CurByte <> $FF)) then begin
      for Bit := 0 to 7 do begin
        if (boolean(CurByte and 1) = aValue) then begin
          Result := (i shl 3) + Bit;
          if not aAction(Self, Result, aExtraData) then
            Exit;
        end;
        CurByte := CurByte shr 1;
      end;
    end;
  end;
  {now do the last 1 to 7 booleans}
  for Bit := (FullBytes * 8) to pred(Capacity) do
    if (Flag[Bit] = aValue) then
      if not aAction(Self, Bit, aExtraData) then begin
        Result := Bit;
        Exit;
      end;
  Result := -1;
end;
{--------}
function TezBooleanArray.baIterateBkwd(aFromInx   : longint;
                                       aValue     : boolean;
                                       aAction    : TezBooleanArrayIterator;
                                       aExtraData : pointer) : longint;
var
  FullBytes : longint;
  Bit       : longint;
  i         : longint;
  CurByte   : byte;
begin
  FullBytes := (aFromInx+1) shr 3;
  {do the last 1 to 7 booleans first, in reverse order}
  for Bit := aFromInx downto (FullBytes * 8) do
    if (Flag[Bit] = aValue) then
      if not aAction(Self, Bit, aExtraData) then begin
        Result := Bit;
        Exit;
      end;
  {now do the complete bytes in reverse order, and their bits in
   reverse order as well }
  for i := pred(Fullbytes) downto 0 do begin
    CurByte := baArray^[i];
    if (aValue and (CurByte <> 0)) or
       ((not aValue) and (CurByte <> $FF)) then begin
      for Bit := 7 downto 0 do begin
        if (((CurByte and $80) <> 0) = aValue) then begin
          Result := (i shl 3) + Bit;
          if not aAction(Self, Result, aExtraData) then
            Exit;
        end;
        CurByte := CurByte shl 1;
      end;
    end;
  end;
  Result := -1;
end;
{--------}
procedure TezBooleanArray.baRecount;
{$I EZBitCnt.INC}
var
  i        : longint;
  NewCount : longint;
begin
  {if there are no booleans, there can't be any true ones}
  if (Capacity = 0) then begin
    baCount := 0;
    Exit;
  end;
  {count in byte sized chunks; use local variable for speed}   {!!.03}
  NewCount := 0;                                               {!!.03}
  for i := 0 to pred(baArraySize) do                           {!!.03}
    inc(NewCount, BitCount[baArray^[i]]);                      {!!.03}
  baCount := NewCount;                                         {!!.03}
end;
{--------}
procedure TezBooleanArray.baSetFlag(aInx : longint; aValue : boolean);
var
  ByteNum : integer;
  BitNum  : integer;
begin
  if (aInx < 0) or (aInx >= Capacity) then
    RaiseError(escBadBooleanInx);
  if (baArray <> nil) then begin
    ByteNum := aInx div 8;
    BitNum := aInx mod 8;
    if aValue then begin
      if ((baArray^[ByteNum] and Mask[BitNum]) = 0) then begin
        inc(baCount);
        baArray^[ByteNum] := baArray^[ByteNum] or Mask[BitNum];
      end;
    end
    else begin
      if ((baArray^[ByteNum] and Mask[BitNum]) <> 0) then begin
        dec(baCount);
        baArray^[ByteNum] := baArray^[ByteNum] and (not Mask[BitNum]);
      end;
    end;
  end;
end;
{--------}
procedure TezBooleanArray.baSetCapacity(aCapacity : longint);
var
  NewArray : PByteArray;
  NewSize  : longint;
begin
  {$IFDEF DEBUG}
  EZAssert(aCapacity >= 0, ascBadCapacity);
  {$ENDIF}
  if (aCapacity = baCapacity) then
    Exit;
  if (aCapacity = 0) then begin
    NewSize := 0;
    NewArray := nil;
  end
  else begin
    NewSize := (aCapacity + 7) shr 3;
    GetMem(NewArray, NewSize);
    if (baArray = nil) then
      FillChar(NewArray^, NewSize, 0)
    else begin
      if (NewSize <= baArraySize) then
        Move(baArray^, NewArray^, NewSize)
      else begin
        FillChar(NewArray^[baArraySize],                       {!!.03}
                 NewSize - baArraySize, 0);                    {!!.03}
        Move(baArray^, NewArray^, baArraySize);
      end;
    end;
  end;
  if baArrayOwner and (baArray <> nil) then
    FreeMem(baArray, baArraySize);
  baArray := NewArray;
  baArraySize := NewSize;
  baCapacity := aCapacity;
  baArrayOwner := (aCapacity <> 0);
  baCalcCleanMask;                                             {!!.03}
end;
{--------}
function TezBooleanArray.Iterate(aAction    : TezBooleanArrayIterator;
                                 aValue     : boolean;
                                 aBackwards : boolean;
                                 aExtraData : pointer) : longint;
begin
  if (Capacity = 0) then
    Result := -1
  else begin
    if aBackwards then
      Result := baIterateBkwd(pred(Capacity), aValue, aAction, aExtraData)
    else
      Result := baIterateFwd(0, aValue, aAction, aExtraData)
  end;
end;
{--------}
function TezBooleanArray.FirstFalse : longint;
begin
  if (Capacity = 0) or (Count = Capacity) then
    Result := -1
  else
    Result := baIterateFwd(0, false, AlwaysStop, nil);
end;
{--------}
function TezBooleanArray.FirstTrue : longint;
begin
  if (Capacity = 0) or (Count = 0) then
    Result := -1
  else
    Result := baIterateFwd(0, true, AlwaysStop, nil);
end;
{--------}
function TezBooleanArray.LastFalse : longint;
begin
  if (Capacity = 0) or (Count = Capacity) then
    Result := -1
  else
    Result := baIterateBkwd(pred(Capacity), false, AlwaysStop, nil);
end;
{--------}
function TezBooleanArray.LastTrue : longint;
begin
  if (Capacity = 0) or (Count = 0) then
    Result := -1
  else
    Result := baIterateBkwd(pred(Capacity), true, AlwaysStop, nil);
end;
{--------}
function TezBooleanArray.NextFalse(aFromInx : longint) : longint;
begin
  inc(aFromInx);
  if (aFromInx < 0) or (aFromInx >= Capacity) then
    Result := -1
  else
    Result := baIterateFwd(aFromInx, false, AlwaysStop, nil);
end;
{--------}
function TezBooleanArray.NextTrue(aFromInx : longint) : longint;
begin
  inc(aFromInx);
  if (aFromInx < 0) or (aFromInx >= Capacity) then
    Result := -1
  else
    Result := baIterateFwd(aFromInx, true, AlwaysStop, nil);
end;
{--------}
procedure TezBooleanArray.OrArray(aArray : TezBooleanArray);
var
  i : integer;
begin
  {$IFDEF DEBUG}
  EZAssert(aArray <> nil, ascNilArray);
  EZAssert(Capacity = aArray.Capacity, ascNotSameSize);
  {$ENDIF}
  for i := 0 to pred(baArraySize) do
    baArray^[i] := baArray^[i] or aArray.baArray^[i];
  baArray^[pred(baArraySize)] :=                               {!!.03}
     baArray^[pred(baArraySize)] and baCleanMask;              {!!.03}
  baRecount;                                                   {!!.03}
end;
{--------}
function TezBooleanArray.PrevFalse(aFromInx : longint) : longint;
begin
  dec(aFromInx);
  if (aFromInx < 0) or (aFromInx >= Capacity) then
    Result := -1
  else
    Result := baIterateBkwd(aFromInx, false, AlwaysStop, nil);
end;
{--------}
function TezBooleanArray.PrevTrue(aFromInx : longint) : longint;
begin
  dec(aFromInx);
  if (aFromInx < 0) or (aFromInx >= Capacity) then
    Result := -1
  else
    Result := baIterateBkwd(aFromInx, true, AlwaysStop, nil);
end;
{--------}
procedure TezBooleanArray.SetAllFalse;
begin
  if (baArray <> nil) then begin
    FillChar(baArray^, baArraySize, 0);
    baCount := 0;
  end;
end;
{--------}
procedure TezBooleanArray.SetAllTrue;
begin
  if (baArray <> nil) then begin
    FillChar(baArray^, baArraySize, $FF);
    baArray^[pred(baArraySize)] :=                             {!!.03}
       baArray^[pred(baArraySize)] and baCleanMask;            {!!.03}
    baCount := baCapacity;
  end;
end;
{--------}
procedure TezBooleanArray.SwitchArrays(aNewArray   : PByteArray;
                                     aCapacity   : longint);
begin
  if baArrayOwner and (baCapacity <> 0) then
    baSetCapacity(0);
  if (aNewArray = nil) then begin
    baArray := nil;
    baArraySize := 0;
    baCapacity := 0;
    baArrayOwner := false;
    baCount := 0;
    baCleanMask := 0;
  end
  else begin
    baArray := aNewArray;
    baArraySize := (aCapacity + 7) shr 3;
    baCapacity := aCapacity;
    baArrayOwner := false;
    baCalcCleanMask;                                           {!!.03}
    baArray^[pred(baArraySize)] :=                             {!!.03}
       baArray^[pred(baArraySize)] and baCleanMask;            {!!.03}
    baRecount;
  end;
end;
{--------}
function TezBooleanArray.Toggle(aInx : longint) : boolean;
                                                     {rewritten !!.03}
var
  ByteNum : integer;
  BitNum : integer;
begin
  if (aInx < 0) or (aInx >= Capacity) then
    RaiseError(escBadBooleanInx);
  ByteNum := aInx div 8;
  BitNum := aInx mod 8;
  Result := (baArray^[ByteNum] and Mask[BitNum]) = 0;
  if Result then begin
    baArray^[ByteNum] := baArray^[ByteNum] or Mask[BitNum];
    inc(baCount)
  end
  else begin
    baArray^[ByteNum] := baArray^[ByteNum] and (not Mask[BitNum]);
    dec(baCount);
  end;
end;
{--------}
procedure TezBooleanArray.ToggleAll;
var
  i : longint;
begin
  if (baArray <> nil) then begin                               {!!.03}
    for i := 0 to pred(baArraySize) do
      baArray^[i] := not baArray^[i];
    baArray^[pred(baArraySize)] :=                             {!!.03}
       baArray^[pred(baArraySize)] and baCleanMask;            {!!.03}
    baRecount;                                                 {!!.03}
  end;                                                         {!!.03}
end;
{--------}
procedure TezBooleanArray.XorArray(aArray : TezBooleanArray);
var
  i : integer;
begin
  {$IFDEF DEBUG}
  EZAssert(aArray <> nil, ascNilArray);
  EZAssert(Capacity = aArray.Capacity, ascNotSameSize);
  {$ENDIF}
  for i := 0 to pred(baArraySize) do
    baArray^[i] := baArray^[i] xor aArray.baArray^[i];
  baArray^[pred(baArraySize)] :=                               {!!.03}
     baArray^[pred(baArraySize)] and baCleanMask;              {!!.03}
  baRecount;                                                   {!!.03}
end;
{====================================================================}


{$IFDEF ThreadsExist}
{===TezThreadsafeBooleanArray========================================}
constructor TezThreadsafeBooleanArray.Create(aCapacity : longint);
begin
  inherited Create;
  baResLock := TezResourceLock.Create;
  baBooleanArray := TezBooleanArray.Create(aCapacity);
end;
{--------}
destructor TezThreadsafeBooleanArray.Destroy;
begin
  baBooleanArray.Free;
  baResLock.Free;
  inherited Destroy;
end;
{--------}
function TezThreadsafeBooleanArray.AcquireAccess : TezBooleanArray;
begin
  baResLock.Lock;
  Result := baBooleanArray;
end;
{--------}
procedure TezThreadsafeBooleanArray.ReleaseAccess;
begin
  baResLock.Unlock;
end;
{====================================================================}
{$ENDIF}


end.
