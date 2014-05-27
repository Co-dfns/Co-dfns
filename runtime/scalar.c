#include <stdlib.h>
#include <error.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "codfns.h"

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

