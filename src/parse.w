\def\title{CO-DFNS PARSER (Version 0.1)}
\def\topofcontents{\null\vfill
  \centerline{\titlefont Co-Dfns Parser}
  \vskip 15pt
  \centerline{(Version 0.1)}
  \vfill}
\def\botofcontents{\vfill
\noindent
Copyright $\copyright$ 2013 Aaron W. Hsu $\.{arcfide@@sacrideo.us}$
\smallskip\noindent
All rights reserved.
}

@* Parsing Co-Dfns. The Co-Dfns language is a rather difficult one to 
parse effectively. While most of the language is trivial, the language
has one or two parts that are inherently ambiguous if you do not already
know the variable references are functions or values. This section 
describes the behavior of the parser and the components that we use to 
support it. Most of the parser is defined as a PEG grammar in the 
file {\tt grammar.peg}. 

@p
#include <stdio.h>

#include "grammar.c"

int
main(int argc, char *argv[])
{
	while(yyparse());
	return 0;
}

@* Index.
