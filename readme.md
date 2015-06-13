EZDSL 3.10
==========

_Easy classical data structures for Delphi_

Introduction
------------

The EZDSL units provide an OOP interface for classical data structures
for Delphi: stacks, queues, priority queues, lists, binary trees, hash
tables, and so forth.

**DANGER, WILL ROBINSON!**

These units were written originally for Delphi 1. You remember that: 16-bit,
shortstrings, still very pointer-bound. Over the years they've been upgraded to
32-bit with later Delphis, but they still maintain their roots. If I were
writing Delphi these days (I don't), I'd chuck all the pointer-based stuff 
and make them fully OOP, Unicode string capable, generic, with some patterns 
thrown in for good measure. But they are what they are: if you've been using 
them over the years, here they are for XE+ Delphis for code written "old-style".

So:

- if you are using long strings, you'll have to take care of the problems 
casting long strings to pointers and back again (the reference counting needs 
to be taken care of by code you write);
- there is no 64-bit support since several units use assembly (either 16- or 32-bit);
- there's issues with the red-black binary tree (as in, it's still a binary tree, 
but the balancing algorithms are subtly broken, it needs rewriting);
- pretty much all source files use obtuse, acronymic, 8.3 naming because of the 
continued support for Delphi 1.


Documentation
-------------

See EZDSL3.MD. 

Licensing
---------

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

