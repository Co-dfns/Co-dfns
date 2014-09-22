#include <stdlib.h>
#include <error.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "codfns.h"

/* ffi_make_array()
 *
 * Intended Function: Given the fields of an array, create a fresh
 * array which does not rely on any of the pointers or memory regions
 * given in the arguments. Store this fresh array in the pointer cell
 * provided.
 */

int
ffi_make_array_int(struct codfns_array **res,
    uint16_t rnk, uint64_t sz, uint64_t *shp, int64_t *dat)
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
		arr->shape = calloc(rnk, sizeof(uint64_t));
		if (arr->shape == NULL) {
			perror("ffi_make_array");
			return 3;
		}
	}

	arr->rank = rnk;
	arr->size = sz;
	arr->type = 2;
	arr->gpu_elements = NULL;
	arr->on_gpu = 0;

	memcpy(arr->shape, shp, sizeof(uint64_t) * rnk);
	memcpy(arr->elements, dat, sizeof(int64_t) * sz);

	*res = arr;

	return 0;
}

int
ffi_make_array_double(struct codfns_array **res,
    uint16_t rnk, uint64_t sz, uint64_t *shp, double *dat)
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
		arr->shape = calloc(rnk, sizeof(uint64_t));
		if (arr->shape == NULL) {
			perror("ffi_make_array");
			return 3;
		}
	}

	arr->rank = rnk;
	arr->size = sz;
	arr->type = 3;
	arr->gpu_elements = NULL;
	arr->on_gpu = 0;

	memcpy(arr->shape, shp, sizeof(uint64_t) * rnk);
	memcpy(arr->elements, dat, sizeof(double) * sz);

	*res = arr;

	return 0;
}

