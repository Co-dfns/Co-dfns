\def\title{HPAPL: Runtime}
\def\topofcontents{\null\vfill
  \centerline{\titlefont The HPAPL Runtime Environment}
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

@* Introduction. You are reading the source code that implements 
the runtime environment for HPAPL. This code deals especially with 
the low-level details of the semantics of HPAPL programs, providing 
an API for the HPAPL compiler to target. It is fairly involved, 
because I want to isolate most of the complexity of the nitty 
details to the C compiler, and away from the main compiler, so that 
the main compiler's whole focus is on higher-level optimizations.
Thus, this runtime is in charge of datastructures, calling 
conventions, function abstractions, higher-order programming, 
primitive APL functions, memory management, and most every other 
detail of implementation. The program can be divided up mostly 
into the following sections:

@p
#include <assert.h>
#include <limits.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

@h

#include <qthread.h>

@<Runtime error reporting@>@;
@<Primary data structures@>@;
@<Internal data structures@>@;
@<Public function declarations@>@;
@<Utility functions@>@;
@<Memory management functions@>@;
@<Scalar APL functions@>@;
@<Non-scalar APL functions@>@;
@<APL Operators@>@;

@ The HPAPL at its core has two data types, functions and arrays. 
Functions as implemented in the runtime are first-class objects, but 
arrays cannot contain functions, which limits the areas where 
functions may be used. Arrays themselves may have either integers, 
reals, or characters in them. They are multi-dimensional and 
follow standard APL practices. We will be implementing most of 
the APL primitives in the runtime directly, but some will be written 
in terms of the others. This is a design decision over having some 
of the primitives written in the higher-level HPAPL language, 
rather than in the language of the runtime. Scalar functions are 
those that operate element-wise over two arrays, and non-scalar 
functions are everything else.  Operators are those class of 
functions that can take other functions as their arguments.

@ We do have one utility function that we use to store the version 
number of the runtime. This prints out a string representing the 
runtime version from the |runtime_ver| variable.

@p
float ver = 1.0;

void
print_version(void)
{
	printf("HPAPL Runtime Version (%f)\n", ver);
	printf("Copyright (c) 2012 Aaron W. Hsu\n");
}

@* Things to do.
The following is a list of things that I have noted need to be changed 
but that I have not yet done.

\medskip{\parindent=0.3in
\item{1.} We should have a separate document that has a set of benchmarks 
that we can work with.
\item{2.} As a runtime we need to find a good balance between safety and 
performance. I am considering a flag which indicates whether we use the 
safe library or the unsafe code.
\item{3.} We can improve the way we handle |function_identity| by running 
it at the time that we create function closures rather than running it 
when we do a reduction. This should save time if we add a field to the 
function closure structure that let's us know ahead of time the identity 
of the function. On the other hand, |function_identity| is probably not 
needed very often.
\item{4.} We currently use |alloc_array| assuming that it will set the 
|type| field. Is it possible that we could do better by not setting the 
|type| in |alloc_array| or |realloc_array|?
\item{5.} We need to audit the code for missing frees. I believe that 
there are a number of memory leaks in the system, so we need to audit our 
uses of |alloc_array| and |realloc_array| to make sure that they are 
freed afterwards using |free_data|.
\item{6.} The current |iota| function computes indexes in a very slow 
fashion. There is a more appropriate approach.
\par}\medskip

@* Array Structure. 
We must implement two main data structures: 
arrays and functions.  Arrays are the core, and we have a few 
requirements that drive our design. First, we want them to be as fast as 
possible, but we also want to be able to decouple the core array 
structure from the data areas where we store the elements. This 
frees us to potentially make use of faster memory allocation 
functions, segmented heaps, as well as shared data regions between 
multiple arrays.
We expect that most of the array headers will be stack allocated 
and that their allocations will be automatic. We use a static 
shape array to store the shape information so that we do not 
have to worry about managing that. In practice, noble arrays are 
rare, and we can do with having only a reasonably large number of 
them. We must also consider the integer type that we use for each 
shape. This should match our integer type that is native in our 
scalar types. We will assume an arbitrary limit that we may have 
no more elements in an array than can be accessed by a single 
dimension integer. 

Assuming that the limit to accessing our arrays is the our native 
|AplInt| type, then we assume that the shape is an array of |AplInt| 
values. We use |MAXRANK| to indicate the size of the static buffer 
that holds the shape of an array. The |rnk| field indicates the 
actual rank of the array, and thus, the number of valid elements of 
the |shp[MAXRANK]| field. Shapes must be nonnegative. The |SHPMAX| 
constant indicates the maximum value of any single shape dimension.

We also have a concept of arrays that will be filled in the future. 
These future arrays need to be marked specially, so that we know that 
the data is not yet available to be used. We use the |futr| flag 
to indicate an array's ``future'' status.

This gives us the following fields for our arrays:

\medskip{\parindent=0.5in
\item{|rnk|} The rank of the array;
\item{|shp|} A static array of length |MAXRANK| whose 
elements are all |AplInt| values;
\item{|siz|} The number of bytes allocated for the region 
pointed to by |data|;
\item{|dat|} A pointer to a region of memory containing 
the elements in row-major order; and finally,
\item{|typ|} An enumeration indicating the type of elements
in the array.
\item{|fut|} A flag indicating whether an array is a 
future or not. We use a |1| to indicate that the whole array is a 
single future, and a |2| to indicate that each element is a distinct 
future.
\par}\medskip

\noindent This leads us to the following |typedef| 
and definitions. We have a maximum array rank of |MAXRANK|. We use 
the macros |RANK|, |SHAPE|, |DATA|, |TYPE|, |FUTR|, and |SIZE| as
field accessors for arrays.

@d MAXRANK 32
@d SHPMAX SINT_MAX
@d RANK(a) ((a)->rnk)
@d SHAPE(a) ((a)->shp)
@d DATA(a) ((a)->dat)
@d TYPE(a) ((a)->typ)
@d FUTR(a) ((a)->fut)
@d SIZE(a) ((a)->siz)
@s AplType int
@s AplScalar int
@s AplInt int

@<Primary data structures@>=
typedef struct apl_array AplArray;
@<Define |AplType|@>@;
struct apl_array {
	short rnk;
	AplInt shp[MAXRANK];
	AplType typ;
	int fut;
	size_t siz;
	AplScalar *dat;
};

@ Since the macros we define above are useful to the outside, we duplicate 
these definitions for our public interface that we define at the end of 
this document.

@<Public macro definitions@>=
#define MAXRANK 32
#define SHPMAX SINT_MAX
#define RANK(a) (a)->rnk
#define SHAPE(a) (a)->shp
#define DATA(a) (a)->dat
#define TYPE(a) (a)->typ
#define FUTR(a) (a)->fut
#define SIZE(a) (a)->siz

@ We have three main types of values that we can have, and to indicate 
which one that we use, we setup an enumeration. We have one other 
value |UNSET| that indicates that nothing has been done with the array 
yet. Our |APLINT| type is a C |int|eger, since I am assuming 
that HPAPL will run on systems with at least 64-bit processors. 
I think this is a reasonable choice, and should be big enough. The 
|APLREAL| type is a |double|, since I want to have as much precision in 
my single floating point type as I can.  Finally, I have |APLCHAR| set 
to |wchar_t| since we are dealing with wide characters throughout;
this is APL afterall.

We define an |AplScalar| union of these types and use it above to 
define the |data| field of arrays. This makes life easy because we 
do not have to worry as much about the allocation needs of each 
individual type, and it makes iteration over the data array easier.
Most of our types are likely to be 64-bits on current systems, 
excepting characters, and this is the normal case we expect. The extra
complexity of working with the multiple datatype sizes to keep things 
as packed as possible is just not worth it.

We also have an internal union field |futr| when we want to store a 
pointer to the future AplArray that will be computed. This is not exposed 
to the world as a type, as no one should actually need to know about 
it outside of the runtime. We use the macros |APLINT|, |APLREAL|, |APLCHAR|, and 
|FUTR| as accessors to the union fields.

The |APLIOTA| type is special in that it is a compressed representation 
for arrays that are returned by certain invokations of the |index_gen| 
function, or derivations from them. We discuss this in more detail later.

@d INT(e) ((e)->intv)
@d REAL(e) ((e)->real)
@d CHAR(e) ((e)->chrv)

@<Define |AplType|@>=
enum apl_type { APLINT, APLREAL, APLCHAR, APLIOTA, UNSET };
typedef enum apl_type AplType;
typedef int AplInt;
typedef double AplReal;
typedef wchar_t AplChar;
typedef AplArray *AplFutr;
union apl_scalar {
	AplInt intv;
	AplReal real;
	AplChar chrv;
	AplFutr futr;
};
typedef union apl_scalar AplScalar;

@ These macros that we define above are also needed for the public, 
so we put these in the public header.

@<Public macro definitions@>=
#define INT(e) ((e)->intv)
#define REAL(e) ((e)->real)
#define CHAR(e) ((e)->chrv)


@ There are a few very useful functions relating to arrays that 
we should talk about. The first is a way to get the number of 
elements in an array based on the array's shape. This is just 
the product of the dimensions of the shape of the array. This 
is $\times/\rho A$ in APL.

@<Utility functions@>=
size_t count(AplArray *a) 
{
	short r;
	size_t c;
	AplInt *s;

	for (c = 1, r = RANK(a), s = SHAPE(a); r--; c *= *s++);
	
	return c;
}

@ It's very helpful at times to be able to talk about the 
product of an integer array's ravel. Basically, we often want to 
compute the product when we are using the array as a reshape value 
for another array or the like. For this we assume that the array 
that we are given is an integer array, and then we get to work.
The APL expression we are computing here is $\times/,A$.

@<Utility functions@>=
AplInt product(AplArray *a)
{
	size_t c;
	AplScalar *d;
	AplInt p;

	for (c = count(a), p = 1, d = DATA(a); c--; p *= INT(d++));

	return p;
}

@ Initializing an array is just a matter of setting up all the 
values to suitable defaults before we do any allocations. This 
should be done to ensure that everything is nice and clean. 
This function does not do any allocation, but simply sets some 
fields.  See the section further down on memory management 
for functions that allocate space for arrays and the like.

@<Utility functions@>=
void init_array(AplArray *a)
{
	RANK(a) = 0;
	TYPE(a) = UNSET;
	SIZE(a) = 0;
	DATA(a) = NULL;
	FUTR(a) = 0;
}

@ We are about done with the work on the array data structure, 
so we should take some time to get all of the other basic array 
utilities out of the way. Let's focus specifically on those that 
we might find generally useful, but that do not deal with 
any allocation explicitly. To start us off, we'll deal with 
shapes.  We may want to know whether a given array is scalar, 
vector, matrix, or noble. These macros can help with that.

@d SCALAR(a) (RANK(a) == 0)
@d VECTOR(a) (RANK(a) == 1)
@d MATRIX(a) (RANK(a) == 2)
@d NOBLE(a)  (RANK(a) > 2)

@ It is also useful to be able to grab the shape from one array 
and put it into another. This is the main header information that 
does not involve allocation. 

@<Utility functions@>=
void copy_shape(AplArray *dst, AplArray *src) 
{
	short r;
	AplInt *d, *s;
	d = SHAPE(dst);
	s = SHAPE(src);
	RANK(dst) = RANK(src);
	for (r = RANK(dst); r--; *d++ = *s++);
}

@ We're talking a lot about shapes now, and for good reason. Many 
important things about arrays can be learned by looking at their shapes.
We often want to know whether two arrays have the same shape. We 
can do this with the following function |shpeq|. It returns |0| 
if the arrays do not have the same shape, and |1| if they do.

@<Utility functions@>=
int shpeq(AplArray *a, AplArray *b) 
{
	AplInt *sa, *sb;
	short r;
	
	if (RANK(a) != RANK(b)) return 0;
	
	for (sa = SHAPE(a), sb = SHAPE(b), r = RANK(a); r--; sa++, sb++)
		if (*sa != *sb) return 0;
	
	return 1;
}

@ We may also want to use arrays as if they were booleans. In this case, 
we want to consider an array as a valid boolean only if it is a scalar
and if it is in the range $[0,1]$. We should also like to know whether 
a boolean is true or not.

@d BOOLEAN(a) (SCALAR(a) && TYPE(a) == APLINT && 
    (INT(DATA(a)) == 0 || INT(DATA(a)) == 1)
@d TRUE(a) (INT(DATA(a)) == 1)
@d FALSE(a) (INT(DATA(a)) == 0)

@ Note, we could also talk about the |type| field, which is another 
field that does not relate directly to the heap-allocated regions 
of the array, but in this case, it's no good, because |type| is 
actually indirectly responsible, and there are not many useful 
functions that we would want to use |type| in that did not 
also involve allocation.

@* Defuturing Arrays. Future arrays are those arrays whose elements are 
not yet calculated, or are being calculated concurrently or in parallel 
to the rest of the system. We may not want to deal with the complications 
array futures in all our functions. In some cases, it simply would not 
net any benefit. This may be true if we already know we must 
touch each array before moving on, 
and there are surely other cases, such as just plain laziness. 
The act of defuturing an array is thus the act of converting a future 
array into a normal array with all values filled in. This is a blocking 
operation performed by the |defutr| function. It is a no-op if the array 
it is given is not a future array. This function serves as a synchronizing
function for threads, as all threads that are involved in computing the 
given array's element values must complete before |defutr| will return.
We implement the |defutr| function by using |qthread_readFF| on our 
|data| region, utilizing the FEB semantics of |qthread_fork| as discussed 
elsewhere. 

We have two distinct cases of futures, depending on the value of the 
|futr| field. We consider each case individually.

@<Utility functions@>=
void defutr(AplArray *a)
{
	switch (FUTR(a)) {
	case 1: @<Defuture standard future array@>@; break;
	case 2: @<Defuture multi-element future array@>@; break;
	}
}

@ In the standard case (case 1), we expect a single array pointer 
in the |DATA(a)| field; that is, |DATA(a)| should point to a single |AplFutr| 
value. We thus have two arrays, the computed array pointed to by |DATA(a)| 
and the given array |a|. We want to move the important data from the 
|DATA(a)| array to the |a| array. Instead of doing a data copy, we can 
just replace the |data(a)| field with the |DATA(*DATA(a))| field, while 
copying over the shape information.

@<Defuture standard future array@>=
{
	AplArray *t;
	if (qthread_readFF((aligned_t *) &t, (aligned_t *) DATA(a))) {
		apl_error(APLERR_QTHREAD);
		exit(APLERR_QTHREAD);
	}
	free_data(a);
	copy_shape(a, t);
	TYPE(a) = TYPE(t);
	FUTR(a) = 0;
	DATA(a) = DATA(t);
	SIZE(a) = SIZE(t);
	free(t);
}

@ In the case of a per element future array, the shape information and 
type of the array are presumably already set, or will be set by 
some other means. The |DATA(a)| field is also allocated to the correct size 
already, and will already contain the elements. We simply need to 
wait for all the threads to finish calculating their corresponding
elements, and then mark the future array as a regular array.

@<Defuture multi-element future array@>=
{
	AplScalar *d;
	size_t c;
	for (d = DATA(a), c = count(a); c--; d++)
		qthread_readFF(NULL, (aligned_t *) d);
	FUTR(a) = 0;
}

@* Function Structure.
Let's proceed to functions. In HPAPL, a function is either an 
operator or a normal function.  At the higher level language, 
we can distinguish these by asking whether a function has 
$\alpha\alpha$ or $\omega\omega$ as a free variable or not. 
We make no distinction between functions which take functions 
and normal functions at the runtime level. Instead, unless 
optimized away, all functions have an explicit, possibly empty 
closure allocated for them. This closure is what is passed 
around to primitive operators and the like. Thus, all functions 
have the same signature as their C function elements.

@s AplDyadic int
@s AplMonadic int

@<Primary data structures@>=
typedef struct apl_function AplFunction;
typedef void@,(*AplMonadic)(AplArray *res, AplArray *, AplFunction *);
typedef void@,(*AplDyadic)(AplArray *res,
    AplArray *, AplArray *, AplFunction *);

@ So, what is an |AplFunction| anyways? It is a structure to 
contain all of the free variables in an APL function that might 
come in other than what the actual arguments to an APL function 
would be. This includes the functions that an operator might 
receive. This means that it needs to have an environment in 
it to store there free variable references, and also pointers 
for the $\alpha\alpha$ and $\omega\omega$ operator variables 
explicitly. However, since we are dealing with a closure here, 
it needs to be more than just the environment. In most cases, 
we will often pass around only an |AplFunction| value, and 
not the actual |AplCodePtr| value.  This means that we need to 
have a pointer to the code that expects the closure as well.
Finally, some HPAPL functions are step functions, which run in 
parallel, and so we store a flag that indicates this.

We will use the macros |MONADIC|, |DYADIC|, |STEP|, |LOP|, |ROP|, 
and |ENV| to talk about the fields.

@d MONADIC(f) ((f)->monadic)
@d DYADIC(f) ((f)->dyadic)
@d STEP(f) ((f)->step)
@d LOP(f) ((f)->lop)
@d ROP(f) ((f)->rop)
@d ENV(f) ((f)->env)

@<Primary data structures@>=
struct apl_function {
	AplMonadic monadic;
	AplDyadic dyadic;
	int step;  /* |0| if regular, |1| if step function */
	void *lop; /* The $\alpha\alpha$ variable */
	void *rop; /* The $\omega\omega$ variable */
	void **env; /* All other free variables */
};

@ {\it Note:} it is important that |AplFunction| code functions do not 
actually overwrite the contents of their input arrays. It is assumed that 
they will not touch their input array contents, but that they will fill 
in and possibly reallocate or allocate fresh space in the result array.
@^Functions, restrictions@>

@ The macros defined above are useful to the public, so let's define 
them in the public header.

@<Public macro definitions@>=
#define MONADIC(f) ((f)->monadic)
#define DYADIC(f) ((f)->dyadic)
#define STEP(f) ((f)->step)
#define LOP(f) ((f)->lop)
#define ROP(f) ((f)->rop)
#define ENV(f) ((f)->env)

@ Finally, we  should talk about initializing closures.  In this
case, a closure  will normally be something that we know the size of
statically,  since we will know how many variables are free in the
function. We  want to make it convenient to setup all those values
based on local elements, so we have a choice of either accepting
those values  directly with a variable length argument list, or
forcing the user  of the runtime (the compiler) to give us an array. 
In this case,  because the number of free variables is expected to be
small most of  the time, I think it is safe to use variable length
argument lists  for convenience instead of forcing the pollution of
the namespace  with an explicit environment list. We assume that we
have an  |AplFunction| structure pointer that is already allocated
for the  correct number of free variables that we have.

@<Utility functions@>=
void init_function(AplFunction *f, AplMonadic m, AplDyadic d,
    int s, void *l, void *r, ...)
{
	va_list ap;
	void **e, *v;
	MONADIC(f) = m;
	DYADIC(f) = d;
	STEP(f) = s;
	LOP(f) = l;
	ROP(f) = r;
	e = ENV(f);
	for (va_start(ap, r); (v = va_arg(ap, void *)) != NULL; *e++ = v);
	va_end(ap);
}

@*1 Function application. Assuming that we have a simple function and 
not a step function, applying is very simple.  The function body itself 
must take care not to break the assumptions on the immutablity of the 
input arguments, so this makes life easy on the caller end. It's easy 
to apply a function as a regular function, but we use additional 
``application'' macros to ensure that the function calling conventions
of passing the function closure as the last argument are preserved.
The arguments are all expected to be pointers to their appropriate
data types.

@d APPLYM(f, z, r) MONADIC(f)((z), (r), (f))
@d APPLYD(f, z, l, r) DYADIC(f)((z), (l), (r), (f))

@ Things are more complicated, unfortunately, by step functions. 
Step functions create future arrays, whose values are filled in at 
a later point in time. They are implemented using threads, by forking 
a thread to do the main computation, and then filling in the array with 
the relavant details after the computation is done. A step function 
does not wait for the computation to complete before returning the 
array. The function |qthread_fork| spawns a new thread, and has a 
signature like this:

\medskip
|int qthread_fork(qthread_f f, const void *arg, aligned_t *ret);|
\medskip

\noindent In this case the |qthread_f| argument is a function pointer of 
the following type:

\medskip|aligned_t@,(*qthread_f)(void *arg);|\medskip

\noindent Basically, the function |f| will be called with |arg| and 
its return value will be stored in |ret| using |qthread_writeF|, which 
marks this data as being full on the return. Readers who wish to know 
more about this interface should read the qthread documentation, such 
as it is. The long and short of it is that |qthread_fork| takes care 
of setting the return full/empty bits correctly.

This interface drives the design of a function |applystep| which 
will receive all the information in a structure, and then do the application 
on a freshly allocated array that we will then return as the result.
The structure needs to contain the arguments to the function and 
the function itself. We do not need to accept the return array because 
we will allocate our own array for this.

@f qthread_f int
@f aligned_t int

@<Internal data structures@>=
struct apl_thread_arg {
	AplFunction *fun;
	AplArray *left;
	AplArray *right;
};

@ @<Utility functions@>=
aligned_t applystep(void *arg)
{
	struct apl_thread_arg *appinfo;
	AplFutr res;
	
	appinfo = arg;
	@<Apply threaded function@>@;
	free(arg);
	return (aligned_t) res;
}

@ We must allocate our return array on the stack because it will live 
past the execution of this function. We also leave allocation of the 
data in the function up to the function that receives it.

@<Apply threaded function@>=
if ((res = malloc(sizeof(AplArray))) == NULL) {
	apl_error(APLERR_MALLOC);
	exit(APLERR_MALLOC);
}
init_array(res);

@ Next we need to know whether we need to apply the function dyadically
or monadically. In this case, we just check whether |appinfo->left == NULL| 
and if it is, we know that we have the monadic case. At that point we can 
make use of our simplistic application macros.

@<Apply threaded function@>=
if (appinfo->left == NULL)
	APPLYM(appinfo->fun, res, appinfo->right);
else
	APPLYD(appinfo->fun, res, appinfo->left, appinfo->right);

@ Of course, things are not quite so simple when we want to deal with 
step functions. Actually applying a step function requires that we setup 
the return array appropriately, and that we make sure that the return 
address and such is linked up correctly. This code looks like this. 
We assume that |rgt| and |lft| are set to appropriate values.

@<Apply step function on |res|@>=
{
	struct apl_thread_arg *appinfo;

	if ((appinfo = malloc(sizeof(struct apl_thread_arg))) == NULL) {
		apl_error(APLERR_MALLOC);
		exit(APLERR_MALLOC);
	}

	appinfo->fun = fun;
	appinfo->left = lft;
	appinfo->right = rgt;

	RANK(res) = 0;
	alloc_array(res, UNSET);
	if (qthread_fork(applystep, appinfo, (aligned_t *) DATA(res))) {
		apl_error(APLERR_QTHREAD);
		exit(APLERR_QTHREAD);
	}
}

@ We now have two concepts of function application, simple ones for functions
not involved in threading, and those which are, called step functions.
We want to encapsulate this into two functions for handling dyadic and
monadic application. Basically, we just check the |STEP(f)| flag in the 
function and dispatch accordingly.

@<Utility functions@>=
void applymonadic(AplFunction *fun, AplArray *res, AplArray *rgt)
{
	AplArray *lft;
	lft = NULL;
	if (STEP(fun) == 1) @<Apply step function on |res|@>@;
	else APPLYM(fun, res, rgt);
}
void applydyadic(AplFunction *fun, AplArray *res, AplArray *lft, AplArray *rgt)
{
	if (STEP(fun) == 1) @<Apply step function on |res|@>@;
	else APPLYD(fun, res, lft, rgt);
}

@* Memory management functions. This section is meant to deal 
specifically with controlling and allocating space for arrays and 
other sorts of things that can be grouped under the ``memory 
management'' moniker. Mostly, this means allocating and freeing 
arrays and function closures in useful, easy ways. Function closures 
are the easiest, but I want to take a moment to discuss the general 
idea behind the |AplArray| structure and how it should be used.

In general, I expect that most allocations of |AplArray| objects 
should be automatic.  That is, most of the time, you know that you 
need one, and you will allocate it locally using stack allocations 
or some other form that allows for automatic memory management. 
This leaves only the |DATA(a)| field as something that needs 
to be managed entirely and almost always on the heap. I imagine 
that if you have a small function with a small array you could 
get by with allocating the |data| element on the stack or 
automatically as well, but this would likely create problems 
unless you are absolutely sure of the lifetime of the array. 
In the future, we might also want to enable some sort of sharing 
of array data structures, to enable access of multiple array 
headers into the same region for shared access to elements. 
This involves a sort of copy on write semantics. If an array 
|DATA(a)| region is not heap-allocated, we could have real problems 
if a region is shared with an array that will outlive the local 
scope of the allocation. In short, always use the memory 
allocation functions here for allocating and resizing arrays 
|DATA(a)| regions, though it is okay and preferred to stack 
allocate |AplArray| structures unless you explicitely want 
to avoid that for some reason.

With that out of the way, let's talk a bit more about closures, 
which are the easier thing to work with.  When we allocate 
a closure, we need to provide values for the $\alpha\alpha$ 
and $\omega\omega$ variables, and potentially also for the 
rest of the free variables. However, we normally know exactly 
how many free variables a function's code body is going to need 
at compile time, and so we can statically allocate those.  
Moreover, it is never possible for a function to be returned 
from another function, just allocated, and this means that we 
can rely on no functions above the current call stack needing 
access to the free variables or the like. Indeed, closures, 
in most cases, should be able to be allocated almost entirely 
statically or automatically.

@ The most common situation that we encounter that requires good 
memory management abstraction is the handling of the |DATA(a)| 
field. Normally, we have an array that has been automatically 
allocated for which we now need to make enough space to store
elements of a particular type. Assuming that we already know how 
the shape of the array looks, we know how many array elements that 
we ultimately need. Ideally speaking, 
we want to reuse space that has already been allocated to the array 
if there is enough room to store the elements that we need. 
We provide two different allocators, the first, |alloc_array| for 
when we do not care to keep the old contents of the array.

@<Memory management functions@>=
void alloc_array(AplArray *a, AplType t)
{
	size_t s;
	s = (t == APLIOTA ? 2 : sizeof(AplScalar) * count(a));
	if (DATA(a) == NULL || s > SIZE(a))
		@<Set |DATA(a)| to region of |s| bytes@>@;
	TYPE(a) = t;
}

@ When we know that we need to allocate new memory, we have the option 
to use |realloc| to do this, but instead, for this particular semantics, 
we will make sure to free any old memory that we have, and then to 
|malloc| a new region entirely, since we do not care about the contents 
of the old memory. In case of an error, we will print both the 
malloc error that we receive, as well as exit with an |APLERR_MALLOC|
code, printing the appropriate error message. 

@<Set |DATA(a)| to region of |s| bytes@>=
{
	AplScalar *d;
	free(DATA(a));
	if ((d = malloc(s)) == NULL) {
		perror("alloc_array()");
		apl_error(APLERR_MALLOC);
		exit(APLERR_MALLOC);
	}
	DATA(a) = d;
	SIZE(a) = s;
}

@ There are times when we may want to preserve the contents of an 
array as we resize it to hold more elements or the like. To handle 
these situations, we provide the |realloc_array| function that is 
basically the same as the |alloc_array| function except that it 
guarantees that the contents of the array will be the same up 
to the |count(array)| of the |array|. 

@<Memory management functions@>=
void realloc_array(AplArray *a, AplType t)
{
	size_t s;
	s = (t == APLIOTA ? 2 : sizeof(AplScalar) * count(a));
	if (DATA(a) == NULL || s > SIZE(a)) 
		@<Reallocate |DATA(a)| to at least |s| bytes@>@;
	TYPE(a) = t;
}

@ In this case, we will work like we did with the previous 
case using |malloc|, but using |realloc| instead of |malloc| to 
do the allocation. We will also return the same error message in case 
of a failure.

@<Reallocate |DATA(a)| to at least |s| bytes@>=
{
	AplScalar *d;
	if ((d = realloc(DATA(a), s)) == NULL) {
		perror("realloc_array()");
		apl_error(APLERR_MALLOC);
		exit(APLERR_MALLOC);
	}
	DATA(a) = d;
	SIZE(a) = s;
}


@ It is extremely useful to be able to copy the contents of one 
array into another. This is a simple function, and we do some 
allocation on the destination to ensure that we have enough space, 
but otherwise, it is a straightforward function.
It is an interesting note that we do not copy the entire |DATA(src)| 
to the destination array. Instead, we copy only what is needed to 
store |count(dst)| elements worth of the data, because that is all 
that is needed by the destination array.  It is presumed that the 
data beyond this point is probably junk. We can also only copy the 
array after it has been fully computed, so future arrays are defutured 
before being copied.

@<Memory management functions@>=
void copy_array(AplArray *dst, AplArray *src) 
{
	if (dst == src) return;
	
	defutr(src);
	copy_shape(dst, src);
	alloc_array(dst, TYPE(src));
	FUTR(dst) = 0;
	memcpy(DATA(dst), DATA(src), 
	    SIZE(src) < SIZE(dst) ? SIZE(src) : SIZE(dst));
}

@ Naturally, we also want to be able to free those things that we 
have allocated. Normally, since we expect that most allocations of 
|AplArray| objects will be automatic, we concern ourselves here with 
freeing memory allocated for the data of the array. The system can 
use |free_data| when we want to clear the data that was allocated 
for an |AplArray| object, but it will not free the |AplArray| object 
which was holding the data. It will initialize the fields back to 
something sane, however.

@<Memory management functions@>=
void free_data(AplArray *a)
{
	free(DATA(a));
	DATA(a) = NULL;
	SIZE(a) = 0;
	TYPE(a) = UNSET;
	FUTR(a) = 0;
}

@* Primitive scalar functions. Now we come to the fun part, where we 
actually start implementing some real APL functions. The first and 
most obvious one to implement is the |plus| function, and it will 
show how we implement most functions.  We try to follow the same 
pattern of coding throughout to maximize the amount of code that we 
can reuse. Basically, all scalar functions have an operation 
that they perform over all elements. This operation should be 
encapsulated into a function that we call |op| with the following 
signature that we |typedef| to |AplScalarMonadic| and |AplScalarDyadic|.
The first argument is meant to be where the result goes, and the other 
arguments the arguments to the function.

@s AplScalarMonadic int
@s AplScalarDyadic int

@<Primary data structures@>=
typedef void@,(*AplScalarMonadic)(AplScalar *, AplScalar *);
typedef void@,(*AplScalarDyadic)(AplScalar *, AplScalar *, AplScalar *);

@ All dyadic scalar functions using the following pattern of code retain
the same  basic function body:@^Scalar functions, design pattern@>

\medskip{\parindent=0.3in
\item{1:} Declare common variables;
\item{2:} Actualize |APLIOTA| arrays if needed;
\item{3:} Set the |op| and |restype| variables;
\item{4:} Set |rgtstp| and |lftstp| variables;
\item{5:} Allocate |res| without corrupting |lft| or |rgt|;
\item{6:} Compute the function based on |op|; 
\item{7:} Finally, clean-up if necessary.
}\medskip

\noindent Step $3$ is specific to the function that you are writing, 
but all of the other sections are the same for each scalar function. 
In step $2$, if a function can work directly with |APLIOTA| arrays, 
then that's fine, but normally they cannot.

@<Compute dyadic scalar function |op|@>=
orig = NULL;
lftstp = SCALAR(lft) ? 0 : 1;
rgtstp = SCALAR(rgt) ? 0 : 1;
@<Allocate |res|, dealing with shared inputs and output structures@>@;
@<Dyadically apply |op| over |rgt| and |lft| by |rgtstp| and |lftstp|@>@;
@<Clean-up after scalar function@>@;

@ @<Declare dyadic scalar function variables@>=
size_t rgtstp, lftstp; /* For scalar distribution iteration */
AplType restype; /* Type of the result array after computation */
AplScalarDyadic op; /* Function pointer to scalar function */

@ We need to have a few things in order to process or apply the 
scalar |op| function over a given array |rgt|, which we will by 
convention store into |res|. Firstly, |res| should be fully allocated 
and its shape should be accurately in place, since we rely on getting 
a valid |size(res)| result to indicate how many elements we should 
process. Unlike with the dyadic case, we do not have to worry about 
scalar distribution of arguments, which means that we always know that 
the shape of |res| is the same as the shape of |rgt|, which means that 
we know that the elements will be traversed in lock-step, as opposed 
to only one argument being traversed, as happens in some cases of 
dyadic scalar functions. We will talk more about this in the dyadic 
case, but for now, it suffices to know that we will never have a 
case where we do not want to traverse the result data array and the 
input data array in lock-step, a single element at a time; and, that
we will do this exactly |count(res)| times, which should be equivalent 
to |count(rgt)|.

@<Apply |op| monadically into |res| over |rgt|@>=
{
	size_t c;
	AplScalar *zd, *rd;

	zd = DATA(res);
	rd = DATA(rgt);

	for (c = count(res); c--; zd++, rd++) op(zd, rd);
}

@ The dyadic case becomes a bit more complex, because, while we must 
assume that |res| is already an allocated array, and we know the 
|count(res)| will tell us how many elements we are iterating, we also 
have the situation where we may have a scalar argument that we distribute 
over a non-scalar array. To handle this, we assume that |rgtstp| and 
|lftstp| are variables assigned to the step amounts for the |rgt| and |lft|
arguments respectively. That is, these indicate the number of elements that 
we should increment.
In the case of a scalar in one of the arguments that will be distributed 
over another array, this step count will be zero. 

@<Dyadically apply |op| over |rgt| and |lft| by |rgtstp| and |lftstp|@>=
{
	size_t c;
	AplScalar *zd, *ld, *rd;

	zd = DATA(res);
	ld = DATA(lft);
	rd = DATA(rgt);

	for (c = count(res); c--; zd++, ld+=lftstp, rd+=rgtstp)
		op(zd, ld, rd);
}

@ Now we need to talk about how we allocate the result array |res|. 
We want to have the guarantee that working on |res| and changing values 
during the course of our scalar computation will not mess with any 
future values that we need for the rest of the scalar computation.
In some cases we can do an in-place computation, even if |res == lft| 
or |res == rgt|. In other cases this is not possible, and a fresh 
allocation must be done. We divide the possible sharing cases thus:

\medskip{\parindent=0.3in
\item{1)} {\it All arguments the same.} In this case, 
|res == lft == rgt|. We know that the input types 
are the same and that the input arrays are of the exact same 
shape. We can always do an in-place update because the output array 
is the same size as the input array.
\item{2)} {\it All inputs are the same.} In this case, 
all the inputs are the same, but the output is a different 
array. We should always do the allocation in this case, as well 
as copying the shape from either of the inputs, which have 
the same shape.
\item{3)} {\it Left or right argument is the same as 
the result.} In this case, we have one or the other of the 
inputs, but not both, equal to the result array in the 
sense that they are the same object in memory. 
When |res| is 
the scalar in a scalar distribution, we cannot safely use it as a 
target, since we might overwrite the input array before it is safe to 
do so. It is not 
enough to just reallocate the array, but we must actually construct 
a temporary array if we want to be correct. The other possibility is that 
|res| is not the scalar, or we do not have a scalar distribution,
in which case it is okay to leave |res| as is; the in-place update is safe.
\item{4)} Finally, then general case is the one where we have 
none of the inputs as equal to one another. This is almost as 
easy as case 2, but we need to figure out where to copy the shape 
for |res| from in the case of a scalar distribution. Otherwise, 
this is a straightforward copy and allocate.
\par}\medskip

