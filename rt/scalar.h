#pragma once

#include <stdlib.h>
#include <error.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "codfns.h"

/* scalar()
 *
 * Intended Function: Predicate that returns 1 when the rank is zero,
 * and zero otherwise.
 */

#define scalar(x) ((x)->rank == 0)

/* scalar_fnm()
 * 
 * The inner loop of a monadic scalar function.
 */

#define scalar_fnm(mon, rest, rgtt) \
{ \
	int code; \
	uint64_t i; \
	type_##rest *res_elems; \
	type_##rgtt *right_elems; \
\
\
	right_elems = rgt->elements; \
\
	if ((code = prepare_res((void **)&res_elems, res, rgt))) return code; \
\
	for (i = 0; i < res->size; i++) { \
		code = mon##_##rgtt(res_elems++, right_elems++); \
		if (code) return code; \
	} \
\
	res->type = apl_type_##rest; \
	/*printf(" res: %ld\n", res->size);*/\
\
	return 0; \
}

/* scalar_fnd()
 *
 * The inner loop of a scalar dyadic function for specific types.
 */

#define scalar_fnd(dya, rest, lftt, rgtt) \
{ \
	int code; \
	uint64_t i; \
	type_##rest *res_elems; \
\
	/* Dyadic case */ \
	if (same_shape(lft, rgt)) { \
		if ((code = prepare_res((void **)&res_elems, res, lft))) return code; \
\
		type_##lftt *left_elems = lft->elements; \
		type_##rgtt *right_elems = rgt->elements; \
\
		for (i = 0; i < res->size; i++) { \
			code = dya##_##lftt##rgtt(res_elems++, \
			    left_elems++, right_elems++); \
			if (code) return code; \
		} \
	} else if (scalar(lft)) { \
		if ((code = prepare_res((void **)&res_elems, res, rgt))) return code; \
\
		type_##lftt left_elems = *((type_##lftt *)lft->elements); \
		type_##rgtt *right_elems = rgt->elements; \
\
		for (i = 0; i < res->size; i++) { \
			code = dya##_##lftt##rgtt(res_elems++, \
			    &left_elems, right_elems++); \
			if (code) return code; \
		} \
	} else if (scalar(rgt)) { \
		if ((code = prepare_res((void **)&res_elems, res, lft))) return code; \
\
		type_##lftt *left_elems = lft->elements; \
		type_##rgtt right_elems = *((type_##rgtt *)rgt->elements); \
\
		for (i = 0; i < res->size; i++) { \
			code = dya##_##lftt##rgtt(res_elems++, \
			    left_elems++, &right_elems); \
			if (code) return code; \
		} \
	} \
\
	res->type = apl_type_##rest; \
\
	return 0; \
}

/* scalar_monadic_dispatch()
 *
 * The body of a top-level scalar monadic function.
 */

#define scalar_monadic_dispatch(fn, dzt, izt) \
if (rgt->type == apl_type_d) \
	scalar_fnm(fn, dzt, d) \
else \
	scalar_fnm(fn, izt, i)

/* scalar_dyadic_dispatch()
 *
 * The body of a top-level scalar dyadic function.
 */

#define scalar_dyadic_dispatch(fn, ddzt, dizt, idzt, iizt) \
if (lft->type == apl_type_d) {\
	if (rgt->type == apl_type_d) \
		scalar_fnd(fn, ddzt, d, d) \
	else \
		scalar_fnd(fn, dizt, d, i) \
} else { \
	if (rgt->type == apl_type_d) \
		scalar_fnd(fn, idzt, i, d) \
	else \
		scalar_fnd(fn, iizt, i, i) \
}

/* scalar_dyadic_inner()
 *
 * The function definition of the inner loop calculation used in the body of a 
 * dyadic scalar function.
 */

#define scalar_dyadic_inner(nm, zt, lt, rt, code) \
int inline static \
nm##_##lt##rt(type_##zt *tgt, type_##lt *lft, type_##rt *rgt) \
{ \
	code \
	return 0; \
}

/* scalar_monadic_inner()
 *
 * The function definition of the calculation inside the loop of 
 * a monadic scalar function.
 */

#define scalar_monadic_inner(nm, zt, rt, code) \
int inline static \
nm##_##rt(type_##zt *tgt, type_##rt *rgt) \
{ \
	code \
	return 0; \
}

/* scalar_monadic_main()
 *
 * The function definition of a scalar monadic primitive.
 */

#define scalar_monadic_main(nm, dt, it) \
int \
codfns_##nm(struct codfns_array *res, \
    struct codfns_array *lft, struct codfns_array *rgt) \
{ \
	scalar_monadic_dispatch(nm, dt, it) \
}

/* scalar_dyadic_main()
 * 
 * The function definition of a scalar dyadic primitive.
 */

#define scalar_dyadic_main(nm, ddt, dit, idt, iit) \
int \
codfns_##nm(struct codfns_array *res, \
    struct codfns_array *lft, struct codfns_array *rgt) \
{ \
	scalar_dyadic_dispatch(nm, ddt, dit, idt, iit) \
}

/* scalar_monadic()
 *
 * The definition of a scalar monadic function.
 */

#define scalar_monadic(nm, dt, it, code) \
scalar_monadic_inner(nm, dt, d, code) \
scalar_monadic_inner(nm, it, i, code) \
scalar_monadic_main(nm, dt, it)

/* scalar_dyadic()
 *
 * The definition of a scalar dyadic function.
 */

#define scalar_dyadic(nm, ddt, dit, idt, iit, code) \
scalar_dyadic_inner(nm, ddt, d, d, code) \
scalar_dyadic_inner(nm, dit, d, i, code) \
scalar_dyadic_inner(nm, idt, i, d, code) \
scalar_dyadic_inner(nm, iit, i, i, code) \
scalar_dyadic_main(nm, ddt, dit, idt, iit)

int
same_shape(struct codfns_array *, struct codfns_array *);

int
copy_shape(struct codfns_array *, struct codfns_array *);

int
scale_elements(struct codfns_array *, uint64_t);

int
prepare_res(void **, struct codfns_array *, struct codfns_array *);

void print_shape(struct codfns_array *);

