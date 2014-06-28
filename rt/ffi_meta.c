#include <inttypes.h>
#include <string.h>

#include "codfns.h"

/* ffi_get_rank()
 *
 * Intended Function: Return the rank field of the array.
 */

uint16_t
ffi_get_rank(struct codfns_array *arr)
{
	return arr->rank;
}

/* ffi_get_size()
 *
 * Intended Function: Return the size field of the array.
 */

uint64_t
ffi_get_size(struct codfns_array *arr)
{
	return arr->size;
}

/* ffi_get_type()
 * 
 * Intended Function: Return the type field of the array.
 */

uint8_t
ffi_get_type(struct codfns_array *arr)
{
	return arr->type;
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


