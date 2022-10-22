#include <limits.h>
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <arrayfire.h>

#include "internal.h"

#define SQUEEZE_BOOL_VALS(otype, tx, zero, expr) {		\
	size_t blocks = count / 8;				\
	int tail = count % 8;					\
	uint8_t *buf = arr->values;				\
								\
	for (size_t i = 0; i < blocks; i++) {			\
		for (int j = 0; j < 8; j++) {			\
			otype t = vals[i * 8 + j];		\
			vals[i * 8 + j] = zero;			\
			buf[i] |= ((uint8_t)tx) << (7 - j);	\
			expr;					\
		}						\
	}                                                       \
								\
	for (int j = 0; j < tail; j++) {			\
		otype t = vals[blocks * 8 + j];			\
		vals[blocks * 8 + j] = zero;			\
		buf[blocks] |= ((uint8_t)tx) << (7 - j);	\
		expr;						\
	}							\
								\
	arr->type = ARR_BOOL;					\
}

#define SQUEEZE_VALS(ctype, atype, otype, tx, expr) {	\
	ctype *buf = arr->values;			\
							\
	for (size_t i = 0; i < count; i++) {		\
		otype t = vals[i];			\
		buf[i] = (ctype)tx;			\
		expr;					\
	}						\
							\
	arr->type = atype;				\
}

#define FIND_MINMAX(MIN, MAX, tx)		\
	min = MAX;				\
	max = MIN;				\
						\
	for (size_t i = 0; i < count; i++) {	\
		t = vals[i];			\
						\
		if (tx < MIN || MAX < tx)	\
			return;			\
						\
		if (tx > max)			\
			max = tx;		\
		else if (tx < min)		\
			min = tx;		\
	}

void
squeeze_host_sint(struct cell_array *arr, size_t count)
{
	int16_t *vals, t, min, max;
	
	vals = arr->values;

	FIND_MINMAX(0, 1, t);
	
	SQUEEZE_BOOL_VALS(int16_t, t, 0,);
}

void
squeeze_host_int(struct cell_array *arr, size_t count)
{
	int32_t *vals, t, min, max;
	
	vals = arr->values;
	
	FIND_MINMAX(INT16_MIN, INT16_MAX, t)
	
	if (0 <= min && max <= 1)
		SQUEEZE_BOOL_VALS(int32_t, t, 0,)
	else 
		SQUEEZE_VALS(int16_t, ARR_SINT, int32_t, t,)
}

void
squeeze_host_dbl(struct cell_array *arr, size_t count)
{
	double *vals, t, min, max;
	
	vals = arr->values;
	
	for (size_t i = 0; i < count; i++)
		if (!is_integer(vals[i]))
			return;
	
	FIND_MINMAX(INT32_MIN, INT32_MAX, t)
	
	if (0 <= min && max <= 1)
		SQUEEZE_BOOL_VALS(double, t, 0,)
	else if (INT16_MIN <= min && max <= INT16_MAX)
		SQUEEZE_VALS(int16_t, ARR_SINT, double, t,)
	else
		SQUEEZE_VALS(int32_t, ARR_INT, double, t,)
}

void
squeeze_host_cmpx(struct cell_array *arr, size_t count)
{
	struct apl_cmpx *vals, t;
	double min, max;
	int is_dbl;
	
	vals = arr->values;
	
	for (size_t i = 0; i < count; i++)
		if (vals[i].imag != 0)
			return;
		
	is_dbl = 0;

	for (size_t i = 0; i < count; i++) {
		if (!is_integer(vals[i].real)) {
			is_dbl = 1;
			break;
		}
	}
	
	if (is_dbl)
		SQUEEZE_VALS(double, ARR_DBL, struct apl_cmpx, t.real,)
	
	FIND_MINMAX(INT32_MIN, INT32_MAX, t.real)
	
	if (0 <= min && max <= 1) {
		struct apl_cmpx zero = {0, 0};
		
		SQUEEZE_BOOL_VALS(struct apl_cmpx, t.real, zero,)
	} else if (INT16_MIN <= min && max <= INT16_MAX)
		SQUEEZE_VALS(int16_t, ARR_SINT, struct apl_cmpx, t.real,)
	else
		SQUEEZE_VALS(int32_t, ARR_INT, struct apl_cmpx, t.real,)
}

void
squeeze_host_char16(struct cell_array *arr, size_t count)
{
	uint16_t *vals, t, min, max;
	
	vals = arr->values;
	
	FIND_MINMAX(0, UINT8_MAX, t)
	
	SQUEEZE_VALS(uint8_t, ARR_CHAR8, uint16_t, t,)
}

void
squeeze_host_char32(struct cell_array *arr, size_t count)
{
	uint32_t *vals, t, min, max;
	
	vals = arr->values;
	
	FIND_MINMAX(0, UINT16_MAX, t)
	
	if (max <= UINT8_MAX)
		SQUEEZE_VALS(uint8_t, ARR_CHAR8, uint32_t, t,)
	else
		SQUEEZE_VALS(uint16_t, ARR_CHAR16, uint32_t, t,)
}

int squeeze_host(struct cell_array *, size_t);

