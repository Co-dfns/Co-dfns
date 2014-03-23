#include <stdlib.h>
#include <error.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "codfns.h"

/* ffi_get_size()
 *
 * Intended Function: Return the size field of the array.
 */

uint64_t
ffi_get_size(struct codfns_array *arr)
{
	return arr->size;
}

/* ffi_get_rank()
 *
 * Intended Function: Return the rank field of the array.
 */

uint16_t
ffi_get_rank(struct codfns_array *arr)
{
	return arr->rank;
}

/* ffi_get_data_int()
 *
 * Intended Function: Fill the given result buffer with the data
 * elements of the array interpreted as integers, assuming enough
 * space in the buffer for the values.
 */

void
ffi_get_data_int(int64_t *res, struct codfns_array *arr)
{
	memcpy(res, arr->elements, sizeof(int64_t) * arr->size);

	return;
}

/* ffi_get_shape()
 *
 * Intended Function: Fill the result buffer with the shape of the
 * given array, assuming enough space in the result buffer.
 */

void
ffi_get_shape(uint32_t *res, struct codfns_array *arr)
{
	memcpy(res, arr->shape, sizeof(uint32_t) * arr->rank);

	return;
}

/* ffi_make_array()
 *
 * Intended Function: Given the fields of an array, create a fresh
 * array which does not rely on any of the pointers or memory regions
 * given in the arguments. Store this fresh array in the pointer cell
 * provided.
 */

int
ffi_make_array(struct codfns_array **res,
    uint16_t rnk, uint64_t sz, uint32_t *shp, int64_t *dat)
{
	struct codfns_array *arr;

	arr = malloc(sizeof(struct codfns_array));

	if (arr == NULL) {
		perror("ffi_make_array");
		return 1;
	}

	if (sz == 0) {
		arr->elements = NULL;
	} else {
		arr->elements = calloc(sz, sizeof(int64_t));
		if (arr->elements == NULL) {
			perror("ffi_make_array");
			return 2;
		}
	}

	if (rnk == 0) {
		arr->shape = NULL;
	} else {
		arr->shape = calloc(rnk, sizeof(uint32_t));
		if (arr->shape == NULL) {
			perror("ffi_make_array");
			return 3;
		}
	}

	arr->rank = rnk;
	arr->size = sz;

	memcpy(arr->shape, shp, sizeof(uint32_t) * rnk);
	memcpy(arr->elements, dat, sizeof(int64_t) * sz);

	*res = arr;

	return 0;
}

/* array_free()
 *
 * Intended Function: Free the contents of an array without freeing
 * the pointer to the array header itself. The array should be reset
 * to a completely empty and consistent state that references no additional
 * memory besides that allocated for the header/structure itself.
 */

void
array_free(struct codfns_array *arr)
{
	free(arr->elements);
	free(arr->shape);
	arr->size = 0;
	arr->rank = 0;
	arr->shape = NULL;
	arr->elements = NULL;

	return;
}

/* array_cp()
 *
 * Intended Function: Copy the contents of one array to the other.
 */

int
array_cp(struct codfns_array *tgt, struct codfns_array *src)
{
	uint32_t *shp;
	int64_t *dat;

	if (tgt == src) return 0;

	shp = tgt->shape;
	dat = tgt->elements;

	if (src->rank > tgt->rank) {
		shp = realloc(shp, sizeof(uint32_t) * src->rank);
		if (shp == NULL) {
			perror("array_cp");
			return 1;
		}
	}

	if (src->size > tgt->size) {
		dat = realloc(dat, sizeof(int64_t) * src->size);
		if (dat == NULL) {
			perror("array_cp");
			return 2;
		}
	}

	memcpy(shp, src->shape, sizeof(uint32_t) * src->rank);
	memcpy(dat, src->elements, sizeof(int64_t) * src->size);

	tgt->rank = src->rank;
	tgt->size = src->size;
	tgt->shape = shp;
	tgt->elements = dat;

	return 0;
}

