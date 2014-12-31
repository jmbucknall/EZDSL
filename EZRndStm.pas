{===EZRndStm==========================================================

This unit provides a set of routines to implement random number
streams. A random number stream is an independent random sequence
generator, implying than more than one can exist in a program. The
basic generator creates uniformly distributed pseudo-random numbers.

To use a random number stream, you first create a new one by calling
CreateRandStream. If you pass zero as the initial seed this will
randomize the stream based on the system clock (equivalent to
System.Randomize), otherwise the stream will be initialized to a known
repeatable state. Then call rsRandom (or rsRandomWord or
rsRandomLongint) to get the next random number from the stream
(rsRandom is equivalent to System.Random). Once you have finished with
the random number stream you call DestroyRandStream and this will free
any memory allocated to the stream.

If you wish to reinitialize a random number stream, destroy it and
create a new one. You can have as many random number streams as memory
will allow, each takes 222 bytes of heap.

The ancillary unit EZRNDDST uses these random streams to generate
random numbers with other distributions.

According to Knuth the internal generator has a cycle of 2^55 - 1.
It's also slightly faster than the standard System unit one, and uses
no data segment space.

References
  Random bit generator from Numerical Recipes in Pascal
  Random table algorithm from Sedgewick: Algorithms
  Random number test algorithms from Knuth: Seminumerical Algorithms
  Other distributions from Knuth again, and
       Watkins: Discrete Event Simulation in C

EZRndStm is Copyright (c) 1994,1997 Julian M. Bucknall

VERSION HISTORY
26Sep97 JMB 3.00 Major new version, release for Delphi 3
13Mar96 JMB 2.00 release for Delphi 2.0
18Jun95 JMB 1.00 initial release
======================================================================}

unit EZRndStm;