int
squeeze_host_nested(struct cell_array *arr, size_t count)
{
	struct cell_array **vals;
	enum array_type type;
	
	vals = arr->values;
	type = vals[0]->type;
	
	for (size_t i = 0; i < count; i++) {
		struct cell_array *t = vals[i];
		
		if (t->rank != 0 || !is_simple(t))
			return 0;

		type = array_max_type(type, t->type);
		
		if (type == ARR_MIXED || type == ARR_NESTED || type == ARR_SPAN)
			return 0;
	}

	switch (type) {
        case ARR_BOOL:
		SQUEEZE_BOOL_VALS(struct cell_array *, 
		    get_scalar_int(t), NULL, release_array(t))
		break;
	case ARR_SINT:
		SQUEEZE_VALS(int16_t, ARR_SINT, struct cell_array *,
		    get_scalar_int(t), release_array(t))
		squeeze_host_sint(arr, count);
		break;
	case ARR_INT:
		SQUEEZE_VALS(int32_t, ARR_INT, struct cell_array *,
		    get_scalar_int(t), release_array(t))
		squeeze_host_int(arr, count);
		break;
	case ARR_DBL:
		SQUEEZE_VALS(double, ARR_DBL, struct cell_array *, 
		    get_scalar_dbl(t), release_array(t))
		squeeze_host_dbl(arr, count);
		break;
        case ARR_CHAR8:
		SQUEEZE_VALS(uint8_t, ARR_CHAR8, struct cell_array *,
		    get_scalar_int(t), release_array(t))
		break;
	case ARR_CHAR16:
		SQUEEZE_VALS(uint16_t, ARR_CHAR16, struct cell_array *,
		    get_scalar_int(t), release_array(t))
		squeeze_host_char16(arr, count);
	case ARR_CHAR32:
		SQUEEZE_VALS(uint32_t, ARR_CHAR32, struct cell_array *,
		    get_scalar_int(t), release_array(t))
		squeeze_host_char32(arr, count);
		break;
	case ARR_CMPX:{
		struct apl_cmpx *buf;
		
		buf = calloc(count, sizeof(struct apl_cmpx));
		
		if (buf == NULL)
			return 1;
		
		for (size_t i = 0; i < count; i ++) {
			buf[i] = get_scalar_cmpx(vals[i]);
			
			release_array(vals[i]);
		}
				
		free(arr->values);
		
		arr->values = buf;
		arr->type = ARR_CMPX;
		
		squeeze_host_cmpx(arr, count);
		break;
	}
	default:
		return 0;
	}
	
	return 0;
}

int
squeeze_host(struct cell_array *arr, size_t count)
{
	void *buf;
	int err;
	
	err = 0;
	
	switch (arr->type) {
	case ARR_SPAN:
        case ARR_BOOL:
        case ARR_CHAR8:
        case ARR_MIXED:
		break;
	case ARR_SINT:
		squeeze_host_sint(arr, count);
		break;
	case ARR_INT:
		squeeze_host_int(arr, count);
		break;
	case ARR_DBL:
		squeeze_host_dbl(arr, count);
		break;
	case ARR_CMPX:
		squeeze_host_cmpx(arr, count);
		break;
	case ARR_CHAR16:
		squeeze_host_char16(arr, count);
		break;
	case ARR_CHAR32:
		squeeze_host_char32(arr, count);
		break;
	case ARR_NESTED:
		err = squeeze_host_nested(arr, count);
		break;
	default:
		err = 99;
	}
	
	if (err)
		return err;
	
	buf = realloc(arr->values, array_values_bytes(arr));
	
	if (buf != NULL)
		arr->values = buf;
	
	return 0;
}

int
squeeze_device(struct cell_array *arr)
{
	af_dtype type;
	int err, is_num;
	double min_real, min_imag, max_real, max_imag;
	
	switch (arr->type) {
	case ARR_SPAN:
	case ARR_BOOL:
	case ARR_CHAR8:
	case ARR_MIXED:
	case ARR_NESTED:
		return 0;
	}
	
	if (err = af_min_all(&min_real, &min_imag, arr->values))
		return err;
	
	if (err = af_max_all(&max_real, &max_imag, arr->values))
		return err;
	
	if (min_imag != 0 || max_imag != 0)
		return 0;
	
	is_num = is_numeric(arr);
	type = arr->type;
		
	if (is_num && 0 <= min_real && max_real <= 1)
		arr->type = ARR_BOOL;
	else if (type == ARR_SINT)
		return 0;
	else if (!is_num && 0 <= min_real && max_real <= UINT8_MAX)
		arr->type = ARR_CHAR8;
	else if (type == ARR_CHAR16)
		return 0;
	else if (!is_num && 0 <= min_real && max_real <= UINT16_MAX)
		arr->type = ARR_CHAR16;
	else if (type == ARR_CHAR32)
		return 0;
	else if (INT16_MIN <= min_real && max_real <= INT16_MAX)
		arr->type = ARR_SINT;
	else if (type == ARR_INT)
		return 0;
	else if (INT32_MIN <= min_real && max_real <= INT32_MAX)
		arr->type = ARR_INT;
	else if (type == ARR_DBL)
		return 0;
	else
		arr->type = ARR_DBL;
	
	return af_cast(&arr->values, arr->values, array_af_dtype(arr));
}

int
squeeze_array(struct cell_array *arr)
{
	size_t count;
	int err;
	
	err = 0;
	count = array_count(arr);
	
	if (!count)
		return 0;
	
	switch (arr->storage) {
	case STG_HOST:
		err = squeeze_host(arr, count);
		break;
	case STG_DEVICE:
		err = squeeze_device(arr);
		break;
	default:
		err = 99;
	}
	
	return err;
}
