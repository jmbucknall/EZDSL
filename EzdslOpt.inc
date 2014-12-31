{===EZDSLOPT.INC======================================================

Fixed compiler options for the EZ Delphi Structures Library.
DO NOT MODIFY ANYTHING IN THIS FILE.

EZDSLOPT.INC is Copyright (c) 1995-2011 by Julian M. Bucknall

VERSION HISTORY
02Jul11 JMB 3.04 Release for Delphi XE
28Feb01 JMB 3.03 Release for Kylix and Delphi 6
24Oct99 JMB 3.02 Release for Delphi 4 & 5
26Sep97 JMB 3.00 Major new version, release for Delphi 3
13Mar96 JMB 1.00 release for Delphi 2.0
{=====================================================================}

{ Check for Delphi }
{$IFNDEF VER80} {$IFNDEF VER90}
  {$IFNDEF VER100} {$IFNDEF VER120}
    {$IFNDEF VER130} {$IFNDEF VER140}
      {$IFNDEF VER180}
        {$IFNDEF VER200}
          {$IFNDEF VER220}
!! Error - EZDSL is for Delphi 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 2006/7, 2009, XE *only*
{$ENDIF} {$ENDIF} {$ENDIF} {$ENDIF} {$ENDIF} {$ENDIF} {$ENDIF} {$ENDIF} {$ENDIF}

{------Fixed compiler options throughout EZDSL------------------------}

{---Delphi 1.0 specific---}
{$IFDEF VER80}
{$B-   Short-circuit boolean expressions }
{$G+   80286+ type instructions }
{$I+   I/O checking via exceptions }
{$V-   Disable var string checking }
{$W-   No Windows realmode stack frame }
{$X+   Enable extended syntax }
{$IFDEF DEBUG}
{$D+,L+  Enable debug information }
{$ELSE}
{$D-,L-  Disable debug information }
{$ENDIF}
{$ENDIF}

{---Delphi 2.0 specific---}
{$IFDEF VER90}
{$A+   Use DWORD alignment whereever possible }
{$B-   Short-circuit boolean expressions }
{$I+   I/O checking via exceptions }
{$V-   Disable var string checking }
{$W-   No Windows realmode stack frame }
{$X+   Enable extended syntax }
{$IFDEF DEBUG}
{$D+,L+  Enable debug information }
{$ELSE}
{$D-,L-  Disable debug information }
{$ENDIF}
{$ENDIF}

{---Delphi 3.0 specific---}
{$IFDEF VER100}
{$A+   Use DWORD alignment whereever possible }
{$B-   Short-circuit boolean expressions }
{$I+   I/O checking via exceptions }
{$V-   Disable var string checking }
{$W-   No Windows realmode stack frame }
{$X+   Enable extended syntax }
{$IFDEF DEBUG}
{$D+,L+  Enable debug information }
{$ELSE}
{$D-,L-  Disable debug information }
{$ENDIF}
{$ENDIF}

{---Delphi 4.0 specific---}
{$IFDEF VER120}
{$A+   Use DWORD alignment whereever possible }
{$B-   Short-circuit boolean expressions }
{$I+   I/O checking via exceptions }
{$V-   Disable var string checking }
{$W-   No Windows realmode stack frame }
{$X+   Enable extended syntax }
{$IFDEF DEBUG}
{$D+,L+  Enable debug information }
{$ELSE}
{$D-,L-  Disable debug information }
{$ENDIF}
{$ENDIF}

{---Delphi 5.0 specific---}
{$IFDEF VER130}
{$A+   Use DWORD alignment whereever possible }
{$B-   Short-circuit boolean expressions }
{$I+   I/O checking via exceptions }
{$V-   Disable var string checking }
{$W-   No Windows realmode stack frame }
{$X+   Enable extended syntax }
{$IFDEF DEBUG}
{$D+,L+  Enable debug information }
{$ELSE}
{$D-,L-  Disable debug information }
{$ENDIF}
{$ENDIF}

{---Delphi 6.0 specific---}
{$IFDEF VER140}
{$A+   Use DWORD alignment whereever possible }
{$B-   Short-circuit boolean expressions }
{$I+   I/O checking via exceptions }
{$V-   Disable var string checking }
{$W-   No Windows realmode stack frame }
{$X+   Enable extended syntax }
{$IFDEF DEBUG}
{$D+,L+  Enable debug information }
{$ELSE}
{$D-,L-  Disable debug information }
{$ENDIF}
{$ENDIF}

{---Delphi 2006 specific---}
{$IFDEF VER180}
{$A+   Use DWORD alignment whereever possible }
{$B-   Short-circuit boolean expressions }
{$I+   I/O checking via exceptions }
{$V-   Disable var string checking }
{$W-   No Windows realmode stack frame }
{$X+   Enable extended syntax }
{$IFDEF DEBUG}
{$D+,L+  Enable debug information }
{$ELSE}
{$D-,L-  Disable debug information }
{$ENDIF}
{$ENDIF}


{---Delphi 2009 specific---}
{$IFDEF VER200}
{$A+   Use DWORD alignment whereever possible }
{$B-   Short-circuit boolean expressions }
{$I+   I/O checking via exceptions }
{$V-   Disable var string checking }
{$W-   No Windows realmode stack frame }
{$X+   Enable extended syntax }
{$IFDEF DEBUG}
{$D+,L+  Enable debug information }
{$ELSE}
{$D-,L-  Disable debug information }
{$ENDIF}
{$ENDIF}


{---Delphi XE specific---}
{$IFDEF VER220}
{$A+   Use DWORD alignment whereever possible }
{$B-   Short-circuit boolean expressions }
{$I+   I/O checking via exceptions }
{$V-   Disable var string checking }
{$W-   No Windows realmode stack frame }
{$X+   Enable extended syntax }
{$IFDEF DEBUG}
{$D+,L+  Enable debug information }
{$ELSE}
{$D-,L-  Disable debug information }
{$ENDIF}
{$ENDIF}


{---Hints and Warnings for later Delphis}
{$IFNDEF VER80}
{$WARNINGS ON}
{$HINTS ON}
{$ENDIF}

{---Thread-capable operating system---}
{$IFDEF Win32}
{$DEFINE ThreadsExist}
{$ENDIF}
{$IFDEF Linux}
{$DEFINE ThreadsExist}
{$ENDIF}

{---32-bit assembler---}
{$IFDEF Win32}
{$DEFINE BASM32}
{$ENDIF}
{$IFDEF Linux}
{$DEFINE BASM32}
{$ENDIF}
{---------------------------------------------------------------------}

