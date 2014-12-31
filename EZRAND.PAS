{===EZRand============================================================

This unit provides a random sequence generator.

There is one main random number function interfaced and it replaces
System.Random for generating random word values. There are two
initialization procedures: jRandomize for setting the internal
variables based on the system clock, and jRandomiseDebug to set the
internal variables to a known state.
According to Knuth this generator has a cycle of 2^55 - 1. It's also
measurably faster than the standard System unit one at the expense of
using 226 bytes of data segment space.
There are a couple of extra random number routines: one for getting a
full 16-bit random number, the other for a full 31 bit random number.

References
  Random bit generator from Numerical Recipes in Pascal
  Random table algorithm from Sedgewick: Algorithms
  Random number test algorithms from Knuth: Seminumerical Algorithms

VERSION HISTORY
08Sep94 JMB 1.00 initial release (extracted from JRandNum).
======================================================================}

unit EZRand;

{ Undefine this if you don't want debugging info }
{.$DEFINE DEBUG}


{------Common compiler switches---------------------------------------}
{$A+   Word align variables }
{$B-   Short-circuit boolean expressions }
{$F+   Force Far calls }
{$I-   No I/O checking }
{$N+   Allow coprocessor instructions }
{$P+   Open parameters enabled }
{$Q-   No integer overflow checking }
{$R-   No range checking }
{$S-   No stack checking }
{$T-   @ operator is NOT typed }
{$V-   Disable var string checking }
{$X+   Enable extended syntax }
{$IFDEF DEBUG}
{$D+,L+,Y+  Enable debug information }
{$ENDIF}
{---------------------------------------------------------------------}

{------Real mode compiler switches------------------------------------}
{$IFDEF MSDOS}
{$E+   Enable coprocessor emulation }
{$G-   8086 type instructions }
{$O-   Do NOT allow overlays }
{$DEFINE RealMode}
{$UNDEF  ProtMode}
{$ENDIF}
{---------------------------------------------------------------------}

{------Protected mode compiler switches-------------------------------}
{$IFDEF DPMI}
{$E+   Enable coprocessor emulation }
{$G+   80286+ type instructions }
{$UNDEF  RealMode}
{$DEFINE ProtMode}
{$ENDIF}
{---------------------------------------------------------------------}

{------Windows compiler switches--------------------------------------}
{$IFDEF WINDOWS}
{$G+   80286+ type instructions }
{$K+   Use smart callbacks
{$W-   No Windows realmode stack frame }
{$UNDEF  RealMode}
{$DEFINE ProtMode}
{$ENDIF}
{---------------------------------------------------------------------}

INTERFACE

{=jRandom=============================================================
Generates a random word value between 0 and UpperLimit-1.
04Dec93 JMB
======================================================================}
function jRandom(UpperLimit : word) : word;

{=jRandomWord=========================================================
Generates a full 16 bit random word value.
04Dec93 JMB
======================================================================}
function jRandomWord : word;

{=jRandomLongint======================================================
Generates a full 31 bit random longint value (>= 0).
04Dec93 JMB
======================================================================}
function jRandomLongint : longint;

{=jRandomize==========================================================
Initialises the random seed using the system clock, then initializes
the random number generator table. Called automatically in the unit's
initialization routine.
04Dec93 JMB
======================================================================}
procedure jRandomize;

{=jRandomizeDebug=====================================================
Initialises the random seed using the value $5555, then initializes
the random number generator table.
04Dec93 JMB
======================================================================}
procedure jRandomizeDebug;

IMPLEMENTATION

const
  TableEntries = 55;
  TableMagic   = 23;

var
  RandomSeed  : longint;
  RandomTable : array [0..pred(TableEntries)] of longint;
  TableInx    : integer;  {Note: this is 4 * element number}

{=RandomBits==========================================================
Generates a random word value between 0 and (2^NumBits)-1. Used for
seeding the random number generator table, should NOT be used as a
direct random number.
Based on the Primitive Polynominal Mod 2: (32, 7, 5, 3, 2, 1, 0).
04Dec93 JMB
======================================================================}
function RandomBits(NumBits : byte) : word; near; assembler;
  asm
    mov dx, RandomSeed.Word[2] {use dx:bx as the seed}
    mov bx, RandomSeed.Word[0]
    xor cx, cx          {use cx as the count}
    mov di, cx          {use di to store the answer}
    mov cl, NumBits
    jcxz @@Exit
    cmp cx, 16
    ja @@Exit
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
    shl di, 1           {save the new bit in our result as well}
    or di, ax
    loop @@NextBit      {go get next random bit, until we've got them all}
    mov RandomSeed.Word[2], dx
    mov RandomSeed.Word[0], bx
  @@Exit:
    xchg ax, di         {return random bits as a word}
  end;

{=InitTable===========================================================
Uses jRandomBits to seed the random number generator table.
04Dec93 JMB
======================================================================}
procedure InitTable; near; assembler;
  asm
    mov di, offset RandomTable
    mov ax, ds
    mov es, ax
    mov cx, TableEntries * 2
    cld
  @@NextWord:
    push di
    push cx
  {$IFOPT G+}
    push 16
  {$ELSE}
    mov al, 16
    push ax
  {$ENDIF}
    call RandomBits
    pop cx
    pop di
    stosw
    loop @@NextWord
    and ax, $1F
    shl ax, 1
    shl ax, 1
    mov TableInx, ax
  end;

procedure jRandomize; assembler;
  asm
    mov ah, $2C
    int $21
    mov RandomSeed.Word[0], cx
    mov RandomSeed.Word[2], dx
    call InitTable
  end;

procedure jRandomizeDebug; assembler;
  asm
    mov ax, $5555;
    mov RandomSeed.Word[0], ax
    mov RandomSeed.Word[2], ax
    call InitTable
  end;

function jRandom(UpperLimit : word) : word; assembler;
  asm
    mov si, offset RandomTable
    mov bx, TableInx
    mov ax, [si+bx]
    mov dx, [si+bx+2]
    add bx, 4
    cmp bx, TableEntries * 4
    jl @@1
    xor bx, bx
  @@1:
    mov di, bx
    add bx, TableMagic * 4
    cmp bx, TableEntries * 4
    jl @@2
    sub bx, TableEntries * 4
  @@2:
    add ax, [si+bx]
    adc dx, [si+bx+2]
    mov bx, di
    {.!.}
    mov [si+bx], ax
    mov [si+bx+2], dx
    mov TableInx, bx
    xchg ax, dx
    mul UpperLimit
    xchg ax, dx
  end;

function jRandomWord : word; assembler;
  asm
  {$IFOPT G+}
    push 1
  {$ELSE}
    xor ax, ax
    inc ax
    push ax
  {$ENDIF}
    call jRandom
    {note that this works because jRandom does an xchg between
     lo & hi word results from the multiplication}
    xchg ax, dx
  end;

function jRandomLongint : longint; assembler;
  asm
    call jRandomWord
    and ax, $7FFF
    push ax
    call jRandomWord
    pop dx
  end;

begin
  jRandomize;
end.
