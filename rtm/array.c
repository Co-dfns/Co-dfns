#include <math.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <arrayfire.h>

#include "internal.h"

#if AF_API_VERSION < 38
#error "Your ArrayFire version is too old."
#endif

#define POOL_OBJECTS 1024
#define POOL_PAGES 16

struct stab array_pool = {0};

DECLSPEC int
mk_array(struct cell_array **dest,
    enum array_type type, enum array_storage storage, unsigned int rank)
{
	struct		cell_array *arr;
	size_t		size;
	
	size = sizeof(struct cell_array) + 4 * sizeof(size_t);
	
	if (!array_pool.start)
		if (stab_init(&array_pool, POOL_PAGES, POOL_OBJECTS, size))
			return 1;
	
	if (rank <= 4) {
		arr = stab_alloc(&array_pool);
	} else {
		size = sizeof(struct cell_array) + rank * sizeof(size_t);
		arr = malloc(size);
	}

	if (arr == NULL)
		return 1;
	
	if (rank > 4)
		arr->stab_page = NULL;

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

DECLSPEC int
alloc_array(struct cell_array *arr)
{
	size_t count, size;
	char *buf;
	af_dtype dtype;
	int err;
	
	count = array_values_count(arr);
		
	switch (arr->storage) {
	case STG_DEVICE:
		dtype = array_af_dtype(arr);
		err = af_create_handle(&arr->values, 1, &count, dtype);
		break;
	case STG_HOST:
		size = count * array_element_size(arr);
		buf = malloc(size + sizeof(int));
		
		if (buf == NULL) {
			err = 1;
			break;
		}
		
		memset(buf, 0, size + sizeof(int));
		
		err = 0;
		arr->values = buf;
		arr->vrefc = (unsigned int *)(buf + size);
		*arr->vrefc = 1;
		
		break;
	default:
		err = 99;
	}
	
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
			CHK(99, done, "Null value refcount.");
		
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
		goto done;
	
	if (!*refc)
		goto done;
	
	--*refc;
	
	if (*refc)
		goto done;
	
	if (arr->type == ARR_NESTED) {
		size_t count = array_values_count(arr);
		struct cell_array **ptrs = arr->values;

		for (size_t i = 0; i < count; i++)
			CHK(release_array(ptrs[i]), done,
			    "Failed to release nested value");
	}

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
		CHK(release_array_data(arr), fail,
		    "release_array_data(arr)");

	if (arr->stab_page)
		stab_free(&array_pool, arr);
	else
		free(arr);
	
	return 0;

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
	
	arr->values = in->values;
	arr->vrefc = in->vrefc;
	
	CHKFN(retain_array_data(arr), fail);
	
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
	
	if (arr->storage == STG_HOST) {
		CHK(arr->vrefc == NULL, fail, "NULL values refcount");
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
	
	if (l->type == ARR_CMPX)
		if (err = squeeze_array(l))
			return err;
	
	if (r->type == ARR_CMPX)
		if (err = squeeze_array(r))
			return err;
	
	if ((l->type == ARR_CMPX) != (r->type == ARR_CMPX)) {
		*is_same = 0;
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
	
#define ARRAY_SAME_LOOP(ltype, rtype) {		\
	ltype *lvals = l->values;		\
	rtype *rvals = r->values;		\
						\
	for (size_t i = 0; i < count; i++) {	\
		if (lvals[i] != rvals[i]) {	\
			*is_same = 0;		\
			return 0;		\
		}				\
	}					\
						\
	break;					\
}

	switch (type_pair(l->type, r->type)) {
	case type_pair(ARR_BOOL, ARR_BOOL):ARRAY_SAME_LOOP(int8_t, int8_t);
	case type_pair(ARR_BOOL, ARR_SINT):ARRAY_SAME_LOOP(int8_t, int16_t);
	case type_pair(ARR_BOOL, ARR_INT):ARRAY_SAME_LOOP( int8_t, int32_t);
	case type_pair(ARR_BOOL, ARR_DBL):ARRAY_SAME_LOOP( int8_t, double);
	case type_pair(ARR_SINT, ARR_BOOL):ARRAY_SAME_LOOP(int16_t, int8_t);
	case type_pair(ARR_SINT, ARR_SINT):ARRAY_SAME_LOOP(int16_t, int16_t);
	case type_pair(ARR_SINT, ARR_INT):ARRAY_SAME_LOOP( int16_t, int32_t);
	case type_pair(ARR_SINT, ARR_DBL):ARRAY_SAME_LOOP( int16_t, double);
	case type_pair(ARR_INT, ARR_BOOL):ARRAY_SAME_LOOP(int32_t, int8_t);
	case type_pair(ARR_INT, ARR_SINT):ARRAY_SAME_LOOP(int32_t, int16_t);
	case type_pair(ARR_INT, ARR_INT):ARRAY_SAME_LOOP( int32_t, int32_t);
	case type_pair(ARR_INT, ARR_DBL):ARRAY_SAME_LOOP( int32_t, double);
	case type_pair(ARR_DBL, ARR_BOOL):ARRAY_SAME_LOOP(double, int8_t);
	case type_pair(ARR_DBL, ARR_SINT):ARRAY_SAME_LOOP(double, int16_t);
	case type_pair(ARR_DBL, ARR_INT):ARRAY_SAME_LOOP( double, int32_t);
	case type_pair(ARR_DBL, ARR_DBL):ARRAY_SAME_LOOP( double, double);
	case type_pair(ARR_CHAR8, ARR_CHAR8):ARRAY_SAME_LOOP(uint8_t, uint8_t);
	case type_pair(ARR_CHAR8, ARR_CHAR16):ARRAY_SAME_LOOP(uint8_t, uint16_t);
	case type_pair(ARR_CHAR8, ARR_CHAR32):ARRAY_SAME_LOOP(uint8_t, uint32_t);
	case type_pair(ARR_CHAR16, ARR_CHAR8):ARRAY_SAME_LOOP( uint16_t, uint8_t);
	case type_pair(ARR_CHAR16, ARR_CHAR16):ARRAY_SAME_LOOP(uint16_t, uint16_t);
	case type_pair(ARR_CHAR16, ARR_CHAR32):ARRAY_SAME_LOOP(uint16_t, uint32_t);
	case type_pair(ARR_CHAR32, ARR_CHAR8):ARRAY_SAME_LOOP( uint32_t, uint8_t);
	case type_pair(ARR_CHAR32, ARR_CHAR16):ARRAY_SAME_LOOP(uint32_t, uint16_t);
	case type_pair(ARR_CHAR32, ARR_CHAR32):ARRAY_SAME_LOOP(uint32_t, uint32_t);
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