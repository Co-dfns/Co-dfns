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

	if (src->rank > tgt->rank) {
		shp = realloc(tgt->shape, sizeof(uint32_t) * src->rank);
		if (shp == NULL) {
			perror("array_cp");
			return 1;
		}
	}

	if (src->size > tgt->size) {
		dat = realloc(tgt->elements, sizeof(int64_t) * src->size);
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

#define scalar(x) ((x)->rank == 0)

int
codfns_same_shape(struct codfns_array *lft, struct codfns_array *rgt)
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

int
codfns_add(struct codfns_array *ret, struct codfns_array *lft, struct codfns_array *rgt)
{
  int i, k;
  int64_t *left_elems, *right_elems, *res_elems, sclr;
  uint32_t *shp;

  if (lft == NULL) {
    return array_cp(ret, rgt);
  }

  if (codfns_same_shape(lft, rgt)) {
    k = ret->size = lft->size;
    ret->rank = lft->rank;
    left_elems = lft->elements;
    right_elems = rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(lft) ? NULL : realloc(ret->shape, lft->rank);
    memcpy(shp, lft->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = *left_elems++ + *right_elems++;

    ret->elements = res_elems;
    ret->shape = shp;
  } else if (scalar(lft)) {
    k = ret->size = rgt->size;
    ret->rank = rgt->rank;
    sclr = *lft->elements;
    right_elems = rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(rgt) ? NULL : realloc(ret->shape, rgt->rank);
    memcpy(shp, rgt->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = sclr + *right_elems++;

    ret->elements = res_elems;
    ret->shape = shp;
  } else if (scalar(rgt)) {
    k = ret->size = lft->size;
    ret->rank = lft->rank;
    left_elems = lft->elements;
    sclr = *rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(lft) ? NULL : realloc(ret->shape, lft->rank);
    memcpy(shp, lft->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = *left_elems++ + sclr;

    ret->elements = res_elems;
    ret->shape = shp;
  }

  return 0;
}


int
codfns_subtract(struct codfns_array *ret, struct codfns_array *lft, struct codfns_array *rgt)
{
  int i, k;
  int64_t *left_elems, *right_elems, *res_elems, sclr;
  uint32_t *shp;

  if (lft == NULL) {
    ret->size = rgt->size;
    ret->rank = rgt->rank;
    k = rgt->rank;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(rgt) ? NULL : realloc(ret->shape, rgt->rank);
    memcpy(shp, rgt->shape, ret->rank);
    memcpy(res_elems, rgt->elements, rgt->size);

    for (i = 0; i < k; i++)
      *res_elems++ *= -1;

    ret->shape = shp;
    ret->elements = res_elems;

    return 0;
  }

  if (codfns_same_shape(lft, rgt)) {
    k = ret->size = lft->size;
    ret->rank = lft->rank;
    left_elems = lft->elements;
    right_elems = rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(lft) ? NULL : realloc(ret->shape, lft->rank);
    memcpy(shp, lft->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = *left_elems++ - *right_elems++;

    ret->elements = res_elems;
    ret->shape = shp;

  } else if (scalar(lft)) {
    k = ret->size = rgt->size;
    ret->rank = rgt->rank;
    sclr = *lft->elements;
    right_elems = rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(rgt) ? NULL : realloc(ret->shape, rgt->rank);
    memcpy(shp, rgt->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = sclr - *right_elems++;

    ret->elements = res_elems;
    ret->shape = shp;
  } else if (scalar(rgt)) {
    k = ret->size = lft->size;
    ret->rank = lft->rank;
    left_elems = lft->elements;
    sclr = *rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(lft) ? NULL : realloc(ret->shape, lft->rank);
    memcpy(shp, lft->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = *left_elems++ - sclr;

    ret->elements = res_elems;
    ret->shape = shp;
  }

  return 0;
}

int
codfns_multiply(struct codfns_array *ret, struct codfns_array *lft, struct codfns_array *rgt)
{
  int i, k;
  int64_t *left_elems, *right_elems, *res_elems, sclr;
  uint32_t *shp;

  /* We return the signum array for the RHS */
  if (lft == NULL) {
    k = rgt->rank;
    ret->size = rgt->size;
    ret->rank = rgt->rank;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(rgt) ? NULL : realloc(ret->shape, rgt->rank);
    memcpy(shp, rgt->shape, ret->rank);
    memcpy(res_elems, rgt->elements, rgt->size);

    for (i = 0; i < k; i++) {
      if(res_elems[i] < 0)
        res_elems[i] = -1;
      else if (res_elems[i] > 0)
        res_elems[i] = 1;
      else res_elems[i] = 0;
    }

    ret->shape = shp;
    ret->elements = res_elems;

    return 0;
  }

  if (codfns_same_shape(lft, rgt)) {
    k = ret->size = lft->size;
    ret->rank = lft->rank;
    left_elems = lft->elements;
    right_elems = rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(lft) ? NULL : realloc(ret->shape, lft->rank);
    memcpy(shp, lft->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = *left_elems++ * *right_elems++;

    ret->shape = shp;
    ret->elements = res_elems;
  } else if (scalar(lft)) {
    k = ret->size = rgt->size;
    ret->rank = rgt->rank;
    sclr = *lft->elements;
    right_elems = rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(rgt) ? NULL : realloc(ret->shape, rgt->rank);
    memcpy(shp, rgt->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = sclr * *right_elems++;

    ret->shape = shp;
    ret->elements = res_elems;
  } else if (scalar(rgt)) {
    k = ret->size = lft->size;
    ret->rank = lft->rank;
    left_elems = lft->elements;
    sclr = *rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp =  scalar(lft) ? NULL : realloc(ret->shape, lft->rank);
    memcpy(shp, lft->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = *left_elems++ * sclr;

    ret->shape = shp;
    ret->elements = res_elems;
  }

  return 0;
}

int
codfns_divide(struct codfns_array *ret, struct codfns_array *lft, struct codfns_array *rgt, int DIV)
{
  int i, k;
  int64_t *left_elems, *right_elems, *res_elems, sclr;
  uint32_t *shp;

  /* We return the reciprocal array for the RHS */
  if (lft == NULL) {
    k = rgt->rank;
    ret->size = rgt->size;
    ret->rank = rgt->rank;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(rgt) ? NULL : realloc(ret->shape, rgt->rank);
    memcpy(shp, rgt->shape, ret->rank);
    memcpy(res_elems, rgt->elements, rgt->size);

    for (i = 0; i < k; i++) {
      if (res_elems[i] != 0)
        res_elems[i] = 1 / res_elems[i];
      else if (DIV == 1)
          res_elems[i] = 0;
        else
          return 1; /* Signal an error */
    }

    ret->shape = shp;
    ret->elements = res_elems;

    return 0;
  }

  if (codfns_same_shape(lft, rgt)) {
    k = ret->size = lft->size;
    ret->rank = lft->rank;
    left_elems = lft->elements;
    right_elems = rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(lft) ? NULL : realloc(ret->shape, lft->rank);
    memcpy(shp, lft->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = *left_elems++ / *right_elems++;

    ret->shape = shp;
    ret->elements = res_elems;
  } else if (scalar(lft)) {
    k = ret->size = rgt->size;
    ret->rank = rgt->rank;
    sclr = *lft->elements;
    right_elems = rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(rgt) ? NULL : realloc(ret->shape, rgt->rank);
    memcpy(shp, rgt->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = sclr / *right_elems++;

    ret->elements = res_elems;
    ret->shape = shp;
  } else if (scalar(rgt)) {
    k = ret->size = lft->size;
    ret->rank = lft->rank;
    left_elems = lft->elements;
    sclr = *rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(lft) ? NULL : realloc(ret->shape, lft->rank);
    memcpy(shp, lft->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = *left_elems++ / sclr;

    ret->elements = res_elems;
    ret->shape = shp;
  }

  return 0;
}

/* Need to do error handling when x is zero and we are raising to a negative power */
int
codfns_power(struct codfns_array *ret, struct codfns_array *lft, struct codfns_array *rgt)
{
  int i, k;
  int64_t *left_elems, *right_elems, *res_elems, sclr;
  uint32_t *shp;

  /* Exponential on the right */
  if (lft == NULL) {
    ret->size = rgt->size;
    ret->rank = rgt->rank;
    right_elems = rgt->elements;
    k = rgt->rank;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(rgt) ? NULL : realloc(ret->shape, rgt->rank);
    memcpy(shp, rgt->shape, ret->rank);
    memcpy(res_elems, rgt->elements, rgt->size);

    for (i = 0; i < k; i++)
      *res_elems++ = exp(*right_elems++);

    ret->shape = shp;
    ret->elements = res_elems;

    return 0;
  }

  if (codfns_same_shape(lft, rgt)) {
    k = ret->size = lft->size;
    ret->rank = lft->rank;
    left_elems = lft->elements;
    right_elems = rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(lft) ? NULL : realloc(ret->shape, lft->rank);
    memcpy(shp, lft->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = pow(*left_elems++, *right_elems++);

    ret->elements = res_elems;
    ret->shape = shp;

  } else if (scalar(lft)) {
    k = ret->size = rgt->size;
    ret->rank = rgt->rank;
    sclr = *lft->elements;
    right_elems = rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(rgt) ? NULL : realloc(ret->shape, rgt->rank);
    memcpy(shp, rgt->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = pow(*right_elems++, sclr);

    ret->elements = res_elems;
    ret->shape = shp;
  } else if (scalar(rgt)) {
    k = ret->size = lft->size;
    ret->rank = lft->rank;
    left_elems = lft->elements;
    sclr = *rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(lft) ? NULL : realloc(ret->shape, lft->rank);
    memcpy(shp, lft->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = pow(*left_elems++, sclr);

    ret->elements = res_elems;
    ret->shape = shp;
  }

  return 0;
}

int
codfns_not(struct codfns_array *ret, struct codfns_array *lft, struct codfns_array *rgt)
{
  int i, k;
  int64_t *res_elems, sclr;
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

int
codfns_less(struct codfns_array *ret, struct codfns_array *lft, struct codfns_array *rgt)  /* Add OCT argument */
{
  int i, k;
  int64_t *left_elems, *right_elems, *res_elems, sclr;
  uint32_t *shp;

  /* There is no monadic form */
  if (lft == NULL) {
    return 0;
  }

  if (codfns_same_shape(lft, rgt)) {
    k = ret->size = lft->size;
    ret->rank = lft->rank;
    left_elems = lft->elements;
    right_elems = rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(lft) ? NULL : realloc(ret->shape, lft->rank);
    memcpy(shp, lft->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = *left_elems++ < *right_elems++;

    ret->elements = res_elems;
    ret->shape = shp;
  } else if (scalar(lft)) {
    k = ret->size = rgt->size;
    ret->rank = rgt->rank;
    sclr = *lft->elements;
    right_elems = rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(rgt) ? NULL : realloc(ret->shape, rgt->rank);
    memcpy(shp, rgt->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = sclr < *right_elems++;

    ret->elements = res_elems;
    ret->shape = shp;
  } else if (scalar(rgt)) {
    k = ret->size = lft->size;
    ret->rank = lft->rank;
    left_elems = lft->elements;
    sclr = *rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(lft) ? NULL : realloc(ret->shape, lft->rank);
    memcpy(shp, lft->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = *left_elems++ < sclr;

    ret->elements = res_elems;
    ret->shape = shp;
  }

  return 0;
}

int
codfns_less_or_equal(struct codfns_array *ret, struct codfns_array *lft, struct codfns_array *rgt)  /* Add OCT argument */
{
  int i, k;
  int64_t *left_elems, *right_elems, *res_elems, sclr;
  uint32_t *shp;

  /* There is no monadic form */
  if (lft == NULL) {
    return 0;
  }

  if (codfns_same_shape(lft, rgt)) {
    k = ret->size = lft->size;
    ret->rank = lft->rank;
    left_elems = lft->elements;
    right_elems = rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(lft) ? NULL : realloc(ret->shape, lft->rank);
    memcpy(shp, lft->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = *left_elems++ <= *right_elems++;

    ret->elements = res_elems;
    ret->shape = shp;
  } else if (scalar(lft)) {
    k = ret->size = rgt->size;
    ret->rank = rgt->rank;
    sclr = *lft->elements;
    right_elems = rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(rgt) ? NULL : realloc(ret->shape, rgt->rank);
    memcpy(shp, rgt->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = sclr <= *right_elems++;

    ret->elements = res_elems;
    ret->shape = shp;
  } else if (scalar(rgt)) {
    k = ret->size = lft->size;
    ret->rank = lft->rank;
    left_elems = lft->elements;
    sclr = *rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(lft) ? NULL : realloc(ret->shape, lft->rank);
    memcpy(shp, lft->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = *left_elems++ <= sclr;

    ret->elements = res_elems;
    ret->shape = shp;
  }
  return 0;
}

int
codfns_equal(struct codfns_array *ret, struct codfns_array *lft, struct codfns_array *rgt)  /* Add OCT argument */
{
  int i, k;
  int64_t *left_elems, *right_elems, *res_elems, sclr;
  uint32_t *shp;

  /* There is no monadic form */
  if (lft == NULL) {
    return 0;
  }

  if (codfns_same_shape(lft, rgt)) {
    k = ret->size = lft->size;
    ret->rank = lft->rank;
    left_elems = lft->elements;
    right_elems = rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(lft) ? NULL : realloc(ret->shape, lft->rank);
    memcpy(shp, lft->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = *left_elems++ = *right_elems++;

    ret->elements = res_elems;
    ret->shape = shp;
  } else if (scalar(lft)) {
    k = ret->size = rgt->size;
    ret->rank = rgt->rank;
    sclr = *lft->elements;
    right_elems = rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(rgt) ? NULL : realloc(ret->shape, rgt->rank);
    memcpy(shp, rgt->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = sclr = *right_elems++;

    ret->elements = res_elems;
    ret->shape = shp;
  } else if (scalar(rgt)) {
    k = ret->size = lft->size;
    ret->rank = lft->rank;
    left_elems = lft->elements;
    sclr = *rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(lft) ? NULL : realloc(ret->shape, lft->rank);
    memcpy(shp, lft->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = *left_elems++ = sclr;

    ret->elements = res_elems;
    ret->shape = shp;
  }

  return 0;
}

int
codfns_greater_or_equal(struct codfns_array *ret, struct codfns_array *lft, struct codfns_array *rgt)  /* Add OCT argument */
{
  int i, k;
  int64_t *left_elems, *right_elems, *res_elems, sclr;
  uint32_t *shp;

  /* There is no monadic form */
  if (lft == NULL) {
    return 0;
  }

  if (codfns_same_shape(lft, rgt)) {
    k = ret->size = lft->size;
    ret->rank = lft->rank;
    left_elems = lft->elements;
    right_elems = rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(lft) ? NULL : realloc(ret->shape, lft->rank);
    memcpy(shp, lft->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = *left_elems++ >= *right_elems++;

    ret->elements = res_elems;
    ret->shape = shp;
  } else if (scalar(lft)) {
    k = ret->size = rgt->size;
    ret->rank = rgt->rank;
    sclr = *lft->elements;
    right_elems = rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(rgt) ? NULL : realloc(ret->shape, rgt->rank);
    memcpy(shp, rgt->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = sclr >= *right_elems++;

    ret->elements = res_elems;
    ret->shape = shp;
  } else if (scalar(rgt)) {
    k = ret->size = lft->size;
    ret->rank = lft->rank;
    left_elems = lft->elements;
    sclr = *rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(lft) ? NULL : realloc(ret->shape, lft->rank);
    memcpy(shp, lft->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = *left_elems++ >= sclr;

    ret->elements = res_elems;
    ret->shape = shp;
  }
  return 0;
}

int
codfns_not_equal(struct codfns_array *ret, struct codfns_array *lft, struct codfns_array *rgt)  /* Add OCT argument */
{
  int i, k;
  int64_t *left_elems, *right_elems, *res_elems, sclr;
  uint32_t *shp;

  /* There is no monadic form */
  if (lft == NULL) {
    return 0;
  }

  if (codfns_same_shape(lft, rgt)) {
    k = ret->size = lft->size;
    ret->rank = lft->rank;
    left_elems = lft->elements;
    right_elems = rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(lft) ? NULL : realloc(ret->shape, lft->rank);
    memcpy(shp, lft->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = *left_elems++ != *right_elems++;

    ret->elements = res_elems;
    ret->shape = shp;
  } else if (scalar(lft)) {
    k = ret->size = rgt->size;
    ret->rank = rgt->rank;
    sclr = *lft->elements;
    right_elems = rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(rgt) ? NULL : realloc(ret->shape, rgt->rank);
    memcpy(shp, rgt->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = sclr != *right_elems++;

    ret->elements = res_elems;
    ret->shape = shp;
  } else if (scalar(rgt)) {
    k = ret->size = lft->size;
    ret->rank = lft->rank;
    left_elems = lft->elements;
    sclr = *rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(lft) ? NULL : realloc(ret->shape, lft->rank);
    memcpy(shp, lft->shape, ret->rank);

    for (i = 0; i < k; i++)
      *res_elems++ = *left_elems++ != sclr;

    ret->elements = res_elems;
    ret->shape = shp;
  }
  return 0;
}

int
codfns_magnitude(struct codfns_array *ret, struct codfns_array *lft, struct codfns_array *rgt)
{
  int i, k;
  int64_t *left_elems, *right_elems, *res_elems, sclr;
  uint32_t *shp;

  /* Exponential on the right */
  if (lft == NULL) {
    ret->size = rgt->size;
    ret->rank = rgt->rank;
    right_elems = rgt->elements;
    k = rgt->rank;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(rgt) ? NULL : realloc(ret->shape, rgt->rank);
    memcpy(shp, rgt->shape, ret->rank);
    memcpy(res_elems, rgt->elements, rgt->size);

    for (i = 0; i < k; i++)
      *res_elems++ = abs(*right_elems++);

    ret->shape = shp;
    ret->elements = res_elems;

    return 0;
  }

  if (codfns_same_shape(lft, rgt)) {
    k = ret->size = lft->size;
    ret->rank = lft->rank;
    left_elems = lft->elements;
    right_elems = rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(lft) ? NULL : realloc(ret->shape, lft->rank);
    memcpy(shp, lft->shape, ret->rank);

    for (i = 0; i < k; i++)
      res_elems[i] = *left_elems++ == 0 ? right_elems[i] : right_elems[i] %  left_elems[i];

    ret->elements = res_elems;
    ret->shape = shp;

  } else if (scalar(lft)) {
    k = ret->size = rgt->size;
    ret->rank = rgt->rank;
    sclr = *lft->elements;
    right_elems = rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(rgt) ? NULL : realloc(ret->shape, rgt->rank);
    memcpy(shp, rgt->shape, ret->rank);

    if (sclr == 0) {
      memcpy(res_elems, rgt->elements, rgt->size);
    } else {
      for (i = 0; i < k; i++)
        *res_elems++ = *right_elems++ % sclr;
    }

    ret->elements = res_elems;
    ret->shape = shp;
  } else if (scalar(rgt)) {
    k = ret->size = lft->size;
    ret->rank = lft->rank;
    left_elems = lft->elements;
    sclr = *rgt->elements;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(lft) ? NULL : realloc(ret->shape, lft->rank);
    memcpy(shp, lft->shape, ret->rank);

    for (i = 0; i < k; i++)
      res_elems[i] = *left_elems++ == 0 ? sclr : sclr %  left_elems[i];

    ret->elements = res_elems;
    ret->shape = shp;
  }

  return 0;
}
