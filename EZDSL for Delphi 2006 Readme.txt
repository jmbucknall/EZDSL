======================================================================
                                EZDSL
                             version 3.03

              Easy classical data structures for Delphi 

              Copyright (c) 1993-2006 Julian M. Bucknall
======================================================================


Support for Delphi 2006 (Win32)
----------------------------------------------------------------------
This readme file explains the support for Delphi 2006 (Win32). There
is no support for Delphi for .NET 2006.

The support comprises four files zipped up in a zip archive
- EZDSL3dA.bdsgroup -- the BDS project group file
- EZDSL3dA.bdsproj  -- the BDS project file
- EZDSL3dA.dpk      -- the source file for the Delphi 2006 package
- EZDSL3dA.res      -- the resource file for the Delphi 2006 package
- EZDSLDef.INC      -- a replacement defines include file that 
                       supresses "unassigned variable" warnings
- EZDSLOpt.INC      -- a replacement compiler options file that 
                       includes a block for Delphi 2006

No pre-compiled package is available for Delphi 2006; instead you must
compile it. This is simple: open the project group file in BDS2006 and
build.

The naming convention I use for packages is EZDSLnxc where n is the
major version number of EZDSL (in this case 3), x is the minor version
number expressed as a alphabetic character (.00=a, .01=b, etc, in this
case d), and c is the Delphi compiler major version number (in this
case A, hexadecimal for 10, since Delphi 2006 is the 10th version of
Delphi). Hence EZDSL3dA.DPL is the EZDSL version 3.03 package for
Delphi 2006.


Unsafe type, code, and typecast warnings
----------------------------------------------------------------------
Unless you want to be totally put off or just want a laugh, do not
compile EZDSL with these warnings active in BDS2006. EZDSL was written
in a very unsafe manner (that's in a .NET sense, not in a "it's lucky
that this code works at all" sense) with pointers, and casts from
pointers to objects, and all the rest of those short cuts we used to
use to gain extra speed at the expense of less readable code.

The code has been thoroughly tested and although "unsafe", works as
described in the voluminous documentation.


                  Julian M. Bucknall, Colorado Springs, USA, July 2006

EZDSL, the library, the units, the include files and this
documentation, is Copyright (c) 1993-2006 Julian M. Bucknall
======================================================================