@<Allocate |res|, dealing with shared inputs and output structures@>=
if (lft == rgt) {
	if (res != lft) {
		copy_shape(res, rgt);
		alloc_array(res, restype);
	}
} else if (res == lft) {
	if (!shpeq(lft, rgt) && SCALAR(lft)) TEMPRES(rgt)@;
} else if (res == rgt) {
	if (!shpeq(lft, rgt) && SCALAR(rgt)) TEMPRES(lft)@;
} else {
	if (shpeq(lft, rgt) || SCALAR(lft)) copy_shape(res, rgt);
	else copy_shape(res, lft);
	alloc_array(res, restype);
} 

@ The above code assumes a macro |TEMPRES| that will handle the allocation 
of a temporary value for us. This macro allocates a temporary array and 
replaces the original |res| with this temporary array so that it is 
safe to write to |res| without worrying about overlap. It stores the original 
array in the |orig| variable.

@d TEMPRES(array) @/
{@/
	AplArray tmp;
	init_array(&tmp);
	copy_shape(&tmp, array);
	alloc_array(&tmp, restype);
	orig = res;
	res = &tmp;
}

@<Declare dyadic scalar function variables@>=
AplArray *orig;

@ We need to ensure that 
we clean up after we are done processing everything. Our |TEMPRES| macro 
makes sure to save the original destination array in |orig|, so we must 
put that data into the right place in the case that |orig != NULL|.

