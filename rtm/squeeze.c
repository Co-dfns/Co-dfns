#include <float.h>
#include <limits.h>
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <arrayfire.h>

#include "internal.h"

enum array_type
closest_numeric_array_type(double x)
{
	if (0 <= x && x <= 1)
		return ARR_BOOL;
	
	if (INT16_MIN <= x && x <= INT16_MAX)
		return ARR_SINT;
	
	if (INT32_MIN <= x && x <= INT32_MAX)
		return ARR_INT;
	
	return ARR_DBL;
}

#define CAST_UNIT(vals, count, src_type, dst_type)	\
	for (size_t i = 0; i < (count); i++) {		\
		src_type t = ((src_type *)(vals))[i];	\
							\
		((dst_type *)(vals))[i] = (dst_type)t;	\
	}

#define CAST_CMPX(vals, count, dst_type)				\
	for (size_t i = 0; i < (count); i++) {				\
		struct apl_cmpx t = ((struct apl_cmpx *)(vals))[i];	\
									\
		((dst_type *)(vals))[i] = (dst_type)t.real;		\
	}

#define CAST_NESTED(arr, count, suffix, dst_type) {			\
	dst_type *dst;							\
	struct cell_array **src;					\
	int err;							\
									\
	src = (arr)->values;						\
	dst = calloc(count, sizeof(dst_type));				\
									\
	if (dst == NULL)						\
		return 1;						\
									\
	for (size_t i = 0; i < (count); i++) {				\
		if (err = get_scalar_##suffix(&dst[i], src[i])) {	\
			free(dst);					\
			return err;					\
		}							\
	}								\
									\
	for (size_t i = 0; i < (count); i++)				\
		release_array(src[i]);					\
									\
	free(src);							\
	(arr)->values = dst;						\
}

inline int
squeeze_values(struct cell_array *arr, size_t count, enum array_type type)
{
	void *buf;
	
	if (arr->storage == STG_DEVICE) {
		if (arr->type == ARR_NESTED)
			return 99;
		
		arr->type = type;
		
		return af_cast(&arr->values, arr->values, array_af_dtype(arr));
	}
	
	if (arr->storage != STG_HOST)
		return 99;

	switch (type_pair(arr->type, type)) {
	case type_pair(ARR_SINT,   ARR_BOOL   ):
		CAST_UNIT(arr->values, count, int16_t, int8_t);
		break;
	case type_pair(ARR_INT,    ARR_SINT   ):
		CAST_UNIT(arr->values, count, int32_t, int16_t);
		break;
	case type_pair(ARR_INT,    ARR_BOOL   ):
		CAST_UNIT(arr->values, count, int32_t, int8_t);
		break;
	case type_pair(ARR_DBL,    ARR_INT    ):
		CAST_UNIT(arr->values, count, double, int32_t);
		break;
	case type_pair(ARR_DBL,    ARR_SINT   ):
		CAST_UNIT(arr->values, count, double, int16_t);
		break;
	case type_pair(ARR_DBL,    ARR_BOOL   ):
		CAST_UNIT(arr->values, count, double, int8_t);
		break;
	case type_pair(ARR_CMPX,   ARR_DBL    ):
		CAST_CMPX(arr->values, count, double);
		break;
	case type_pair(ARR_CMPX,   ARR_INT    ):
		CAST_CMPX(arr->values, count, int32_t);
		break;
	case type_pair(ARR_CMPX,   ARR_SINT   ):
		CAST_CMPX(arr->values, count, int16_t);
		break;
	case type_pair(ARR_CMPX,   ARR_BOOL   ):
		CAST_CMPX(arr->values, count, int8_t);
		break;
	case type_pair(ARR_CHAR16, ARR_CHAR8  ):
		CAST_UNIT(arr->values, count, uint16_t, uint8_t);
		break;
	case type_pair(ARR_CHAR32, ARR_CHAR16 ):
		CAST_UNIT(arr->values, count, uint32_t, uint16_t);
		break;
	case type_pair(ARR_CHAR32, ARR_CHAR8  ):
		CAST_UNIT(arr->values, count, uint32_t, uint8_t);
		break;
	case type_pair(ARR_NESTED, ARR_CHAR32 ):
		CAST_NESTED(arr, count, char32, uint32_t);
		break;
	case type_pair(ARR_NESTED, ARR_CHAR16 ):
		CAST_NESTED(arr, count, char16, uint16_t);
		break;
	case type_pair(ARR_NESTED, ARR_CHAR8  ):
		CAST_NESTED(arr, count, char8, uint8_t);
		break;
	case type_pair(ARR_NESTED, ARR_CMPX   ):
		CAST_NESTED(arr, count, cmpx, struct apl_cmpx);
		break;
	case type_pair(ARR_NESTED, ARR_DBL    ):
		CAST_NESTED(arr, count, dbl, double);
		break;
	case type_pair(ARR_NESTED, ARR_INT    ):
		CAST_NESTED(arr, count, int, int32_t);
		break;
	case type_pair(ARR_NESTED, ARR_SINT   ):
		CAST_NESTED(arr, count, sint, int16_t);
		break;
	case type_pair(ARR_NESTED, ARR_BOOL   ):
		CAST_NESTED(arr, count, bool, int8_t);
		break;
	default:
		return 0;
	}
	
	arr->type = type;
	
	buf = realloc(arr->values, array_values_bytes(arr));
	
	if (buf != NULL)
		arr->values = buf;	
		
	return 0;
}

