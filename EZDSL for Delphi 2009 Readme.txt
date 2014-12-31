======================================================================
                                EZDSL
                             version 3.03

              Easy classical data structures for Delphi 

              Copyright (c) 1993-2009 Julian M. Bucknall
======================================================================


Support for Delphi 2009 (Win32)
----------------------------------------------------------------------
This readme file explains the support for Delphi 2009 (Win32). There
is no support for Delphi Prism.

The support comprises four files zipped up in a zip archive
- EZDSL3dC.bdsgroup -- the BDS project group file
- EZDSL3dC.bdsproj  -- the BDS project file
- EZDSL3dC.dpk      -- the source file for the Delphi 2006 package
- EZDSL3dC.res      -- the resource file for the Delphi 2006 package
- EZDSLDef.INC      -- a replacement defines include file that 
                       supresses "unassigned variable" warnings
- EZDSLOpt.INC      -- a replacement compiler options file that 
                       includes a block for Delphi 2009
- EZDSLHsh.PAS      -- a replacement hash table source file 
                       (removes an unneeded "packed" keyword
- DTSTGEN.PAS       -- a replacement test helper source file
                       (removes all shortstrings to avoid UniCode
                       string errors)


No pre-compiled package is available for Delphi 2009; instead you must
compile it. This is simple: open the project group file in Delphi 2009
(or RAD Studio 2009) and build.

The naming convention I use for packages is EZDSLnxc where n is the
major version number of EZDSL (in this case 3), x is the minor version
number expressed as a alphabetic character (.00=a, .01=b, etc, in this
case d), and c is the Delphi compiler major version number (in this
case C, hexadecimal for 12, since Delphi 2006 is the 12th version of
Delphi). Hence EZDSL3dC.DPL is the EZDSL version 3.03 package for
Delphi 2009.


Unsafe type, code, and typecast warnings
----------------------------------------------------------------------
Unless you want to be totally put off or just want a laugh, do not
compile EZDSL with these warnings active in Delphi 2009. EZDSL was
written in a very unsafe manner (that's in a .NET sense, not in a
"it's lucky that this code works at all" sense) with pointers, and
casts from pointers to objects, and all the rest of those short cuts
we used to use to gain extra speed at the expense of less readable
code.

The code has been thoroughly tested and although "unsafe", works as
described in the voluminous documentation.


              Julian M. Bucknall, Colorado Springs, USA, February 2009

EZDSL, the library, the units, the include files and this
documentation, is Copyright (c) 1993-2009 Julian M. Bucknall
======================================================================