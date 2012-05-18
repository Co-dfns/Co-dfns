\def\title{RUNTIME GAME OF LIFE}
\def\topofcontents{\null\vfill
  \centerline{\titlefont Game of Life in HPAPL Runtime}
  \vfill}
\def\botofcontents{\vfill
\noindent
Copyright $\copyright$ 2012 Aaron W. Hsu $\.{arcfide@@sacrideo.us}$
\smallskip\noindent
Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.
\smallskip\noindent
THE SOFTWARE IS PROVIDED ``AS IS'' AND THE AUTHOR DISCLAIMS ALL
WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR
PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
}

\font\aplfont = "APL385 Unicode" at 10pt
\def\apl{\medskip\begingroup\aplfont\obeylines}
\def\endapl{\par\endgroup\medskip}

@* Introduction.  This is an example of using the HPAPL runtime for a 
simple program, in this case, the Game of Life stencil.  It will also 
serve as an useful benchmark for testing the runtime speed against some 
other possible implementations, such as Kanor.  The intention of this 
document is to use only the things that we would use as a compiler of 
the HPAPL language.  This means that the code here should look like the 
code that would be output by the compiler.

%%% XXX Insert a diagram of the Game of Life Program

Our program is laid out as follows:

@p
#include <stdio.h>
#include <hpapl.h>
@<CnC Steps@>@;
@<Main Program@>@;

@ We are assuming that we are using the runtime to have efficient code,
so we will be making some optimizations that the current compiler may 
not yet be able to do without help.

@* Steps. We have two main steps in this computation, the generator 
and the game of life program proper.  Let us tackle the game of life 
first. Here is what the step would look like in APL:

\apl
∇R←T Life D;NC
NC←+/,1 0 ¯1∘.⊖1 0 ¯1⌽¨⊂D
R←⊃1 D∨.∧3 4=NC
R←¯1 ¯1↓1⊖1⌽R
∇\endapl

\noindent We will take each of these lines in turn, but lets start by 
getting the basic outline of the |Life| function written.

@<CnC Steps@>=
void
Life(Array *R, Array *T, Array *D)
{
	@<Declare local state and allocate@>@;
	@<Compute neighbor counts@>@;
	@<Compute next generation@>@;
	@<Strip ghost cells from result@>@;
	@<In |Life|, clean up our mess@>@;
}

@ When dealing with the local state, we assume that the incoming arrays
may not be large enough for our purposes, and especially the output 
array may need to be allocated correctly.  However, we also assume that 
we are safe to do whatever we want to these arrays, as they are local 
and specific to this step instance.  In our case, we have a single local
array, but the incoming array |D| is not actually used after NC is 
introduced, so we can overload these and treat them like the same 
array.  This means that we have no local state to declare.  We do need
to calculate the array consumption needs of our step however.

@<Declare local state and allocate@>=


@* Main Program.

@* Index.
