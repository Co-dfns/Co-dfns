/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Core forms and runtime environment header
 * 
 * Copyright (c) 2012 Aaron Hsu <arcfide@sacrideo.us>
 * 
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#include <stdlib.h>

/*****************
 * Error handling
 *****************/

#define ALLOC_MALLOCFAIL 1
#define ALLOC_MALLOCFAIL_MSG "Failed to allocate array"

/***********************
 * Array data structure
 ***********************/

union scalar {
	long long i;
	double    f;
	char      c;
};

struct array {
	unsigned short rank;
	unsigned int   *shape;
	union scalar   data[];
};

typedef struct array *Array;

#define decl(x) Array x
#define alloc(x, r, s) allocp(&x, r, s) 
#define frea(x) free(x);

void allocp(Array *, unsigned short, size_t);

/***************************************
 * Dealing with functions and operators
 ***************************************/

typedef void (*FnPtr)(Array, Array, Array, VarEnv);

struct function {
	FnPtr fn;
	OpArg lft;
	OpArg rgt;
	Array env[];
};

typedef struct function *Function;

union oparg {
	Function fun;
	Array    arr;
};

typedef union oparg OpArg;

#define fv(i) env[i]
#define declf(nm) Function nm
#define mfn(tgt, nm, varc) mfnp(&tgt, nm, varc)
#define mop(tgt, nm, lft, rgt) mopp(&tgt, nm, lft, rgt)
#define defun(nm) \
    void nm(Array res, Array lft, Array rgt, \
        OpArg lfto, OpArg rgto, Array env[])
#define call(tgt, nm, lft, rgt) \
    (nm->fn)(tgt, lft, rgt, nm->lft, nm->rgt, nm->env)

void mfnp(Function *, FnPtr, int);
void mopp(Function *, Function, Function, Function);

/*******************************
 * Core functions and operators 
 *******************************/

void set(Array, Array);          /* X←Y */
void iset(Array, Array, Array);  /* (I⌷X)←Y */
void saset(Array, Array, Array); /* (I⌷X)↤Y */

/* Operators */
void axis(Array, Function, Array, Array, Array);
void eachm(Array, Function, Array);
void eachd(Array, Function, Array, Array);
void outp(Array, Function, Array, Array);
void redm(Array, Function, Array);
void redd(Array, Function, Array, Array);

/* Functions */
#define monadic(fn) void fn(Array, Array)
#define dyadic(fn) void fn(Array, Array, Array)

monadic(rev);     dyadic(rot);     /* ⌽ */
monadic(rev1);    dyadic(rot1);    /* ⊖ */
monadic(rav);     dyadic(cat);     /* , */
monadic(eqm);     dyadic(eqd);     /* = */
monadic(andm);    dyadic(andd);    /* ∧ */
monadic(orm);     dyadic(ord);     /* ∨ */
                  dyadic(drop);    /* ↓ */
                  dyadic(take);    /* ↑ */
monadic(neg);     dyadic(minus);   /* - */
monadic(shape);   dyadic(reshape); /* ⍴ */
monadic(floor);   dyadic(min);     /* ⌊ */
monadic(ceil);    dyadic(max);     /* ⌈ */
monadic(conj);    dyadic(plus);    /* + */
monadic(iota);    dyadic(find);    /* ⍳ */
monadic(abs);     dyadic(mod);     /* | */
monadic(recp);    dyadic(div);     /* ÷ */
                  dyadic(idx);     /* ⌷ */
monadic(encl);                     /* ⊂ */
monadic(disc);                     /* ⊃ */