{ Undefine this if you don't want debugging info }
{.$DEFINE DEBUG}

{$IFNDEF VER70}
{$IFNDEF VER80} {$IFNDEF VER90} {$IFNDEF VER100}
!! Error - this unit is for BP7 and Delphi 1.0/2.0/3.0 only
{$ENDIF} {$ENDIF} {$ENDIF}
{$ENDIF}

{$DEFINE Delphi}
{$IFDEF VER70}
{$UNDEF Delphi}
{$ENDIF}

{------Fixed compiler switches----------------------------------------}
{$B-   Short-circuit boolean expressions }
{$IFNDEF VER90}
{$G+   80286+ type instructions }
{$ENDIF}
{$V-   Disable var string checking }
{$W-   No Windows realmode stack frame }
{$X+   Enable extended syntax }
{$IFDEF DEBUG}
{$D+,L+  Enable debug information }
{$ELSE}
{$D-,L-  Disable debug information }
{$ENDIF}
{---------------------------------------------------------------------}

INTERFACE

{$IFDEF Win32}
uses
  SysUtils, Windows;
{$ELSE}
{$IFDEF VER80}
uses
  SysUtils;
{$ENDIF}
{$ENDIF}

const
  rsTableEntries = 55;

type
  {A random number stream}
  PRandStream = ^TRandStream;
  TRandStream = record
    Table : array [0..pred(rsTableEntries)] of longint;
    Offset: integer;
  end;

  {Definition of a floating point value}
  {$IFDEF Win32}
  TrsFloat = extended;
  {$ELSE}
  {$IFOPT N+}
  TrsFloat = extended;
  {$ELSE}
  TrsFloat = real;
  {$ENDIF}
  {$ENDIF}

  {Numerical parameter errors}
  TrsError = (rsErrNone,                {No error}
              rsErrBadMean,             {Invalid mean}
              rsErrBadVariance,         {Invalid variance}
              rsErrBadStdDev,           {Invalid standard deviation}
              rsErrBadRange,            {Invalid range}
              rsErrBadOrder,            {Bad order}
              rsErrInvProb);            {Invalid probability}

  {Error handler prototype}
  TrsErrorHandler = procedure (Error : TrsError);

{=rsErrorHandler======================================================
The unit's error handler. The default one raises an exception under
Delphi, and halts the program with runtime error 207 in other Borland
Pascal versions.
Replace with your own error handler if you want this behaviour to
change.
18Jun95 JMB
======================================================================}
const
  rsErrorHandler : TrsErrorHandler = nil;

{=CreateRandStream====================================================
Creates a new random number stream on the heap. Seed is the initial
value to seed the internal table. If this is zero, the seed is taken
from the system clock.
18Jun95 JMB
======================================================================}
function  CreateRandStream(Seed : longint) : PRandStream;

{=DestroyRandStream===================================================
Destroys a random number stream initialized by CreateRandStream. Sets
the RS parameter to nil.
18Jun95 JMB
======================================================================}
procedure DestroyRandStream(var RS : PRandStream);

{=rsRandom============================================================
Returns the next random number from the passed random number stream.
The value is between 0 and pred(UpperLimit).
18Jun95 JMB
======================================================================}
function  rsRandom(RS : PRandStream; UpperLimit : word) : Cardinal;

{=rsRandomWord========================================================
Returns the next random number from the passed random number stream.
The value is a full 16-bit word, ie between 0 and 65535 inclusive.
18Jun95 JMB
======================================================================}
function  rsRandomWord(RS : PRandStream) : word;

{=rsRandomLongint=====================================================
Returns the next random number from the passed random number stream.
The value is a full 31-bit non-negative longint between 0 and
pred(2^31) inclusive.
18Jun95 JMB
======================================================================}
function  rsRandomLongint(RS : PRandStream) : longint;

{=rsRandomFloat=======================================================
Returns the next random number from the passed random number stream.
The value is uniformly distributed in the range: 0.0 <= x < 1.0.
18Jun95 JMB
======================================================================}
function  rsRandomFloat(RS : PRandStream) : TrsFloat;

{=rsRandomUniform=====================================================
Returns the next random number from the passed random number stream.
The value is uniformly distributed in the range: Lower <= x < Upper.
Will call rsErrorHandler with rsErrBadRange if Upper <= Lower.
18Jun95 JMB
======================================================================}
function rsdRandomUniform(RS : PRandStream; Lower, Upper : TrsFloat) : TrsFloat;

IMPLEMENTATION

{Note: the Offset field is a byte offset, not an element offset}

{$IFDEF Win32}
var
{$ELSE}
const
{$ENDIF}
  IsUnitInitialised : boolean = false;

const
  TableMagic   = 23;

{=DefErrorHandler=====================================================
Default error handler: just exits with run time error 207.
18Jun95 JMB
======================================================================}
procedure DefErrorHandler(Error : TrsError); far;
  begin
    {$IFDEF VER80}
    Raise(Exception.Create('Random number generator error'));
    {$ELSE}
    RunError(207); {invalid floating point operation}
    {$ENDIF}
  end;

{=InitRSUnit==========================================================
Initialises the unit: sets the default error handler.
18Jun95 JMB
======================================================================}
procedure InitRSUnit;
  begin
    if not Assigned(rsErrorHandler) then
      rsErrorHandler := DefErrorHandler;

    IsUnitInitialised := true;
  end;

{$IFDEF Win32}
{=Random32Bit=========================================================
Generates a random 32-bit word value, bit by bit. Used for seeding a
random number generator table, should NOT be used as a direct random
number.

Based on the Primitive Polynominal Mod 2: (32, 7, 5, 3, 2, 1, 0).

Input:  EBX = current seed
Output: EBX = new seed
        EAX = 32-bit random value
        ECX, EDX trashed

13Mar96 JMB
======================================================================}
procedure Random32Bit;
  register;
  asm
    mov ecx, 32         {use ecx as the count}
  @@NextBit:
    mov edx, ebx
    mov eax, edx        {get bit 0 of seed}
    shr edx, 1          {xor with bit 1 of seed}
    xor eax, edx
    shr edx, 1          {xor with bit 2 of seed}
    xor eax, edx
    shr edx, 2          {xor with bit 4 of seed}
    xor eax, edx
    shr edx, 2          {xor with bit 6 of seed}
    xor eax, edx
    shr edx, 25         {xor with bit 31 of seed}
    xor eax, edx
    and eax, 1          {isolate the new random bit}
    shl ebx, 1          {shift seed left by one}
    or ebx, eax         {add in the new bit to the seed as bit 0}
    dec ecx             {go get next random bit, until we've got them all}
    jnz @@NextBit
    mov eax, ebx        {return random bits}
  end;
{$ELSE}
{=Random16Bit=========================================================
Generates a random 16-bit word value, bit by bit. Used for seeding a
random number generator table, should NOT be used as a direct random
number.

Based on the Primitive Polynominal Mod 2: (32, 7, 5, 3, 2, 1, 0).

Input:  DX:BX = current seed
Output: DX:BX = new seed
        AX    = 16-bit random value
        CX, SI, DI trashed

18Jun95 JMB
======================================================================}
procedure Random16Bit;
  near; assembler;
  asm
    mov cx, 16          {use cx as the count}
  @@NextBit:
    mov si, bx
    mov ax, si          {get bit 0 of seed}
    shr si, 1           {xor with bit 1 of seed}
    xor ax, si
    shr si, 1           {xor with bit 2 of seed}
    xor ax, si
    shr si, 1           {xor with bit 4 of seed}
    shr si, 1
    xor ax, si
    shr si, 1           {xor with bit 6 of seed}
    shr si, 1
    xor ax, si
    mov si, dx          {xor with bit 31 of seed}
    shl si, 1
    rcl si, 1
    xor ax, si
    and ax, 1           {isolate the new random bit}
    shl bx, 1           {shift seed left by one}
    rcl dx, 1
    or bx, ax           {add in the new bit to the seed as bit 0}
    loop @@NextBit      {go get next random bit, until we've got them all}
    mov ax, bx          {return random bits as a word}
  end;
{$ENDIF}

{=InitTable===========================================================
Uses Random16Bit/Random32Bit to seed the random number generator
table.
13Mar96 JMB
======================================================================}
{$IFDEF Win32}
procedure InitTable(RS : PRandStream; Seed : longint);
  register;
  asm
    push edi
    push ebx
    mov edi, eax
    mov ecx, rsTableEntries
    mov ebx, edx
  @@NextEntry:
    push ecx
    call Random32Bit
    pop ecx
    stosd
    dec ecx
    jnz @@NextEntry
    and eax, $1F
    shl eax, 2
    stosd
    pop ebx
    pop edi
  end;
{$ELSE}
procedure InitTable(RS : PRandStream; Seed : longint);
  near; assembler;
  asm
    push ds
    lds di, RS
    mov ax, ds
    mov es, ax
    mov cx, rsTableEntries * 2
    cld
    mov dx, Seed.Word[2]
    mov bx, Seed.Word[0]
  @@NextWord:
    push di
    push cx
    call Random16Bit
    pop cx
    pop di
    stosw
    loop @@NextWord
    and ax, $1F
    shl ax, 1
    shl ax, 1
    stosw
    pop ds
  end;
{$ENDIF}

function  CreateRandStream(Seed : longint) : PRandStream;
  var
    RS : PRandStream;
  begin
    GetMem(RS, sizeof(TRandStream));
    if Assigned(RS) then
      begin
        if (Seed = 0) then
          {$IFDEF Win32}
          Seed := GetTickCount;
          {$ELSE}
          asm
            mov ah, $2C
            int $21
            mov Seed.Word[0], cx
            mov Seed.Word[2], dx
          end;
          {$ENDIF}
        InitTable(RS, Seed);
        if not IsUnitInitialised then
          InitRSUnit;
      end;
    CreateRandStream := RS;
  end;

procedure DestroyRandStream(var RS : PRandStream);
  begin
    if Assigned(RS) then
      begin
        FreeMem(RS, sizeof(TRandStream));
        RS := nil;
      end;
  end;

{$IFDEF Win32}
function GetNextRandomLong(RS : PRandStream) : longint;
  {Input:  eax = RS
   Output: eax = random long word
           ecx, edx trashed}
  register;
  asm
    mov ecx, eax
    mov edx, [ecx].TRandStream.&Offset
    mov eax, [ecx+edx]
    sub edx, 4
    jge @@1
    mov edx, rsTableEntries * 4 - 4
  @@1:
    push edx
    sub edx, TableMagic * 4
    jge @@2
    add edx, rsTableEntries * 4
  @@2:
    add eax, [ecx+edx]
    pop edx
    mov [ecx+edx], eax
    mov [ecx].TRandStream.&Offset, edx
  end;

function rsRandom(RS : PRandStream; UpperLimit : word) : Cardinal;
  {Input:  eax = RS
           edx = UpperLimit
   Output: ax = random value}
  register;
  asm
    movzx edx, dx
    push edx
    call GetNextRandomLong
    pop edx
    mul edx
    mov eax, edx
  end;

function rsRandomWord(RS : PRandStream) : word;
  {Input:  eax = RS
   Output: ax = random value}
  register;
  asm
    call GetNextRandomLong
    shr eax, 16
  end;

function rsRandomLongint(RS : PRandStream) : longint; assembler;
  {Input:  eax = RS
   Output: eax = random value}
  register;
  asm
    call GetNextRandomLong
    shr eax, 1
  end;

function  rsRandomFloat(RS : PRandStream) : TrsFloat; assembler;
  {Input:  eax = RS
   Output: random value on floating point stack}
  register;
  const
    Scale : integer = -31;
  asm
    call GetNextRandomLong
    shr eax, 1
    fild Scale
    push eax
    fild dword ptr [esp]
    add esp, 4
    fscale
    fstp st(1)
  end;
{$ELSE}
procedure GetNextRandomLong;
  {-Input:  ds:si   => TRandStream
    Output: dx:ax   new random longint
            ds, si  unchanged
            bx, di  trashed
            cx      not touched}
  near; assembler;
  asm
    mov bx, [si].TRandStream.&Offset
    mov ax, [si+bx]
    mov dx, [si+bx+2]
    sub bx, 4
    jge @@1
    mov bx, rsTableEntries * 4 - 4
  @@1:
    mov di, bx
    sub bx, TableMagic * 4
    jge @@2
    add bx, rsTableEntries * 4
  @@2:
    add ax, [si+bx]
    adc dx, [si+bx+2]
    mov bx, di
    mov [si+bx], ax
    mov [si+bx+2], dx
    mov [si].TRandStream.&Offset, bx
  end;

function rsRandom(RS : PRandStream; UpperLimit : word) : word;
  assembler;
  asm
    mov cx, ds
    lds si, RS
    call GetNextRandomLong
    xchg ax, dx
    mul UpperLimit
    xchg ax, dx
    mov ds, cx
  end;

function rsRandomWord(RS : PRandStream) : word;
  assembler;
  asm
    mov cx, ds
    lds si, RS
    call GetNextRandomLong
    xchg ax, dx
    mov ds, cx
  end;

function rsRandomLongint(RS : PRandStream) : longint;
  assembler;
  asm
    mov cx, ds
    lds si, RS
    call GetNextRandomLong
    shr dx, 1
    rcr ax, 1
    mov ds, cx
  end;

function  rsRandomFloat(RS : PRandStream) : TrsFloat;
  assembler;
{$IFOPT N+}
  var
    R : longint;
    Scale : integer;
  asm
    mov cx, ds
    lds si, RS
    call GetNextRandomLong
    shr dx, 1
    rcr ax, 1
    mov R.Word[0], ax
    mov R.Word[2], dx
    mov Scale, -31
    fild Scale
    fild R
    fscale
    fstp st(1)
    fwait
    mov ds, cx
  end;
{$ELSE} {N-}
  asm
    mov cx, ds
    lds si, RS
    call GetNextRandomLong
    mov bx, ax
    or ax, dx
    jz @@Exit
    mov ax, $80
    jmp @@StartNormalize
  @@MultBy2:
    shl bx, 1
    rcl dx, 1
    dec al
  @@StartNormalize:
    test dh, $80
    jz @@MultBy2
    and dh, $7F
  @@Exit:
    mov ds, cx
  end;
{$ENDIF}
{$ENDIF}

function rsdRandomUniform(RS : PRandStream; Lower, Upper : TrsFloat) : TrsFloat;
  begin
    if (Upper <= Lower) then
      begin
        rsErrorHandler(rsErrBadRange);
        rsdRandomUniform := 0.0;
      end
    else
      rsdRandomUniform := (rsRandomFloat(RS) * (Upper - Lower)) + Lower;
  end;

end.
