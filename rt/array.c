#include <stdlib.h>
#include <error.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "codfns.h"

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
	arr->type = 0;

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

