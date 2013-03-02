\def\title{CO-DFNS COMPILER (Version 0.1)}
\def\topofcontents{\null\vfill
  \centerline{\titlefont Co-Dfns Compiler}
  \vskip 15pt
  \centerline{(Version 0.1)}
  \vfill}
\def\botofcontents{\vfill
\noindent
Copyright $\copyright$ 2013 Aaron W. Hsu $\.{arcfide@@sacrideo.us}$
\smallskip\noindent
All rights reserved.
}

% These are some helpers for handling some of the apl characters.
\def\aa{\alpha\alpha}
\def\ww{\omega\omega}

% Some things for handling verbatim
\def\verbatim{\begingroup
  \def\do##1{\catcode`##1=12 } \dospecials
  \parskip 0pt \parindent 0pt \let\!=!
  \catcode`\ =13 \catcode`\^^M=13
  \tt \catcode`\!=0 \verbatimdefs \verbatimgobble}
{\catcode`\^^M=13{\catcode`\ =13\gdef\verbatimdefs{\def^^M{\ \par}\let =\ }} %
  \gdef\verbatimgobble#1^^M{}}

% Setup the fonts that we want
% ...

@** Co-Dfns Compiler.  Welcome to the Co-Dfns compiler.  This document
forms the complete description and implementation of the Co-Dfns
compiler and almost all of it's constituent parts.  The Co-Dfns
compiler is designed to be a fast, performant compiler for the Co-Dfns
array language.  It should produce code that executes quickly and
efficiently where traditional APL languages may not do so well.  The
language itself is a slight set of concurrent extensions to the D-fns
language created by Dyalog, Ltd.  The language accepted and compiled
by the compiler described here should produce code that is
semantically equivalent (or as near as makes sense) to the results
obtained by the Dyalog APL implementation.

The compiler itself is divided into a series of sections that
correspond to traditional compiler designs.  This compiler takes a few
strategies to compilation that distinguish it from the traditional
compiler, however.  Firstly, the compiler lacks a tokenizer as such.
Instead, a PEG grammar suffices to describe the initial abstract
syntax that is fed into the compiler passes.  Secondly, the compiler
itself is composed of a number of small, specific compiler passes,
rather than a few, sophisticated large ones.  This is called the
Nanopass style of compiler construction, and while the language of
implementation is C, the spirit of this compiler rests very heavily in
the research done on nanopass systems [citation needed].

The compiler itself consists of the following primary components.

@p
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

@<Memory handling functions and structures@>@;
@<Stack functions and structures@>@;
@<Compiler AST and related structures@>@;
@<AST constructors and copiers@>@;
@<Utilities for parsing@>@;
@<Parser functions and structures@>@;
#include "grammar.c"
@<Primary compiler interface@>@;

@ The main compiler interface is pretty basic. It takes input and
output filenames and will compile the input filename to an LLVM module
that is written to the output filename.

@<Primary compiler interface@>=
int
main(int argc, char *argv[])
{
        @<Check for errors and print usage if necessary@>@;

	yycontext ctx;
	Module *ast;
	Pool *ast_pool;

	@<Configure parser context@>@;
	@<Open input file for parsing@>@;
	@<Parse |ifile| to |ast|@>@;
	print_module(ast);
        return 0;
}

@ The following summarizes the usage of the program.

@<Check for errors and print usage if necessary@>=
if (argc != 3) {
        fprintf(stderr, 
            "You must provide an input and output file only.\n");
        exit(EXIT_FAILURE);
}

@ When compiling, we need to open up the input file that we received 
for reading. We will save both the name of the file and the 
|FILE *| stream that we receive.
The output file name is saved here as well, but we don't manually 
open the file stream for that, because the LLVM module printer will 
do that for us later on.

@<Open input file for parsing@>=
char *ifname = argv[1];
char *ofname = argv[2];

ctx.ifile = fopen(ifname, "r");

if (ctx.ifile == NULL) {
	perror(argv[0]);
	exit(EXIT_FAILURE);
}

@** Abstract Syntax: there and back again.  The first consideration
shall be the definition of the underlying data structure over which
the rest of the compiler will operate.  All future sections are
predicated upon an understanding of the abstract representation of
code given here. One must understand the target structure of the
parser, as well as understand the form over which all compiler passes
operate.

Before considering the questions of how to parse and how to compile
the syntax tree, it must first be defined.  The following description
gives a rough estimation of what the whole abstract syntax looks like.

\def\var#1{\hbox{\it #1}}
$$\eqalign{%
  \var{Module}\to&\var{Global}*\cr
  \var{Global}\to&\var{Variable}(\var{Constant}\vert\var{Function})\cr
  \var{Constant}\to&\hbox{integer}*\cr
  \var{Function}\to&\var{Constant}\vert\var{Variable}\cr
  \var{Variable}\to&\hbox{string}\cr
}$$

\noindent
Abstractly (snicker, snicker), every Co-Dfns program is considered to 
be a module (to borrow the LLVM terminology) of global definitions.
These are usually obtained from a parsed file, but they may come 
from some other means. These definitions may either define constant 
values from array expression, or they may define functions and
operators. 

@<Compiler AST...@>=
typedef struct ast_module {
        int count;
	struct ast_global *globals[];
} Module;

@ A global represents an assignment to a global variable, which is 
either a function or a constant.

@<Compiler AST...@>=
enum global_type {
	GLOBAL_FUNC, GLOBAL_CONST
};
typedef struct ast_global {
	enum global_type type;
	struct ast_variable *var;
	void *value;
} Global;

@ A constant value is an array of integers. 

@<Compiler AST...@>=
typedef struct ast_constant {
	int count;
	long long elems[];
} Constant;

@ A function's body is either a variable or a constant.

@<Compiler AST...@>=
enum function_type {
	FUNCTION_VAR, FUNCTION_LIT
};
typedef struct ast_function {
	enum function_type type;
	void *body;
} Function;

@ A variable holds only a name at the moment.

@<Compiler AST...@>=
typedef struct ast_variable {
	char *name;
} Variable;

@ Finally, there are times when we want to box up an integer for use
in one way or another. The following structure helps with that.

@<Compiler AST...@>=
typedef struct ast_integer {
	long long int value;
} Integer;

@* Pretty printing ASTs. This section defines a pretty printer for the
AST we just defined. It is very basic right now, and it is not
designed to result in a read/write invariance. This is the set of
functions we define here.

@<Parser functions...@>=
void print_module(Module *);
void print_global(Global *);
void print_function(Function *);
void print_constant(Constant *);
void print_variable(Variable *);

@ Let's start with just a simple printer of modules. In this case, we
just have to call the global printer for each of the globals.

@<Parser functions...@>=
void
print_module(Module *module)
{
        int i;

        for (i=0; i < module->count; i++) {
                print_global(module->globals[i]);
                printf("\n");
        }

        return;
}

@ Printing globals is also pretty easy. The general form is to print 
the variable followed by the $\gets$ symbol and then the result of 
printing the expression.

@<Parser functions...@>=
void
print_global(Global *global)
{
        printf("%s←", global->var->name);

	switch (global->type) {
		case GLOBAL_CONST:
			print_constant(global->value);
			break;
		case GLOBAL_FUNC:
			print_function(global->value);
			break;
	}


        return;
}

@ A function is printed surround by braces, each on their own line.

@<Parser functions...@>=
void
print_function(Function *func)
{
        printf("{\n");

	switch (func->type) {
		case FUNCTION_VAR:
			print_variable(func->body);
			break;
		case FUNCTION_LIT:
			print_constant(func->body);
			break;
	}

        printf("\n}\n");

        return;
}

@ Printing variables works just like printing strings.

@<Parser functions...@>=
void
print_variable(Variable *var)
{
	printf("%s", var->name);
}

@ Printing literals is just printing the values in space delimited 
form. Since a constant is only or always a vector of some sort, 
we do not have to deal with any special printing needs.

@<Parser functions...@>=
void
print_constant(Constant *con)
{
	int i;

	for (i = 0; i < con->count; i++) {
		printf("%lld ", con->elems[i]);
	}
}

@* Parsing Co-Dfns Programs. There are a number of parts that actually
make up the parser for Co-Dfns. The first is a grammar description of
the initial, slightly ambiguous grammar that is used to turn a file
into an initial AST. This initial transformation is not actually
complete, and requires some fixing up, since the Co-Dfns syntax is
ambiguous in absence of type information on variables that indicates
whether they are functions, operators, or values. Here is the PEG
grammar describing this.

\medskip\begingroup\narrower
\def\printgrammar{
\begingroup
  \def\do##1{\catcode`##1=12 } \dospecials
  \parskip 0pt \parindent 0pt
  \catcode`\ =13 \catcode`\^^M=13
  \tt \verbatimdefs \input grammar.peg 
\endgroup}
\printgrammar\endgroup
\medskip

\noindent This grammar is compiled to a ``grammar.c'' file using the
|peg(1)| program. It produces a backtracking, recursive descent parser
from the above description. Moreover, it also builds the AST as a
result. To support this, we define an extra field in the parser's 
context that holds a stack and a memory pool. We use both to 
build up the AST value as to go through our parsing.

@d YY_CTX_MEMBERS struct parse_data pd; FILE *ifile;

@<Parser functions...@>=
struct parse_data {
	Stack *ast;
	Pool *pool;
};

@ Let's consider the code necessary to support the PEG grammar. 
Our AST tree must be considered as a tree of nodes we construct 
from the bottom up. Roughly speaking, each major non-terminal 
in our PEG grammar corresponds to a constructor of a part of that tree. 
To make it simple, we try to ensure that only a single "parser" 
function need be called for each significant non-terminal in the 
grammar. It is possible to construct a tree by making use of a stack, 
in the same basic fashion of a calculator. We push nodes onto 
the |ast| field in the parser context as we encounter them, and 
|pop| them off the stack as we make use of them to construct new 
elements in the tree. Eventually, by the end of the parsing, 
a single node --- the root node of the fully parsed AST --- 
will reside in the |ast| stack. 

@ Let us take a simple one as an example first, variables. The 
|parse_variable| function needs only the name of the variable to 
initially construct the variable node. We leave the type of the 
variable unknown for the omoment. This brings up an interesting 
element of the PEG parser; the text matched is delivered 
in |yytext| and its length is provided in |yyleng|. We must 
allocate enough space fo rthe variable, but fortunately, this is 
pretty easy.

@<Parser functions...@>=
void
parse_variable(struct parse_data *pd, char *n, int l)
{
	Variable *var;

	var = new_variable(pd->pool, n, l);
	push(pd->ast, var);
}

@ Now that we have warmed up a bit, we can proceed to an 
example of consuming elements from the stack. We expect to have 
two elements on the stack when |parse_global| is called. As the 
prodcution of a PEG grammar is examined left to right, the variable 
will be pushed first, followed by the function or constant node. 
We need only to pop those elements off and make use of them to build 
the global node.

@<Parser functions...@>=
void
parse_global(struct parse_data *pd, enum global_type t)
{
	Variable *var;
	void *value;
	Global *g;

	value = pop(pd->ast);
	var = pop(pd->ast);
	g = new_global(pd->pool, var, t, value);

	push(pd->ast, g);
}

@ We are really on a roll now! What about something a bit more 
involved? The module and integer forms both take some interesting 
pieces, but the heart of it is that they must have more than a 
fixed number of elements. Let's handle modules first, as they are 
actually simpler. At this point, all the elements in the stack 
are globals.

@<Parser functions...@>=
void
parse_module(struct parse_data *pd)
{
	int i, c; 
	Module *mod;

	c = STACK_COUNT(pd->ast);
	mod = new_module(pd->pool, c);

	for (i = 0; i < c; i++) {
		mod->globals[i] = pop(pd->ast);
	}

	push(pd->ast, mod);
}

@ Our next magic trick involves integer arrays. In this case, we 
must add yet another strangeness. in order to make stacks nicer and 
simple, only pointers compatible with |void *| pointers are pushed 
onto stacks. While we might make the case that integers fall into 
this category, let's not deceive ourselves with cheap tricks. 
Such foolery is for the masses, not for a compiler writer. 
Instead, we box our integers when parsing them, with the 
understanding that we will unbox them when necessary or convenient. 
This is our convenient time, when parsing arrays of integers. 
Her we work almost as in |parse_module|, but we remember to unbox 
our integers as they come in.
We do have to be careful here because the stack may not contain 
just our own integers that we care about. To deal with this, we 
use a technique of putting a spacer between the elements that 
we care about, which will be at the top, and anything else that 
we may have in the stack. We discuss this more in the next section.

@<Parser functions...@>=
void
parse_intarray(struct parse_data *pd)
{
	int i, c;
	Integer *n;
	Constant *a;
	Stack *s;

	s = new_stack_barrier(pd->ast);
	c = STACK_COUNT(s);
	a = new_constant(pd->pool, c);

	for (i = 0; i < c; i++) {
		n = pop(s);
		a->elems[i] = n->value;
	}

	push(pd->ast, a);
	stack_dispose(s);
}

@ The above |parse_intarray| function looks pretty straightforward, 
and it almost looks like the |parse_module| function, but for some 
key differences. The unboxing of integers we have dealt with in 
the previous section, but this section is meant to discuss that 
strange little |new_stack_barrier()| function that we use there. 
That's the function that helps us to split a stack based on a 
spacer. When we parse an integer array, for instance, we may 
already have some other things on the stack besides just the 
integer arrays that we care about. We don't want to also treat 
those other values as boxed integers --- that would be very bad. 
Instead, before we begin parsing the integers themselves, we 
put a spacer value on the stack, which marks the end of the integers 
as we are going through them. We can then use this spacer to get 
just the values that we care about. The |new_stack_barrier| 
function does just this, by giving us a new stack whose elements 
consist only of the elements up to the barrier. 

@<Utilities for parsing@>=
Stack *
new_stack_barrier(Stack *s)
{
	int i, c;
	void *t;
	Stack *n;

	c = STACK_COUNT(s);
	n = new_stack(c);

	for (i = 0; i < c; i++) {
		t = pop(s);
		if (t == NULL) return n;
		push(n, t);
	}

	return n;
}

@ I find it ironic that it has taken so long to make it here. 
One might find parsing integers to be relatively easy, but not 
really, compared to our previous examples. Still, we had to 
make it here some time, and what better time than the present? 
We use |strtoll| to do the conversion.

@<Parser functions...@>=
void
parse_int(struct parse_data *pd, char *ns, int l)
{
	long long v;
	Integer *n;
	char b[64];

	strncpy(b, ns, l);
	v = strtoll(b, NULL, 10);
	n = new_int(pd->pool, v);
	push(pd->ast, n);
}

@ Next, let's talk about parsing functions. These are pretty 
easy, but the parser needs to provide a type of the function 
when it is created. 

@<Parser functions...@>=
void
parse_function(struct parse_data *pd, enum function_type t)
{
	Function *fn;

	fn = NEW_NODE(pd->pool, Function, 0);

	fn->body = pop(pd->ast);
	fn->type = t;

	push(pd->ast, fn);
}

@ Now that our parsing infrastructure is up and running, it must 
be initialized sommehow. The name of the main entry point to the 
parser is |parse_codfns|.

@d YYPARSE parse_codfns

@ When parsing, we want to have a unique parsing context for each 
invocation of the compiler, so we may support multiple, parallel 
invocations of the compiler. This requires setting up some 
definitions of course, but we must also remember to initialize the 
context appropriately.

@d YY_CTX_LOCAL
@d INIT_POOL_SIZE 1024
@d INIT_STACK_SIZE 64

@<Configure parser context@>=
memset(&ctx, 0, sizeof(yycontext));
ctx.pd.ast = new_stack(INIT_STACK_SIZE);
ctx.pd.pool = new_pool(INIT_POOL_SIZE);

@ The final piece we approache here is the means by which the parser 
gets data into itself. We grab data from the |ifile| variable. 

@d YY_INPUT(buf, result, max_size)
{
	int yyc = fgetc(ctx->ifile);
	result = (EOF == yyc) ? 0 : (*(buf) = yyc, 1);
}

@ Now we can consider how we actually invoke and run the parser. 
We must repeatedly call |parse_codfns| until it indicates that 
no more parsing is possible. The result of parsing will be found in 
|ctx.pd.ast| at the top of the stack. 

@<Parse |ifile| to |ast|@>=
while (parse_codfns(&ctx));
ast = pop(ctx.pd.ast);
ast_pool = ctx.pd.pool;
stack_dispose(ctx.pd.ast);

@* Allocating Memory. 
In many traditional compilers, you mutate your AST as you go along. 
This would seem to be an endless source of potential bugs just 
waiting to happen. Functional programming langauges deal with this 
by making a new AST at each pass, ensuring that no mutation of 
a previous AST need ever to occur. We take a similar solution here, 
where each of our AST generating passes constructs a new AST as 
its result. Unfortunately, managing this all by using raw |malloc|
calls every time we want to make a new node in the AST is cumbersom 
at best, and much more likely to introduce error, as many complex 
cleanup operations must exist to avoid leaking memory. Fortunately, 
we have an alternative: we can use a singl epool of memory for 
each new, self-contained AST generated from a pass. We can pre-allocate 
space before entering the pass and free the entire structure in one 
go when we no longer need the AST returned from that pass. This 
section details the operations needed to support this style of memory 
management.

@ First, how are pools created and managed, and what is their 
structure? A pool is a block of pre-allocated memory for allocations. 
We support only allocation, not freeing individual blocks of memory 
in the pool. We use a structure which stores the start, end, 
and current pointer to unallocated space within the memory pool. 

@<Memory handling functions...@>=
typedef struct pool {
	void *start;
	void *end;
	void *cur;
} Pool;

@ Use |new_pool| to create a new pool. We return a pointer to the 
new pool structure. Internally, we allocate two separate blocks 
of memory, the first to hold the structure, and the second to 
hold the rest of the memory. We could have embedded the pool structure 
into the actual memory block, but in practice this results in 
some awkward uses, and it is easier to transparently resize a 
pool this way.

@<Memory handling...@>=
Pool *
new_pool(size_t s)
{
	char *buf;
	Pool *res;

	buf = malloc(s);

	if (buf == NULL) {
		perror("new_pool");
		return NULL;
	}

	res = malloc(sizeof(Pool));

	if (res == NULL) {
		perror("new_pool");
		free(buf);
		return NULL;
	}

	res->start = buf;
	res->end = buf + s;
	res->cur = buf;
	
	return res;
}

@ The macros |POOL_AVAIL| and |POOL_SIZE| give the amount of 
memory available and the amount of memory total in a pool 
respectively.

@d POOL_SIZE(p) ((char *)(p)->end - (char *)(p)->start)
@d POOL_AVAIL(p) ((char *)(p)->end - (char *)(p)->cur)

@ We can also resize a pool if it is too small.

@<Memory handling...@>=
int
pool_resize(Pool *p, size_t s)
{
	char *buf;
	int o;

	buf = p->start;
	o = (char *)p->cur - buf;
	buf = realloc(buf, s);

	if (buf == NULL) {
		perror("pool_resize");
		return 1;
	}

	p->start = buf;
	p->end = buf + s;
	p->cur = buf + o;

	return 0;
}

@ We only allow freeing of whole memory pools, and not 
elements in them. However, this is most easily achieved with a 
few calls to |free|.

@<Memory handling...@>=
void
pool_dispose(Pool *p)
{
	free(p->start);
	free(p);
}

@ The whole intent behind using memory pools is to make it 
easier to manage many small allocations. These allocations 
are not all allocations of the same type. To help in creating 
the constructors that use pools to create special purpose 
elements or types, we have the |NEW_NODE| macro which creates 
nodes of the right type and allows you to give extra padding 
in the allocation. This is enough to serve as the main underlying 
allocation function for the main node constructors.

@d NEW_NODE(p, t, s) ((t*)pool_alloc((p), ((s)+sizeof(t))))

@<Memory handling...@>=
void *
pool_alloc(Pool *p, size_t s)
{
	void *res;

	while (s > POOL_AVAIL(p)) {
		if (pool_resize(p, 1.5 * POOL_SIZE(p) + 1))
			return NULL;
	}

	res = p->cur;
	p->cur = ((char *)p->cur) + s;

	return res;
}

@* Stacks of pointers.
Our implementation of stacks of pointers is very similar to that 
for memory pools except that we have push and pop operations 
instead of memory allocations. We also know ahead of time the size 
of every element in the stack. The stack meta data mirrors that of 
a memory pool. 

@<Stack functions...@>=
typedef struct stack {
	void **start;
	void **end;
	void **cur;
} Stack;

@ Allocation or creating a new stack using |new_stack| works 
a whole lot like creating a new memory pool, however, the input is 
the number of elements in the stack, as opposed to bytes of memory.

@<Stack functions...@>=
Stack *
new_stack(int count)
{
	Stack *res;
	void **buf;

	buf = malloc(count * sizeof(void *));

	if (buf == NULL) {
		perror("new_stack");
		return NULL;
	}

	res = malloc(sizeof(Stack));

	if (res == NULL) {
		perror("new_stack");
		free(buf);
		return NULL;
	}

	res->start = buf;
	res->end = buf + count;
	res->cur = buf;

	return res;
}

@ Disposing of a stack requires a couple of calls to the 
|free| function.

@<Stack functions...@>=
void
stack_dispose(Stack *s)
{
	free(s->start);
	free(s);
}

@ We likewise would like to know the size and number of elements 
available in a stack, but unlike memory pool, we often would like 
to know how many elements are in the stack already, too.

@d STACK_SIZE(s) ((s)->end - (s)->start)
@d STACK_AVAIL(s) ((s)->end - (s)->cur)
@d STACK_COUNT(s) ((s)->cur - (s)->start)

@ We would also like to be able to easily resize the stack.

@<Stack functions...@>=
int
stack_resize(Stack *s, int count)
{
	int o;
	void **buf;
	
	o = STACK_COUNT(s);
	buf = realloc(s->start, count * sizeof(void *));

	if (buf == NULL) {
		perror("stack_resize");
		return 1;
	}

	s->start = buf;
	s->end = buf + count;
	s->cur = buf + o;

	return 0;
}

@ Now that the book keeping is out of the way, let's proceed to 
the main even, pushing and popping. 

@d pop(s) (*((s)->cur--))

@<Stack functions...@>=
int
push(Stack *s, void *e)
{
	if (!STACK_AVAIL(s)) {
		if (stack_resize(s, 1.5 * STACK_SIZE(s) + 1)) {
			perror("push");
			return 1;
		}
	}

	*(s->cur++) = e;
	return 0;
}

@* Creating and copying ASTS.
The core structures of the ASTs can be created easily enough if 
you just use the memory pools and the |NEW_NODE| macro, but that's 
still not a very nice way to do things. This chapter describes the
functions for creating and copying ASTs, which allows for easy 
building of ASTs up from nothing. This is the set of functions 
we will be defining in this chapter.

@<AST constructors and copiers@>=
Module *new_module(Pool *, int);
Global *new_global(Pool *, Variable *, enum global_type, void *);
Constant *new_constant(Pool *, int);
Function *new_function(Pool *, enum function_type, void *);
Variable *new_variable(Pool *, char *, int);
Integer *new_int(Pool *, long long int);

@ Let's go down the list. The |Module| constructor is actually 
almost trivial.

@<AST const...@>=
Module *
new_module(Pool *p, int count)
{
	return NEW_NODE(p, Module, count * sizeof(Global *));
}

@ Next, let's create a global. This one is also quite easy.

@<AST const...@>=
Global *
new_global(Pool *p, Variable *v, enum global_type t, void *val)
{
	Global *res;

	res = NEW_NODE(p, Global, 0);

	res->var = v;
	res->type = t;
	res->value = val;

	return res;
}

@ When creating a constant, this is basically the same pattern 
as for modules. Note here, as in a module, the elements are not 
fully populated yet.

@<AST const...@>=
Constant *
new_constant(Pool *p, int count)
{
	return NEW_NODE(p, Constant, count * sizeof(long long));
}

@ Now let's consider constructing a function. This also doesn't 
take much effort.

@<AST const...@>=
Function *
new_function(Pool *p, enum function_type t, void *body)
{
	Function *res;

	res = NEW_NODE(p, Function, 0);

	res->type = t;
	res->body = body;
	
	return res;
}

@ Creating a new |Variable| might be the only thing around here 
that could be considered a little involved and not strictly 
trivial.

@<AST const...@>=
Variable *
new_variable(Pool *p, char *n, int l)
{
	char *str;
	Variable *res;

	res = NEW_NODE(p, Variable, 0);
	str = NEW_NODE(p, char, l);

	strncpy(str, n, l);
	res->name = str;

	return res;
}

@ The following allows us to box up a |long long int| value into 
an |Integer *| value.

@<AST const...@>=
Integer *
new_int(Pool *p, long long v)
{
	Integer *res;

	res = NEW_NODE(p, Integer, 0);

	res->value = v;

	return res;
}


@** Index.
