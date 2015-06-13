{===EZDSLOPT.INC======================================================

Fixed compiler options for the EZ Delphi Structures Library.
DO NOT MODIFY ANYTHING IN THIS FILE.

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


{ Check for Delphi }
{$IF CompilerVersion >= 22}
  {$DEFINE XeOrLater}
{$ENDIF}
{$IFNDEF VER80} {$IFNDEF VER90}
  {$IFNDEF VER100} {$IFNDEF VER120}
    {$IFNDEF VER130} {$IFNDEF VER140}
      {$IFNDEF VER180}
        {$IFNDEF VER200}
          {$IFNDEF XeOrLater}
!! Error - EZDSL is for Delphi 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 2006/7, 2009, XE+ *only*
{$ENDIF} {$ENDIF} {$ENDIF} {$ENDIF} {$ENDIF}
{$ENDIF} {$ENDIF} {$ENDIF} {$ENDIF}

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


{---Delphi XE+ specific---}
{$IFDEF XeOrLater}
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

{---32-bit assembler---}
{$IFDEF Win32}
{$DEFINE BASM32}
{$ENDIF}
{---------------------------------------------------------------------}

