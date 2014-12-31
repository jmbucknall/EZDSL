program TstEZRnd;
  {-Full random number test suite for EZRNDSTM.
    This program was partly derived from RAN_TEST.C, written by
    Kevin Watkins from his book Discrete Event Simulation in C.
    There are several bugs in that program (and some errors in the
    book), this program uses Knuth's Seminumerical Algorithms to
    solve them.
    The Chi-Squared table was generated from routines in Numerical
    Recipes in Pascal.}

{Copyright (c) 1994, Julian M. Bucknall}

{$N+}

{$IFNDEF Win32}
!! Error - Win32 only
{$ENDIF}
{$APPTYPE CONSOLE}

uses
  Windows, EZRndStm;

const
  Intervals = 100;
  Gaps = 10;
  {$IFOPT N+}
  DefNumber = 5000;
  {$ELSE}
  DefNumber = 10000;
  {$ENDIF}

type
  {$IFOPT N+}
  RandFloat = extended;
  {$ELSE}
  RandFloat = real;
  {$ENDIF}

{$I CHITABLE.INC}

const
  RandArrayElements = 65520 div sizeof(RandFloat);

type
  PRandArray = ^TRandArray;
  TRandArray = array [0..pred(RandArrayElements)] of RandFloat;

var
  RA : PRandArray;
  Number : integer;

function IntPower(X  : RandFloat; N : integer) : RandFloat;
  begin
    case N of
      0 : IntPower := 1.0;
      1 : IntPower := X;
      2 : IntPower := Sqr(X);
    else
      if Odd(N) then
        IntPower := Sqr(IntPower(X, N div 2)) * X
      else
        IntPower := Sqr(IntPower(X, N div 2));
    end;{case}
  end;

function Stirling(N, M : integer) : RandFloat;
  {-Calculate type-2 Stirling number, n & m are both assumed >= 0}
  var
    Work1, Work2 : RandFloat;
  begin
    if (N < M) then
      Stirling := 0.0
    else if (N = M) then
      Stirling := 1.0
    else
      case m of
        0 : Stirling := 0.0;
        1 : Stirling := 1.0;
        2 : Stirling := IntPower(2.0, n-1) - 1.0;
      else
        Work1 := Stirling(n-1, m);
        Work2 := Stirling(n-1, m-1);
        Stirling := (Work1 * m) + Work2;
      end;{case}
  end;

procedure WriteHeading(S : string);
  function UnderLine(Len : integer) : string;
    begin
      SetLength(Result, Len);
      FillChar(Result[1], Len, '-');
    end;
  begin
    writeln(UnderLine(50));
    writeln(S);
    writeln(Underline(length(S)));
    writeln;
  end;

procedure WriteChiRange(DegFree : integer; ChiSqVal : RandFloat);
  begin
    writeln('90% of the time, the value should be between');
    writeln('  ', ChiTable5[DegFree]:0:5, ' and ', ChiTable95[DegFree]:0:5);
    if not ( (ChiTable5[DegFree] <= ChiSqVal) and
             (ChiSqVal <= ChiTable95[DegFree]) ) then
      writeln('  **FAILED**');
  end;

