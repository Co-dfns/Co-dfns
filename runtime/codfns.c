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
	void *dat;

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
	tgt->type = src->type;

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
int static inline
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

#define scalar_fnm(mon, typ, rest, rgtt) \
{ \
	int code; \
	uint64_t i; \
	rest *res_elems; \
	rgtt *right_elems; \
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
\
	return 0; \
}
	

#define scalar_fnd(dya, typ, rest, lftt, rgtt) \
{ \
	int code; \
	uint64_t i; \
	rest *res_elems; \
	lftt *left_elems; \
	rgtt *right_elems; \
 \
	right_elems = rgt->elements; \
	left_elems = lft->elements; \
 \
	/* Dyadic case */ \
	if (same_shape(lft, rgt)) { \
		if ((code = prepare_res((void **)&res_elems, res, lft))) return code; \
 \
		for (i = 0; i < res->size; i++) { \
			code = dya(res_elems++, left_elems++, right_elems++); \
			if (code) return code; \
		} \
	} else if (scalar(lft)) { \
		if ((code = prepare_res((void **)&res_elems, res, rgt))) return code; \
 \
		for (i = 0; i < res->size; i++) { \
			code = dya(res_elems++, left_elems, right_elems++); \
			if (code) return code; \
		} \
	} else if (scalar(rgt)) { \
		if ((code = prepare_res((void **)&res_elems, res, lft))) return code; \
 \
		for (i = 0; i < res->size; i++) { \
			code = dya(res_elems++, left_elems++, right_elems); \
			if (code) return code; \
		} \
	} \
\
	res->type = typ; \
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


/* codfns_add()
 *
 * Intended Function: Compute the + APL primitive, both monadic and dyadic
 * cases.
 */

#define identity(nm, tgtt, rgtt) \
int inline static \
nm(tgtt *tgt, rgtt *rgt) \
{ \
	*tgt = *rgt; \
	return 0; \
}

identity(identity_i, int64_t, int64_t)
identity(identity_d, double, double)

#define add(nm, zt, lt, rt) \
int inline static \
nm(zt *tgt, lt *lft, rt *rgt) \
{ \
	*tgt = *lft + *rgt; \
	return 0; \
}

add(add_ii, int64_t, int64_t, int64_t)
add(add_id, double, int64_t, double)
add(add_di, double, double, int64_t)
add(add_dd, double, double, double)

int
codfns_add(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	scalar_dispatch(
	    identity_d, 3, double, double,
	    identity_i, 2, int64_t, int64_t,
	    add_dd, 3, double, double, double,
	    add_di, 3, double, double, int64_t,
	    add_id, 3, double, int64_t, double,
	    add_ii, 2, int64_t, int64_t, int64_t)
}

/* codfns_subtract()
 *
 * Intended Function: Implement the primitive APL - function.
 */

#define negate(nm, zt, rt) \
int inline static \
nm(zt *tgt, rt *rgt) \
{ \
	*tgt = -1 * *rgt; \
	return 0; \
}

negate(negate_i, int64_t, int64_t)
negate(negate_d, double, double)

#define subtract(nm, zt, lt, rt) \
int inline static \
nm(zt *tgt, lt *lft, rt *rgt) \
{ \
	*tgt = *lft - *rgt; \
	return 0; \
}

subtract(subtract_ii, int64_t, int64_t, int64_t)
subtract(subtract_id, double, int64_t, double)
subtract(subtract_di, double, double, int64_t)
subtract(subtract_dd, double, double, double)

int
codfns_subtract(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	scalar_dispatch(
	    negate_d, 3, double, double,
	    negate_i, 2, int64_t, int64_t,
	    subtract_dd, 3, double, double, double,
	    subtract_di, 3, double, double, int64_t,
	    subtract_id, 3, double, int64_t, double,
	    subtract_ii, 2, int64_t, int64_t, int64_t)
}


/* codfns_multiply()
 *
 * Intended Function: Compute the APL × function.
 */

#define direction(nm, rt) \
int inline static \
nm(int64_t *tgt, rt *rgt) \
{ \
	if (*rgt == 0) \
		*tgt = 0; \
	else if (*rgt < 0) \
		*tgt = -1; \
	else \
		*tgt = 1; \
 \
	return 0; \
}

direction(direction_i, int64_t)
direction(direction_d, double)

#define multiply(nm, zt, lt, rt) \
int inline static \
nm(zt *tgt, lt *lft, rt *rgt) \
{ \
	*tgt = *lft * *rgt; \
	return 0; \
}

multiply(multiply_ii, int64_t, int64_t, int64_t)
multiply(multiply_id, double, int64_t, double)
multiply(multiply_di, double, double, int64_t)
multiply(multiply_dd, double, double, double)

int
codfns_multiply(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	scalar_dispatch(
	    direction_d, 2, int64_t, double,
	    direction_i, 2, int64_t, int64_t,
	    multiply_dd, 3, double, double, double,
	    multiply_di, 3, double, double, int64_t,
	    multiply_id, 3, double, int64_t, double,
	    multiply_ii, 2, int64_t, int64_t, int64_t)
}

/* codfns_divide()
 *
 * Intended Function: Compute the APL ÷ function.
 */

#define reciprocal(nm, rt) \
int inline static \
nm(double *tgt, rt *rgt) \
{ \
	if (*rgt == 0) { \
		fprintf(stderr, "DOMAIN ERROR: Divide by zero\n"); \
		return 11; \
	} \
 \
	*tgt = 1.0 / *rgt; \
 \
	return 0; \
}

reciprocal(reciprocal_i, int64_t)
reciprocal(reciprocal_d, double)

#define divide(nm, lt, rt) \
int inline static \
nm(double *tgt, lt *lft, rt *rgt) \
{ \
	if (*rgt == 0) { \
		fprintf(stderr, "DOMAIN ERROR: Divide by zero\n"); \
		return 11; \
	} \
 \
	*tgt = *lft / 1.0 * *rgt; \
 \
	return 0; \
}

divide(divide_ii, int64_t, int64_t)
divide(divide_id, int64_t, double)
divide(divide_di, double, int64_t)
divide(divide_dd, double, double)

int
codfns_divide(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	scalar_dispatch(
	    reciprocal_d, 3, double, double,
	    reciprocal_i, 3, double, int64_t,
	    divide_dd, 3, double, double, double,
	    divide_di, 3, double, double, int64_t,
	    divide_id, 3, double, int64_t, double,
	    divide_ii, 3, double, int64_t, int64_t)
}

/* codfns_magnitude()
 *
 * Intended Function: Compute the APL | function.
 */

#define magnitude(nm, zt, rt) \
int inline static \
nm(zt *tgt, rt *rgt) \
{ \
	*tgt = llabs(*rgt); \
 \
	return 0; \
}

magnitude(magnitude_i, int64_t, int64_t)
magnitude(magnitude_d, double, double)

int inline static
residue_ii(int64_t *tgt, int64_t *lft, int64_t *rgt)
{
	*tgt = *lft % *rgt;
	return 0;
}

#define residue(nm, zt, lt, rt) \
int inline static \
nm(zt *tgt, lt *lft, rt *rgt) \
{ \
	double res; \
\
	res = *rgt / *lft; \
	res = floor(res); \
	*tgt = *rgt - res * *lft; \
	return 0; \
}

residue(residue_id, double, int64_t, double)
residue(residue_di, double, double, int64_t)
residue(residue_dd, double, double, double)

int
codfns_residue(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	scalar_dispatch(
	    magnitude_d, 3, double, double,
	    magnitude_i, 2, int64_t, int64_t,
	    residue_dd, 3, double, double, double,
	    residue_di, 3, double, double, int64_t,
	    residue_id, 3, double, int64_t, double,
	    residue_ii, 2, int64_t, int64_t, int64_t)
}

/* codfns_power()
 *
 * Intended Function: Compute the APL * function.
 */

#define expapl(nm, zt, rt) \
int inline static \
nm(zt *tgt, rt *rgt) \
{ \
	*tgt = exp(*rgt); \
	return 0; \
}

expapl(exp_i, int64_t, int64_t)
expapl(exp_d, double, double)

#define powapl(nm, zt, lt, rt) \
int inline static \
nm(zt *tgt, lt *lft, rt *rgt) \
{ \
	*tgt = pow(*lft, *rgt); \
	return 0; \
}

powapl(pow_dd, double, double, double)
powapl(pow_di, double, double, int64_t)
powapl(pow_id, double, int64_t, double)
powapl(pow_ii, int64_t, int64_t, int64_t)

int
codfns_power(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	scalar_dispatch(
	    exp_d, 3, double, double,
	    exp_i, 2, int64_t, int64_t,
	    pow_dd, 3, double, double, double,
	    pow_di, 3, double, double, int64_t,
	    pow_id, 3, double, int64_t, double,
	    pow_ii, 2, int64_t, int64_t, int64_t)
}

/* codfns_log()
 *
 * Intended Function: Compute the APL ⍟ function.
 */

#define logapl(nm, rt) \
int inline static \
nm(double *tgt, rt *rgt) \
{ \
	*tgt = log(*rgt); \
	return 0; \
}

logapl(log_i, int64_t)
logapl(log_d, double)

#define logbn(nm, lt, rt) \
int inline static \
nm(double *tgt, lt *lft, rt *rgt) \
{ \
	*tgt = log(*rgt) / log(*lft); \
	return 0; \
}

logbn(logbn_dd, double, double)
logbn(logbn_di, double, int64_t)
logbn(logbn_id, int64_t, double)
logbn(logbn_ii, int64_t, int64_t)

int
codfns_log(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	scalar_dispatch(
	    log_d, 3, double, double,
	    log_i, 3, double, int64_t,
	    logbn_dd, 3, double, double, double,
	    logbn_di, 3, double, double, int64_t,
	    logbn_id, 3, double, int64_t, double,
	    logbn_ii, 3, double, int64_t, int64_t)
}

/* codfns_max()
 *
 * Intended Function: Compute the APL ⌈ function.
 */

#define ceilapl(nm, zt, rt) \
int inline static \
nm(zt *tgt, rt *rgt) \
{ \
	*tgt = ceil(*rgt); \
	return 0; \
}

ceilapl(ceiling_d, double, double)
ceilapl(ceiling_i, int64_t, int64_t)

#define maxapl(nm, zt, lt, rt) \
int inline static \
nm(zt *tgt, lt *lft, rt *rgt) \
{ \
	*tgt = (*lft >= *rgt ? *lft : *rgt); \
	return 0; \
}

maxapl(max_dd, double, double, double)
maxapl(max_di, double, double, int64_t)
maxapl(max_id, double, int64_t, double)
maxapl(max_ii, int64_t, int64_t, int64_t)

int
codfns_max(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	scalar_dispatch(
	    ceiling_d, 3, double, double,
	    ceiling_i, 2, int64_t, int64_t,
	    max_dd, 3, double, double, double,
	    max_di, 3, double, double, int64_t,
	    max_id, 3, double, int64_t, double,
	    max_ii, 2, int64_t, int64_t, int64_t)
}

/* codfns_min()
 *
 * Intended Function: Compute the APL ⌊ function.
 */

#define floorapl(nm, zt, rt) \
int inline static \
nm(zt *tgt, rt *rgt) \
{ \
	*tgt = floor(*rgt); \
	return 0; \
}

floorapl(floor_d, double, double)
floorapl(floor_i, int64_t, int64_t)

#define minapl(nm, zt, lt, rt) \
int inline static \
nm(zt *tgt, lt *lft, rt *rgt) \
{ \
	*tgt = (*lft <= *rgt ? *lft : *rgt); \
	return 0; \
}

minapl(min_dd, double, double, double)
minapl(min_di, double, double, int64_t)
minapl(min_id, double, int64_t, double)
minapl(min_ii, int64_t, int64_t, int64_t)

int
codfns_min(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	scalar_dispatch(
	    floor_d, 3, double, double,
	    floor_i, 2, int64_t, int64_t,
	    min_dd, 3, double, double, double,
	    min_di, 3, double, double, int64_t,
	    min_id, 3, double, int64_t, double,
	    min_ii, 2, int64_t, int64_t, int64_t)
}

/* codfns_less()
 *
 * Intended Function: Compute the APL < function.
 */

#define less(nm, lt, rt) \
int inline static \
nm(int64_t *tgt, lt *lft, rt *rgt) \
{ \
	*tgt = (*lft < *rgt); \
	return 0; \
}

less(less_dd, double, double)
less(less_di, double, int64_t)
less(less_id, int64_t, double)
less(less_ii, int64_t, int64_t)

int
codfns_less(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)  /* Add OCT argument */
{
	if (lft == NULL) {
		fprintf(stderr, "SYNTAX ERROR");
		return 2;
	}

	scalar_dispatch(
	    identity_d, 3, double, double,
	    identity_i, 2, int64_t, int64_t,
	    less_dd, 2, int64_t, double, double,
	    less_di, 2, int64_t, double, int64_t,
	    less_id, 2, int64_t, int64_t, double,
	    less_ii, 2, int64_t, int64_t, int64_t)
}

/* codfns_less_or_equal()
 *
 * Intended Function: Compute the APL ≤ function.
 */

#define lesseq(nm, lt, rt) \
int inline static \
nm(int64_t *tgt, lt *lft, rt *rgt) \
{ \
	*tgt = (*lft <= *rgt); \
	return 0; \
}

lesseq(lesseq_dd, double, double)
lesseq(lesseq_di, double, int64_t)
lesseq(lesseq_id, int64_t, double)
lesseq(lesseq_ii, int64_t, int64_t)

int
codfns_less_or_equal(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)  /* Add OCT argument */
{
	if (lft == NULL) {
		fprintf(stderr, "SYNTAX ERROR");
		return 2;
	}

	scalar_dispatch(
	    identity_d, 3, double, double,
	    identity_i, 2, int64_t, int64_t,
	    lesseq_dd, 2, int64_t, double, double,
	    lesseq_di, 2, int64_t, double, int64_t,
	    lesseq_id, 2, int64_t, int64_t, double,
	    lesseq_ii, 2, int64_t, int64_t, int64_t)
}

/* codfns_equal()
 *
 * Intended Function: Compute the APL = function.
 */

#define equal(nm, lt, rt) \
int inline static \
nm(int64_t *tgt, lt *lft, rt *rgt) \
{ \
	*tgt = (*lft == *rgt); \
	return 0; \
}

equal(equal_dd, double, double)
equal(equal_di, double, int64_t)
equal(equal_id, int64_t, double)
equal(equal_ii, int64_t, int64_t)

int
codfns_equal(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)  /* Add OCT argument */
{
	if (lft == NULL) {
		fprintf(stderr, "SYNTAX ERROR");
		return 2;
	}

	scalar_dispatch(
	    identity_d, 3, double, double,
	    identity_i, 2, int64_t, int64_t,
	    equal_dd, 2, int64_t, double, double,
	    equal_di, 2, int64_t, double, int64_t,
	    equal_id, 2, int64_t, int64_t, double,
	    equal_ii, 2, int64_t, int64_t, int64_t)
}

/* codfns_not_equal()
 *
 * Intended Function: Compute the APL ≠ function.
 */

#define notequal(nm, lt, rt) \
int inline static \
nm(int64_t *tgt, lt *lft, rt *rgt) \
{ \
	*tgt = (*lft != *rgt); \
	return 0; \
}

notequal(notequal_dd, double, double)
notequal(notequal_di, double, int64_t)
notequal(notequal_id, int64_t, double)
notequal(notequal_ii, int64_t, int64_t)

int
codfns_not_equal(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)  /* Add OCT argument */
{
	if (lft == NULL) {
		fprintf(stderr, "SYNTAX ERROR");
		return 2;
	}


	scalar_dispatch(
	    identity_d, 3, double, double,
	    identity_i, 2, int64_t, int64_t,
	    notequal_dd, 2, int64_t, double, double,
	    notequal_di, 2, int64_t, double, int64_t,
	    notequal_id, 2, int64_t, int64_t, double,
	    notequal_ii, 2, int64_t, int64_t, int64_t)
}


/* codfns_greater_or_equal()
 *
 * Intended Function: Compute the APL ≥ function.
 */

#define greateq(nm, lt, rt) \
int inline static \
nm(int64_t *tgt, lt *lft, rt *rgt) \
{ \
	*tgt = (*lft >= *rgt); \
	return 0; \
}

greateq(greateq_dd, double, double)
greateq(greateq_di, double, int64_t)
greateq(greateq_id, int64_t, double)
greateq(greateq_ii, int64_t, int64_t)

int
codfns_greater_or_equal(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	if (lft == NULL) {
		fprintf(stderr, "SYNTAX ERROR");
		return 2;
	}

	scalar_dispatch(
	    identity_d, 3, double, double,
	    identity_i, 2, int64_t, int64_t,
	    greateq_dd, 2, int64_t, double, double,
	    greateq_di, 2, int64_t, double, int64_t,
	    greateq_id, 2, int64_t, int64_t, double,
	    greateq_ii, 2, int64_t, int64_t, int64_t)
}

/* codfns_greater()
 *
 * Intended Function: Compute the APL > function.
 */

#define great(nm, lt, rt) \
int inline static \
nm(int64_t *tgt, lt *lft, rt *rgt) \
{ \
	*tgt = (*lft > *rgt); \
	return 0; \
}

great(great_dd, double, double)
great(great_di, double, int64_t)
great(great_id, int64_t, double)
great(great_ii, int64_t, int64_t)

int
codfns_greater(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	if (lft == NULL) {
		fprintf(stderr, "SYNTAX ERROR");
		return 2;
	}

	scalar_dispatch(
	    identity_d, 3, double, double,
	    identity_i, 2, int64_t, int64_t,
	    great_dd, 2, int64_t, double, double,
	    great_di, 2, int64_t, double, int64_t,
	    great_id, 2, int64_t, int64_t, double,
	    great_ii, 2, int64_t, int64_t, int64_t)
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

/* The following are not complete implementations of anything and 
 * exist only for the benefit of getting the runtime working quickly.
 */
 
int static inline
scale_shape(struct codfns_array *arr, uint16_t rank)
{
	uint32_t *buf;

	buf = arr->shape;

	if (rank > arr->rank) {
		buf = realloc(buf, sizeof(uint32_t) * rank);
		if (buf == NULL) {
			perror("scale_shape");
			return 1;
		}
	}

	arr->rank = rank;
	arr->shape = buf;

	return 0;
}

int
codfns_indexgen(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	uint32_t i;
	int64_t cnt, *dat;
	
	cnt = *((int64_t *)rgt->elements);
	
	if (scale_shape(res, 1)) {
		perror("codfns_indexgen");
		return 1;
	}
	
	if (scale_elements(res, cnt)) {
		perror("codfns_indexgen");
		return 2;
	}
	
	res->type = 2;
	dat = res->elements;
	
	for (i = 0; i < cnt; i++)
		*dat++ = i;
		
	return 0;
}


int
codfns_squad(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	int row;
	
	if (scale_shape(res, 1)) {
		perror("codfns_squad");
		return 1;
	}
	
	if (scale_elements(res, rgt->shape[1])) {
		perror("codfns_squad");
		return 2;
	}
	
	res->type = rgt->type;
	*res->shape = rgt->shape[1];
	row = *((int64_t *)lft->elements);
	
	if (res->type == 3) {
		double *elems = rgt->elements;
		elems += row * res->size;
		memcpy(res->elements, elems, sizeof(double) * res->size);
	} else {
		int64_t *elems = rgt->elements;
		elems += row * res->size;
		memcpy(res->elements, elems, sizeof(int64_t) * res->size);
	}
	
	return 0;
}

int
codfns_index(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	uint64_t i;
	int64_t *lfte;
	
	if (copy_shape(res, lft)) {
		perror("codfns_index");
		return 1;
	}
	
	if (scale_elements(res, lft->size)) {
		perror("codfns_index");
		return 2;
	}
	
	res->type = rgt->type;
	lfte = lft->elements;
	
	if (res->type == 3) {
		double *rgte = rgt->elements;
		double *rese = res->elements;
		for (i = 0; i < res->size; i++)
			*rese++ = rgte[*lfte++];
	} else {
		int64_t *rgte = rgt->elements;
		int64_t *rese = res->elements;
		for (i = 0; i < res->size; i++)
			*rese++ = rgte[*lfte++];
	}
	
	return 0;
}

int
codfns_reshape(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	uint64_t i, size;
	int64_t *lfte;
	uint32_t *rgts, *ress;
	
	if (lft == NULL) {
		int64_t *rese;
		
		if (scale_shape(res, 1)) {
			perror("codfns_reshape");
			return 1;
		}
		
		if (scale_elements(res, rgt->rank)) {
			perror("codfns_reshape");
			return 2;
		}
		
		res->type = 2;
		*res->shape = rgt->rank;
		rese = res->elements;
		rgts = rgt->shape;
		
		for (i = 0; i < rgt->rank; i++)
			*rese++ = *rgts++;
	} else {
		size_t esize;
		
		if (scale_shape(res, lft->size)) {
			perror("codfns_reshape");
			return 3;
		}
		
		lfte = lft->elements;
		
		for (i = 0, size = 1; i < lft->size; i++)
			size *= *lfte++;
		
		if (scale_elements(res, size)) {
			perror("codfns_reshape");
			return 4;
		}
		
		res->type = rgt->type;
		esize = res->type == 3 ? sizeof(double) : sizeof(int64_t);
		ress = res->shape;
		lfte = lft->elements;
		
		for (i = 0; i < lft->size; i++)
			*ress++ = *lfte++;
		
		memcpy(res->elements, rgt->elements, esize * size);
	}
	
	return 0;
}

int
codfns_catenate(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	uint64_t i;
	
	if (scale_shape(res, 1)) {
		perror("codfns_catenate");
		return 1;
	}
	
	if (scale_elements(res, lft->size + rgt->size)) {
		perror("codfns_catenate");
		return 2;
	}
	
	*res->shape = lft->size + rgt->size;
	res->type = lft->type;
	
	if (res->type == 3) {
		double *rese = res->elements;
		double *lfte = lft->elements;
		double *rgte = rgt->elements;
	
		for (i = 0; i < lft->size; i++) 
			*rese++ = *lfte++;
	
		for (i = 0; i < rgt->size; i++)
			*rese++ = *rgte++;
	} else {
		int64_t *rese = res->elements;
		int64_t *lfte = lft->elements;
		int64_t *rgte = rgt->elements;
	
		for (i = 0; i < lft->size; i++) 
			*rese++ = *lfte++;
	
		for (i = 0; i < rgt->size; i++)
			*rese++ = *rgte++;
	}
		
	return 0;
}

int
codfns_ptred(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	uint64_t i;
	double val, *lfte, *rgte;
	
	if (scale_shape(res, 0)) {
		perror("codfns_ptred");
		return 1;
	}
	
	if (scale_elements(res, 1)) {
		perror("codfns_ptred");
		return 2;
	}
	
	lfte = lft->elements;
	rgte = rgt->elements;
	val = 0;
	
	for (i = 0; i < rgt->size; i++) 
		val += *lfte++ * *rgte++;
		
	*((double *)res->elements) = val;

	return 0;
}

int
codfns_each(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt,
    int (*fn)(struct codfns_array *, struct codfns_array *,
        struct codfns_array *, struct codfns_array **),
    struct codfns_array **env)
{
	int code;
	uint64_t i;
	double *rese, *srgte;
	struct codfns_array sres, srgt;

	if (copy_shape(res, rgt)) {
		perror("codfns_each");
		return 1;
	}
	
	if (scale_elements(res, rgt->size)) {
		perror("codfns_each");
		return 2;
	}
	
	sres.rank = 0;
	sres.size = 0;
	sres.type = 2;
	sres.shape = NULL;
	sres.elements = NULL;
	
	srgt.rank = 0;
	srgt.size = 1;
	srgt.type = rgt->type;
	srgt.shape = NULL;
	srgte = srgt.elements = rgt->elements;
	
	rese = res->elements;
	
	for (i = 0; i < res->size; i++) {
		if ((code = fn(&sres, NULL, &srgt, env)))
			return code;
		
		srgt.elements = ++srgte;
		*rese++ = *((double *)sres.elements);
	}
	
	res->type = sres.type;
	
	array_free(&sres);

	return 0;
}
