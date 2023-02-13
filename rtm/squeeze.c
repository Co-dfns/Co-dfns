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

#define CAST_UNIT(count, src_type, dst_type) {	\
	src_type *src = arr->values;		\
	dst_type *dst = (dst_type *)buf;	\
						\
	for (size_t i = 0; i < (count); i++)	\
		dst[i] = (dst_type)src[i];	\
}						\

#define CAST_CMPX(count, dst_type) {		\
	struct apl_cmpx *src = arr->values;	\
	dst_type *dst = (dst_type *)buf;	\
						\
	for (size_t i = 0; i < (count); i++)	\
		dst[i] = (dst_type)src[i].real;	\
}						\

#define CAST_NESTED(count, suffix, dst_type) {				\
	struct cell_array **src = arr->values;				\
	dst_type *dst = (dst_type *)buf;				\
									\
	for (size_t i = 0; i < (count); i++)				\
		CHK(get_scalar_##suffix(&dst[i], src[i]), fail,		\
		    L"get_scalar_" L#suffix L"(&dst[i], src[i]");	\
}									\

inline int
cast_values(struct cell_array *arr, enum array_type type)
{
	size_t count, in_size, out_size, size;
	char *buf;
	int err, reuse;
	
	err = 0;
	
	if (arr->storage == STG_DEVICE) {
		af_dtype dtyp;
		af_array newv;
		
		if (arr->type == ARR_NESTED)
			return 99;
		
		arr->type = type;
		dtyp = array_af_dtype(arr);
		
		CHKAF(af_cast(&newv, arr->values, dtyp), done);
		CHK(release_array_data(arr), done,
		    L"release_array_data(arr)");
		
		arr->values = newv;
		goto done;
	}
	
	if (arr->storage != STG_HOST)
		return 99;
	
	count = array_values_count(arr);
	in_size = count * array_element_size(arr);
	out_size = count * array_element_size_type(type);
	reuse = *arr->vrefc == 1 && in_size >= out_size;
	
	if (arr->type == ARR_NESTED)
		reuse = 0;
	
	size = out_size;
	    
	buf = reuse ? arr->values : malloc(size + sizeof(int));
	CHK(buf == NULL, done, L"Failed to alloc squeeze buffer.");

	switch (type_pair(arr->type, type)) {
	case type_pair(ARR_SINT,   ARR_BOOL   ):
		CAST_UNIT(count, int16_t, int8_t);
		break;
	case type_pair(ARR_INT,    ARR_SINT   ):
		CAST_UNIT(count, int32_t, int16_t);
		break;
	case type_pair(ARR_INT,    ARR_BOOL   ):
		CAST_UNIT(count, int32_t, int8_t);
		break;
	case type_pair(ARR_DBL,    ARR_INT    ):
		CAST_UNIT(count, double, int32_t);
		break;
	case type_pair(ARR_DBL,    ARR_SINT   ):
		CAST_UNIT(count, double, int16_t);
		break;
	case type_pair(ARR_DBL,    ARR_BOOL   ):
		CAST_UNIT(count, double, int8_t);
		break;
	case type_pair(ARR_CMPX,   ARR_DBL    ):
		CAST_CMPX(count, double);
		break;
	case type_pair(ARR_CMPX,   ARR_INT    ):
		CAST_CMPX(count, int32_t);
		break;
	case type_pair(ARR_CMPX,   ARR_SINT   ):
		CAST_CMPX(count, int16_t);
		break;
	case type_pair(ARR_CMPX,   ARR_BOOL   ):
		CAST_CMPX(count, int8_t);
		break;
	case type_pair(ARR_CHAR16, ARR_CHAR8  ):
		CAST_UNIT(count, uint16_t, uint8_t);
		break;
	case type_pair(ARR_CHAR32, ARR_CHAR16 ):
		CAST_UNIT(count, uint32_t, uint16_t);
		break;
	case type_pair(ARR_CHAR32, ARR_CHAR8  ):
		CAST_UNIT(count, uint32_t, uint8_t);
		break;
	case type_pair(ARR_NESTED, ARR_CHAR32 ):
		CAST_NESTED(count, char32, uint32_t);
		break;
	case type_pair(ARR_NESTED, ARR_CHAR16 ):
		CAST_NESTED(count, char16, uint16_t);
		break;
	case type_pair(ARR_NESTED, ARR_CHAR8  ):
		CAST_NESTED(count, char8, uint8_t);
		break;
	case type_pair(ARR_NESTED, ARR_CMPX   ):
		CAST_NESTED(count, cmpx, struct apl_cmpx);
		break;
	case type_pair(ARR_NESTED, ARR_DBL    ):
		CAST_NESTED(count, dbl, double);
		break;
	case type_pair(ARR_NESTED, ARR_INT    ):
		CAST_NESTED(count, int, int32_t);
		break;
	case type_pair(ARR_NESTED, ARR_SINT   ):
		CAST_NESTED(count, sint, int16_t);
		break;
	case type_pair(ARR_NESTED, ARR_BOOL   ):
		CAST_NESTED(count, bool, int8_t);
		break;
	default:
		return 0;
	}
	
	arr->type = type;
	
	if (reuse) {
		buf = realloc(buf, size + sizeof(int));
		CHK(buf == NULL, done, L"Failed to realloc squeeze.");
	} else {
		CHK(release_array_data(arr), fail,
		    L"release_array_data(arr)");
	}
	
	arr->values = buf;
	arr->vrefc = (unsigned int *)(buf + size);
	*arr->vrefc = 1;
	
done:
	return err;
	
fail:
	free(buf);
	return err;
}

inline int
find_minmax(double *min, double *max, 
    unsigned char *is_real, unsigned char *is_int, struct cell_array *arr)
{
	size_t count;
	void *vals;
	
	count = array_values_count(arr);
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
		MINMAX_LOOP(double, t, *is_int = (*is_int && is_integer_dbl(t)))
		break;
	case ARR_CMPX:
		MINMAX_LOOP(struct apl_cmpx, t.real, {
			*is_int = (*is_int && is_integer_dbl(t.real));
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
		
		if (err = cast_values(arr, type))
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
	
	err = find_minmax(&min_real, &max_real, &is_real, &is_int, arr);
	
	if (err)
		return err;
	
	if (!is_real)
		return 0;
	
	if (!is_int)
		return cast_values(arr, ARR_DBL);
	
	if (is_char_array(arr)) {
		if (0 <= min_real && max_real <= UINT8_MAX)
			return cast_values(arr, ARR_CHAR8);
		
		if (0 <= min_real && max_real <= UINT16_MAX)
			return cast_values(arr, ARR_CHAR16);
		
		return 0;
	}
	
	if (0 <= min_real && max_real <= 1)
		return cast_values(arr, ARR_BOOL);
	
	if (INT16_MIN <= min_real && max_real <= INT16_MAX)
		return cast_values(arr, ARR_SINT);
	
	if (INT32_MIN <= min_real && max_real <= INT32_MAX)
		return cast_values(arr, ARR_INT);
	
	return cast_values(arr, ARR_DBL);
}
