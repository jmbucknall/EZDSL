{===EZDSLDEF.INC======================================================

Compiler defines for the EZ Delphi Structures Library.

EZDSLDEF.INC is Copyright (c) 1995-2011 by Julian M. Bucknall

VERSION HISTORY
02Jul11 JMB 3.04 Release for Delphi XE
28Feb01 JMB 3.03 Release for Kylix and Delphi 6
24Oct99 JMB 3.02 Release for Delphi 4 & 5
26Sep97 JMB 3.00 Major new version, release for Delphi 3
13Mar96 JMB 2.00 release for Delphi 2.0
18Jun95 JMB 1.00 initial release
{=====================================================================}

{Notes: to deactivate a compiler define, place a period '.' between   }
{       the left curly brace and the '$' of '$DEFINE'.                }

{Undefine this if you don't want debugging info or assertion checks   }
{$DEFINE DEBUG}

{Undefine this if you want to see all the warnings 32-bit Delphi      }
{produces for the EZDSL units. Has no effect for Delphi 1.0. Note that}
{all warnings have been verified to be false (generally because an    }
{exception would have been raised, for example).                      }
{$DEFINE SuppressWarnings}