@<Clean-up after scalar function@>=
if (NULL != orig) {
	free(DATA(orig));
	SIZE(orig) = SIZE(res);
	DATA(orig) = DATA(res);
}

@ The special arrays return by the |index_gen| function can sometimes be 
extended by certain functions, but this is far from true when it comes to 
all scalar functions, and thus, in the normal case, we will actualize the 
index array fully before doing anything with scalars. 

@<Actualize |APLIOTA| arrays@>=
if (TYPE(lft) == APLIOTA) actualize_idx(lft);
if (TYPE(rgt) == APLIOTA) actualize_idx(rgt);

@*1 Implementing Plus and Identity.
Now that we have covered the basic 
scalar abstractions, let's take a whack at
trying to implement the more specific functions, namely, the |plus| 
function. We need to define a few things. Firstly, we need to know 
the domain on which |plus| operates. In this case, it is a dyadic 
function which works only in |APLINT| and |APLREAL| types. The resulting 
type of the computation should be determined by the largest 
input type, which means that two |APLINT| types are |APLINT| results, 
but everything else is a |APLREAL|. We can define the main 
|plus| function as follows.

@<Scalar APL functions@>=
void plus(AplArray *res, AplArray *lft, AplArray *rgt, AplFunction *env)
{
	@<Declare dyadic scalar function variables@>@;
	
	@<Shift |APLIOTA| ranges if possible, otherwise actualize@>@;
	
	if (TYPE(lft) == APLINT) {
		if (TYPE(rgt) == APLINT) {
			op = plus_int_int;
			restype = APLINT;
		} else if (TYPE(rgt) == APLREAL) {
			op = plus_int_real;
			restype = APLREAL;
		} else goto err;
	} else if (TYPE(lft) == APLREAL) {
		if (TYPE(rgt) == APLINT) {
			op = plus_real_int;
			restype = APLREAL;
		} else if (TYPE(rgt) == APLREAL) {
			op = plus_real_real;
			restype = APLREAL;
		} else goto err;
	} else goto err;
	@#
	@<Compute dyadic scalar function |op|@>@;
	return;
	@#
err:
	apl_error(APLERR_DOMAIN);
	exit(APLERR_DOMAIN);
	
}

