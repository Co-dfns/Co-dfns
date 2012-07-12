\def\title{HPAPL: Runtime Examples}
\def\topofcontents{\null\vfill
  \centerline{\titlefont Examples of using the HPAPL Runtime}
  \vskip 15pt
  \centerline{(Version 1.0)}
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
\def\idxbox{\mathrel{\lower0.3em\vbox{
  \hrule
  \hbox{\strut\vrule\thinspace\vrule}
  \hrule
}}}
\def\eachop{\mathrel{\ddot{ }}}

@* Introduction.
This document gives some examples of using the HPAPL runtime by hand. 
Normally this is a bad idea, but it will let you get an understanding 
of what an HPAPL compiler's output should look like. We progress from 
simple programs to those that become progressively more complex.
Each example can be run by executing the function with a single 
argument that is ``ex$n$'' where $n$ is the number of the example without 
any leading zeros.

\medskip{\parindent=0.3in
\item{1.}{\it Scalar addition.} A simple demonstration of scalar addition.
By computing $5+5$.
\par}\medskip

@p
#include <stdio.h>
#include <string.h>
@#
#include "hpapl.h"
@#
@<Ex 1. Compute $5+5$@>@;

int main(int argc, char *argv[])
{
	void (*example)(void);
	char *msg;
	
	if (argc != 2) { 
		printf("%s: ex<n>\nRun the <n>th example.\n\n", argv[0]);
		return 1;
	}@#
	
	if (!strcmp(argv[1], "ex1")) {
		msg = "Ex 1: Computing 5 + 5";
		example = ex1;
	} else {
		printf("Unknown example, please enter a valid example.\n");
		return 2;
	}@#
	
	printf("Running %s\n\n", msg);
	example();
	printf("\nFinished running the example, goodbye!\n\n");@#
	
	return 0;
}

@* Example 1. This example computes the sum of $5$ and $5$. It is the 
simplest sort of example that shows the basic setup necessary for such 
things. We do not take advantage of any of the more complicated elements
such as printing out array values, either. Instead, we will just print 
the field results.

@<Ex 1. Compute $5+5$@>=
void ex1(void) 
{
	AplArray z, x;
	init_array(&z);
	init_array(&x);
	alloc_array(&z, INT);
	alloc_array(&x, INT);
	*((AplInt *) x.data) = (AplInt) 5;
	plus(&z, &x, &x, NULL);
	printf("%ld\n", *((AplInt *) z.data));
	free_data(&z);
	free_data(&x);
}

@* Index.