/* clean_env()
 *
 * Intended Function: Given an environment pointer and its size, free
 * the arrays in that environment.
 */

void
clean_env(struct codfns_array *env, int count)
{
	int i;
	struct codfns_array *cur;

	for (i = 0, cur = env; i < count; i++)
		array_free(cur++);

	return;
}

/* scalar()
 *
 * Intended Function: Predicate that returns 1 when the rank is zero,
 * and zero otherwise.
 */

#define scalar(x) ((x)->rank == 0)

/* same_shape()
 *
 * Intended Function: Predicate that returns 1 when the two arrays have the
 * same shape, and zero otherwise.
 */

int static inline
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

int static inline
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

	memcpy(buf, src->shape, sizeof(uint32_t) * tgt->rank);

	tgt->rank = src->rank;
	tgt->shape = buf;

	return 0;
}

/* scale_elements()
 *
 * Intended Function: Given a size, ensure that the element buffer of an
 * array can handle that size of elements, and set the size field
 * appropriately.
 */

int static inline
scale_elements(struct codfns_array *arr, uint64_t size)
{
	int64_t *buf;

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
int static inline
prepare_res(int64_t **buf, struct codfns_array *res,
    struct codfns_array *pat)
{
	if (scale_elements(res, pat->size))
		return 99;

	if (copy_shape(res, pat))
		return 99;

	*buf = res->elements;

	return 0;
}

/* scalar_fn()
 *
 * Intended Function: Given a monadic and dyadic scalar functions,
 * a result, left, and right argument, compute the scalar APL function
 * defined by the given monadic and dyadic functions.
 */

int static inline
scalar_fn(int (*mon)(int64_t *, int64_t *),
    int (*dya)(int64_t *, int64_t *, int64_t *),
    struct codfns_array *res,
    struct codfns_array *lft,
    struct codfns_array *rgt)
{
	int i, code;
	int64_t *left_elems, *right_elems, *res_elems;

	right_elems = rgt->elements;

	/* Monadic case */
	if (lft == NULL) {
		if ((code = prepare_res(&res_elems, res, rgt))) return code;

		for (i = 0; i < res->size; i++) {
			code = mon(res_elems++, right_elems++);
			if (code) return code;
		}

		return 0;
	}

	left_elems = lft->elements;

	/* Dyadic case */
	if (same_shape(lft, rgt)) {
		if ((code = prepare_res(&res_elems, res, lft))) return code;

		for (i = 0; i < res->size; i++) {
			code = dya(res_elems++, left_elems++, right_elems++);
			if (code) return code;
		}
	} else if (scalar(lft)) {
		if ((code = prepare_res(&res_elems, res, rgt))) return code;

		for (i = 0; i < res->size; i++) {
			code = dya(res_elems++, left_elems, right_elems++);
			if (code) return code;
		}
	} else if (scalar(rgt)) {
		if ((code = prepare_res(&res_elems, res, lft))) return code;

		for (i = 0; i < res->size; i++) {
			code = dya(res_elems++, left_elems++, right_elems);
			if (code) return code;
		}
	}

	return 0;
}

/* codfns_add()
 *
 * Intended Function: Compute the + APL primitive, both monadic and dyadic
 * cases.
 */

int inline
identity(int64_t *tgt, int64_t *rgt)
{
	*tgt = *rgt;
	return 0;
}

int inline
add_int(int64_t *tgt, int64_t *lft, int64_t *rgt)
{
	*tgt = *lft + *rgt;
	return 0;
}

int
codfns_add(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	return scalar_fn(identity, add_int, res, lft, rgt);
}

/* codfns_subtract()
 *
 * Intended Function: Implement the primitive APL - function.
 */

int inline
negate_int(int64_t *tgt, int64_t *rgt)
{
	*tgt = -1 * *rgt;
	return 0;
}

int inline
subtract_int(int64_t *tgt, int64_t *lft, int64_t *rgt)
{
	*tgt = *lft - *rgt;
	return 0;
}

int
codfns_subtract(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	return scalar_fn(negate_int, subtract_int, res, lft, rgt);
}


/* codfns_multiply()
 *
 * Intended Function: Compute the APL × function.
 */

int inline
direction_int(int64_t *tgt, int64_t *rgt)
{
	if (*rgt == 0)
		*tgt = 0;
	else if (*rgt < 0)
		*tgt = -1;
	else
		*tgt = 1;

	return 0;
}

int inline
multiply_int(int64_t *tgt, int64_t *lft, int64_t *rgt)
{
	*tgt = *lft * *rgt;
	return 0;
}

int
codfns_multiply(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	return scalar_fn(direction_int, multiply_int, res, lft, rgt);
}

/* codfns_divide()
 *
 * Intended Function: Compute the APL ÷ function.
 */

int inline
reciprocal_int(int64_t *tgt, int64_t *rgt)
{
	if (*rgt == 0) {
		fprintf(stderr, "DOMAIN ERROR: Divide by zero\n");
		return 11;
	}

	*tgt = 1 / *rgt;

	return 0;
}

int inline
divide_int(int64_t *tgt, int64_t *lft, int64_t *rgt)
{
	if (*rgt == 0) {
		fprintf(stderr, "DOMAIN ERROR: Divide by zero\n");
		return 11;
	}

	*tgt = *lft / *rgt;

	return 0;
}

int
codfns_divide(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	return scalar_fn(reciprocal_int, divide_int, res, lft, rgt);
}

/* codfns_magnitude()
 *
 * Intended Function: Compute the APL | function.
 */

int inline
magnitude_int(int64_t *tgt, int64_t *rgt)
{
	*tgt = llabs(*rgt);

	return 0;
}

int inline
residue_int(int64_t *tgt, int64_t *lft, int64_t *rgt)
{
	*tgt = *lft % *rgt;

	return 0;
}

int
codfns_residue(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	return scalar_fn(magnitude_int, residue_int, res, lft, rgt);
}

/* codfns_power()
 *
 * Intended Function: Compute the APL * function.
 */

int inline
exp_int(int64_t *tgt, int64_t *rgt)
{
	*tgt = exp(*rgt);
	return 0;
}

int inline
pow_int(int64_t *tgt, int64_t *lft, int64_t *rgt)
{
	*tgt = pow(*lft, *rgt);
	return 0;
}

int
codfns_power(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	return scalar_fn(exp_int, pow_int, res, lft, rgt);
}

/* codfns_log()
 *
 * Intended Function: Compute the APL ⍟ function.
 */

int inline
log_int(int64_t *tgt, int64_t *rgt)
{
	*tgt = log(*rgt);
	return 0;
}

int inline
logbn_int(int64_t *tgt, int64_t *lft, int64_t *rgt)
{
	*tgt = log(*rgt) / log(*lft);
	return 0;
}

int
codfns_log(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	return scalar_fn(log_int, logbn_int, res, lft, rgt);
}

/* codfns_max()
 *
 * Intended Function: Compute the APL ⌈ function.
 */

int inline
ceiling_int(int64_t *tgt, int64_t *rgt)
{
	*tgt = ceil(*rgt);
	return 0;
}

int inline
max_int(int64_t *tgt, int64_t *lft, int64_t *rgt)
{
	*tgt = (*lft >= *rgt ? *lft : *rgt);
	return 0;
}

int
codfns_max(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	return scalar_fn(ceiling_int, max_int, res, lft, rgt);
}

/* codfns_min()
 *
 * Intended Function: Compute the APL ⌊ function.
 */

int inline
floor_int(int64_t *tgt, int64_t *rgt)
{
	*tgt = floor(*rgt);
	return 0;
}

int inline
min_int(int64_t *tgt, int64_t *lft, int64_t *rgt)
{
	*tgt = (*lft <= *rgt ? *lft : *rgt);
	return 0;
}

int
codfns_min(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	return scalar_fn(floor_int, min_int, res, lft, rgt);
}

/* codfns_less()
 *
 * Intended Function: Compute the APL < function.
 */

int inline
less_int(int64_t *tgt, int64_t *lft, int64_t *rgt)
{
	*tgt = (*lft < *rgt);
	return 0;
}

int
codfns_less(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)  /* Add OCT argument */
{
	if (lft == NULL) {
		fprintf(stderr, "SYNTAX ERROR");
		return 2;
	}

	return scalar_fn(identity, less_int, res, lft, rgt);
}

/* codfns_less_or_equal()
 *
 * Intended Function: Compute the APL ≤ function.
 */

int inline
less_or_equal_int(int64_t *tgt, int64_t *lft, int64_t *rgt)
{
	*tgt = (*lft <= *rgt);
	return 0;
}

int
codfns_less_or_equal(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)  /* Add OCT argument */
{
	if (lft == NULL) {
		fprintf(stderr, "SYNTAX ERROR");
		return 2;
	}

	return scalar_fn(identity, less_or_equal_int, res, lft, rgt);
}

/* codfns_equal()
 *
 * Intended Function: Compute the APL = function.
 */

int inline
equal_int(int64_t *tgt, int64_t *lft, int64_t *rgt)
{
	*tgt = (*lft == *rgt);
	return 0;
}

int
codfns_equal(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)  /* Add OCT argument */
{
	if (lft == NULL) {
		fprintf(stderr, "SYNTAX ERROR");
		return 2;
	}

	return scalar_fn(identity, equal_int, res, lft, rgt);
}

/* codfns_not_equal()
 *
 * Intended Function: Compute the APL ≠ function.
 */

int inline
not_equal_int(int64_t *tgt, int64_t *lft, int64_t *rgt)
{
	*tgt = (*lft != *rgt);
	return 0;
}

int
codfns_not_equal(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)  /* Add OCT argument */
{
	if (lft == NULL) {
		fprintf(stderr, "SYNTAX ERROR");
		return 2;
	}

	return scalar_fn(identity, not_equal_int, res, lft, rgt);
}


/* codfns_greater_or_equal()
 *
 * Intended Function: Compute the APL ≥ function.
 */

int inline
greater_or_equal_int(int64_t *tgt, int64_t *lft, int64_t *rgt)
{
	*tgt = (*lft >= *rgt);
	return 0;
}

int
codfns_greater_or_equal(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	if (lft == NULL) {
		fprintf(stderr, "SYNTAX ERROR");
		return 2;
	}

	return scalar_fn(identity, greater_or_equal_int, res, lft, rgt);
}

/* codfns_greater()
 *
 * Intended Function: Compute the APL > function.
 */

int inline
greater_int(int64_t *tgt, int64_t *lft, int64_t *rgt)
{
	*tgt = (*lft > *rgt);
	return 0;
}

int
codfns_greater(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	if (lft == NULL) {
		fprintf(stderr, "SYNTAX ERROR");
		return 2;
	}

	return scalar_fn(identity, greater_int, res, lft, rgt);
}

int
codfns_not(struct codfns_array *ret, struct codfns_array *lft, struct codfns_array *rgt)
{
  int i, k;
  int64_t *res_elems;
  uint32_t *shp;

  /* We return the negation array for the RHS */
  if (lft == NULL) {
    ret->size = rgt->size;
    ret->rank = rgt->rank;
    k = rgt->rank;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(rgt) ? NULL : realloc(ret->shape, rgt->rank);
    memcpy(shp, rgt->shape, ret->rank);
    memcpy(res_elems, rgt->elements, rgt->size);

    for (i = 0; i < k; i++)
        res_elems[i] = !res_elems[i];

    ret->elements = res_elems;
    ret->shape = shp;

    return 0;
  }
  return 1;
}

