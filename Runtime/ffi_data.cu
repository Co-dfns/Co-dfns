#include <string.h>

#include "h.cuh"

extern "C" {
/* ffi_get_data_int()
 *
 * Intended Function: Fill the given result buffer with the data
 * elements of the array interpreted as integers, assuming enough
 * space in the buffer for the values.
 */

void
ffi_get_data_int(int64_t *res, struct codfns_array *arr)
{
	g2h(arr);
	memcpy(res, arr->elements, sizeof(int64_t) * arr->size);

	return;
}

/* ffi_get_data_float()
 *
 * Intended Function: Fill the given result buffer with the data
 * elements of the array interpreted as doubles, assuming enough
 * space in the buffer for the values.
 */

void
ffi_get_data_float(double *res, struct codfns_array *arr)
{
	g2h(arr);
	memcpy(res, arr->elements, sizeof(double) * arr->size);

	return;
}
}
