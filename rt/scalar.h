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

#define scalar_fnm(mon, typ, rest, rgtt) \
{ \
	int code; \
	uint64_t i; \
	rest *res_elems; \
	rgtt *right_elems; \
\
	/* print_shape(rgt);\
	printf(" rgt: %ld", rgt->size);*/\
 \
	right_elems = rgt->elements; \
\
	if ((code = prepare_res((void **)&res_elems, res, rgt))) return code; \
\
	for (i = 0; i < res->size; i++) { \
		code = mon(res_elems++, right_elems++); \
		if (code) return code; \
	} \
\
	res->type = typ; \
	/*printf(" res: %ld\n", res->size);*/\
\
	return 0; \
}

#define scalar_fnd(dya, typ, rest, lftt, rgtt) \
{ \
	int code; \
	uint64_t i; \
	rest *res_elems; \
\
	/* print_shape(lft);\
	print_shape(rgt);\
	printf(" lft: %ld rgt: %ld", lft->size, rgt->size); */ \
 \
	/* Dyadic case */ \
	if (same_shape(lft, rgt)) { \
		if ((code = prepare_res((void **)&res_elems, res, lft))) return code; \
 \
		lftt *left_elems = lft->elements; \
		rgtt *right_elems = rgt->elements; \
\
		for (i = 0; i < res->size; i++) { \
			code = dya(res_elems++, left_elems++, right_elems++); \
			if (code) return code; \
		} \
	} else if (scalar(lft)) { \
		if ((code = prepare_res((void **)&res_elems, res, rgt))) return code; \
 \
		lftt left_elems = *((lftt *)lft->elements); \
		rgtt *right_elems = rgt->elements; \
\
		for (i = 0; i < res->size; i++) { \
			code = dya(res_elems++, &left_elems, right_elems++); \
			if (code) return code; \
		} \
	} else if (scalar(rgt)) { \
		if ((code = prepare_res((void **)&res_elems, res, lft))) return code; \
 \
		lftt *left_elems = lft->elements; \
		rgtt right_elems = *((rgtt *)rgt->elements); \
\
		for (i = 0; i < res->size; i++) { \
			code = dya(res_elems++, left_elems++, &right_elems); \
			if (code) return code; \
		} \
	} \
\
	res->type = typ; \
\
	/* printf(" res: %ld\n", res->size); */\
 \
	return 0; \
}

#define scalar_dispatch(df, dt, dzt, drt, ifn, it, izt, irt, ddf, ddt, ddzt, ddlt, ddrt, dif, dit, dizt, dilt, dirt, idf, idt, idzt, idlt, idrt, iif, iit, iizt, iilt, iirt) \
if (lft == NULL) { \
	if (rgt->type == 3) \
		scalar_fnm(df, dt, dzt, drt) \
	else \
		scalar_fnm(ifn, it, izt, irt) \
} else if (lft->type == 3) { \
	if (rgt->type == 3) \
		scalar_fnd(ddf, ddt, ddzt, ddlt, ddrt) \
	else \
		scalar_fnd(dif, dit, dizt, dilt, dirt) \
} else { \
	if (rgt->type == 3) \
		scalar_fnd(idf, idt, idzt, idlt, idrt) \
	else \
		scalar_fnd(iif, iit, iizt, iilt, iirt) \
}

int
same_shape(struct codfns_array *, struct codfns_array *);

int
copy_shape(struct codfns_array *, struct codfns_array *);

int
scale_elements(struct codfns_array *, uint64_t);

int
prepare_res(void **, struct codfns_array *, struct codfns_array *);

void print_shape(struct codfns_array *);

