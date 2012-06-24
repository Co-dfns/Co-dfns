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
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>

@h

@<Primary data structures@>@;
@<Internal utility functions@>@;
/*Memory management functions*/@;
/*Scalar APL functions*/@;
/*Non-scalar APL functions*/@;
/*APL Operators*/@;

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

@ This concludes the main introductions, we can now proceed to the 
details of implementing the runtime.

@* Data structures.  We must implement two main data structures: 
arrays and functions.  Arrays are the most used, and we have a few 
requirements that drive our design. First, we want them to be as fast as 
possible, but we also want to be able to decouple the core array 
structure from the data areas where we store the elements. This 
frees us to potentially make use of faster memory allocation 
functions, segmented heaps, as well as shared data regions between 
multiple arrays. In the end, it is a more flexible solution. 
We expect that most of the array headers will be stack allocated 
and that their allocations will be automatic. We use a static 
shape array to store the shape information so that we do not 
have to worry about managing that. In practice, noble arrays are 
rare, and we can do with having only a reasonably large number of 
them. There is some question as to the size that we allocate for 
each dimension. Specifically, the number of elements that are 
needed for any given array of shape $s$ whose rank is $r$ and 
where $s_i$ is the dimension length of the $i$th dimension of 
the array, the number of elements that we need is thus:

$$\prod_{i=0}^{r}s_i$$

\noindent Of course, we have a theoretical limit on the 
number of elements that we can have and reference, and we 
would want a vector (rank 1 array) to be able to have that many 
elements as well as arrays of other rank. This implies that our 
space that we allocate for a single dimension must be capable 
of addressing our theoretical limit on our elements, but this 
also means that we could create an invalid array that references 
more elements than we have space to store. However, we can 
actually have valid arrays like this that we can implement if 
they have patterns that allow us to compress their element 
representations, such as repeating arrays or arrays whose 
elements are all the same.

Because of the above considerations, we make the arrays 
dimensions |unsigned int| in size. We use the unsigned feature 
because we do not have negative shapes. This gives us all the 
range of |unsigned int| save one, so we have a maximum number 
of elements for an array fixed at |UINT_MAX - 1|, where 
|UINT_MAX| is used to indicate that a particular dimension is not
in use. For future ease of transition to larger sizes we make sure 
to define |SHAPE_END| for use instead of |UINT_MAX|. The shape 
of an array is then the non-negative elements of the shape 
field up to but not including the first element whose value is 
|SHAPE_END|. We expect all the other values to be |SHAPE_END| 
after that. While using |unsigned int| is relatively small for the
number of elements that we can potentially access on a 64-bit 
machine, it is big enough at the moment, and we can scale this 
up without cause for alarm in the future. We do not limit the 
size of the data regions like this though, and we use an 
appropriate |size_t| variable to hold the size of the data 
region. This gives us the following fields for our arrays:

\medskip
\itemitem{|shape|} A static array of length |MAXRANK| whose 
elements are all |unsigned int| values;
\itemitem{|size|} The number of bytes allocated for the region 
pointed to by |data|;
\itemitem{|data|} A pointer to a region of memory containing 
the elements in row-major order; and finally,
\itemitem{|type|} An enumeration indicating the type of elements
in the array.

\medskip\noindent This leads us to the following |typedef| 
and definitions. We have a maximum array rank of 32. 

@d MAXRANK 32
@d SHAPE_END UINT_MAX
@s AplType int

@<Primary data structures@>=
@<Define AplType@>@;
struct apl_array {
	unsigned int shape[MAXRANK];
	AplType type;
	size_t size;
	void *data;
};
typedef struct apl_array AplArray;

@ We have three main types of values that we can have, and to indicate 
which one that we use, we setup an enumeration. We have one other 
value |UNSET| that indicates that nothing has been done with the array 
yet. Our |INT| type is the largest integer type that we have in C89
which happens to be |long|. On my system this is a 64-bit integer, 
but this is only required to be a 32-bit integer. I think this is a 
reasonable choice to get decent performance on most systems. The 
|REAL| type is a |double|, since I want to have as much precision in 
my single floating point type as I can.  Finally, I have |CHAR| set 
to |wchar_t| since we are dealing with wide characters throughout;
this is APL afterall.

@<Define AplType@>=
enum apl_type { INT, REAL, CHAR, UNSET };
typedef enum apl_type AplType;
typedef long AplInt;
typedef double AplReal;
typedef wchar_t AplChar;

@ There are a few very useful functions relating to arrays that 
we should talk about. The first is a way to get the size based on 
the contents of the |shape| array.