@ Now we must define the various |op| functions that we used above.
We have four cases of addition that we need to handle. Each of them 
can be expressed with the C |+| operation, so a macro suffices to 
help us define each function.

@d COPFUNC(nm, op, ZT, LT, RT)@/
void nm(AplScalar *res, AplScalar *lft, AplScalar *rgt)@/
{
	ZT(res) = LT(lft)@,op@,RT(rgt);
}

@<Utility functions@>=
COPFUNC(plus_int_int, +, INT, INT, INT)@;@/
COPFUNC(plus_int_real, +, REAL, INT, REAL)@;@/
COPFUNC(plus_real_int, +, REAL, REAL, INT)@;@/
COPFUNC(plus_real_real, +, REAL, REAL, REAL)@;

@ Addition can be done directly on |APLIOTA| arrays without requiring 
any actualization of those arrays if one of the arrays is a scalar 
and the other is an |APLIOTA| array. We cannot actually do this if 
we have two |APLIOTA| arrays, since this would mean having some concept 
of a step amount in the ranges, which we do not yet have. In that 
case we just actualize the arrays.

@d PLUSIOTA(scl, arr) {
	AplInt s;
	s = INT(DATA(scl));
	if (res != arr) {
		copy_array(res, arr);
	} 
	INT(DATA(res)) += s;
	INT(DATA(res)+1) += s;
}		

@<Shift |APLIOTA| ranges if possible, otherwise actualize@>=
if (SCALAR(lft) && TYPE(lft) == APLINT && TYPE(rgt) == APLIOTA)
	PLUSIOTA(lft, rgt)@;
else if (SCALAR(rgt) && TYPE(rgt) == APLINT && TYPE(lft) == APLIOTA)
	PLUSIOTA(rgt, lft)@;
else @<Actualize |APLIOTA| arrays@>@;

@ The |identity| function is the monadic form of the $+$ function 
in APL. In this case, since we know that it is the identity function, 
we can avoid a number of the overheads of the generic looping 
constructs in the case when we know the relationship between the 
single argument and its result array. Otherwise, a simple 
|memcpy()| suffices instead of a loop.

