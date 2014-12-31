if %1x==buildx goto Build
if %1x==BUILDx goto Build
goto Clean

:Build
c:\borland\delphi\bin\brcc -foezdslcts.r16 ezdslcts.rc
c:\borland\delphi5\bin\brcc32 -foezdslcts.r32 ezdslcts.rc
c:\borland\delphi3\bin\dcc32 -b ezdsl3d3.dpk
c:\borland\delphi4\bin\dcc32 -b ezdsl3d4.dpk
c:\borland\delphi5\bin\dcc32 -b ezdsl3d5.dpk
c:\borland\delphi6\bin\dcc32 -b ezdsl3d6.dpk
if exist c:\borland\delphi5\projects\bpl\ezdsl3d5.bpl move c:\borland\delphi5\projects\bpl\ezdsl3d5.bpl .
if exist c:\borland\delphi5\projects\bpl\ezdsl3d5.dcp move c:\borland\delphi5\projects\bpl\ezdsl3d5.dcp .
if exist c:\borland\delphi6\projects\bpl\ezdsl3d6.bpl move c:\borland\delphi6\projects\bpl\ezdsl3d6.bpl .
if exist c:\borland\delphi6\projects\bpl\ezdsl3d6.dcp move c:\borland\delphi6\projects\bpl\ezdsl3d6.dcp .

:Clean
if exist ezdsl3*.res ren ezdsl3*.res *.sav

for %%a in (*.~??) do del %%a
for %%a in (*.bak) do del %%a
for %%a in (*.res) do del %%a
for %%a in (*.opt) do del %%a
for %%a in (*.dsk) do del %%a
for %%a in (*.dof) do del %%a
for %%a in (*.dcu) do del %%a

if exist ezdsl3*.sav ren ezdsl3*.sav EZDSL3*.RES

ren EZDSLBAr.PAS EZDSLBAr.PAS
ren EZDSLBse.PAS EZDSLBse.PAS
ren EZDSLBtr.PAS EZDSLBtr.PAS
ren EZDSLCol.PAS EZDSLCol.PAS
ren EZDSLCts.PAS EZDSLCts.PAS
ren EZDSLDbl.PAS EZDSLDbl.PAS
ren EZDSLHsh.PAS EZDSLHsh.PAS
ren EZDSLLst.PAS EZDSLLst.PAS
ren EZDSLPQu.PAS EZDSLPQu.PAS
ren EZDSLQue.PAS EZDSLQue.PAS
ren EZDSLRnd.PAS EZDSLRnd.PAS
ren EZDSLSkp.PAS EZDSLSkp.PAS
ren EZDSLStk.PAS EZDSLStk.PAS
ren EZDSLSup.PAS EZDSLSup.PAS
ren EZDSLThd.PAS EZDSLThd.PAS
ren EZDSLDef.INC EZDSLDef.INC
ren EZDSLOpt.INC EZDSLOpt.INC
ren EZPrimes.INC EZPrimes.INC
ren EZBitCnt.INC EZBitCnt.INC
ren EZDSLCts.RC  EZDSLCts.RC
ren EZDSLCts.R16 EZDSLCts.R16
ren EZDSLCts.R32 EZDSLCts.R32
ren EZDSL3d3.DPK EZDSL3d3.DPK
ren EZDSL3d3.DCP EZDSL3d3.DCP
ren EZDSL3d3.DPL EZDSL3d3.DPL
ren EZDSL3d4.DPK EZDSL3d4.DPK
ren EZDSL3d4.DCP EZDSL3d4.DCP
ren EZDSL3d4.BPL EZDSL3d4.BPL
ren EZDSL3d5.DPK EZDSL3d5.DPK
ren EZDSL3d5.DCP EZDSL3d5.DCP
ren EZDSL3d5.BPL EZDSL3d5.BPL
ren EZDSL3d6.DPK EZDSL3d6.DPK
ren EZDSL3d6.DCP EZDSL3d6.DCP
ren EZDSL3d6.BPL EZDSL3d6.BPL

:Save
if not exist k:\ezdslsav\*.* goto IDriveDS
echo y|del k:\ezdslsav\*.*
xcopy *.* k:\ezdslsav

:IDriveDS
if not exist i:\ezunits\ezdsl3\*.* goto Done
echo y|del i:\ezunits\ezdsl3\*.*
xcopy *.* i:\ezunits\ezdsl3


:Done


:Exit

