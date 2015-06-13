{===EZDSLCts==========================================================

Constants for the EZDSL (Delphi Structures Library) unit.

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

unit EzdslCts;

interface

{Note: the actual strings are found in EZDSLCTS.RC and
       EZDSLCTS.R16/.R32}

const
  {Start offset for string constants}
  {Note: this can be altered to suit the application}
  ezdsStartOffset = $62D5;

  {Error string constants}
  escTooManyItems   = ezdsStartOffset+ 1;
  escInsInvalidHere = ezdsStartOffset+ 2;
  escDelInvalidHere = ezdsStartOffset+ 3;
  escInsertDup      = ezdsStartOffset+ 4;
  escCannotMoveHere = ezdsStartOffset+ 5;
  escNoCompare      = ezdsStartOffset+ 6;
  escNoDupData      = ezdsStartOffset+ 7;
  escNoDisposeData  = ezdsStartOffset+ 8;
  escBadSource      = ezdsStartOffset+ 9;
  escIndexError     = ezdsStartOffset+10;
  escBadCaseSwitch  = ezdsStartOffset+11;
  escKeyNotFound    = ezdsStartOffset+12;
  escTableFull      = ezdsStartOffset+13;
  escSortNeedsCmp   = ezdsStartOffset+14;
  escCmpNeeded      = ezdsStartOffset+15;
  escBadBooleanInx  = ezdsStartOffset+16;


  {Assertion string constants}
  ascFreeNilNode    = ezdsStartOffset+50;
  ascNewNodeSize0   = ezdsStartOffset+51;
  ascFreeNodeSize0  = ezdsStartOffset+52;
  ascEmptyExamine   = ezdsStartOffset+53;
  ascEmptyPop       = ezdsStartOffset+54;
  ascDeleteEdges    = ezdsStartOffset+55;
  ascExamineEdges   = ezdsStartOffset+56;
  ascInsertEdges    = ezdsStartOffset+57;
  ascReplaceEdges   = ezdsStartOffset+58;
  ascAlreadyAtEnd   = ezdsStartOffset+59;
  ascAlreadyAtStart = ezdsStartOffset+60;
  ascCannotJoinHere = ezdsStartOffset+61;
  ascCannotJoinData = ezdsStartOffset+62;
  ascSplitEdges     = ezdsStartOffset+63;
  ascOutOfRange     = ezdsStartOffset+64;
  ascExamineLeaf    = ezdsStartOffset+65;
  ascBadSkipLevel   = ezdsStartOffset+66;
  ascIsSortedList   = ezdsStartOffset+67;
  ascIsNotSortedList= ezdsStartOffset+68;
  ascBadCapacity    = ezdsStartOffset+69;
  ascNilArray       = ezdsStartOffset+70;
  ascNotSameSize    = ezdsStartOffset+71;

implementation

end.
