{===EZDSLSTK==========================================================

Part of the Delphi Structures Library--the stack.

EZDSLSTK is Copyright (c) 1993-2011 by  Julian M. Bucknall

VERSION HISTORY
02Jul11 JMB 3.04 Release for Delphi XE
28Feb01 JMB 3.03 Release for Kylix and Delphi 6
24Oct99 JMB 3.02 Release for Delphi 4 & 5
19Apr98 JMB 3.00 Major new version, release for Delphi 3
13Mar96 JMB 2.00 release for Delphi 2.0
18Jun95 JMB 1.00 conversion of EZStrucs to Delphi
=====================================================================}
{ Copyright (c) 1993-2002, Julian M. Bucknall. All Rights Reserved   }

unit EzdslStk;

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
  TStack = class(TAbstractContainer)
    {-Stack object}
    private
      stHead : PNode;

    public
      constructor Create(DataOwner : boolean); override;
      constructor Clone(Source     : TAbstractContainer;
                        DataOwner  : boolean;
                        NewCompare : TCompareFunc); override;

      procedure Empty; override;
      function Examine : pointer;
      function Pop : pointer;
      procedure Push(aData : pointer);
  end;

{$IFDEF ThreadsExist}
type
  TThreadsafeStack = class
    protected {private}
      sStack : TStack;
      sResLock  : TezResourceLock;
    protected
    public
      constructor Create(aDataOwner : boolean);
      destructor Destroy; override;

      function AcquireAccess : TStack;
      procedure ReleaseAccess;
  end;
{$ENDIF}

implementation

{===TStack===========================================================}
constructor TStack.Create(DataOwner : boolean);
begin
  acNodeSize := 2 * sizeof(pointer);
  inherited Create(DataOwner);
  stHead := acNewNode(nil);
  stHead^.Link := stHead;
  acCount := 0;
end;
{--------}
constructor TStack.Clone(Source : TAbstractContainer;
                         DataOwner : boolean; NewCompare : TCompareFunc);
var
  JoinNode,
  NewNode,
  Node     : PNode;
  OldStack : TStack absolute Source;
  NewData  : pointer;
begin
  Create(DataOwner);
  Compare := NewCompare;
  DupData := OldStack.DupData;
  DisposeData := OldStack.DisposeData;

  if not (Source is TStack) then
    RaiseError(escBadSource);

  if OldStack.IsEmpty then Exit;

  JoinNode := stHead;
  Node := OldStack.stHead^.Link;
  while (Node <> OldStack.stHead) do begin
    if DataOwner then
      NewData := DupData(Node^.Data)
    else
      NewData := Node^.Data;
    try
      NewNode := acNewNode(NewData);
      NewNode^.Link := JoinNode^.Link;
      JoinNode^.Link := NewNode;
      JoinNode := NewNode;
      Node := Node^.Link;
    except
      if DataOwner and Assigned(NewData) then
        DisposeData(NewData);
      raise;
    end;{try..except}
  end;
end;
{--------}
procedure TStack.Empty;
begin
  if IsDataOwner then begin
    while not IsEmpty do
      DisposeData(Pop)
  end
  else begin
    while not IsEmpty do
      Pop;
  end;
  if acInDone then
    if Assigned(stHead) then
      acDisposeNode(stHead);
end;
{--------}
function TStack.Examine : pointer;
begin
  {$IFDEF DEBUG}
  EZAssert(not IsEmpty, ascEmptyExamine);
  {$ENDIF}
  Result := stHead^.Link^.Data;
end;
{--------}
function TStack.Pop : pointer;
var
  Node : PNode;
begin
  {$IFDEF DEBUG}
  EZAssert(not IsEmpty, ascEmptyPop);
  {$ENDIF}
  Node := stHead^.Link;
  stHead^.Link := Node^.Link;
  Result := Node^.Data;
  acDisposeNode(Node);
end;
{--------}
procedure TStack.Push(aData : pointer);
var
  Node : PNode;
begin
  Node := acNewNode(aData);
  Node^.Link := stHead^.Link;
  stHead^.Link := Node;
end;
{====================================================================}


{$IFDEF ThreadsExist}
{===TThreadsafeStack=================================================}
constructor TThreadsafeStack.Create(aDataOwner : boolean);
begin
  inherited Create;
  sResLock := TezResourceLock.Create;
  sStack := TStack.Create(aDataOwner);
end;
{--------}
destructor TThreadsafeStack.Destroy;
begin
  sStack.Free;
  sResLock.Free;
  inherited Destroy;
end;
{--------}
function TThreadsafeStack.AcquireAccess : TStack;
begin
  sResLock.Lock;
  Result := sStack;
end;
{--------}
procedure TThreadsafeStack.ReleaseAccess;
begin
  sResLock.Unlock;
end;
{====================================================================}
{$ENDIF}

end.