{=====================================================================
The uniformity test.
The random numbers are partitioned into a number of equally sized
buckets between 0.0 and 1.0. On the average, each bucket should have
the same number of random numbers; ie they should be evenly spread
over the range [0.0, 0.1). Apply Chi-Squared test to the buckets.
======================================================================}
procedure UniformityTest;
  var
    BucketNumber,
    i : integer;
    RangeLeft, RangeRight,
    Expected, ChiSqVal : RandFloat;
    Bucket : array[0..pred(Intervals)] of integer;
  begin
    WriteHeading('UNIFORMITY TEST');
    {Fill buckets}
    FillChar(Bucket, sizeof(Bucket), 0);
    for i := 0 to pred(Number) do
      begin
        BucketNumber := trunc(RA^[i] * Intervals);
        inc(Bucket[BucketNumber]);
      end;
    {calc chi squared}
    RangeRight := 0.0;
    Expected := Number / Intervals;
    ChiSqVal := 0.0;
    writeln('       INTERVAL   EXPECTED   OBSERVED');
    for i := 0 to pred(Intervals) do
      begin
        RangeLeft := RangeRight;
        RangeRight := (1.0 + i) / Intervals;
        writeln(RangeLeft:0:5, '-', RangeRight:0:5, Expected:11:5,
                Bucket[i]:5, '.00000');
        ChiSqVal := ChiSqVal + (Sqr(Expected - Bucket[i]) / Expected);
      end;
    writeln('Number of Categories:   ', Intervals);
    writeln('Chi-Squared test value: ', ChiSqVal:0:5);
    writeln('Degrees of freedom:     ', Intervals-1);
    WriteChiRange(Intervals-1, ChiSqVal);
    writeln;
  end;


{=====================================================================
The gap test.
Each random number is tested to be in the range Lower..Upper. If it
is a value of 1 is assigned, if not 0 is assigned. You'll get a stream
of 0's and 1's. The lengths of the runs of 0's are then counted. These
lengths are then bucketed, you'll get lengths of 0 upwards. These
lengths are the 'gaps' between 1's. Apply Chi-Squared test to the
buckets.
======================================================================}
procedure GapTest(Lower, Upper : RandFloat);
  var
    NumGaps,
    GapLen : integer;
    i : integer;
    p,
    Expected, ChiSqVal : RandFloat;
    Bucket : array [0..pred(Gaps)] of integer;
  begin
    WriteHeading('GAP TEST');
    writeln('Range: ', Lower:0:5, ' to ', Upper:0:5);
    {calc gaps and fill buckets}
    FillChar(Bucket, sizeof(Bucket), 0);
    GapLen := 0;
    NumGaps := 0;
    for i := 0 to pred(Number) do
      begin
        if (Lower <= RA^[i]) and (RA^[i] < Upper) then
          begin
            if (GapLen >= Gaps) then
              GapLen := pred(Gaps);
            inc(Bucket[GapLen]);
            inc(NumGaps);
            GapLen := 0;
          end
        else
          if (GapLen < Gaps) then
            inc(GapLen);
      end;
    {cater for last gap}
    if (GapLen > 0) then
      begin
        if (GapLen >= Gaps) then
          GapLen := pred(Gaps);
        inc(Bucket[GapLen]);
        inc(NumGaps);
      end;
    writeln('Number of gaps found: ', NumGaps);
    p := Upper - Lower;
    ChiSqVal := 0.0;
    writeln('GAP SIZE   EXPECTED   OBSERVED');
    for i := 0 to Gaps-2 do
      begin
        Expected := p * IntPower(1-p, i) * NumGaps;
        writeln(i:8, Expected:11:5, Bucket[i]:5, '.00000');
        ChiSqVal := ChiSqVal + (Sqr(Expected - Bucket[i]) / Expected);
      end;
    i := pred(Gaps);
    Expected := IntPower(1-p, i) * NumGaps;
    writeln(i:8, Expected:11:5, Bucket[i]:5, '.00000');
    ChiSqVal := ChiSqVal + (Sqr(Expected - Bucket[i]) / Expected);

    writeln('Number of Categories:   ', Gaps);
    writeln('Chi-Squared test value: ', ChiSqVal:0:5);
    writeln('Degrees of freedom:     ', Gaps-1);
    WriteChiRange(Gaps-1, ChiSqVal);
    writeln;
  end;

