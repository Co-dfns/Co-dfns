#include <math.h>
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <arrayfire.h>

#include "internal.h"

#if AF_API_VERSION < 38
#error "Your ArrayFire version is too old."
#endif

size_t
array_count_shape(unsigned int rank, size_t shape[])
{
	size_t count;

	count = 1;

	for (unsigned int i = 0; i < rank; i++)
		count *= shape[i];

	return count;
}

size_t
array_count(struct cell_array *arr)
{
	return array_count_shape(arr->rank, arr->shape);
}

size_t
array_values_count_shape(unsigned int rank, size_t shape[])
{
	size_t count;

	count = array_count_shape(rank, shape);

	if (!count)
		count = 1;

	return count;
}

size_t
array_values_count(struct cell_array *arr)
{
	return array_values_count_shape(arr->rank, arr->shape);
}

size_t
array_element_size_type(enum array_type type)
{
	switch (type) {
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

size_t
array_element_size(struct cell_array *arr)
{
	return array_element_size_type(arr->type);
}

size_t
array_values_bytes(struct cell_array *arr)
{
	size_t count;

	count = array_values_count(arr);

	if (arr->type == ARR_BOOL && arr->storage == STG_HOST)
		count = (count + 7) / 8;

	return count * array_element_size(arr);
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
	struct		cell_array *arr;
	size_t		count, size;
	int		err;
	af_dtype	dtype;
	
	count = array_values_count_shape(rank, shape);
	size = sizeof(struct cell_array) + rank * sizeof(size_t);
	
	if (storage == STG_HOST)
		size += count * array_element_size_type(type);
	
	arr = malloc(size);

	if (arr == NULL)
		return 1;

	arr->ctyp       = CELL_ARRAY;
	arr->refc       = 1;
	arr->type       = type;
	arr->storage    = storage;
	arr->rank       = rank;

	for (unsigned int i = 0; i < rank; i++)
		arr->shape[i] = shape[i];

	if (storage == STG_DEVICE) {
		dtype = array_af_dtype(arr);
		err = af_create_handle(&arr->values, 1, &count, dtype);
	} else if (storage == STG_HOST) {
		arr->values = &arr->shape[rank];
		err = 0;
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
		count = array_values_count(arr);

		for (size_t i = 0; i < count; i++)
			release_array(ptrs[i]);
	}

	if (arr->values)
		switch (arr->storage) {
		case STG_DEVICE:
			af_release_array(arr->values);
			break;
		case STG_HOST:
			break;
		default:
			exit(99);
		}

	free(arr);
}

int
is_integer(double x)
{
	return rint(x) == x;
}

int
is_integer_type(enum array_type type)
{
	switch (type) {
	case ARR_SPAN:
	case ARR_BOOL:
	case ARR_SINT:
	case ARR_INT:
		return 1;
	default:
		return 0;
	}
}

int
is_char_type(enum array_type type)
{
	switch (type) {
	case ARR_CHAR8:
	case ARR_CHAR16:
	case ARR_CHAR32:
		return 1;
	default:
		return 0;
	}
}

int
is_numeric_type(enum array_type type)
{
	switch (type) {
	case ARR_SPAN:
	case ARR_BOOL:
	case ARR_SINT:
	case ARR_INT:
	case ARR_DBL:
	case ARR_CMPX:
		return 1;
	default:
		return 0;
	}
}

int
is_integer_array(struct cell_array *arr)
{
	return is_integer_type(arr->type);
}

int
is_real_array(struct cell_array *arr)
{
	return is_numeric_type(arr->type) && arr->type != ARR_CMPX;
}

int
is_numeric_array(struct cell_array *arr)
{
	return is_numeric_type(arr->type);
}

int
is_char_array(struct cell_array *arr)
{
	return is_char_type(arr->type);
}

enum array_type
array_max_type(enum array_type a, enum array_type b)
{
	if (a == ARR_SPAN)
		return b;
	
	if (b == ARR_SPAN)
		return a;
	
	if (a == ARR_NESTED || b == ARR_NESTED)
		return ARR_NESTED;
	
	if (a == ARR_MIXED || b == ARR_MIXED)
		return ARR_MIXED;
	
	if (is_char_type(a) && is_numeric_type(b))
		return ARR_MIXED;
	
	if (is_numeric_type(a) && is_char_type(b))
		return ARR_MIXED;
	
	if (a < b)
		return b;
	
	return a;
}

int
get_scalar_data(void **val, void *buf, struct cell_array *arr)
{
	int err;
	
	switch (arr->storage) {
	case STG_DEVICE:
		if (err = af_get_scalar(buf, arr->values))
			return err;
		
		*val = buf;
		break;
	case STG_HOST:
		*val = arr->values;
		break;
	default:
		return 99;
	}
	
	return 0;
}

int
get_scalar_bool(int8_t *dst, struct cell_array *arr)
{
	char buf[16];
	void *val;
	int err;
	
	if (err = get_scalar_data(&val, buf, arr))
		return err;
	
	switch (arr->type) {
	case ARR_BOOL:
		*dst = *((int8_t *)val);
		break;
	case ARR_SINT:
		*dst = (int8_t)*((int16_t *)val);
		break;
	case ARR_INT:
		*dst = (int8_t)*((int32_t *)val);
		break;
	case ARR_DBL:
		*dst = (int8_t)*((double *)val);
		break;
	case ARR_CMPX:
		*dst = (int8_t)(*(struct apl_cmpx *)val).real;
		break;
	case ARR_CHAR8:
	case ARR_CHAR16:
	case ARR_CHAR32:
	case ARR_SPAN:
	case ARR_MIXED:
	case ARR_NESTED:
	default:
		return 99;
	}
	
	return 0;
}

int
get_scalar_sint(int16_t *dst, struct cell_array *arr)
{
	char buf[16];
	void *val;
	int err;
	
	if (err = get_scalar_data(&val, buf, arr))
		return err;
	
	switch (arr->type) {
	case ARR_BOOL:
		*dst = (int16_t)*((int8_t *)val);
		break;
	case ARR_SINT:
		*dst = (int16_t)*((int16_t *)val);
		break;
	case ARR_INT:
		*dst = (int16_t)*((int32_t *)val);
		break;
	case ARR_DBL:
		*dst = (int16_t)*((double *)val);
		break;
	case ARR_CMPX:
		*dst = (int16_t)(*(struct apl_cmpx *)val).real;
		break;
	case ARR_CHAR8:
	case ARR_CHAR16:
	case ARR_CHAR32:
	case ARR_SPAN:
	case ARR_MIXED:
	case ARR_NESTED:
	default:
		return 99;
	}
	
	return 0;
}

int
get_scalar_int(int32_t *dst, struct cell_array *arr)
{
	char buf[16];
	void *val;
	int err;
	
	if (err = get_scalar_data(&val, buf, arr))
		return err;
	
	switch (arr->type) {
	case ARR_BOOL:
		*dst = (int32_t)*((int8_t *)val);
		break;
	case ARR_SINT:
		*dst = (int32_t)*((int16_t *)val);
		break;
	case ARR_INT:
		*dst = (int32_t)*((int32_t *)val);
		break;
	case ARR_DBL:
		*dst = (int32_t)*((double *)val);
		break;
	case ARR_CMPX:
		*dst = (int32_t)(*(struct apl_cmpx *)val).real;
		break;
	case ARR_CHAR8:
	case ARR_CHAR16:
	case ARR_CHAR32:
	case ARR_SPAN:
	case ARR_MIXED:
	case ARR_NESTED:
	default:
		return 99;
	}
	
	return 0;
}

int
get_scalar_dbl(double *dst, struct cell_array *arr)
{
	char buf[16];
	void *val;
	int err;
	
	if (err = get_scalar_data(&val, buf, arr))
		return err;
	
	switch (arr->type) {
	case ARR_BOOL:
		*dst = (double)*((int8_t *)val);
		break;
	case ARR_SINT:
		*dst = (double)*((int16_t *)val);
		break;
	case ARR_INT:
		*dst = (double)*((int32_t *)val);
		break;
	case ARR_DBL:
		*dst = (double)*((double *)val);
		break;
	case ARR_CMPX:
		*dst = (double)(*(struct apl_cmpx *)val).real;
		break;
	case ARR_CHAR8:
	case ARR_CHAR16:
	case ARR_CHAR32:
	case ARR_SPAN:
	case ARR_MIXED:
	case ARR_NESTED:
	default:
		return 99;
	}
	
	return 0;
}

int
get_scalar_cmpx(struct apl_cmpx *dst, struct cell_array *arr)
{
	char buf[16];
	void *val;
	int err;
	
	if (err = get_scalar_data(&val, buf, arr))
		return err;
	
	switch (arr->type) {
	case ARR_BOOL:
		(*dst).real = (double)*((int8_t *)val);
		(*dst).imag = 0;
		break;
	case ARR_SINT:
		(*dst).real = (double)*((int16_t *)val);
		(*dst).imag = 0;
		break;
	case ARR_INT:
		(*dst).real = (double)*((int32_t *)val);
		(*dst).imag = 0;
		break;
	case ARR_DBL:
		(*dst).real = (double)*((double *)val);
		(*dst).imag = 0;
		break;
	case ARR_CMPX:
		*dst = *((struct apl_cmpx *)val);
		break;
	case ARR_CHAR8:
	case ARR_CHAR16:
	case ARR_CHAR32:
	case ARR_SPAN:
	case ARR_MIXED:
	case ARR_NESTED:
	default:
		return 99;
	}
	
	return 0;
}

int
get_scalar_char8(uint8_t *dst, struct cell_array *arr)
{
	char buf[16];
	void *val;
	int err;
	
	if (err = get_scalar_data(&val, buf, arr))
		return err;
	
	switch (arr->type) {
	case ARR_CHAR8:
		*dst = (uint8_t)*(uint8_t *)val;
		break;
	case ARR_CHAR16:
		*dst = (uint8_t)*(uint16_t *)val;
		break;
	case ARR_CHAR32:
		*dst = (uint8_t)*(uint32_t *)val;
		break;
	case ARR_BOOL:
	case ARR_SINT:
	case ARR_INT:
	case ARR_DBL:
	case ARR_CMPX:
	case ARR_SPAN:
	case ARR_MIXED:
	case ARR_NESTED:
	default:
		return 99;
	}
	
	return 0;
}

int
get_scalar_char16(uint16_t *dst, struct cell_array *arr)
{
	char buf[16];
	void *val;
	int err;
	
	if (err = get_scalar_data(&val, buf, arr))
		return err;
	
	switch (arr->type) {
	case ARR_CHAR8:
		*dst = (uint16_t)*(uint8_t *)val;
		break;
	case ARR_CHAR16:
		*dst = (uint16_t)*(uint16_t *)val;
		break;
	case ARR_CHAR32:
		*dst = (uint16_t)*(uint32_t *)val;
		break;
	case ARR_BOOL:
	case ARR_SINT:
	case ARR_INT:
	case ARR_DBL:
	case ARR_CMPX:
	case ARR_SPAN:
	case ARR_MIXED:
	case ARR_NESTED:
	default:
		return 99;
	}
	
	return 0;
}

int
get_scalar_char32(uint32_t *dst, struct cell_array *arr)
{
	char buf[16];
	void *val;
	int err;
	
	if (err = get_scalar_data(&val, buf, arr))
		return err;
	
	switch (arr->type) {
	case ARR_CHAR8:
		*dst = (uint32_t)*(uint8_t *)val;
		break;
	case ARR_CHAR16:
		*dst = (uint32_t)*(uint16_t *)val;
		break;
	case ARR_CHAR32:
		*dst = (uint32_t)*(uint32_t *)val;
		break;
	case ARR_BOOL:
	case ARR_SINT:
	case ARR_INT:
	case ARR_DBL:
	case ARR_CMPX:
	case ARR_SPAN:
	case ARR_MIXED:
	case ARR_NESTED:
	default:
		return 99;
	}
	
	return 0;
}