@<Internal utility functions@>=
int size(AplArray *array) 
{
	int i, res;
	unsigned int *shp;

	res = 1;
	shp = array->shape;

	for (i = 0; i < MAXRANK; i++, shp++) {
		if (SHAPE_END == *shp) break;
		else res *= *shp;
	}
	
	return res;
}

@ Next, we very often want to talk about the rank of an array, so 
we encapsulate that up into a function.

@<Internal utility functions@>=
short rank(AplArray *array) 
{
	short i, rnk;
	unsigned int *shp;

	rnk = 0;
	shp = array->shape;

	for(i = 0; i < MAXRANK; i++) {
		if (SHAPE_END == *shp++) break;
		else rnk++;
	}

	return rnk;
}

@ Finally, it's very helpful at times to be able to talk about the 
product of an integer array's ravel. Basically, we often want to 
compute the product when we are using the array as a reshape value 
for another array or the like. For this we assume that the array 
that we are given is an integer array, and then we get to work.

@<Internal utility functions@>=
unsigned int product(AplArray *array)
{
	int i, len;
	int *data;
	unsigned int prod;

	prod = 1;
	len = size(array);
	data = array->data;

	for (i = 0; i < len; i++) prod *= *data++;

	return prod;
}

@ Let's proceed to functions. In HPAPL, a function is either an 
operator or a normal function.  At the higher level language, 
we can distinguish these by asking whether a function has 
$\alpha\alpha$ or $\omega\omega$ as a free variable or not. 
We make no distinction between functions which take functions 
and normal functions at the runtime level. Instead, unless 
optimized away, all functions have an explicit, possibly empty 
closure allocated for them. This closure is what is passed 
around to primitive operators and the like. Thus, all functions 
have the same signature as their C function elements.

@s AplCodePtr int
@s AplFunction int

@<Primary data structures@>=
@<Define |AplFunction| type@>@;
typedef void (*AplCodePtr)(AplArray **res_ptr,
    AplArray *, AplArray *, AplFunction *);

@ Each APL function should place its result into the array that is 
pointed to in |res_ptr| unless that pointer is NULL, in which case 
it should store into |res_ptr| the pointer to a newly allocated 
array. We use the convention that |res| always contains the 
result array, so we can encapsulate this main logic here.

@<Setup return array |res|@>=
if (NULL == *res_ptr) {
	res = malloc(sizeof(AplArray));
	if (NULL == res) apl_error(APLERROR_MALLOC);
	*res_ptr = res;
} else {
	res = *res_ptr;
}

init_array(res);

@ Initializing an array is just a matter of setting up all the 
values to suitable defaults before we do any allocations. This 
should be done to ensure that everything is nice and clean. 
This function does not do any allocation, but simply sets some 
fields.  See the section further down on memory management 
for functions that allocate space for arrays and the like.

@<Internal utility functions@>=
void init_array(AplArray *array)
{
	int i;
	unsigned int *shp;

	shp = array->shape;
	array->type = UNSET;
	array->size = 0;
	array->data = NULL;

	for (i = 0; i < MAXRANK; i++) *shp++ = SHAPE_END;
}

@ So, what is an |AplFunction| anyways. It is a structure to 
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

@s AplOperand int
@s AplOperand int

@<Define |AplFunction| type@>=
struct apl_function {
	void (*code)(AplArray **, AplArray *, AplArray *,
	    struct apl_function *);
	union apl_operand *lop; /* The $\alpha\alpha$ variable */
	union apl_operand *rop; /* The $\omega\omega$ variable */
	AplArray *env; /* All other free variables */
};
typedef struct apl_function AplFunction;

@ To actually use a closure we need to be able to apply it to 
arguments. This is done through a simple macro.
The arguments are all expected to be pointers to their appropriate
data types.

@d apply(fun, res, lft, rgt) ((fun)->code)(&res, lft, rgt, fun)

@ We have not yet explained why we use |AplOperand| for the |lop| 
and |rop| variables, which correspond to $\alpha\alpha$ and 
$\omega\omega$ variables in a function. In APL, an operators 
left and right operands can be either functions or arrays. We may 
need to allow both even in the same operator, so we have a type 
which can be either the one or the other. We implement this with 
a union, because in practice, we will know at the time that we 
use an operand, how it is to be used: either as a function or as 
an array. This means that we do not need to have a type tag as 
we do with the |AplArray| type.

@<Primary data structures@>=
union apl_operand {
	AplArray array;
	AplFunction function;
};
typedef union apl_operand AplOperand;


@* Index.