{=====================================================================
The poker test.
The random numbers are grouped into 'hands' of 5, and the numbers are
converted into a digit from 0..9. The number of different digits in
each hand is then counted (1..5), and this result is bucketed. Because
the probability of only one digit repeated 5 times is so low, it is
grouped into the 2-different-digit category. Apply Chi-Squared test to
the buckets.
======================================================================}
procedure PokerTest;
  var
    i, j, Inx,
    BucketNumber,
    NumFives : integer;
    Accum, Divisor,
    Expected, ChiSqVal : RandFloat;
    Bucket : array [0..4] of integer;
    Flag : array [0..9] of boolean;
    p : array [0..4] of RandFloat;
  begin
    WriteHeading('POKER TEST');
    {prepare}
    FillChar(Bucket, sizeof(Bucket), 0);
    NumFives := Number div 5;
    Inx := 0;
    {calc probabilities for each bucket, algorithm from Knuth}
    Accum := 1.0;
    Divisor := IntPower(10.0, 5);
    for i := 0 to 4 do
      begin
        Accum := Accum * (10.0 - i);
        p[i] := Accum * Stirling(5, succ(i)) / Divisor;
      end;
    {for each group of five random numbers, convert all five to a
     number between 1 and 10, count the number of different digits}
    for i := 1 to NumFives do
      begin
        FillChar(Flag, sizeof(Flag), 0);
        for j := 1 to 5 do
          begin
            Flag[trunc(RA^[Inx] * 10.0)] := true;
            inc(Inx);
          end;
        BucketNumber := -1;
        for j := 0 to 9 do
          if Flag[j] then inc(BucketNumber);
        inc(Bucket[BucketNumber]);
      end;

    writeln('NUMBER   EXPECTED   OBSERVED');
    {Write the first bucket separately - it'll be the sum
     of the 'all the same' and 'two different digits' buckets}
    inc(Bucket[1], Bucket[0]);
    Expected := (p[0]+p[1]) * NumFives;
    writeln('1 or 2', Expected:11:5, Bucket[1]:5, '.00000');
    ChiSqVal := Sqr(Expected - Bucket[1]) / Expected;
    {write the other buckets}
    for i := 2 to 4 do
      begin
        Expected := p[i] * NumFives;
        writeln(succ(i):6, Expected:11:5, Bucket[i]:5, '.00000');
        ChiSqVal := ChiSqVal + (Sqr(Expected - Bucket[i]) / Expected);
      end;

    writeln('Number of Categories:   4');
    writeln('Chi-Squared test value: ', ChiSqVal:0:5);
    writeln('Degrees of freedom:     3');
    WriteChiRange(3, ChiSqVal);
    writeln;
  end;

{=====================================================================
The coupon collectors test.
The random numbers are read one by one, converted into a number from
0 to 4. The length of the sequence required to get a complete set of
the digits 0..4 is counted, this will vary from 5 upwards. Once a full
set is obtained, start over. Bucket the lengths of these sequences.
Apply Chi-Squared test to the buckets.
======================================================================}
procedure CouponCollectorsTest;
  var
    NumSeqs, LenSeq, NumVals, NewVal, Inx,
    i : integer;
    work,
    Expected, ChiSqVal : RandFloat;
    Bucket : array [5..20] of integer;
    Occurs : array [0..4] of boolean;
    p : array [5..20] of RandFloat;
  begin
    WriteHeading('COUPON COLLECTORS TEST');

    {calc probabilities for each bucket, algorithm from Knuth}
    p[20] := 1.0;
    for i := 5 to 19 do
      begin
        p[i] := (120.0 * Stirling(i-1, 4)) / IntPower(5.0, i);
        p[20] := p[20] - p[i];
      end;
    {an alternative to calculate the last probability value:
      p[last] := 1.0 - ((120.0 * Stirling(last-1, 5)) / IntPower(5.0, last-1)); }

    NumSeqs := 0;
    Inx := 0;
    FillChar(Bucket, sizeof(Bucket), 0);
    repeat
      LenSeq := 0;
      NumVals := 0;
      FillChar(Occurs, sizeof(Occurs), 0);
      repeat
        inc(LenSeq);
        NewVal := trunc(RA^[Inx] * 5);
        if not Occurs[NewVal] then
          begin
            Occurs[NewVal] := true;
            inc(NumVals);
          end;
        inc(Inx);
      until (NumVals = 5) or (Inx >= Number);
      if (NumVals = 5) then
        begin
          if (LenSeq > 20) then
            LenSeq := 20;
          inc(Bucket[LenSeq]);
          inc(NumSeqs);
        end;
    until (Inx >= Number);

    writeln('Number of sequences found: ', NumSeqs);
    writeln('LENGTH   EXPECTED   OBSERVED');
    ChiSqVal := 0.0;
    {write the other buckets}
    for i := 5 to 20 do
      begin
        Expected := p[i] * NumSeqs;
        writeln(i:6, Expected:11:5, Bucket[i]:5, '.00000');
        ChiSqVal := ChiSqVal + (Sqr(Expected - Bucket[i]) / Expected);
      end;

    writeln('Number of Categories:   16');
    writeln('Chi-Squared test value: ', ChiSqVal:0:5);
    writeln('Degrees of freedom:     15');
    WriteChiRange(15, ChiSqVal);
    writeln;
  end;

