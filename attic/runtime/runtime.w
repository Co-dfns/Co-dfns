\def\title{HPAPL RUNTIME (VERSION 0.1)}
\def\topofcontents{\null\vfill
  \centerline{\titlefont HPAPL Runtime Library}
  \vskip 15pt
  \centerline{(Version 0.1)}
  \vfill}
\def\botofcontents{\vfill
\noindent
Copyright $\copyright$ 2011 Aaron W. Hsu $\.{arcfide@@sacrideo.us}$
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

@** Introduction.  This is the runtime library for HPAPL.  It is designed
to provide the basic vocabulary for HPAPL programs into which a given HPAPL 
program is compiled.  This includes the built-in functions as well as the 
necessary semantic helpers.  This library is extremely experimental, and 
is very likely to change drastically in the future.  

We lay out our main runtime file like so, along with a header file for 
all public elements.  All utility functions are defined as they are first 
introduced throughout the text.  A summary of these functions is given in 
its own section. 

@p
#include "runtime.h"

@<Utility functions@>@;
@<Scalar functions@>@;
@<Primitive functions@>@;

@ @(runtime.h@>=
@<Header includes@>@;
@<Type declarations@>@;
@<Function declarations@>@;

@* Array representation.  First thing we need is a proper array 
representation.  In this experimental case, we shall start with a basic 
generic $N$-dimensional representation of arrays in row-major format. 

@f Array int

@<Type declarations@>=
@<Scalar typedef@>@;
typedef struct apl_array {
	int 	rank;
	int	ssize;
	int 	*shape;
	size_t	dlen;
	size_t 	dsize;
	Scalar 	*data;
} Array;

@ @<Header includes@>=
#include <stddef.h>

@ We define array equality in the following manner.  Basically, we care 
only about the actual values specified by the meta information, and not 
any of the extra information that may be in the array, including differences 
in allocated space, \AM c. 

@<Utility functions@>=
bool
array_equal(Array *a1, Array *a2)
{
	if (a1->rank != a2->rank) return false;
	if (a1->dlen != a2->dlen) return false;
	for (int i = 0; i < a1->rank; i++) 
		if (a1->shape[i] != a2->shape[i])
			return false;
	for (int i = 0; i < a1->dlen; i++)
		if (!scalar_equal(&a1->data[i], &a2->data[i]))
			return false;
	return true;
}

@ @<Function declarations@>=
bool array_equal(Array *, Array *);

@ We assume that we have only flat arrays at the moment, filled with scalars. 
This means that we do not, right now, allow for nested arrays.  This is a 
feature that I plan to add at a later time once the basic ideas have been
demonstrated to be sound.  Instead, each element of an array is a |Scalar|.
This is a union type of booleans, floats, integers, and characters.

@f Scalar int

@<Scalar typedef@>=
enum scalar_type {stb, stc, sti, stf};

union apl_scalar {
	bool		b;
	wchar_t 	c;
	long long 	i;
	long double 	f;
};

typedef struct apl_typed_scalar {
	enum scalar_type t;
	union apl_scalar v;
} Scalar;

@ @<Header includes@>=
#include <stdbool.h>
#include <wchar.h>

@ We define |Scalar| equality only on objects of the same type for the 
moment.

@<Utility functions@>=
bool
scalar_equal(Scalar *a, Scalar *b)
{
	if (a->t != b->t) return false;
	switch (a->t) {
	case stb: if (a->v.b == b->v.b) return true;
	case stc: if (a->v.c == b->v.c) return true;
	case sti: if (a->v.i == b->v.i) return true;
	case stf: if (a->v.f == b->v.f) return true;
	}
	return false;
}

@ @<Function declarations@>=
bool scalar_equal(Scalar *, Scalar *);

@* Testing Harness.  At this point, we begin our treatment of the actual 
functions and other procedures in the runtime library.  This requires a 
good testing harness for reliable operation and regression testing.  We 
define this harness here, before we get into the meat of our presentation. 
The main file has the following layout.

@(runtime-test.c@>=
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

#include "runtime.h"

@<Test harness globals@>@;
@<Testing function declarations@>@;
@<Testing functions@>@;
@<Runtime tests@>@;
@<Main test entry point@>@;

@ There are some global variables that track our state and also represent 
some settings that are used throughout the program. The first indicates 
whether we should continue testing throughout the program or quit at the 
first occurance of an error.  By default, we continue going through our 
tests even if we encounter a failure.

@<Test harness globals@>=
bool exit_on_fail = false;

@ When writing tests, most tests will take the form of some random 
computation, ending in a |test_assert|, which checks to see that you 
got the expected value from your computation.  The programmer can provide 
a message naming the test or describing things.  Normally, this message 
is not printed unless there is a problem. 

@<Testing functions@>=
void
test_assert(const char *name, Array *expected, Array *actual)
{
	if (array_equal(expected, actual)) {
		test_succeed(name); 
	} else {
		test_fail(name, expected, actual);
		if (true == exit_on_fail) {
			test_results();
			exit(1);
		}
	}
}

@ @<Testing function declarations@>=
void test_assert(const char *, Array *, Array *);

@ Our testing harness keeps track of the number of successful tests, as 
well as the number of failed tests.  We don't need to print anything out 
if a test succeeds, but we do need to print something out if a test fails. 
We don't need to print the expected values out unless we have asked 
specifically for the output.

@<Test harness globals@>=
int tests_passed = 0;
int tests_failed = 0;
bool print_results = false;

@ @<Testing functions@>=
void 
test_succeed(const char *name)
{
	tests_passed++;
}

void
test_fail(const char *name, Array *exp, Array *act)
{
	tests_failed++;
	printf("\n******* Failed: %s\n", name);
	if (true == print_results) {
		printf("Expected:\n");
		apl_print(exp);
		printf("\nActual:\n");
		apl_print(act);
	}
}

@ @<Testing function declarations@>=
void test_succeed(const char *);
void test_fail(const char *, Array *, Array *);

@ We need to have a nice little utility for printing arrays. This will print 
out in grid format, but without much else in the way of formatting at the 
moment.  Right now I want to be really lazy about this, so I am going to 
just print out the elements in an array all in a row, and print out some 
meta data explicitly.

@<Utility functions@>=
void
scalar_print(Scalar *s)
{
	switch (s->t) {
	case stb: printf("%d", s->v.b);
	case stc: printf("%lc", s->v.c);
	case sti: printf("%ld", s->v.i);
	case stf: printf("%Lf", s->v.f);
	default: printf("N/A");
	}
}

void
apl_print(Array *arr)
{
	printf("\nMeta (rank/ssize/dlen/dsize): %d/%d/%d/%d\n",
	    arr->rank, arr->ssize, arr->dlen, arr->dsize);
	printf("Shape: ");
	for (int i = 0; i < arr->rank; i++)
		printf("%d ", arr->shape[i]);
	printf("\nData: ");
	for (int i = 0; i < arr->dlen; i++) {
		scalar_print(&arr->data[i]);
		printf(" ");
	}
	printf("\n\n");
}

@ @<Function declarations@>=
void apl_print(Array *);

@ @<Header includes@>=
#include <stdio.h>

@ We assume that we have a specific section name for storing all of our 
tests. We wrap this around our main function to do the tests and print 
the results.

@<Main test entry point@>=
int
main(int argc, char *argv[]) 
{
	exit_on_fail = false;
	print_results = true;

	@<Run test suite@>@;

	test_results();
	return 0;
}

@ We use |test_results| to print the final totals of all of the tests, 
where, of course, we hope that everything passes.  It gives us simple 
feedback on the general progress of test completion, but not much else.
Note that I do not want to include the exit condition here, because 
we may want to print results at times other than right before we exit 
the program.

@<Testing functions@>=
void
test_results(void)
{
	printf("Passed %d tests.\n", tests_passed);
	printf("Failed %d tests.\n", tests_failed);
	printf("Total tests: %d\n", tests_failed+tests_passed);
}

@ @<Testing function declarations@>=
void test_results(void);

@** Runtime Primitives.  This section details the actual ``language'' that 
the runtime provides, in some sense.  The runtime is designed not to be a 
front-end language, and to that end, it does not try to help the user at 
all.  Instead, the purpose is to make an useful compilation target.  This
basically means that it should be simple, direct, and as efficient as 
possible.  All forms of safety are provided at a higher level by the 
compiler.  All the runtime provides is a sort of assembly language of 
arrays that allows me to work with arrays at some lower level.  

As a general rule, I want to reduce allocation costs as much as possible, 
and therefore, all of the following primitives do no allocation of their 
own.  Instead, the compiler is in charge of ensuring that the right amount 
of memory and from the right places is available to the system.  All of 
these functions are destructive, and as a rule they should also have a 
|void| return value.  This makes them very much like a RISC architecture 
over arrays. 

@* 1 Scalar operations.  The operations in this section are those which 
operate at a scalar level.  Most of the APL operations could be grouped 
under this heading.  They have the nice property that their outputs 
and inputs all have the same shape.  This makes them easy to analyze 
and work with.  They all have a shape like so:

\medskip{\narrower\noindent
|void f(out, left, right);|\par}\medskip

\noindent Here, the |left| and |right| arguments correspond to the left 
and right input arrays, and the |out| array is the array into which the 
results will go.  With scalar functions, it is safe to reuse one of 
the input arrays as the output array, since we work on an element by 
element basis.  For each of these scalar functions, there is usually 
the monadic and dyadic forms, so we define each of these separately 
using the form |functd| and |functm| to distinguish the two.

Additionally, at some point, these operations are going to operate 
on a per |Scalar| level, so for each function there is an internal 
function |functs| that has a signature like so:

\medskip{\narrower\noindent
|Scalar functs(left, right);|\par}\medskip

\noindent This is the operation that we will actually perform on each 
of the underlying |Scalar|s of the array.

@* 2 Add and conjugate.  The |+| symbol is the add function in its dyadic
form, and it is the conjugate in its monadic form.  Since we do not yet have
complex numbers the conjugate function is just the identify function for
other types.

@<Primitive functions@>=
void
plusd(Array *out, Array *left, Array *right)
{
	int i;

	for (i = 0; i < left->dlen; i++)
		pluss(&out->data[i], &left->data[i], &right->data[i]);
	set_meta(out, left);
}

void
plusm(Array *out, Array *in)
{
	int i;

	if (out == in) return;
	for (i = 0; i < in->dlen; i++)
		out->data[i] = in->data[i];
	set_meta(out, in);
}

@ @<Function declarations@>=
void plusd(Array *, Array *, Array *);
void plusm(Array *, Array *);

@ When adding any two scalars together, we coerce everything to an interger 
right now unless it is a float, in which case everything will go to a float.

@<Scalar functions@>=
void 
pluss(Scalar *res, Scalar *l, Scalar *r)
{
	int c;

	c = (l->t << 2) + (r->t);
	res->t = (l->t == stf || r->t == stf) ? stf : sti;
	
	switch (c) {
	case 0: res->v.i = l->v.b + r->v.b; break;
	case 1: res->v.i = l->v.b + r->v.c; break;
	case 2: res->v.i = l->v.b + r->v.i; break;
	case 3: res->v.f = l->v.b + r->v.f; break;
	case 4: res->v.i = l->v.c + r->v.b; break;
	case 5: res->v.i = l->v.c + r->v.c; break;
	case 6: res->v.i = l->v.c + r->v.i; break;
	case 7: res->v.f = l->v.c + r->v.f; break;
	case 8: res->v.i = l->v.i + r->v.b; break;
	case 9: res->v.i = l->v.i + r->v.c; break;
	case 10: res->v.i = l->v.i + r->v.i; break;
	case 11: res->v.f = l->v.i + r->v.f; break;
	case 12: res->v.f = l->v.f + r->v.b; break;
	case 13: res->v.f = l->v.f + r->v.c; break;
	case 14: res->v.f = l->v.f + r->v.i; break;
	case 15: res->v.f = l->v.f + r->v.f; break;
	}
}

@ At this point we introduce one of those helpers that will probably be 
seen throughout.  Specifically, the |set_meta| helper.  This is in charge 
of actually making sure that the output array has the right meta data. 
While we assume that our arrays are all allocated to hold enough of the
data, we do not assume that they have their meta data initialized to 
the appropriate values.  In order to assure this, we need to make sure 
that we do this ourselves.  We also implement a tiny optimization here 
in that we don't need to update the meta data if we are talking about 
the same pointers.

@<Utility functions@>=
void
set_meta(Array *out, Array *in)
{
	if (out == in) return;
	out->rank = in->rank;
	out->dlen = in->dlen;
	for (int i = 0; i < in->rank; i++) 
		out->shape[i] = in->shape[i];
}

@ Let's throw in some testing of these functions to see if they work the 
way that we want them to.

@<Runtime tests@>=
void
test_plus(void)
{
	Array s1, s2, s3, sa;	/* Scalar arrays */
	Array v1, v2, v3, va;	/* Vector arrays */
	Array m1, m2, m3, ma;	/* Matrix arrays */

	@<Run scalar tests@>@;
}

@ @<Run test suite@>=
test_plus();

@ The first test should determine whether the plus functions work for 
scalars.  The inputs are |s1| and |s2|, the output array is |s3|, 
and the expected result is |sa|.  We test both the monadic and dyadic 
plus. 

@<Run scalar tests@>=
Scalar x, y, z, u;

x.t = y.t = u.t = sti;
x.v.i = u.v.i = 3;
y.v.i = 7;
z.v.i = 0; z.t = 0; 

init_array(&s1, 0, 0, NULL, 1, 1, &x);
init_array(&s2, 0, 0, NULL, 1, 1, &y);
init_array(&s3, 0, 0, NULL, 1, 1, &z);
init_array(&sa, 0, 0, NULL, 1, 1, &u);

plusm(&s3, &s1);
test_assert("Plus Monadic", &sa, &s3);

sa.data[0].v.i = 10;
plusd(&s3, &s1, &s2);
test_assert("Plus Dyadic", &sa, &s3);

@ The function |init_array()| is useful for setting up these initial array 
values.  It simply sets the fields of the given array based on the arguments 
that we pass to it. 

@<Utility functions@>=
void
init_array(Array *a, int r, int ss, int *sp, 
    size_t dl, size_t ds, Scalar *d)
{
	a->rank = r;
	a->ssize = ss;
	a->shape = sp;
	a->dlen = dl;
	a->dsize = ds;
	a->data = d;
}

@ @<Function declarations@>=
void init_array(Array *, int, int, int *, size_t, size_t, Scalar *);

@* Utility function summary.  This section summarizes the utility functions 
that we have introduced throughout the text. 

\medskip{\narrower\parindent = 0in
|void apl_print(Array *arr);|\hfill\break
|bool array_equal(Array *a, Array *a);|\hfill\break
|void init_array(Array *a, int r, int ss, int *sp,
    size_t dl, size_t ds, Scalar *d);|\hfill\break
|bool scalar_equal(Scalar *a, Scalar *b);|\hfill\break
|void set_meta(Array *out, Array *in);|\hfill\break
\par}


@* Index. 