@<Scalar APL functions@>=
void identity(AplArray *res, AplArray *rgt, AplFunction *env)
{
	if (res == rgt) return;
	else copy_array(res, rgt);
}

@*1 The Subtraction and Negation functions.
The subtraction function |minus| works just like the plus, and has the 
same domain constraints. Thus, our implementation is basically the same, 
but with different operators.

@<Scalar APL functions@>=
void minus(AplArray *res, AplArray *lft, AplArray *rgt, AplFunction *fun)
{
	@<Declare dyadic scalar function variables@>@;
	@<Actualize |APLIOTA| arrays@>@;
	
	if (TYPE(lft) == APLINT) {
		if (TYPE(rgt) == APLINT) {
			op = minus_int_int;
			restype = APLINT;
		} else if (TYPE(rgt) == APLREAL) {
			op = minus_int_real;
			restype = APLREAL;
		} else goto err;
	} else if (TYPE(lft) == APLREAL) {
		if (TYPE(rgt) == APLINT) {
			op = minus_real_int;
			restype = APLREAL;
		} else if (TYPE(rgt) == APLREAL) {
			op = minus_real_real;
			restype = APLREAL;
		} else goto err;
	} else goto err;
	@#
	@<Compute dyadic scalar function |op|@>@;
	return;
	@#
err:
	apl_error(APLERR_DOMAIN);
	exit(APLERR_DOMAIN);
}

@ Our operators are also nearly the same as the plus case, but with 
a different C operator.

@<Utility functions@>=
COPFUNC(minus_int_int, -, INT, INT, INT)@;@/
COPFUNC(minus_int_real, -, REAL, INT, REAL)@;@/
COPFUNC(minus_real_int, -, REAL, REAL, INT)@;@/
COPFUNC(minus_real_real, -, REAL, REAL, REAL)@;

@* Non-scalar primitive functions. In this section we will deal with 
the class of functions that are non-scalar. These do not have the 
nice, neat, and regular properties that the scalar functions have, 
and so we cannot abstract away all of those operations into a common 
set of macros. Fortunately, there are not quite so many of these 
functions, and they are quite fun and interesting, so let's look 
at them.

@*1 The Iota function. This is the classic $\iota$ function that 
is so fundamental to APL. However, we are going to implement this a 
bit more like the way that iota is treated in ``A Mathematics of 
Arrays.'' We do not have nested arrays in HPAPL, which is different 
than some other APL systems, like APL2, Dyalog, or APLX, which 
all have nested arrays. This is a philosophical consideration 
as much as anything, but it leads to interesting things when 
we call Iota with non-scalar vectors whose size is greater than 
one. Fortunately, the basic iota is still relatively straight 
forward, so we will begin there and discuss the details of the 
more complicated setup next.

@<Non-scalar APL functions@>=
void index_gen(AplArray *res, AplArray *rgt, AplFunction *env)
{
	size_t cnt;
	if (APLINT != TYPE(rgt)) {
		apl_error(APLERR_DOMAIN);
		exit(APLERR_DOMAIN);
	}
	cnt = count(rgt);
	if (RANK(rgt) == 0 || (RANK(rgt) == 1 && cnt == 1)) 
		@<Create |APLIOTA| array@>@;
	else @<Compute indexes of non-scalar vector@>@;
}

@ Most of the time, we want the index generation to happen 
much more quickly than computing all the elements explicitly, 
to enable operators and other functions to 
take advantage of a more compact representation. This is the |APLIOTA| 
array. It is a non future array of the same shape as the regular 
arrays generated above, but the data fields number only two, with the 
first being an |AplInt| pointing to the lower bound, and the second 
pointing to the upper bound of the iota range. At this point, it will 
always be in the range $[0, X)$ where $X$ is the scalar value of the
input array.

@<Create |APLIOTA| array@>=
{
	RANK(res) = 1;
	*SHAPE(res) = INT(DATA(rgt));
	alloc_array(res, APLIOTA);
	INT(DATA(res)) = 0;
	INT(DATA(res) + 1) = *SHAPE(res);
}

@ In the special case where we have a single scalar argument or a 
one-element vector, it's easy to calculate the result explicitly, without 
needing to use more expensive indexing functions. We can do this with 
the |actualize_idx| function, which will take an |APLIOTA| array and 
convert it to a regular |APLINT| array. We make sure to grab the values
from the array before we allocate it.

@<Utility functions@>=
void actualize_idx(AplArray *res)
{
	AplInt i, e;
	AplScalar *d;
	i = INT(DATA(res));
	e = INT(DATA(res) + 1);
	alloc_array(res, APLINT);
	d = DATA(res);
	for (d = DATA(res); i < e; INT(d++) = i++);
}

@ Now let's consider the main case of the Iota (properly, then |index|) 
function.  In this case, we have a vector $v$ of some $n$ elements 
where we want to return a matrix where each row is a valid index into 
an array of shape $v$. These indexes should be in row-major order.
Now, the way that we compute this set is to progress in order down 
the data array and compute the function directly. We have one 
helper array $p$ where, if $r$ is the size of the incoming vector, 
$p_r=1$ and $p_i = \prod_{j=i+1}^{r}v_j$ where $v_j$ is the $j$th 
element of the incoming input array |rgt|. Thus, $p$ is the 
``places'' array. For example, in an array of three 10's, the 
vector $p$ would be $\{100, 10, 1\}$. We use this to then compute 
the value of each cell in the matrix according to the following 
formula:

$$a_{i,j} = \lfloor i/p_{j}\rfloor\bmod v_j$$

\noindent To make this more clear, we can think about our result 
array as being a matrix of numbers from $0$ to the |product(rgt)| 
where each number is represented from lowest to highest, one 
per row. Each column is one digit of the number represented in 
a base |rgt|, that is, a base where each place is one of the 
dimensions of the array we are indexing into. The function above 
computes one of these digits. In our implementation, we use 
a doubly nested loop to give us the $i$ and $j$ elements.

@<Compute indexes of non-scalar vector@>=
{
	size_t *p, prod;
	int i, j;
	AplScalar *v, *a;

	v = DATA(rgt);
	a = DATA(res);
	prod = product(rgt);
	@<Compute |p| vector@>@;
	for (i = 0; i < prod; i++)
		for (j = 0; j < cnt; j++)
			INT(a++) = (i / p[j]) % INT(v+j);
	free(p);
}

@ Computing the product vector means that we compute the product 
of the elements in |rgt| after the current index that we are 
considering. The easiest way to do this is to start at the end 
and move towards the front.

@<Compute |p| vector@>=
p = malloc(cnt * sizeof(size_t));
if (p == NULL) {
	apl_error(APLERR_MALLOC);
	exit(APLERR_MALLOC);
}
p[cnt - 1] = 1;
for (i = cnt - 1; i > 0; i--)
	p[i-1] = p[i] * INT(v+i);

@*1 The Indexing function. 
One of the most important functions in APL is the indexing 
function. This lets you get at subarrays of a given array, including 
scalar elements, by passing in another array. In particular, 
given an array $A$ whose shape is represented by array $S$, the 
result array |R| and an vector |I| of integers whose length
$\rho I$ is less than or equal to the length of |S|, the 
indexing function |index(R, I, A, NULL)| stores into |R| the 
subarray of |A| whose shape is $(\rho I)\downarrow S$. 
That is, the subarray selected by $A[I_0;\ldots;I_n;\ldots]$ where 
|n == count(I)|, or $n = \rho I$ in APL notation. 
If $(\rho I)\equiv\rho S$ then |R| is a scalar and $\rho R$ is the 
empty array. For more information about this function, see the Dyalog 
Language Reference or another book on APL, such as The Mathematics 
of Arrays, which has a similar indexing function. 

We implement the array storage in row-major formate, which enables 
a fairly straightforward extraction of the sub-array. We know that 
the sub-array will already be a contiguous region somewhere along 
the data region of |A|. Thus, we need only to compute the starting 
location of the region, the resultant size of the region, and 
then copy that data into the result array. This leads us to the 
following outline for the |index()| function. 

@<Non-scalar APL functions@>=
void index(AplArray *res, AplArray *lft, AplArray *rgt, AplFunction *env)
{
        int i;
        AplScalar *src, *dst, *idx;
        AplInt *shpi;
        size_t rng, cnt;
	@<Actualize |APLIOTA| arrays@>@;
        @<Compute the shape and allocate |res|@>@;
        @<Copy data into result array@>@;
}

@ We compute the result shape by grabbing the shape from the end of
|SHAPE(rgt)|. That is, since the shape of the result is 
$(\rho I)\downarrow\rho S$, we perform the drop directly on |SHAPE(rgt)| by
copying the elements of |SHAPE(rgt)| from the |count(lft)| element to the end.
We can then allocate the array by
using the type from |rgt|, but we must be careful to use
|realloc_array| when |res == rgt|, since we must preserve the elements
in the buffer in that case. 

@<Compute the shape and allocate |res|@>=
cnt = count(lft);
RANK(res) = RANK(rgt) - cnt;
memcpy(SHAPE(res), SHAPE(rgt) + cnt, sizeof(AplScalar) * RANK(res));
if (res == rgt) realloc_array(res, TYPE(rgt));
else alloc_array(res, TYPE(rgt));

@ Copying the data elements is somewhat obvious. We do need to do some
work at the beginning to set the |src| pointer to where our subarray
starts first. When doing this we use |rng| to mean the range from the
start, |DATA(rgt)|, to the place where we want to begin copying, using
elements as the unit. After this, we can get the range |rng| of the
elements in the result array using the count of |res|. The only other
important consideration is to ensure that we use |memmove| when 
|res == rgt| to deal with potentially overlapping regions.

@<Copy data into result array@>=
dst = DATA(res);
src = DATA(rgt);
shpi = SHAPE(rgt);
idx = DATA(lft);
for (rng = 0, i = 1; i < cnt; i++) {
        rng += INT(idx++);
        rng *= *++shpi;
}
src += rng;
rng = count(res) * sizeof(AplScalar);
if (res == rgt) memmove(dst, src, rng);
else memcpy(dst, src, rng);

@* APL Operators and their implementation.
APL operators are functions that return other functions. In the 
end, there is always some specific function that they compute, but 
that computation is parameterized by one or two input functions, 
or possibly a combination of functions and arrays. It is helpful to 
imagine first how an operator might be used in a piece of code.
In the code below, we implement the equivalent to the following 
APL program:

