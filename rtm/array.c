#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <arrayfire.h>

#include "codfns.h"

#if AF_API_VERSION < 38
#error "Your ArrayFire version is too old."
#endif

DECLSPEC size_t
array_count(struct cell_array *arr)
{
	size_t count;
	
	count = 1;
	
	for (unsigned int i = 0; i < arr->rank; i++)
		count *= arr->shape[i];
	
	return count;
}

DECLSPEC size_t
array_values_count(struct cell_array *arr)
{
	size_t count;
	
	count = array_count(arr);
	
	if (!count)
		count = 1;
	
	return count;
}

DECLSPEC size_t
array_element_size(struct cell_array *arr)
{
	switch (arr->type) {
	case ARR_SPAN:
		return sizeof(af_array *);
	case ARR_BOOL:
		return sizeof(char);
	case ARR_SINT:
		return sizeof(int16_t);
	case ARR_INT:
		return sizeof(int32_t);
	case ARR_DBL:
		return sizeof(double);
	case ARR_CMPX:
		return sizeof(struct apl_cmpx);
	case ARR_CHAR8:
		return sizeof(uint8_t);
	case ARR_CHAR16:
		return sizeof(uint16_t);
	case ARR_CHAR32:
		return sizeof(uint32_t);
	case ARR_MIXED:
		return sizeof(void *);
	case ARR_NESTED:
		return sizeof(struct cell_array *);
	default:
		return 0;
	}
}

af_dtype
array_af_dtype(struct cell_array *arr)
{
	switch (arr->type) {
	case ARR_SPAN:
		return s32;
	case ARR_BOOL:
		return b8;
	case ARR_SINT:
		return s16;
	case ARR_INT:
		return s32;
	case ARR_DBL:
		return f64;
	case ARR_CMPX:
		return c64;
	case ARR_CHAR8:
		return u8;
	case ARR_CHAR16:
		return u16;
	case ARR_CHAR32:
		return u32;
	case ARR_MIXED:
		return u64;
	case ARR_NESTED:
		return u64;
	default:
		return 0;
	}
}

DECLSPEC int
fill_array(struct cell_array *arr, void *data)
{
	size_t	count, size;
	int	err;
	
	count	= array_values_count(arr);
	size	= count * array_element_size(arr);
	err	= 0;
	
	switch (arr->storage) {
	case STG_DEVICE:
		err = af_write_array(arr->values, data, size, afHost);
		break;
	case STG_HOST:
		memcpy(arr->values, data, size);
		break;
	default:
		return 99;
	}
	
	return err;
}

DECLSPEC int
mk_array(struct cell_array **dest,
    enum array_type type, enum array_storage storage, unsigned int rank,
    size_t shape[])
{
	struct	cell_array *arr;
	size_t	count, size;
	int	err;
	af_dtype	dtype;
	
	size	= sizeof(struct cell_array) + rank * sizeof(size_t);
	arr	= malloc(size);

	if (arr == NULL)
		return 1;

	arr->ctyp       = CELL_ARRAY;
	arr->refc       = 1;
	arr->type       = type;
	arr->storage    = storage;
	arr->rank       = rank;
	
	for (unsigned int i = 0; i < rank; i++) 
		arr->shape[i] = shape[i];
	
	count	= array_values_count(arr);
	
	if (storage == STG_DEVICE) {
		dtype = array_af_dtype(arr);
		err = af_create_handle(&arr->values, 1, &count, dtype);
	} else if (storage == STG_HOST) {
		arr->values = calloc(count, array_element_size(arr));
		err = (arr->values == NULL);
	} else {
		err = 99;
	}
	
	if (err) {
		free(arr);
		return err;
	}
	
	*dest = arr;

	return 0;
}

DECLSPEC void
release_array(struct cell_array *arr)
{
	size_t count;
	struct cell_array **ptrs;
	
	if (arr == NULL)
		return;
	
	if (!arr->refc)
		return;

	arr->refc--;

	if (arr->refc)
		return;

	if (arr->type == ARR_NESTED) {
		ptrs = arr->values;
		count = array_count(arr);
		
		for (size_t i = 0; i < count; i++)
			release_array(ptrs[i]);
	}

	if (arr->values)
		switch (arr->storage) {
		case STG_DEVICE:
			af_release_array(arr->values);
			break;
		case STG_HOST:
			free(arr->values);
			break;
		default:
			exit(99);
		}

	free(arr);
}
