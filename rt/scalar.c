#include <stdlib.h>
#include <error.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "codfns.h"
#include "scalar.h"

/* SCALAR APL PRIMITIVES */

/* Monadic + */
scalar_monadic(addm, i, d, 
{
	*tgt = *rgt;
})

/* Dyadic + */
scalar_dyadic(addd, d, d, d, i,
{
	*tgt = *lft + *rgt;
})

/* Monadic ÷ */
scalar_monadic(dividem, d, d,
{
	/* if (*rgt == 0) {
		fprintf(stderr, "DOMAIN ERROR: Divide by zero\n");
		return 11;
	} */

	*tgt = 1.0 / *rgt;
})

/* Dyadic ÷ */
scalar_dyadic(divided, d, d, d, d,
{
	/* if (*rgt == 0) {
		fprintf(stderr, "DOMAIN ERROR: Divide by zero\n");
		return 11;
	} */
	
	*tgt = (1.0 * *lft) / (1.0 * *rgt);
})

/* Dyadic = */
scalar_dyadic(equald, i, i, i, i,
{
	*tgt = (*lft == *rgt);
})

/* Dyadic ≥ */
scalar_dyadic(greateqd, i, i, i, i,
{
	*tgt = (*lft >= *rgt);
})

/* Dyadic > */
scalar_dyadic(greaterd, i, i, i, i,
{
	*tgt = (*lft > *rgt);
})

/* Dyadic ≤ */
scalar_dyadic(lesseqd, i, i, i, i,
{
	*tgt = (*lft <= *rgt);
})

/* Dyadic < */
scalar_dyadic(lessd, i, i, i, i,
{
	*tgt = (*lft < *rgt);
})

/* Monadic ⍟ */
scalar_monadic(logm, d, d,
{
	*tgt = log(*rgt);
})

/* Dyadic ⍟ */
scalar_dyadic(logd, d, d, d, d,
{
	*tgt = log(*rgt) / log(*lft);
})

/* Monadic | */
scalar_monadic(residuem, d, i,
{
	if (*rgt < 0) {
		*tgt = -1 * *rgt;
	} else {
		*tgt = *rgt;
	}

	return 0;
})

/* Dyadic | */
#define RESIDUEI *tgt = *lft % *rgt;
#define RESIDUED { \
	double res; \
	res = *rgt / *lft; \
	res = floor(res); \
	*tgt = *rgt - res * *lft; \
	return 0; \
}

scalar_dyadic_inner(residued, d, d, d, RESIDUED)
scalar_dyadic_inner(residued, d, d, i, RESIDUED)
scalar_dyadic_inner(residued, d, i, d, RESIDUED)
scalar_dyadic_inner(residued, i, i, i, RESIDUEI)
scalar_dyadic_scalar(residued, d, d, d, RESIDUED)
scalar_dyadic_scalar(residued, d, d, i, RESIDUED)
scalar_dyadic_scalar(residued, d, i, d, RESIDUED)
scalar_dyadic_scalar(residued, i, i, i, RESIDUEI)
scalar_dyadic_main(residued, d, d, d, i)

/* Monadic ⌈ */
scalar_monadic(maxm, d, i,
{
	*tgt = ceil(*rgt);
})

/* Dyadic ⌈ */
scalar_dyadic(maxd, d, d, d, i,
{
	*tgt = (*lft >= *rgt ? *lft : *rgt);
})

/* Monadic ⌊ */
scalar_monadic(minm, d, i,
{
	*tgt = floor(*rgt);
})

/* Dyadic ⌊ */
scalar_dyadic(mind, d, d, d, i,
{
	*tgt = (*lft <= *rgt ? *lft : *rgt);
})

/* Monadic × */
scalar_monadic(multiplym, d, i,
{
	if (*rgt == 0) *tgt = 0;
	else if (*rgt < 0) *tgt = -1;
	else *tgt = 1;

	return 0;
})

/* Dyadic × */
scalar_dyadic(multiplyd, d, d, d, i,
{
	*tgt = *lft * *rgt;
})

/* Dyadic ≠ */
scalar_dyadic(neqd, i, i, i, i,
{
	*tgt = (*lft != *rgt);
})

/* Monadic ~ */
scalar_monadic(notm, i, i,
{
	if (*rgt == 1) {
		*tgt = 0;
	} else if (*rgt == 0) {
		*tgt = 1;
	} else {
		fprintf(stderr, "DOMAIN ERROR\n");
		return 11;
	}

	return 0;
})

/* Monadic * */
scalar_monadic(powerm, d, i,
{
	*tgt = exp(*rgt);
})

/* Dyadic * */
scalar_dyadic(powerd, d, d, d, i,
{
	*tgt = pow(*lft, *rgt);
})

/* Monadic - */
scalar_monadic(subtractm, d, i,
{
	*tgt = -1 * *rgt;
})

/* Dyadic - */
scalar_dyadic(subtractd, d, d, d, i,
{
	*tgt = *lft - *rgt;
})


/* SCALAR HELPER FUNCTION */

/* same_shape()
 *
 * Intended Function: Predicate that returns 1 when the two arrays have the
 * same shape, and zero otherwise.
 */

int 
same_shape(struct codfns_array *lft, struct codfns_array *rgt)
{
	int i, k;
	uint32_t *rshape, *lshape;

	if (lft->rank != rgt->rank)
		return 0;

	k = rgt->rank;
	lshape = lft->shape;
	rshape = rgt->shape;

	for (i = 0; i < k; i++)
		if (*lshape++ != *rshape++)
			return 0;

	return 1;
}

/* copy_shape()
 *
 * Intended Function: Take the shape of the source array and copy it to the
 * target array.
 */

int 
copy_shape(struct codfns_array *tgt, struct codfns_array *src)
{
	uint32_t *buf;

	buf = tgt->shape;

	if (src->rank > tgt->rank) {
		buf = realloc(buf, sizeof(uint32_t) * src->rank);
		if (buf == NULL) {
			perror("copy_shape");
			return 1;
		}
	}

	tgt->rank = src->rank;
	tgt->shape = buf;
	memcpy(buf, src->shape, sizeof(uint32_t) * tgt->rank);

	return 0;
}

/* scale_elements()
 *
 * Intended Function: Given a size, ensure that the element buffer of an
 * array can handle that size of elements, and set the size field
 * appropriately.
 */

int 
scale_elements(struct codfns_array *arr, uint64_t size)
{
	void *buf;

	buf = arr->elements;

	if (size > arr->size) {
		buf = realloc(buf, sizeof(int64_t) * size);
		if (buf == NULL) {
			perror("scale_elements");
			return 1;
		}
	}

	arr->size = size;
	arr->elements = buf;

	return 0;
}

/* prepare_res()
 *
 * Intended Function: Prepare a result array and buffer for scalar function
 * iteration.
 */
int 
prepare_res(void **buf, struct codfns_array *res,
    struct codfns_array *pat)
{
	if (scale_elements(res, pat->size))
		return 99;

	if (copy_shape(res, pat))
		return 99;

	*buf = res->elements;

	return 0;
}

void print_shape(struct codfns_array *arr)
{
	int i;
	
	printf("Shape: ");
	
	for (i = 0; i < arr->rank; i++)
		printf("%"PRIu32" ", arr->shape[i]);
}