inline int
find_minmax(double *min, double *max, 
    unsigned char *is_real, unsigned char *is_int,
    struct cell_array *arr, size_t count)
{
	void *vals;
	
	vals = arr->values;
	
	if (arr->storage == STG_DEVICE) {
		int err;
		double real, imag;
		
		if (err = af_min_all(&real, &imag, vals))
			return err;
		
		*min = real;
		*is_real = (imag == 0);
		
		if (err = af_max_all(&real, &imag, vals))
			return err;
		
		*max = real;
		*is_real = (*is_real && (imag == 0));
		
		if (!*is_real) {
			*is_int = 0;
			return 0;
		}
		
		if (err = is_integer_device(is_int, vals))
			return err;
		
		return 0;
	}
	
	if (arr->storage != STG_HOST)
		return 99;
	
	*is_real = 1;
	*is_int = 1;
	*min = DBL_MAX;
	*max = DBL_MIN;
	
#define MINMAX_LOOP(type, tx, expr)		\
	for (size_t i = 0; i < count; i++) {	\
		type t = ((type *)vals)[i];	\
						\
		expr;				\
						\
		if (tx < *min)			\
			*min = tx;		\
		if (tx > *max)			\
			*max = tx;		\
	}
	
	switch (arr->type) {
	case ARR_BOOL:
		MINMAX_LOOP(int8_t,t,)
		break;
	case ARR_SINT:
		MINMAX_LOOP(int16_t,t,)
		break;
	case ARR_INT:
		MINMAX_LOOP(int32_t,t,)
		break;
	case ARR_CHAR8:
		MINMAX_LOOP(uint8_t,t,)
		break;
	case ARR_CHAR16:
		MINMAX_LOOP(uint16_t,t,)
		break;
	case ARR_CHAR32:
		MINMAX_LOOP(uint32_t,t,)
		break;
	case ARR_DBL:
		MINMAX_LOOP(double, t, *is_int = (*is_int && is_integer(t)))
		break;
	case ARR_CMPX:
		MINMAX_LOOP(struct apl_cmpx, t.real, {
			*is_int = (*is_int && is_integer(t.real));
			*is_real = (*is_real && (t.imag == 0));
		})
	default:
		return 99;
	}
		
	return 0;
}

int
squeeze_array(struct cell_array *arr)
{
	size_t count;
	double min_real, max_real;
	int err;
	unsigned char is_real, is_int;

	err = 0;
	count = array_count(arr);
	
	if (!count)
		return 0;
	
	if (arr->type == ARR_NESTED) {
		struct cell_array **vals = arr->values;
		enum array_type type = vals[0]->type;
		
		for (size_t i = 0; i < count; i++) {
			struct cell_array *t = vals[i];
			
			if (t->rank !=0 || t->type == ARR_NESTED)
				return 0;
			
			type = array_max_type(type, t->type);
		}
		
		if (err = squeeze_values(arr, count, type))
			return err;
		
		if (arr->type == ARR_NESTED)
			return 0;
	}
	
	switch (arr->type) {
	case ARR_SPAN:
	case ARR_BOOL:
	case ARR_CHAR8:
	case ARR_MIXED:
		return 0;
	case ARR_SINT:
	case ARR_INT:
	case ARR_DBL:
	case ARR_CMPX:
	case ARR_CHAR16:
	case ARR_CHAR32:
		break;
	default:
		return 99;
	}
	
	err = find_minmax(&min_real, &max_real, &is_real, &is_int, arr, count);
	
	if (err)
		return err;
	
	if (!is_real)
		return 0;
	
	if (!is_int)
		return squeeze_values(arr, count, ARR_DBL);
	
	if (is_char_array(arr)) {
		if (0 <= min_real && max_real <= UINT8_MAX)
			return squeeze_values(arr, count, ARR_CHAR8);
		
		if (0 <= min_real && max_real <= UINT16_MAX)
			return squeeze_values(arr, count, ARR_CHAR16);
		
		return 0;
	}
	
	if (0 <= min_real && max_real <= 1)
		return squeeze_values(arr, count, ARR_BOOL);
	
	if (INT16_MIN <= min_real && max_real <= INT16_MAX)
		return squeeze_values(arr, count, ARR_SINT);
	
	if (INT32_MIN <= min_real && max_real <= INT32_MAX)
		return squeeze_values(arr, count, ARR_INT);
	
	return squeeze_values(arr, count, ARR_DBL);
}
