#include <float.h>
#include <limits.h>
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
	return array_values_count(arr) * array_element_size(arr);
}

af_dtype
array_type_af_dtype(enum array_type type)
{
	switch (type) {
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

af_dtype
array_af_dtype(struct cell_array *arr)
{
	return array_type_af_dtype(arr->type);
}

size_t
array_static_avail(struct cell_array *arr)
{
	if (arr->rank > STATIC_RANK_MAX)
		return 0;
	
	return sizeof(size_t) * (STATIC_RANK_MAX - arr->rank);
}

size_t mk_array_count = 0;
size_t free_array_count = 0;

DECLSPEC int
mk_array(struct cell_array **dest,
    enum array_type type, enum array_storage storage, unsigned int rank)
{
	struct		cell_array *arr;
	size_t		size;
	
	mk_array_count++;
	
	size = sizeof(*arr);
	
	if (rank > STATIC_RANK_MAX)
		size += sizeof(size_t) * (rank - STATIC_RANK_MAX);
	
	arr = malloc(size);

	if (arr == NULL)
		return 1;

	arr->ctyp	= CELL_ARRAY;
	arr->refc	= 1;
	arr->type	= type;
	arr->storage	= storage;
	arr->rank	= rank;
	arr->values	= NULL;
	arr->vrefc	= NULL;

	*dest = arr;

	return 0;
}

size_t alloc_array_malloc_count = 0;

DECLSPEC int
alloc_array(struct cell_array *arr)
{
	size_t count, size;
	char *buf;
	af_dtype dtype;
	int err;
	
	count = array_values_count(arr);
	
	if (arr->values != NULL)
		CHK(99, done, "Trying to allocate pre-allocated array.");
		
	switch (arr->storage) {
	case STG_DEVICE:
		dtype = array_af_dtype(arr);
		err = af_create_handle(&arr->values, 1, &count, dtype);
		break;
	case STG_HOST:
		size = count * array_element_size(arr);
		
		if (size <= array_static_avail(arr)) {
			buf = (char *)(arr->shape + arr->rank);
			arr->vrefc = NULL;
			
			memset(buf, 0, size);
		} else {
			alloc_array_malloc_count++;
			buf = malloc(size + sizeof(int));
			
			if (buf == NULL) {
				err = 1;
				break;
			}
			
			memset(buf, 0, size + sizeof(int));
			
			arr->vrefc = (unsigned int *)(buf + size);
			*arr->vrefc = 1;
		}
		
		err = 0;
		arr->values = buf;
		
		break;
	default:
		err = 99;
	}

done:	
	return err;
}

DECLSPEC int
fill_array(struct cell_array *arr, void *data)
{
	size_t	size;
	int	err;
	
	if (arr->values == NULL) {
		if (err = alloc_array(arr))
			return err;
	}

	size	= array_values_count(arr) * array_element_size(arr);

	switch (arr->storage) {
	case STG_DEVICE:
		err = af_write_array(arr->values, data, size, afHost);
		break;
	case STG_HOST:
		memcpy(arr->values, data, size);
		err = 0;
		break;
	default:
		err = 99;
	}

	return err;
}

int
retain_array_data(struct cell_array *arr)
{
	int err;
	
	err = 0;
	
	if (arr == NULL)
		goto done;
	
	if (arr->values == NULL)
		goto done;
	
	switch (arr->storage) {
	case STG_DEVICE:
		CHKAF(af_retain_array(&arr->values, arr->values), done);
		break;
	case STG_HOST:
		if (arr->vrefc == NULL)
			CHK(99, done, "Cannot retain static values.");
		
		++*arr->vrefc;
		break;
	default:
		CHK(99, done, "Unknown storage device");		
	}
	
done:
	return err;
}

int
release_device_data(struct cell_array *arr)
{
	int err;
	
	CHKAF(af_release_array(arr->values), done);
	
	arr->values = NULL;
	arr->vrefc = NULL;

done:
	return err;
}

int
release_host_data(struct cell_array *arr)
{
	unsigned int *refc;
	int err;
	
	err = 0;	
	refc = arr->vrefc;
	
	if (!refc)
		goto release_nested;
	
	if (!*refc)
		goto done;
	
	--*refc;
	
	if (*refc)
		goto done;

release_nested:
	if (arr->type == ARR_NESTED) {
		size_t count = array_values_count(arr);
		struct cell_array **ptrs = arr->values;

		for (size_t i = 0; i < count; i++)
			CHK(release_array(ptrs[i]), done,
			    "Failed to release nested value");
	}

	if (refc)
		free(arr->values);
	
done:
	arr->values = NULL;
	arr->vrefc = NULL;
	
	return err;
}

int
release_array_data(struct cell_array *arr)
{	
	switch (arr->storage) {
	case STG_DEVICE:
		return release_device_data(arr);
	case STG_HOST:
		return release_host_data(arr);
	default:
		return 99;
	}
}

DECLSPEC int
release_array(struct cell_array *arr)
{
	int err;

	if (arr == NULL)
		return 0;

	if (!arr->refc)
		return 0;

	arr->refc--;

	if (arr->refc)
		return 0;

	if (arr->values)
		CHKFN(release_array_data(arr), fail);

	free_array_count++;
	
	free(arr);
	
	return 0;

fail:
	return err;
}

int
array_share_values(struct cell_array *out, struct cell_array *in)
{
	int err = 0;
	
	if (in->storage == STG_HOST && in->vrefc == NULL) {
		CHKFN(alloc_array(out), fail);
		
		memcpy(out->values, in->values, array_values_bytes(in));
		
		if (out->type == ARR_NESTED) {
			size_t count = array_values_count(out);
			struct cell_array **ptrs = out->values;
			
			for (size_t i = 0; i < count; i++)
				retain_cell(ptrs[i]);
		}
	} else {
		out->values = in->values;
		out->vrefc = in->vrefc;		
		CHKFN(retain_array_data(out), fail);
	}	
	
fail:
	return err;
}

int
array_shallow_copy(struct cell_array **out, struct cell_array *in)
{
	struct cell_array *arr;
	int err;
	
	arr = NULL;
	
	CHKFN(mk_array(&arr, in->type, in->storage, in->rank), fail);
	
	for (unsigned int i = 0; i < in->rank; i++)
		arr->shape[i] = in->shape[i];
	
	CHKFN(array_share_values(arr, in), fail);
	
	*out = arr;
	
fail:
	if (err)
		free(arr);
	
	return err;
}

int
chk_array_valid(struct cell_array *arr) {
	int err;
	
	CHK(!arr, fail, "NULL array");
	CHK(arr->ctyp >= CELL_MAX, fail, "Invalid cell type");
	CHK(arr->refc == 0, fail, "Zero array refcount");
	CHK(arr->storage >= STG_MAX, fail, "Invalid storage type");
	CHK(arr->type >= ARR_MAX, fail, "Invalid element type");
	
	if (arr->type == ARR_SPAN)
		return 0;
	
	CHK(arr->values == NULL, fail, "NULL values");
	
	if (arr->storage == STG_HOST && arr->vrefc) {
		CHK(*arr->vrefc == 0, fail, "Zero values refcount");
	}
	
	return 0;
	
fail:
	return 99;
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

int
is_integer_dbl(double x)
{
	return rint(x) == x;
}

int
is_integer_device(unsigned char *res, af_array vals)
{
	af_array t, u;
	double real, imag;
	int err;
	unsigned char is_int;
	
	t = u = NULL;
	
	CHKAF(af_is_integer(&is_int, vals), fail);
	
	if (is_int) {
		*res = 1;
		return 0;
	}
	
	CHKAF(af_trunc(&t, vals), fail);
	CHKAF(af_eq(&u, t, vals, 0), fail);
	CHKAF(af_all_true_all(&real, &imag, u), fail);
	
	*res = (int)real;

fail:
	af_release_array(u);
	af_release_array(t);
	
	return err;
}

int
has_integer_values(int *res, struct cell_array *arr)
{
	size_t count;
	double *vals;
	int err;
	unsigned char is_int;
	
	if (!is_numeric_array(arr)) {
		*res = 0;
		return 0;
	}
	
	if (arr->type == ARR_CMPX)
		if (err = squeeze_array(arr))
			return err;

	if (arr->type == ARR_CMPX) {
		*res = 0;
		return 0;
	}

	if (arr->type < ARR_DBL) {
		*res = 1;
		return 0;
	}
	
	if (arr->storage == STG_DEVICE) {
		if (err = is_integer_device(&is_int, arr->values))
			return err;
		
		*res = is_int;
		
		return 0;
	}
	
	if (arr->storage != STG_HOST)
		return 99;
	
	vals = arr->values;
	count = array_count(arr);
	
	for (size_t i = 0; i < count; i++) {
		if (!is_integer_dbl(vals[i])) {
			*res = 0;
			return 0;
		}
	}
	
	*res = 1;
	
	return 0;
}

int
has_natural_values(int *res, struct cell_array *arr)
{
	size_t count;
	int err, is_int;
	
	CHK(has_integer_values(&is_int, arr), done,
	    "has_integer_values(&is_int, arr)");
	
	if (!is_int) {
		*res = 0;
		return 0;
	}
	
	if (arr->storage == STG_DEVICE) {
		af_array t;
		double real, imag;
		
		CHKAF(af_sign(&t, arr->values), done);
		CHKAF(af_any_true_all(&real, &imag, t), done);
		CHKAF(af_release_array(t), done);
		
		*res = !real;

		return 0;
	}
	
	count = array_count(arr);
	
#define NATURAL_CASE(tp) {			\
	tp *vals = arr->values;			\
						\
	for (size_t i = 0; i < count; i++) {	\
		if (vals[i] < 0) {		\
			*res = 0;		\
			return 0;		\
		}				\
	}					\
	break;					\
}

	switch (arr->type) {
	case ARR_BOOL:NATURAL_CASE(int8_t)
	case ARR_SINT:NATURAL_CASE(int16_t)
	case ARR_INT:NATURAL_CASE(int32_t)
	case ARR_DBL:NATURAL_CASE(double)
	default:
		TRC(99, "Unexpected array type");
	}
	
	*res = 1;

done:	
	return err;
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
get_scalar_data(void **val, void *buf, struct cell_array *arr, size_t i)
{
	int err;
	
	err = 0;
	
	switch (arr->storage) {
	case STG_DEVICE:
		if (i)
			CHK(99, fail, "Cannot index beyond first element of device buffer");
		
		CHKAF(af_get_scalar(buf, arr->values), fail);
		
		*val = buf;
		break;
	case STG_HOST:
		*val = arr->values;
		break;
	default:
		CHK(99, fail, "Unknown storage type");
	}

fail:
	return err;
}

#define DEFN_GET_SCALAR_NUM(name, ztype)			\
int                                                             \
name(ztype *dst, struct cell_array *arr, size_t i)              \
{                                                               \
	char buf[16];                                           \
	void *val;                                              \
	int err;                                                \
								\
	CHKFN(get_scalar_data(&val, buf, arr, i), fail);	\
								\
	switch (arr->type) {                                    \
	case ARR_BOOL:                                          \
		*dst = (ztype)((int8_t *)val)[i];               \
		break;                                          \
	case ARR_SINT:                                          \
		*dst = (ztype)((int16_t *)val)[i];              \
		break;                                          \
	case ARR_INT:                                           \
		*dst = (ztype)((int32_t *)val)[i];              \
		break;                                          \
	case ARR_DBL:                                           \
		*dst = (ztype)((double *)val)[i];               \
		break;                                          \
	case ARR_CMPX:                                          \
		*dst = (ztype)((struct apl_cmpx *)val)[i].real; \
		break;                                          \
	case ARR_CHAR8:                                         \
	case ARR_CHAR16:                                        \
	case ARR_CHAR32:                                        \
	case ARR_SPAN:                                          \
	case ARR_MIXED:                                         \
	case ARR_NESTED:                                        \
	default:                                                \
		return 99;                                      \
	}                                                       \
								\
fail:								\
	return err;	                                        \
}                                                               \

DEFN_GET_SCALAR_NUM(get_scalar_int8, int8_t)
DEFN_GET_SCALAR_NUM(get_scalar_int16, int16_t)
DEFN_GET_SCALAR_NUM(get_scalar_int32, int32_t)
DEFN_GET_SCALAR_NUM(get_scalar_dbl, double)
DEFN_GET_SCALAR_NUM(get_scalar_u64, uint64_t)

int
get_scalar_cmpx(struct apl_cmpx *dst, struct cell_array *arr, size_t i)
{
	char buf[16];
	void *val;
	int err;
	
	CHKFN(get_scalar_data(&val, buf, arr, i), fail);
	
	switch (arr->type) {
	case ARR_BOOL:
		(*dst).real = (double)((int8_t *)val)[i];
		(*dst).imag = 0;
		break;
	case ARR_SINT:
		(*dst).real = (double)((int16_t *)val)[i];
		(*dst).imag = 0;
		break;
	case ARR_INT:
		(*dst).real = (double)((int32_t *)val)[i];
		(*dst).imag = 0;
		break;
	case ARR_DBL:
		(*dst).real = (double)((double *)val)[i];
		(*dst).imag = 0;
		break;
	case ARR_CMPX:
		*dst = ((struct apl_cmpx *)val)[i];
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

fail:
	return err;
}

#define DEFN_GET_SCALAR_CHAR(name, ztype)		\
int                                                     \
name(ztype *dst, struct cell_array *arr, size_t i)      \
{                                                       \
	char buf[16];                                   \
	void *val;                                      \
	int err;                                        \
							\
	CHKFN(get_scalar_data(&val, buf, arr, i), fail);\
							\
	switch (arr->type) {                            \
	case ARR_CHAR8:                                 \
		*dst = (ztype)((uint8_t *)val)[i];      \
		break;                                  \
	case ARR_CHAR16:                                \
		*dst = (ztype)((uint16_t *)val)[i];     \
		break;                                  \
	case ARR_CHAR32:                                \
		*dst = (ztype)((uint32_t *)val)[i];     \
		break;                                  \
	case ARR_BOOL:                                  \
	case ARR_SINT:                                  \
	case ARR_INT:                                   \
	case ARR_DBL:                                   \
	case ARR_CMPX:                                  \
	case ARR_SPAN:                                  \
	case ARR_MIXED:                                 \
	case ARR_NESTED:                                \
	default:                                        \
		return 99;                              \
	}                                               \
							\
fail:							\
	return err;                                     \
}                                                       \

DEFN_GET_SCALAR_CHAR(get_scalar_char8, uint8_t)
DEFN_GET_SCALAR_CHAR(get_scalar_char16, uint16_t)
DEFN_GET_SCALAR_CHAR(get_scalar_char32, uint32_t)

#define DEFN_MKARRAY(name, atype, ctype)		\
int							\
name(struct cell_array **z, ctype val)			\
{							\
	struct cell_array *t;				\
	int err;					\
							\
	if (err = mk_array(&t, atype, STG_HOST, 0))	\
		return err;				\
							\
	if (err = alloc_array(t))			\
		return err;				\
							\
	*(ctype *)t->values = val;			\
							\
	*z = t;						\
							\
	return 0;					\
}

DEFN_MKARRAY(mk_array_int8, ARR_BOOL, int8_t)
DEFN_MKARRAY(mk_array_int16, ARR_SINT, int16_t)
DEFN_MKARRAY(mk_array_int32, ARR_INT, int32_t)
DEFN_MKARRAY(mk_array_dbl, ARR_DBL, double)
DEFN_MKARRAY(mk_array_cmpx, ARR_CMPX, struct apl_cmpx)
DEFN_MKARRAY(mk_array_char8, ARR_CHAR8, uint8_t)
DEFN_MKARRAY(mk_array_char16, ARR_CHAR16, uint16_t)
DEFN_MKARRAY(mk_array_char32, ARR_CHAR32, uint32_t)

int
mk_array_real(struct cell_array **z, double real)
{
	double abv;

	if (!is_integer_dbl(real))
		return mk_array_dbl(z, real);
	
	abv = fabs(real);
	
	if (abv <= 1)
		return mk_array_int8(z, (int8_t)real);
	
	if (abv <= INT16_MAX)
		return mk_array_int16(z, (int16_t)real);
	
	if (abv <= INT32_MAX)
		return mk_array_int32(z, (int32_t)real);
	
	return mk_array_dbl(z, real);
}

int
mk_array_nested(struct cell_array **z, struct cell_array *val)
{
	*z = retain_cell(val);
	
	return 0;
}

int
array_get_host_buffer(void **res, int *flag, struct cell_array *arr)
{
	void *buf;
	int err;
	
	if (arr->storage == STG_HOST) {
		*res = arr->values;
		*flag = 0;
		
		return 0;
	}
	
	buf = malloc(array_values_count(arr) * array_element_size(arr));
	
	CHK(buf == NULL, fail, "Failed to allocate buffer");
	
	CHKAF(af_eval(arr->values), fail);
	CHKAF(af_get_data_ptr(buf, arr->values), fail);
	
	*res = buf;
	*flag = 1;
	
fail:
	if (err)
		free(buf);
	
	return err;
}

int
cmpx_eq(struct apl_cmpx x, struct apl_cmpx y)
{
	return (x.real == y.real) && (x.imag == y.imag);
}

int
array_migrate_storage(struct cell_array *arr, enum array_storage stg)
{
	af_array t;
	size_t count;
	int err;
	
	if (arr->storage == stg)
		return 0;
	
	if (arr->type == ARR_NESTED && stg == STG_DEVICE)
		CHK(99, fail, "Cannot migrate nested array to device.");
	
	if (arr->type == ARR_MIXED)
		CHK(16, fail, "Cannot migrate mixed arrays right now.");
	
	if (arr->type == ARR_SPAN)
		return 0;
	
	count = array_values_count(arr);
	
	if (stg == STG_DEVICE) {
		af_dtype dtp;
		
		dtp = array_af_dtype(arr);
		
		CHKAF(af_create_array(&t, arr->values, 1, &count, dtp), fail);
		CHKFN(release_host_data(arr), fail);
		
		arr->values = t;
		arr->storage = STG_DEVICE;
		
		return 0;
	}
	
	if (stg != STG_HOST)
		CHK(99, fail, "Unexpected storage type.");
	
	t = arr->values;
	arr->storage = STG_HOST;
	arr->values = NULL;
	
	CHKFN(alloc_array(arr), fail);
	CHKAF(af_eval(t), fail);
	CHKAF(af_get_data_ptr(arr->values, t), fail);
	CHKAF(af_release_array(t), fail);
	
fail:
	return err;
}

int
array_promote_storage(struct cell_array *l, struct cell_array *r)
{
	enum array_storage stg;
	int err;
	
	CHKFN(squeeze_array(l), fail);
	CHKFN(squeeze_array(r), fail);
	
	stg = STG_HOST;
	
	if (r->type == ARR_NESTED || l->type == ARR_NESTED)
		stg = STG_HOST;
	else if (l->storage == STG_DEVICE || r->storage == STG_DEVICE)
		stg = STG_DEVICE;
	else if (array_count(l) > STORAGE_DEVICE_THRESHOLD)
		stg = STG_DEVICE;
	else if (array_count(r) > STORAGE_DEVICE_THRESHOLD)
		stg = STG_DEVICE;
	
	CHKFN(array_migrate_storage(r, stg), fail);
	CHKFN(array_migrate_storage(l, stg), fail);
	
fail:
	return err;
}

int
array_is_same(int8_t *is_same, struct cell_array *l, struct cell_array *r)
{
	size_t count;
	int err;
	
	if (l == r) {
		*is_same = 1;
		return 0;
	}
	
	if (l->rank != r->rank) {
		*is_same = 0;
		return 0;
	}
	
	for (unsigned int i = 0; i < l->rank; i++) {
		if (l->shape[i] != r->shape[i]) {
			*is_same = 0;
			return 0;
		}
	}
	
	if (is_char_array(l) != is_char_array(r)) {
		*is_same = 0;
		return 0;
	}
	
	if ((l->type == ARR_NESTED) != (r->type == ARR_NESTED)) {
		*is_same = 0;
		return 0;
	}
	
	if ((l->type == ARR_SPAN) != (r->type == ARR_SPAN)) {
		*is_same = 0;
		return 0;
	}
	
	if (l->type == ARR_SPAN) {
		*is_same = 1;
		return 0;
	}
	
	if (l->type == ARR_MIXED || r->type == ARR_MIXED) {
		return 16;
	}
	
	if (err = array_promote_storage(l, r))
		return err;
	
	if (l->type != r->type) {
		*is_same = 0;
		return 0;
	}
	
	if (l->storage == STG_DEVICE) {
		af_array t;
		double real, imag;
		
		if (err = af_neq(&t, l->values, r->values, 0))
			return err;
		
		if (err = af_any_true_all(&real, &imag, t))
			return err;
		
		if (err = af_release_array(t))
			return err;
		
		*is_same = !real;
		return 0;
	}
	
	if (l->storage != STG_HOST)
		return 99;

	count = array_values_count(l);

	if (l->type == ARR_NESTED) {
		struct cell_array **lvals, **rvals;
		
		lvals = l->values;
		rvals = r->values;
		
		for (size_t i = 0; i < count; i++) {
			int8_t f;
			
			if (err = array_is_same(&f, lvals[i], rvals[i]))
				return err;
			
			if (!f) {
				*is_same = 0;
				return 0;
			}
		}
		
		*is_same = 1;
		return 0;
	}
	
	if (l->type == ARR_CMPX) {
		struct apl_cmpx *lvals = l->values;
		struct apl_cmpx *rvals = r->values;
		
		for (size_t i = 0; i < count; i++) {
			if (!cmpx_eq(lvals[i], rvals[i])) {
				*is_same = 0;
				return 0;
			}
		}
		
		*is_same = 1;
		return 0;
	}
	
#define ARRAY_SAME_LOOP(type) {			\
	type *lvals = l->values;		\
	type *rvals = r->values;		\
						\
	for (size_t i = 0; i < count; i++) {	\
		if (lvals[i] != rvals[i]) {	\
			*is_same = 0;		\
			return 0;		\
		}				\
	}					\
}

	switch (l->type) {
	case ARR_BOOL:  ARRAY_SAME_LOOP(int8_t);   break;
	case ARR_SINT:  ARRAY_SAME_LOOP(int16_t);  break;
	case ARR_INT:   ARRAY_SAME_LOOP(int32_t);  break;
	case ARR_DBL:   ARRAY_SAME_LOOP(double);   break;
	case ARR_CHAR8: ARRAY_SAME_LOOP(uint8_t);  break;
	case ARR_CHAR16:ARRAY_SAME_LOOP(uint16_t); break;
	case ARR_CHAR32:ARRAY_SAME_LOOP(uint32_t); break;
	default:
		return 99;
	}
	
	*is_same = 1;
	return 0;
}

struct apl_cmpx
cast_cmpx(double x)
{
	struct apl_cmpx z = {x, 0};
	
	return z;
}

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

int
cast_values_device(struct cell_array *arr, enum array_type type)
{
	af_array newv, v;
	int err;
	unsigned char is_cmpx;
	
	if (type == ARR_NESTED)
		CHK(99, fail, "Cannot cast device array to nested type.");
	
	is_cmpx = 0;
	v = NULL;
	
	CHKAF(af_is_complex(&is_cmpx, arr->values), fail);
	
	if (is_cmpx) {
		CHKAF(af_real(&v, arr->values), fail);
	} else {
		v = arr->values;
	}
	
	CHKAF(af_cast(&newv, v, array_type_af_dtype(type)), fail);
	CHKFN(release_array_data(arr), fail);
	
	arr->type = type;
	arr->values = newv;
	
	err = 0;
	
fail:
	if (is_cmpx)
		af_release_array(v);
		
	return err;
}

int
cast_values_host(struct cell_array *arr, enum array_type out_type)
{
	size_t count, in_size, out_size, static_buf[STATIC_RANK_MAX];
	char *out, *in;
	int err, reuse;
	unsigned int *in_vrefc;
	enum array_type in_type;
	
	err = 0;
	
	in_type = arr->type;
	in_vrefc = arr->vrefc;
	in = arr->values;
	
	count = array_values_count(arr);
	in_size = count * array_element_size_type(in_type);
	out_size = count * array_element_size_type(out_type);

	reuse = (!in_vrefc || *arr->vrefc == 1) && in_size >= out_size;
	
	if (arr->type == ARR_NESTED)
		reuse = 0;
	
	if (reuse) {
		arr->type = out_type;
	} else if (!in_vrefc) {
		in = (char *)static_buf;
		memcpy(in, arr->values, in_size);
		
		arr->values = NULL;
		arr->type = out_type;
		CHKFN(alloc_array(arr), fail);
	} else {
		arr->values = NULL;
		arr->vrefc = NULL;
		
		arr->type = out_type;
		CHKFN(alloc_array(arr), fail);
	}
	
	out = arr->values;

	#define CAST_FAIL(ts, as, fail) \
		CHK(99, fail, "Cannot cast" as " to " ts);
	#define CAST_LOOP(stmt, tt, at) {			\
		at *rv = (at *)in;				\
		tt *tv = (tt *)out;				\
								\
		for (size_t i = 0; i < count; i++)		\
			stmt;					\
	}	
	#define CAST_SCL(oper, tt, at) CAST_LOOP(tv[i] = oper(rv[i]), tt, at)
	#define CAST_CELL(oper, tt, at, fail) \
		CAST_LOOP(CHKFN(oper, fail), tt, at)
	#define CAST_real_real(ts, tt, as, at, fail) CAST_SCL((tt), tt, at)
	#define CAST_real_cmpx(ts, tt, as, at, fail) CAST_SCL((tt)cast_real_cmpx, tt, at)
	#define CAST_real_char(ts, tt, as, at, fail) CAST_FAIL(#ts, #as, fail)
	#define CAST_real_cell(ts, tt, as, at, fail) CAST_CELL(get_scalar_##ts(&tv[i], rv[i], 0), tt, at, fail)
	#define CAST_cmpx_real(ts, tt, as, at, fail) CAST_SCL(cast_cmpx_real, tt, at)
	#define CAST_cmpx_cmpx(ts, tt, as, at, fail) CAST_SCL(, tt, at)
	#define CAST_cmpx_char(ts, tt, as, at, fail) CAST_FAIL(#ts, #as, fail)
	#define CAST_cmpx_cell(ts, tt, as, at, fail) CAST_CELL(get_scalar_##ts(&tv[i], rv[i], 0), tt, at, fail)
	#define CAST_char_real(ts, tt, as, at, fail) CAST_FAIL(#ts, #as, fail)
	#define CAST_char_cmpx(ts, tt, as, at, fail) CAST_FAIL(#ts, #as, fail)
	#define CAST_char_char(ts, tt, as, at, fail) CAST_SCL((tt), tt, at)
	#define CAST_char_cell(ts, tt, as, at, fail) CAST_CELL(get_scalar_##ts(&tv[i], rv[i], 0), tt, at, fail)
	#define CAST_cell_real(ts, tt, as, at, fail) CAST_CELL(mk_array_##as(&tv[i], rv[i]), tt, at, fail)
	#define CAST_cell_cmpx(ts, tt, as, at, fail) CAST_CELL(mk_array_##as(&tv[i], rv[i]), tt, at, fail)
	#define CAST_cell_char(ts, tt, as, at, fail) CAST_CELL(mk_array_##as(&tv[i], rv[i]), tt, at, fail)
	#define CAST_cell_cell(ts, tt, as, at, fail) CAST_SCL(, tt, at)
	#define CAST_SWITCH(op, ak, at, as, tk, tt, ts, fail) \
		CAST_##tk##_##ak(ts, tt, as, at, fail)
	
	DYADIC_TYPE_SWITCH(in_type, out_type, CAST_SWITCH, , fail);

	if (reuse && arr->vrefc) {
		out = realloc(out, out_size + sizeof(int));
		CHK(out == NULL, fail, "Failed to realloc squeeze.");
		
		arr->values = out;
		arr->vrefc = (unsigned int *)(out + out_size);
		*arr->vrefc = 1;
	} else {
		void *out_vrefc = arr->vrefc;
		
		arr->type = in_type;
		arr->values = in;
		arr->vrefc = in_vrefc;
	
		CHKFN(release_array_data(arr), fail);
		
		arr->type = out_type;
		arr->values = out;
		arr->vrefc = out_vrefc;
	}
	
	return err;
	
fail:
	if (!reuse) {
		release_array_data(arr);
		arr->type = in_type;
		arr->values = in;
		arr->vrefc = in_vrefc;
	}
	
	return err;
}

int
cast_values(struct cell_array *arr, enum array_type type)
{
	int err;
	
	if (arr->type == type)
		return 0;
	
	if (type == ARR_MIXED) {
		CHKFN(array_migrate_storage(arr, STG_HOST), fail);
		CHKFN(cast_values(arr, ARR_NESTED), fail);
		
		return 0;
	}
	
	switch (arr->storage) {
	case STG_DEVICE:
		CHKFN(cast_values_device(arr, type), fail);
		break;
	case STG_HOST:
		CHKFN(cast_values_host(arr, type), fail);
		break;
	default:
		CHK(99, fail, "Unexpected storage type.");
	}

fail:
	return err;
}

int
find_minmax(double *min, double *max, 
    unsigned char *is_real, unsigned char *is_int, struct cell_array *arr)
{
	size_t count;
	void *vals;
	int err;
	
	count = array_values_count(arr);
	vals = arr->values;
	*is_real = 1;
	*is_int = 1;
	*min = DBL_MAX;
	*max = DBL_MIN;
	
	if (arr->storage == STG_DEVICE) {
		double real, imag;
		unsigned char is_cmpx;

		CHKAF(af_is_complex(&is_cmpx, vals), fail);
		
		if (is_cmpx) {
			af_array t, u;
			
			t = u = NULL;
			
			CHKAF(af_imag(&t, vals), cmpx_done);
			CHKAF(af_iszero(&u, t), cmpx_done);
			CHKAF(af_all_true_all(&real, &imag, u), cmpx_done);
			
			*is_real = (real == 1);
			
		cmpx_done:
			af_release_array(t);
			af_release_array(u);
			
			if (err)
				return err;
			
			if (!*is_real) {
				*is_int = 0;
				return 0;
			}
		}
		
		CHKAF(af_min_all(&real, &imag, vals), fail);
		
		*min = real;
		
		CHKAF(af_max_all(&real, &imag, vals), fail);
		
		*max = real;
		
		CHKFN(is_integer_device(is_int, vals), fail);
		
		return 0;
	}
	
	if (arr->storage != STG_HOST)
		CHK(99, fail, "Expected host storage");
	
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
		break;
	default:
		CHK(99, fail, "Unexpected array type");
	}
	
	return 0;

fail:
	return err;
}

DECLSPEC int
squeeze_array(struct cell_array *arr)
{
	size_t count;
	double min_real, max_real;
	int err;
	unsigned char is_real, is_int;
	
	count = array_count(arr);
	
	if (!count)
		return 0;
	
	if (arr->type == ARR_NESTED) {
		struct cell_array **vals = arr->values;
		enum array_type type = vals[0]->type;
		
		for (size_t i = 0; i < count; i++) {
			struct cell_array *t = vals[i];
			
			CHKFN(squeeze_array(t), fail);
			
			if (t->rank != 0 || t->type == ARR_NESTED ||
			    t->type == ARR_SPAN)
				return 0;
			
			type = array_max_type(type, t->type);
		}
		
		CHKFN(cast_values(arr, type), fail);
		
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
	
	CHKFN(find_minmax(&min_real, &max_real, &is_real, &is_int, arr),
	    fail);
	
	if (!is_real)
		return 0;
	
	if (!is_int) {
		CHKFN(cast_values(arr, ARR_DBL), fail);
		return err;
	}
	
	if (is_char_array(arr)) {
		if (0 <= min_real && max_real <= UINT8_MAX) {
			CHKFN(cast_values(arr, ARR_CHAR8), fail);
			return err;
		}
		
		if (0 <= min_real && max_real <= UINT16_MAX) {
			CHKFN(cast_values(arr, ARR_CHAR16), fail);
			return err;
		}
		
		return 0;
	}
	
	if (0 <= min_real && max_real <= 1) {
		CHKFN(cast_values(arr, ARR_BOOL), fail);
		return err;
	}
	
	if (INT16_MIN <= min_real && max_real <= INT16_MAX) {
		CHKFN(cast_values(arr, ARR_SINT), fail);
		return err;
	}
	
	if (INT32_MIN <= min_real && max_real <= INT32_MAX) {
		CHKFN(cast_values(arr, ARR_INT), fail);
		return err;
	}
	
	CHKFN(cast_values(arr, ARR_DBL), fail);
	
fail:
	return err;
}

void
print_array_stats(void)
{
	printf("\tarrays alloc: %zd freed: %zd\n", 
	    mk_array_count, free_array_count);
	printf("\talloc_array_malloc_count: %zd\n", alloc_array_malloc_count);
}