$$X+\ddot{ }\ X\gets\iota 100$$

\noindent Here is an example:

@<Example use of an APL operator@>=
AplFunction myeach, myplus;
AplArray z, a;
alloc_array(&a, APLINT);
INT(a.data) = 100;
index(&a, &a, NULL);
init_function(&myplus, identity, plus, 0, NULL, NULL, NULL);
init_function(&myeach, eachm, eachd, 0, &myplus, NULL, NULL);
applydyadic(&myeach, &z, &a, &a);

@ As you can see in the above example, we must create a closure 
for every function that we intend to pass to an operator, and 
we create a closure for each operator whose function instance we 
want to use. This means that we need to use apply with those
functions that we create.  We could probably have gotten away 
with just using the |each| call directly here, because the each 
operator is a primitive, and sometimes that will be preferrable. 
Thus, we could have eliminated the indirection of the application 
by calling |each| directly. You can see this here below.

@<Trading out the application@>=
eachd(&z, &a, &a, &myeach);

@ Like the non-scalar APL functions, each APL operator is slightly 
unique, and requires its own implementation. This means that there 
is no special abstraction to use in each operator to share the 
work. We must implement each one directly. Let's proceed with each 
operator in turn through the rest of this section.

@*1 The Each operator. The each operator (represented as $\ddot{ }$ 
in APL) is the operator that will be most familiar to you if you 
have read the preceding sections. It takes in any function and 
returns a scalar function that applies that given function to each 
of the scalars in turn just as a scalar function would. This 
implies that the functions given to the each operator should make 
sure to support scalar arrays. Our general implementation has 
a few responsibilities. We must make sure that there is enough 
space to store the result, and we must present the given 
function with something that looks like a scalar array. 
In the case where we receive empty arrays as the inputs, then we 
should give back an empty array. To handle all of this complexity, 
we divide the main task into the following sections:

@<APL Operators@>=
void eachm(AplArray *res, AplArray *rgt, AplFunction *env) 
{
	@<Declare common |each| variables@>@;@#
	@<Initialize variables for |eachm|@>@;
	@<Deal with the simple cases of |eachm|@>@;
	@<Allocate |res| in |eachm|@>@;
	@<Apply $\alpha\alpha$ monadically on each element@>@;
	@<Do any cleanup necessary in |each|@>@;
}

@ The dyadic version of each is much the same in outline. We need 
a few more variables to handle some of the complication that comes 
with dyadic functions, but the basic outline remains the same.

@<APL Operators@>=
void eachd(AplArray *res, AplArray *lft, AplArray *rgt, AplFunction *env)
{ 
	@<Declare common |each| variables@>@;
	AplArray *shp, l; /* Shape template for result and extra temporary */
	@<Initialize variables for |eachd|@>@;
	@<Deal with the simple cases of |eachd|@>@;
	@<Actualize |APLIOTA| arrays@>@;
	@<Allocate |res| in |eachd|@>@;
	@<Apply $\alpha\alpha$ dyadically on each element@>@;
	@<Do any cleanup necessary in |each|@>@;
}

@ The two functions |eachm| and |eachd| both share a common set of 
variables, which we declare here.

@<Declare common |each| variables@>=
AplArray z, r; /* Scalar temporaries for the loop */
AplArray tmp; /* Temporary array in case it is needed */
AplArray *orig; /* Original array in case of a copy in |res| */
AplFunction *func; /* Function to apply */
size_t cnt; /* Number of elements to iterate */
AplScalar *resd; /* Result buffer pointing somewhere in |res->data| */
short clean; /* Indicates whether cleanup is necessary */

@ Let's do the initialization first. We want to initialize all the 
variables that we can ahead of time, but there are some variables, 
like |clean| and |cnt| that we cannot do until we know more 
about the relationship between all of the arguments. Otherwise, 
we need to make sure that all of our arrays are initialized and 
that we have the rank of the input array(s).

@<Initialize variables for |eachm|@>=
init_array(&z);
init_array(&r);
init_array(&tmp);
func = LOP(env);
orig = NULL;

@ @<Initialize variables for |eachd|@>=
@<Initialize variables for |eachm|@>@;
init_array(&l);
init_array(&tmp);

@ Both the monadic and dyadic forms of |each| have simple cases 
where we can avoid most of the other work. In both forms, if we are 
dealing with scalar inputs, then we can avoid most of the overhead 
entirely. If we are dealing with scalar vectors, we can achieve 
basically the same effect. If neither of these are the case, 
then we know a little something about the arrays, and we should 
save that for use later. 

@<Deal with the simple cases of |eachm|@>=
if (RANK(rgt) == 0) {
	applymonadic(func, res, rgt);
	return;
} else if ((cnt = count(rgt)) == 0) {
	copy_array(res, rgt);
	return;
}

@ The dyadic case is a bit more complicated because we want to deal 
with scalar distribution as well as just the scalar inputs. This 
means that we will save a pointer to the array that guides the 
shape of the main function into the |shp| variable. This will be 
used later on to determine the shape of the result array. 

@<Deal with the simple cases of |eachd|@>=
if (RANK(lft) == 0 && RANK(rgt) == 0) {
	applydyadic(func, res, lft, rgt);
	return;
} else if (RANK(rgt) == 0) {
	cnt = count(lft);
	shp = lft;
} else {
	cnt = count(rgt);
	shp = rgt;
}
if (cnt == 0) {
	copy_array(res, shp);
	return;
}

@ After we know that we are dealing with the general case,  we are free
to begin  allocating the space for the result array.  It is not as
simple as just setting the shape and allocating an  array, though. Here
is where we must deal with the possibility  that the input array is the
same as the output array. At the end of this computation, the main 
invariant that we want to preserve is that |res| must point  to an
array that is safe to over-write element wise, and  that is allocated
and is the correct output shape. We do  not guarantee after this that
|res| is different than either  of its inputs, in the case when it is
possible to do an  in-place update. We set the |clean| to indicate what
case we encounter.

@<Allocate |res| in |eachm|@>=
if (res != rgt) {
	copy_shape(res, rgt);
	alloc_array(res, UNSET);
	clean = 0;
} if (TYPE(rgt) == APLIOTA) {
	realloc_array(rgt, APLINT);
	TYPE(rgt) = APLIOTA;
} else clean = 0;

@ The dyadic case is much the same as the monadic case, except 
that we do not know whether |lft| or |rgt| is the correct array 
on which to base the shape, so we instead rely on |shp| being set 
early on in the computation to the right array on which we can 
base our shape. The same guarantees and invariants mentioned in 
the previous section apply here.

@<Allocate |res| in |eachd|@>=
if (res == rgt || res == lft) {
	if (res == shp || RANK(lft) == RANK(rgt)) { /* XXX WRONG */
		clean = 0;
	} else {
		copy_shape(&tmp, shp);
		alloc_array(&tmp, UNSET);
		orig = res;
		res = &tmp;
		clean = EACH_COPY;
	}
} else {
	copy_shape(res, shp);
	alloc_array(res, UNSET);
	clean = 0;
}

@ While we are still on the subject, let's make sure that we take 
care of the cleanup that we have done with these allocation 
functions. We do this now while the invariants are still fresh 
in our head. After this, all that is left to complete the 
implementation of |each|, both dyadically and monadically, is 
the main loop of the two functions |eachm| and |eachd|. 
We have three cases to deal with when we perform cleanup, 
one of which actually requires work. This case is given by 
the |EACH_COPY| constant. The no-op case is 
given when |clean == 0|. Otherwise, |clean| will be set to |EACH_COPY|, 
and we need to clean. 

\medskip{\parindent=.75in
\item{|EACH_COPY|} Here, we have actually allocated temporary 
space for the resultant array so that we do not invalidate our 
input arrays with the output of the function. This means that 
we need to put the important data buffers into the correct output 
array, which we keep in the |orig| variable. 
\par}\medskip

\noindent After we do this cleanup, the assumption is that we can 
safely return from the function.

@d EACH_COPY 1

@<Do any cleanup necessary in |each|@>=
switch (clean) {
case EACH_COPY:
	free(DATA(orig));
	SIZE(orig) = SIZE(&tmp);
	DATA(orig) = DATA(&tmp);
	TYPE(orig) = TYPE(&tmp);
	FUTR(orig) = FUTR(&tmp);
	copy_shape(orig, &tmp);
	break;
}

@ With all that preparation and setup complete, we are now ready to 
get down to the main event. This is the main loop that will actually 
do the iteration over the elements and apply the given function to 
each of them in turn. We try to do this efficiently by moving only 
over the data fields in each of the scalars.  

@<Apply $\alpha\alpha$ monadically on each element@>=
resd = DATA(res);
if (STEP(func)) @<Apply step monadically on |rgt|@>@;
else {
	if (TYPE(rgt) == APLIOTA) @<Apply |func| monadically over range@>@;
	else @<Apply |func| monadically over |rgt| array@>@;
	TYPE(res) = TYPE(&z);
	FUTR(res) = 0;
}

@ The dyadic case is virtually unchanged from this but for the 
extra argument.

@<Apply $\alpha\alpha$ dyadically on each element@>=
SIZE(&l) = SIZE(&r) = sizeof(AplScalar);
TYPE(&l) = TYPE(lft); TYPE(&r) = TYPE(rgt);
resd = DATA(res);
if (STEP(func)) @<Apply step dyadically on each element@>@;
else {
	for (DATA(&l) = DATA(lft), DATA(&r) = DATA(rgt); 
	    cnt--; DATA(&l)++, DATA(&r)++) {
		applydyadic(func, &z, &l, &r); 
		*resd++ = *DATA(&z);
	}
	TYPE(res) = TYPE(&z);
}

@ The only temporary array that we allocate is |z|, implicitly by 
doing an application with |z| as the result array. Recall before that 
an APL function is expected to write into its result array argument, 
but that is should not write into its input array arguments. 
@^Functions, restrictions@>
Once we are done with the main each loops in both cases, we can safely
free the |z| array's data.

@<Do any cleanup necessary in |each|@>=
free_data(&z);

@ When we process a normal array, we slide the |DATA(&r)| pointer 
over the data and apply each function to it. 

@<Apply |func| monadically over |rgt| array@>=
{
	TYPE(&r) = TYPE(rgt);
	SIZE(&r) = sizeof(AplScalar);
	DATA(&r) = DATA(rgt);
	for (DATA(&r) = DATA(rgt); cnt--; DATA(&r)++) {
		applymonadic(func, &z, &r);
		*resd++ = *DATA(&z);
	}
}

