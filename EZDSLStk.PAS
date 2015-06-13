{===EZDSLSTK==========================================================

Part of the Delphi Structures Library--the stack.

Copyright (c) 1993-2015, Julian M Bucknall
All rights reserved.

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are 
met:

1. Redistributions of source code must retain the above copyright 
notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright 
notice, this list of conditions and the following disclaimer in the 
documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its 
contributors may be used to endorse or promote products derived from 
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=====================================================================}

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