var
  i,
  ec : integer;
  SumX, SumXX,
  Mean, Variance,
  X : RandFloat;
  RS : PRandStream;
  UseSYSTEM : boolean;
  StartTime, EndTime : integer;
  RF : TrsFloat;

begin
  {Get command line arguments}
  {--first parameter is the number of random numbers to generate}
  {--second parameter is '/s' to indicate using the SYSTEM.Random function}
  Number := DefNumber;
  UseSYSTEM := false;
  if (ParamCount >= 1) then
    begin
      Val(ParamStr(1), Number, ec);
      if (ec <> 0) or (Number > RandArrayElements) or (Number = 0) then
        Number := DefNumber;
      if (ParamCount >= 2) then
        if (ParamStr(2) = '/S') or (ParamStr(2) = '/s') then
          UseSYSTEM := true;
    end;
  {Create new random number stream}
  Randomize;
  RS := CreateRandStream(0);
  {quick test on speed--calculate 1000000 random numbers}
  StartTime := GetTickCount;
  for i := 1 to 1000000 do
    RF := Random;
  EndTime := GetTickCount;
  writeln('Speed test, System.Random: ', EndTime-StartTime);
  StartTime := GetTickCount;
  for i := 1 to 1000000 do
    RF := rsRandomFloat(RS);
  EndTime := GetTickCount;
  writeln('Speed test, rsRandomFloat: ', EndTime-StartTime);
  readln;
  {Create random number array on heap}
  New(RA);
  {Populate random number array, calc sum values for mean/variance}
  SumX := 0.0;
  SumXX := 0.0;
  for i := 0 to pred(Number) do
    begin
      if UseSYSTEM then
        X := Random
      else
        {$IFOPT N+}
        X := rsRandomFloat(RS);
        {$ELSE}
        X := rsRandomReal(RS);
        {$ENDIF}
      SumX := SumX + X;
      SumXX := SumXX + (X * X);
      RA^[i] := X;
    end;
  {Write number, mean and variance}
  writeln('Number of random numbers generated: ', Number);
  Mean := SumX / Number;
  writeln('Mean:     (', (1.0/2.0):0:7, ') ', Mean:0:7);
  Variance := (SumXX - (SumX * Mean)) / (Number - 1);
  writeln('Variance: (', (1.0/12.0):0:7, ') ', Variance:0:7);
  writeln;
  {Perform statistical tests}
  UniformityTest;
  readln;
  GapTest(0.0, 0.5);         {gap test for first half of [0,1)}
  readln;
  GapTest(0.5, 1.0);         {gap test for second half of [0,1)}
  readln;
  GapTest(1.0/3.0, 2.0/3.0); {gap test for middle third of [0,1)}
  readln;
  PokerTest;
  readln;
  CouponCollectorsTest;
  readln;
  {clean up}
  FreeMem(RA, Number * sizeof(RandFloat));
  if not UseSYSTEM then
    DestroyRandStream(RS);
end.