@ Processing |APLIOTA| ranges is pretty straightforward given our current 
layout, using a counter instead of sliding the range around. 

@<Apply |func| monadically over range@>=
{
	AplInt s, e;
	s = INT(DATA(rgt));
	e = INT(DATA(rgt) + 1);
	alloc_array(&r, APLINT);
	for (INT(DATA(&r)) = s; INT(DATA(&r)) < e; INT(DATA(&r))++) {
		applymonadic(func, &z, &r);
		*resd++ = *DATA(&z);
	}
	free_data(&r);
}

@*2 Processing step functions in |each|. Very little actually changes in 
the code of |each| when we deal with a step function. A thread is spawned 
for each element, and each element corresponds to an FEB (full-empty bit) 
that can be queried. It will be empty before the value has been filled 
in by the thread, and full afterwards. We deal with step functions specially 
in |each| because we do not want to incure the overhead involved with 
creatind |AplFutr| objects for each element, and then converting out. Instead, 
the result of |each| will be an array that has a |TYPE| which is |UNSET| 
but marked as being a future array of type |2|, meaning that each element 
corresponds to an individual future, rather than the array being a single, 
large future. Functions that operate only on certain elements may then 
block only on those elements, or they may choose to wait for the entire 
future to realize itself using the |defutr| function. 

In the normal loop, we set the type from last element that we compute. In 
this case, we will be a little lazy for the moment and set the type with 
each element that we get. This is safe at the moment because we assume 
that each element must be of the same type. 

@<Apply step monadically on |rgt|@>=
{
	SIZE(&r) = sizeof(AplScalar);
	if (TYPE(rgt) == APLIOTA)
		@<Apply step monadically over range@>@;
	else
		@<Apply step monadically on each element@>@;
	FUTR(res) = 2;
	defutr(res);
}

@ When we are dealing with a normal array, then we can have |r| slide 
along the |DATA(rgt)| array. This is the normal way that applying 
the step would work. 

@<Apply step monadically on each element@>=
{
	TYPE(&r) = TYPE(rgt);
	DATA(&r) = DATA(rgt);
	for (DATA(&r) = DATA(rgt); cnt--; DATA(&r)++) {
		struct each_step_arg *appinfo;
		appinfo = new_each_arg(func, NULL, &r, &TYPE(res));
		qthread_fork(each_step, appinfo, (aligned_t *) resd++);
	}
}

@ If we instead are dealing with an |APLIOTA| array |rgt|, then we need 
to change the way that we handle the |r| array.

@<Apply step monadically over range@>=
{
	AplInt s, e;
	s = INT(DATA(rgt));
	e = INT(DATA(rgt)+1);
	alloc_array(&r, APLINT);
	for (INT(DATA(&r)) = s; INT(DATA(&r)) < e; INT(DATA(&r))++) {
		struct each_step_arg *appinfo;
		appinfo = new_each_arg(func, NULL, &r, &TYPE(res));
		qthread_fork(each_step, appinfo, (aligned_t *) resd++);
	}
	free_data(&r);
}
	
@ Now let's deal with the dyadic cases. These follow the same basic 
line as the monadic ones, except that we have an extra argument. 
At the moment, since we actualize the input array, we do not have to 
deal with the |APLIOTA| arrays like we do with the monadic case.

@<Apply step dyadically on each element@>=
{
	for (DATA(&l) = DATA(lft), DATA(&r) = DATA(rgt); cnt--; 
	    DATA(&l)++, DATA(&r)++) {
		struct each_step_arg *appinfo;
		appinfo = new_each_arg(func, &l, &r, &TYPE(res));
		qthread_fork(each_step, appinfo, (aligned_t *) resd++);
	}
	FUTR(res) = 2;
	defutr(res);
}

@ The argument to |each_step|, which we call |appinfo|, is a bit like 
the |struct apl_thread_arg| that we used in general step function application, 
but it needs to carry a full copy of the input arrays, since we may change 
the values in |l| and |r| before the step function has finished its work 
with them. To that end, we have something like this. Since we are being 
lazy, we also have a field that points to the type field of the eventual 
output array.

@<Internal data structures@>=
struct each_step_arg {
	AplFunction *func;
	AplArray lft;
	AplArray rgt;
	AplType *type;
};

@ We use the |new_each_arg| function to allocate a new |struct each_step_arg|
object for us. It handles both the dyadic and monadic cases. In the case 
of a monadic, the |lft| field is filled only with the initial state.

@<Utility functions@>=
struct each_step_arg *
new_each_arg(AplFunction *func, AplArray *lft, AplArray *rgt, AplType *type)
{
	struct each_step_arg *res;
	
	if ((res = malloc(sizeof(struct each_step_arg))) == NULL) {
		perror("new_each_arg");
		apl_error(APLERR_MALLOC);
		exit(APLERR_MALLOC);
	}
	
	res->func = func;
	res->type = type;
	init_array(&res->lft);
	init_array(&res->rgt);
	if (lft != NULL) copy_array(&res->lft, lft);
	copy_array(&res->rgt, rgt);
	
	return res;
}

@ Now we should talk about the actual |each_step| function. The job of 
this function is to apply the |func| that we are given to the arguments 
that we are given, and then extract the scalar value from the |DATA| 
field and return it. We are expecting that the result is a scalar, but 
we do not do any checking to ensure that this is the case. Additionally,
since we are being lazy, we also set the type of our output array in 
each case. We specifically bypass the usual checking that is done by the 
|applymonadic| and |applydyadic| functions, and go directly to the 
|APPLYM| and |APPLYD| macros that are meant specifically for applying 
normal functions. This is because we do not want to treat these functions 
as step functions, since we have already spawned the requisite thread for 
the computation.

@<Utility functions@>=
aligned_t each_step(void *arg) 
{
	struct each_step_arg *appinfo;
	AplArray z;
	
	appinfo = arg;
	init_array(&z);
	
	if (DATA(&appinfo->lft) == NULL)
		APPLYM(appinfo->func, &z, &appinfo->rgt);
	else 
		APPLYD(appinfo->func, &z, &appinfo->lft, &appinfo->rgt);
	
	*appinfo->type = TYPE(&z);
	
	return *((aligned_t *) DATA(&z));
}

@*1 The Reduce Operator.
The reduction operator takes scalar functions and produces a monadic
function in return. It expects its incoming functions to be scalar 
dyadic. The result of applying a reduction function to an array $A$ is an 
array of 
shape $\mathrel{\bar{ }}1\downarrow\rho A$. 
That is, we reduce an array along its last axis. The elements in each 
index $I$ of the resulting array is the result of distributing the 
operand along the elements of the vector $I\idxbox A$. Assuming we have Dyalog 
APL, then we can express general reduction in terms of reduction over 
vectors using this equality:

$$(f/A)\equiv(\iota\mathrel{\bar{ }}1\downarrow\rho A)\{f/\alpha\idxbox\omega\}
\mathrel{\ddot{ }}\thinspace\subset A$$

\noindent Distribution over a vector happens according to APL's rules 
of association, meaning that everything associates right to left. We 
might be tempted to implement reduction over vectors first, 
and then scale the process up to arrays of greater dimensions; instead
of dealing with the expensive copying that might result from that, 
we will implement this in-place, handling any dimension from the start. 

We are going to be a little picky here. Namely, we are going to assume 
that the domain or type of the output array is the same as the input array. 
This simplifies some of our work, but makes the reduction operator less 
general. This will work for now. We do not need to allocate the array if 
|res == rgt| because we know that there is enough space in that case. 

@<APL Operators@>=
void reduce(AplArray *res, AplArray *rgt, AplFunction *env)
{
	AplInt step;
	AplType t;
	AplScalarFunction tf;
	AplFunction *fun;
	AplScalarDyadic op;
	t = (TYPE(rgt) == APLIOTA ? APLINT : TYPE(rgt));
	@<Determine |fun|@>@;
	@<Set |SHAPE(res)| and determine |step| size@>@;
	if (res != rgt) alloc_array(res, t);
	@<Reduce over last axis@>@;
	TYPE(res) = t;
}

@ The function that we use depends on whether we can find a known 
scalar functions for the |LOP(env)|. If we can, then we will use that, 
otherwise, we will just use the left operand as is. We say that the 
type of the array is |APLINT| when we have an |APLIOTA| array in this 
case as this is the equivalent type that the scalar function will 
see when we do the reduction.

@<Determine |fun|@>=
{
	if ((op = known_scalard(plus, t, t)) == NULL) {
		fun = LOP(env);
	} else {
		init_sfunc(&tf, NULL, op);
		fun = (AplFunction *) &tf;
	}
}

@ We can know the shape of our output without running 
our function. We avoid copying the shape information when |res == rgt|.
The last dimension of our input array is the |step| size unless the 
rank of the input array is 0, in which case our |step| size is 1.
We do not want to allocate the 
|res| array here because we have not yet dealt with special cases in 
the input which might change our perspective.

@<Set |SHAPE(res)| and determine |step| size@>=
if (RANK(rgt) == 0) {
	step = 1;
	RANK(res) = 0;
} else {
	RANK(res) = RANK(rgt) - 1;
	step = SHAPE(rgt)[RANK(res)];
	if (res != rgt)
		memcpy(SHAPE(res), SHAPE(rgt), sizeof(AplScalar) * RANK(res));
}

@ After determining the shape of |res|, |step| contains the
number of elements per individual reduction. We can use this value to
catch some special cases. When |step == 1|, we know that we are
dealing either with a scalar input or an array whose last dimension is
|1|. In either case, we know that we will not run |fun| on any of our
inputs. In the scalar case, we are basically the identity function, and
in the singular final dimension case we are the identity function with
a small reshape that has zero effect on |count(res)|. This translates
into a straight copy of the data in the case when |res != rgt|, and a
no-op when they are the same object. Otherwise, we are dealing with 
the cases where |step == 0| or |step > 1|, which both require a bit 
more work, so we dedicate separate sections to handling them.

We actualize the array when the step is 0 or 1 because there is no real use 
in having it in the APLIOTA form.

@<Reduce over last axis@>=
if ((step == 0 || step == 1) && TYPE(rgt) == APLIOTA) actualize_idx(rgt);
switch (step) {
case 0: 
	@<Fill |res| with identity of |fun|@>@;	
	break;
case 1: 
	if (res != rgt) 
		memcpy(DATA(res), DATA(rgt), sizeof(AplScalar) * count(res)); 
	break;
default: 
	@<Reduce over array whose |step >= 2|@>@;
}

@ When |step == 0| we are dealing 
with a case where we need to fill in the result with the identity 
of the function, not apply the identity function over |rgt->data|.
We can only do this when the function that we have been given is a 
function that we know about, and that we have an identity for.
Otherwise we need to signal an error. 

@<Fill |res| with identity of |fun|@>=
{
	int c;
	AplScalar *o;
	AplArray z;

	init_array(&z);
	if (function_identity(&z, LOP(env))) {
		apl_error(APLERR_NOIDENTITY);
		exit(APLERR_NOIDENTITY);
	}
	if (TYPE(&z) != TYPE(res)) {
		apl_error(APLERR_DOMAIN);
		exit(APLERR_DOMAIN);
	}
	o = DATA(res);
	for (c = count(res); c--;) *o++ = *DATA(&z);
	free_data(&z);
}

@ The |function_identity| function is used to fill its first argument,
which is of type |AplArray *|, with a scalar array whose value is 
the identity of the |AplFunction *| that is passed as the second argument. 
On return, |function_identity| should return either |0| on success or 
a non-zero value on error. A common error that might occur is if there 
is no identity function corresponding to the function given.

@<Utility functions@>=
int function_identity(AplArray *res, AplFunction *fun)
{
	int ret;
	AplDyadic ptr;
	
	RANK(res) = 0;
	ret = 0;
	ptr = DYADIC(fun);
	
	if (ptr == plus) {
		alloc_array(res, APLINT);
		INT(DATA(res)) = 0;
	} else {
		ret = 1;
	}
	
	return ret;
}

@ In case where we have a |step >= 2|, we have either an |APLIOTA| 
array or a normal array. We can do some special things with the |APLIOTA| 
array, so we will do that. Otherwise, they are both going to need a 
temporary array |l| as the element array, so we will declare and 
initialize that here.

@<Reduce over array whose |step >= 2|@>=
{
	AplArray l;
	init_array(&l);
	if (TYPE(rgt) == APLIOTA)
		@<Compute range reduction using |rgt|@>@;
	else 
		@<Reduce over general array when |step >= 2|@>@;
}

@ When we have an |APLIOTA| array, we know that the result is going to 
be a single scalar, and we also know how we are going to reduce. This 
allows us to do some special stuff. For one thing, this allows us to 
use only a single additional array |l| for our reduction, and we can 
use the final |res| array for our accumulator. Additionally, we do not 
have to traverse a region in memory, and we can instead just work 
directly over a static range.

@<Compute range reduction using |rgt|@>=
{
	AplInt e, s;
	s = INT(DATA(rgt));
	e = INT(DATA(rgt) + 1) - 1;
	alloc_array(&l, APLINT);
	INT(DATA(res)) = e;
	for (INT(DATA(&l)) = e - 1; INT(DATA(&l)) >= s; INT(DATA(&l))--)
		APPLYD(fun, res, &l, res);
	free_data(&l);
}

@ In the normal case, we conceptually divide our original array into
segments of vectors.  Note that because of the row-major order of our
arrays, and because we are  reducing over the last axis, these vector
segments correspond directly to  the contiguous block of memory in our
array region, in order, each of  the size of the vector whose shape is
the last dimension of the input  array. Each of these regions will be
reduced to a single scalar value. These are in the same order in the
output array |res| as the vector  segments appear in the input array
|rgt|. Thus, we compute each element  of the |res| array in turn,
letting |p| point to the start of the next  segment. We use |z| as an
accumulation array and |l| as the element array that is always used 
as the left argument in our allocation.

@<Reduce over general array when |step >= 2|@>=
{
	size_t c, s;
	AplScalar *p, *d;
	AplArray z;
	init_array(&z);
	TYPE(&l) = TYPE(rgt);
	SIZE(&l) = sizeof(AplScalar);
	alloc_array(&z, TYPE(rgt));
	d = DATA(res);
	for (c = count(res), p = DATA(rgt) + step; c--; p+=step) {
		*DATA(&z) = p[-1];
		DATA(&l) = p - 2;
		for (s = step - 1; s--; DATA(&l)--) APPLYD(fun, &z, &l, &z);
		*d++ = *DATA(&z);
	}
	free_data(&z);
}	

@* Improving performance. We would like to improve performance in functions 
where we can. However, sometimes we need to establish special paths in order 
to get the performance that we want. As a simple point, let's consider 
operations that take functions which operate over scalars. In this case, 
it is helpful, since we know the shapes ahead of time, if we can bypass 
the shape checks and the like of the more general functions. We cannot 
do this if we do not know what the function is, but if we do know what 
the function is, then we can use the scalar functions instead.

@<Utility functions@>=
AplScalarDyadic known_scalard(AplDyadic fn, AplType ld, AplType rd)
{
	if (plus == fn) 
		if (APLINT == ld) 
			if (APLINT == rd) return plus_int_int;
			else if (APLREAL == rd) return plus_int_real;
			else return NULL;
		else if (APLREAL == ld)
			if (APLINT == rd) return plus_real_int;
			else if (APLREAL == rd) return plus_real_real;
			else return NULL;
		else return NULL;
	else return NULL;
}

@ We can enable easy use of this by creating a scalar function for 
application that expects a known scalar function as its left operand.
You can then use these when creating function closures.

@<Utility functions@>=
void 
scalard(AplArray *res, AplArray *lft, AplArray *rgt, AplScalarFunction *fun)
{
	AplScalarDyadic op = fun->sd;
	op(DATA(res), DATA(lft), DATA(rgt));
}
void 
scalarm(AplArray *res, AplArray *rgt, AplScalarFunction *fun)
{
	AplScalarMonadic op = fun->sm;
	op(DATA(res), DATA(rgt));
}

@ To make creating scalar functions easier, we have |init_sfunc| 
that initializes an |AplScalarFunction| with the appropriate 
dyadic and monadic elements. The |AplScalarFunction| structure is the 
same as an |AplFunction| but with the left and right operand fields 
changed to use |AplScalarMonadic| and |AplScalarDyadic| pointers instead.
This structure has just enough fields the same to enable it to be 
used in place of an |AplFunction| structure. 

@s AplScalarFunction int

@<Internal data structures@>=
typedef struct apl_scalar_function AplScalarFunction;
struct apl_scalar_function {
	void@,(*monadic)(AplArray *, AplArray *, AplScalarFunction *);
	void@,(*dyadic)(AplArray *, AplArray *, AplArray *, 
	    AplScalarFunction *);
	int step;
	AplScalarMonadic sm;
	AplScalarDyadic sd;
};

@ The |init_sfunc| need only to take the scalar functions, as 
all the other fields will always be the same, including the |step| 
field, which will always be 0.

@<Utility functions@>=
void init_sfunc(AplScalarFunction *f, AplScalarMonadic mf, AplScalarDyadic df)
{
	f->monadic = scalarm;
	f->dyadic = scalard;
	f->step = 0;
	f->sm = mf;
	f->sd = df;
}

@* Reporting runtime errors. Much as I would like to think that my 
compiler and that my coding are perfect, it turns out that this is 
not going to happen. Imagine that. Instead, I want to have a good 
backup plan: error reports that make sense.  In general, this 
means that when I hit a major error, I report the error with a 
specific error code (macros starting with |APLERR_|) or report it 
as a warning (macros starting with |APLWARN_|), after I have 
reported the system error, if relevant. I leave it up to the 
call site whether or not to continue working or not.
What follows are the error message code that I use and their 
plain text descriptions in a static array.

@d APLERR_MALLOC 1
@d APLERR_SHAPEMISMATCH 2
@d APLERR_DOMAIN 3
@d APLERR_NOIDENTITY 4
@d APLERR_QTHREAD 5

@<Runtime error reporting@>=
char *error_messages[] = 
	{  @/
	  "Success", @/
	  "Allocation failure", /* |APLERR_MALLOC| */
	  "Shape mismatch", /* |APLERR_SHAPEMISMATCH| */
	  "Invalid domain", /* |APLERR_DOMAIN| */
	  "No identity is defined for this function", /* |APLERR_NOIDENTITY| */
	  "Error with qthread function" /* |APLERR_QTHREAD| */
	};
char *warning_messages[] =
	{  @/
	  "Success" @/
	};

@ The |apl_error| function is meant for reporting serious errors 
that are not part of the normal operation of the system.
The |apl_warning| function is for printing out non-critical 
warnings about things that are probably important, but that are 
not complete or partial show-stoppers. They should generally 
always be recoverable and should not halt the execution of the 
runtime.

@<Runtime error reporting@>=
void apl_error(int code)
{
	fprintf(stderr, "APL Error (%d): %s\n", code, 
	    error_messages[code]);
}
void apl_warning(int code)
{
	fprintf(stderr, "APL Warning (%d): %s\n",
	    code, warning_messages[code]);
}

@* Public Header Definition.
We define a header ``hpapl.h'' that contains the public interface to 
this code.

@(hpapl.h@>=
#include <stddef.h>

@<Public macro ...@>@;
@<Primary data structures@>@;
@<Public function ...@>@;

@ It is helpful to have the set of all of our functions that we use 
that should be publicly available in a single section. This allows us to 
declare the functions at the top of our code body and get some more 
flexibility in laying out our code.

@<Public function declarations@>=
void init_array(AplArray *);
void init_function(AplFunction *, AplMonadic, AplDyadic, 
    int, void *, void *, ...);
void applymonadic(AplFunction *, AplArray *, AplArray *);
void applydyadic(AplFunction *, AplArray *, AplArray *, AplArray *);
void alloc_array(AplArray *, AplType);
void realloc_array(AplArray *, AplType);
void copy_array(AplArray *, AplArray *);
void free_data(AplArray *);
size_t count(AplArray *);
void actualize_idx(AplArray *);@#

void identity(AplArray *, AplArray *, AplFunction *);
void plus(AplArray *, AplArray *, AplArray *, AplFunction *);@#

void index_gen(AplArray *, AplArray *, AplFunction *);
void index(AplArray *, AplArray *, AplArray *, AplFunction *);@#

void eachm(AplArray *, AplArray *, AplFunction *);
void eachd(AplArray *, AplArray *, AplArray *, AplFunction *);
void reduce(AplArray *, AplArray *, AplFunction *);

@* Index.

