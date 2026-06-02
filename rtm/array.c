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
	case ARR_NESTED:
		return sizeof(struct apl_cmpx); /* Enough room for squeezing */
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

size_t
array_values_space(struct cell_array *arr)
{
	char *start = arr;
	char *values = &arr->shape[arr->rank];

	return (start + arr->size) - values;
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

size_t mk_array_count = 0;
size_t free_array_count = 0;
size_t malloc_array_count = 0;
size_t realloc_array_count = 0;

struct cell_array **array_pool = NULL;
int array_cur = 0;
int array_end = 0;

DECLSPEC int
mk_array(struct cell_array **dest,
    enum array_type type, enum array_storage storage, 
    unsigned int rank, size_t count)
{
	struct cell_array *arr;
	size_t size, ebytes;
	
	for (; array_cur < array_end; array_cur++) {
		struct cell_array *arr = array_pool[array_cur];
		
		if (arr == NULL || !arr->refc)
			break;
	}
	
	if (array_cur == array_end) {
		int end = !array_end ? 1024 : array_end * 2;
		
		array_pool = realloc(array_pool, end * sizeof(*array_pool));
		
		if (array_pool == NULL)
			return 1;
		
		for (; array_end < end; array_end++)
			array_pool[array_end] = NULL;
	}
	
	ebytes = count * array_element_size_type(type);
	size = sizeof(*arr) + rank * sizeof(size_t) + ebytes;
	arr = array_pool[array_cur];

	if (arr && size > arr->size) {
		realloc_array_count++;

		free(arr);

		arr = array_pool[array_cur] = NULL;
	}
	
	if (arr == NULL) {
		malloc_array_count++;
		
		arr = array_pool[array_cur] = malloc(size);
		
		if (arr == NULL)
			return 1;
	
		arr->ctyp	= CELL_ARRAY;
		arr->pool_idx	= array_cur;
		arr->size	= size;
	}
	
	arr->refc	= 1;
	arr->rank	= rank;
	arr->type	= type;
	arr->storage	= storage;
	arr->values	= NULL;
	
	if (storage == STG_HOST)
		arr->values = &arr->shape[rank];

	if (type == ARR_NESTED)
		memset(arr->values, 0, ebytes);
	
	array_cur++;
	*dest = arr;
	
	return 0;
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
	
	free_array_count++;

	if (arr->pool_idx == -1)
		CHK(99, fail, "Attempt to release static array");
	
	if (arr->pool_idx < array_cur)
		array_cur = arr->pool_idx;
	
	if (arr->storage == STG_DEVICE && arr->values != NULL) {
		CHKAF(af_release_array(arr->values), fail);
		arr->values = NULL;
	}
	
	if (arr->storage == STG_HOST && arr->type == ARR_NESTED) {
		size_t count = array_values_count(arr);
		struct cell_array **ptrs = arr->values;
		
		for (size_t i = 0; i < count; i++)
			CHK(release_array(ptrs[i]), fail,
			    "Failed to release nested value");
	}

	return 0;

fail:
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
	if (err = mk_array(&t, atype, STG_HOST, 0, 1))	\
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
DECLSPEC DEFN_MKARRAY(mk_array_int32, ARR_INT, int32_t)
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
array_copy(struct cell_array **tgt, struct cell_array *src)
{
	struct cell_array *arr;
	size_t count;
	int err;

	count = array_values_count(src);
	arr = NULL;

	CHKFN(mk_array(&arr, src->type, src->storage, src->rank, count), fail);

	switch (src->storage) {
	case STG_DEVICE:
		CHKAF(af_retain_array(&arr->values, src->values), fail);
		break;
	case STG_HOST:
		memcpy(arr->values, src->values, array_values_bytes(src));
		break;
	default:
		CHK(99, fail, "Unknown storage type");
	}

	*tgt = arr;

	return 0;

fail:
	release_array(arr);

	return err;
}

int
array_get_host_data(void **buf, struct cell_array *arr)
{
	size_t size;
	int err;

	if (arr->storage == STG_HOST) {
		if (buf != NULL)
			*buf = arr->values;

		return 0;
	}

	if (array_values_space(arr) < array_values_bytes(arr))
		CHK(99, fail, "Size required exceeds allocated space.");

	CHKAF(af_eval(arr->values), fail);
	CHKAF(af_get_data_ptr(&arr->shape[arr->rank], arr->values), fail);

	if (buf != NULL)
		*buf = &arr->shape[arr->rank];

fail:
	return err;
}

int
array_get_device_data(af_array *t, struct cell_array *arr)
{
	size_t count;
	int err;
	af_dtype dtp;

	if (arr->storage == STG_DEVICE) {
		*t = arr->values;
		return 0;
	}

	switch (arr->type) {
	case ARR_SPAN:
	case ARR_MIXED:
	case ARR_NESTED:
		CHK(99, fail, "Cannot get device buffer.");
	}
	
	dtp = array_af_dtype(arr);
	count = array_values_count(arr);
	
	CHKAF(af_create_array(t, arr->values, 1, &count, dtp), fail);
		
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

	if ((l->storage == STG_DEVICE || r->storage == STG_DEVICE)
	    && l->type != ARR_NESTED && r->type != ARR_NESTED) {
		af_array t, lv, rv;
		double real, imag;

		lv = NULL;
		rv = NULL;
			
		if (is_char_array(l) != is_char_array(r)) {
			*is_same = 0;
			return 0;
		}

		CHKFN(array_get_device_data(&lv, l), fail_dev);
		CHKFN(array_get_device_data(&rv, r), fail_dev);

		CHKAF(af_neq(&t, lv, rv, 0), fail_dev);
		CHKAF(af_any_true_all(&real, &imag, t), fail_dev);
		CHKAF(af_release_array(t), fail_dev);

		*is_same = !real;

fail_dev:
		if (lv != l->values)
			af_release_array(lv);

		if (rv != r->values)
			af_release_array(rv);
			
		return err;
	}
		
	count = array_values_count(l);

	switch (l->type) {
	case APL_SPAN:
		*is_same = r->type == APL_SPAN;
		return 0;
	case APL_BOOL:{
		int8_t *lv = l->values; 
		switch (r->type) {
		case APL_SPAN:
		case APL_CHAR8:
		case APL_CHAR16:
		case APL_CHAR32:
			*is_same = 0;
			return 0;
		case APL_BOOL:{
			int8_t *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_SINT:{
			int16_t *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_INT:{
			int32_t *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_DBL:{
			double *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_CMPX:{
			struct apl_cmpx *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (rv[i].imag != 0 || lv[i] != rv[i].real) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_NESTED:{
			struct cell_array *rv = r->values;
			struct cell_array tv = {
				CELL_ARRAY, 1, 0, sizeof(tv), 0, 
				STG_HOST, ARR_BOOL, NULL
			};

			CHKFN(array_get_host_data(&lv, l), fail);

			for (size_t i = 0; i < count; i++) {
				tv.values = &lv[i];
				CHKFN(array_is_same(is_same, &tv, rv[i]), fail);
				if (!*is_same)
					return 0;
			}
		}break;
		case APL_MIXED:
		default:
			CHK(99, fail, "Unexpected type");
		}
	}break;
	case APL_SINT:{
		int16_t *lv = l->values; 
		switch (r->type) {
		case APL_SPAN:
		case APL_CHAR8:
		case APL_CHAR16:
		case APL_CHAR32:
			*is_same = 0;
			return 0;
		case APL_BOOL:{
			int8_t *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_SINT:{
			int16_t *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_INT:{
			int32_t *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_DBL:{
			double *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_CMPX:{
			struct apl_cmpx *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (rv[i].imag != 0 || lv[i] != rv[i].real) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_NESTED:{
			struct cell_array *rv = r->values;
			struct cell_array tv = {
				CELL_ARRAY, 1, 0, sizeof(tv), 0, 
				STG_HOST, ARR_SINT, NULL
			};

			CHKFN(array_get_host_data(&lv, l), fail);

			for (size_t i = 0; i < count; i++) {
				tv.values = &lv[i];
				CHKFN(array_is_same(is_same, &tv, rv[i]), fail);
				if (!*is_same)
					return 0;
			}
		}break;
		case APL_MIXED:
		default:
			CHK(99, fail, "Unexpected type");
		}
	}break;
	case APL_INT:{
		int32_t *lv = l->values; 
		switch (r->type) {
		case APL_SPAN:
		case APL_CHAR8:
		case APL_CHAR16:
		case APL_CHAR32:
			*is_same = 0;
			return 0;
		case APL_BOOL:{
			int8_t *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_SINT:{
			int16_t *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_INT:{
			int32_t *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_DBL:{
			double *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_CMPX:{
			struct apl_cmpx *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (rv[i].imag != 0 || lv[i] != rv[i].real) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_NESTED:{
			struct cell_array *rv = r->values;
			struct cell_array tv = {
				CELL_ARRAY, 1, 0, sizeof(tv), 0, 
				STG_HOST, ARR_INT, NULL
			};

			CHKFN(array_get_host_data(&lv, l), fail);

			for (size_t i = 0; i < count; i++) {
				tv.values = &lv[i];
				CHKFN(array_is_same(is_same, &tv, rv[i]), fail);
				if (!*is_same)
					return 0;
			}
		}break;
		case APL_MIXED:
		default:
			CHK(99, fail, "Unexpected type");
		}
	}break;
	case APL_DBL:{
		double *lv = l->values; 
		switch (r->type) {
		case APL_SPAN:
		case APL_CHAR8:
		case APL_CHAR16:
		case APL_CHAR32:
			*is_same = 0;
			return 0;
		case APL_BOOL:{
			int8_t *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_SINT:{
			int16_t *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_INT:{
			int32_t *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_DBL:{
			double *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_CMPX:{
			struct apl_cmpx *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (rv[i].imag != 0 || lv[i] != rv[i].real) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_NESTED:{
			struct cell_array *rv = r->values;
			struct cell_array tv = {
				CELL_ARRAY, 1, 0, sizeof(tv), 0, 
				STG_HOST, ARR_DBL, NULL
			};

			CHKFN(array_get_host_data(&lv, l), fail);

			for (size_t i = 0; i < count; i++) {
				tv.values = &lv[i];
				CHKFN(array_is_same(is_same, &tv, rv[i]), fail);
				if (!*is_same)
					return 0;
			}
		}break;
		case APL_MIXED:
		default:
			CHK(99, fail, "Unexpected type");
		}
	}break;
	case APL_CMPX:{
		struct apl_cmpx *lv = l->values; 
		switch (r->type) {
		case APL_SPAN:
		case APL_CHAR8:
		case APL_CHAR16:
		case APL_CHAR32:
			*is_same = 0;
			return 0;
		case APL_BOOL:{
			int8_t *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i].imag != 0 || lv[i].real != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_SINT:{
			int16_t *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i].imag != 0 || lv[i].real != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_INT:{
			int32_t *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i].imag != 0 || lv[i].real != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_DBL:{
			double *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i].imag != 0 || lv[i].real != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_CMPX:{
			struct apl_cmpx *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i].real != rv[i].real
				    lv[i].imag != rv[i].imag) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_NESTED:{
			struct cell_array *rv = r->values;
			struct cell_array tv = {
				CELL_ARRAY, 1, 0, sizeof(tv), 0, 
				STG_HOST, ARR_CMPX, NULL
			};

			CHKFN(array_get_host_data(&lv, l), fail);

			for (size_t i = 0; i < count; i++) {
				tv.values = &lv[i];
				CHKFN(array_is_same(is_same, &tv, rv[i]), fail);
				if (!*is_same)
					return 0;
			}
		}break;
		case APL_MIXED:
		default:
			CHK(99, fail, "Unexpected type");
		}
	}break;
	case APL_CHAR8:{
		uint8_t *lv = l->values;
		switch (r->type) {
		case APL_SPAN:
		case APL_BOOL:
		case APL_SINT:
		case APL_INT:
		case APL_DBL:
		case APL_CMPX:
			*is_same = 0;
			return 0;
		case APL_CHAR8:{
			uint8_t *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_CHAR16:{
			uint16_t *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_CHAR32:{
			uint32_t *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_NESTED:{
			struct cell_array *rv = r->values;
			struct cell_array tv = {
				CELL_ARRAY, 1, 0, sizeof(tv), 0, 
				STG_HOST, ARR_CHAR8, NULL
			};

			CHKFN(array_get_host_data(&lv, l), fail);

			for (size_t i = 0; i < count; i++) {
				tv.values = &lv[i];
				CHKFN(array_is_same(is_same, &tv, rv[i]), fail);
				if (!*is_same)
					return 0;
			}
		}break;
		case APL_MIXED:
		default:
			CHK(99, fail, "Unexpected type");
		}
	}break;
	case APL_CHAR16:{
		uint16_t *lv = l->values;
		switch (r->type) {
		case APL_SPAN:
		case APL_BOOL:
		case APL_SINT:
		case APL_INT:
		case APL_DBL:
		case APL_CMPX:
			*is_same = 0;
			return 0;
		case APL_CHAR8:{
			uint8_t *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_CHAR16:{
			uint16_t *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_CHAR32:{
			uint32_t *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_NESTED:{
			struct cell_array *rv = r->values;
			struct cell_array tv = {
				CELL_ARRAY, 1, 0, sizeof(tv), 0, 
				STG_HOST, ARR_CHAR16, NULL
			};

			CHKFN(array_get_host_data(&lv, l), fail);

			for (size_t i = 0; i < count; i++) {
				tv.values = &lv[i];
				CHKFN(array_is_same(is_same, &tv, rv[i]), fail);
				if (!*is_same)
					return 0;
			}
		}break;
		case APL_MIXED:
		default:
			CHK(99, fail, "Unexpected type");
		}
	}break;
	case APL_CHAR32:{
		uint32_t *lv = l->values;
		switch (r->type) {
		case APL_SPAN:
		case APL_BOOL:
		case APL_SINT:
		case APL_INT:
		case APL_DBL:
		case APL_CMPX:
			*is_same = 0;
			return 0;
		case APL_CHAR8:{
			uint8_t *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_CHAR16:{
			uint16_t *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_CHAR32:{
			uint32_t *rv = r->values;
			for (size_t i = 0; i < count; i++)
				if (lv[i] != rv[i]) {
					*is_same = 0;
					return 0;
				}
		}break;
		case APL_NESTED:{
			struct cell_array *rv = r->values;
			struct cell_array tv = {
				CELL_ARRAY, 1, 0, sizeof(tv), 0, 
				STG_HOST, ARR_CHAR32, NULL
			};

			CHKFN(array_get_host_data(&lv, l), fail);

			for (size_t i = 0; i < count; i++) {
				tv.values = &lv[i];
				CHKFN(array_is_same(is_same, &tv, rv[i]), fail);
				if (!*is_same)
					return 0;
			}
		}break;
		case APL_MIXED:
		default:
			CHK(99, fail, "Unexpected type");
		}
	}break;
	case APL_NESTED:{
		struct cell_array *lv = l->values;
		struct cell_array tv = {
			CELL_ARRAY, 1, 0, sizeof(tv), 0,
			STG_HOST, r->type, NULL
		};
		void *hv;

		CHKFN(array_get_host_data(&hv, r), fail);

		switch (r->type) {
		case APL_SPAN:
			*is_same = 0;
			return 0;
		case APL_BOOL:{
			int8_t *rv = hv;
			
			for (size_t i = 0; i < count; i++) {
				tv.values = &rv[i];
				CHKFN(array_is_same(is_same, lv[i], &tv), fail);
				if (!*is_same)
					return 0;
			}
		}break;
		case APL_SINT:{
			int16_t *rv = hv;
			
			for (size_t i = 0; i < count; i++) {
				tv.values = &rv[i];
				CHKFN(array_is_same(is_same, lv[i], &tv), fail);
				if (!*is_same)
					return 0;
			}
		}break;
		case APL_INT:{
			int32_t *rv = hv;
			
			for (size_t i = 0; i < count; i++) {
				tv.values = &rv[i];
				CHKFN(array_is_same(is_same, lv[i], &tv), fail);
				if (!*is_same)
					return 0;
			}
		}break;
		case APL_DBL:{
			double *rv = hv;
			
			for (size_t i = 0; i < count; i++) {
				tv.values = &rv[i];
				CHKFN(array_is_same(is_same, lv[i], &tv), fail);
				if (!*is_same)
					return 0;
			}
		}break;
		case APL_CMPX:{
			struct apl_cmpx *rv = hv;
			
			for (size_t i = 0; i < count; i++) {
				tv.values = &rv[i];
				CHKFN(array_is_same(is_same, lv[i], &tv), fail);
				if (!*is_same)
					return 0;
			}
		}break;
		case APL_CHAR8:{
			uint8_t *rv = hv;
			
			for (size_t i = 0; i < count; i++) {
				tv.values = &rv[i];
				CHKFN(array_is_same(is_same, lv[i], &tv), fail);
				if (!*is_same)
					return 0;
			}
		}break;
		case APL_CHAR16:{
			uint16_t *rv = hv;
			
			for (size_t i = 0; i < count; i++) {
				tv.values = &rv[i];
				CHKFN(array_is_same(is_same, lv[i], &tv), fail);
				if (!*is_same)
					return 0;
			}
		}break;
		case APL_CHAR32:{
			uint32_t *rv = hv;
			
			for (size_t i = 0; i < count; i++) {
				tv.values = &rv[i];
				CHKFN(array_is_same(is_same, lv[i], &tv), fail);
				if (!*is_same)
					return 0;
			}
		}break;
		case APL_NESTED:{
			struct cell_array *rv = hv;

			for (size_t i = 0; i < count; i++) {
				CHKFN(array_is_same(is_same, lv[i], rv[i]), fail);
				if (!*is_same)
					return 0;
			}
		}break;
		case APL_MIXED:
		default:
			CHK(99, fail, "Unexpected type");
		}
	}break;
	case APL_MIXED:
	default:
		CHK(99, fail, "Unexpected type");
	}

	*is_same = 1;

fail:
	return err;
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
stretch_values(struct cell_array **dst, struct cell_array *src, enum array_type type)
{
	struct cell_array *t;
	size_t count;
	int err;
	enum storage_type storage;

	t	= NULL;
	count	= array_values_count(src);
	storage	= type >= ARR_MIXED ? STG_HOST : src->storage;
	type	= type == ARR_MIXED ? ARR_NESTED : type;

	if (src->type ≥ type)
		CHK(99, fail, "Attempting to stretch to smaller or equal type");

	CHKFN(mk_array(&t, type, storage, src->rank, count), fail);

	for (unsigned int i = 0; i < t->rank; i++)
		t->shape[i] = src->shape[i];

	if (t->storage == STG_DEVICE) {
		af_dtype aft;

		aft = array_type_af_dtype(type);

		CHKAF(af_cast(&t->values, src->values, aft), fail);
		
		*dst = t;

		return 0;
	}

	if (t->storage != STG_HOST)
		CHK(99, fail, "Unknown storage type");

	#define CAST_LP(tt, st) {			\
		tt *tv = t->values;			\
		st *sv = src->values;			\
		for (size_t i = 0; i < count; i++)	\
			tv[i] = sv[i];			\
	}

	#define CAST_LP_CMPX(st) {			\
		struct apl_cmpx *tv = t->values;	\
		st *sv = src->values;			\
		for (size_t i = 0; i < count; i++) {	\
			tv[i].real = sv[i];		\
			tv[i].imag = 0;			\
		}					\
	}

	#define CAST_LP_NST(st) {						\
		st *sv;								\
		struct cell_array **tv = t->values;				\
		CHKFN(array_get_host_data(&sv, src), fail);			\
		for (size_t i = 0; i < count; i++) {				\
			CHKFN(mk_array(&tv[i], src->type, STG_HOST, 0, 1), fail); \
			*(st *)tv[i]->values = sv[i];				\
		}								\
	}

	switch (t->type) {
	case APL_SINT:
		switch (src->type) {
		case APL_BOOL:CAST_LP(int16_t, int8_t);break;
		default:
			CHK(99, fail, "Unexpected stretch source type");
		}break;
	case APL_INT:
		switch (src->type) {
		case APL_BOOL:CAST_LP(int32_t, int8_t);break;
		case APL_SINT:CAST_LP(int32_t, int16_t);break;
		default:
			CHK(99, fail, "Unexpected stretch source type");
		}break;
	case APL_DBL:
		switch (src->type) {
		case APL_BOOL:CAST_LP(double, int8_t);break;
		case APL_SINT:CAST_LP(double, int16_t);break;
		case APL_INT:CAST_LP(double, int32_t);break;
		default:
			CHK(99, fail, "Unexpected stretch source type");
		}break;
	case APL_CMPX:
		switch (src->type) {
		case APL_BOOL:CAST_LP_CMPX(int8_t);break;
		case APL_SINT:CAST_LP_CMPX(int16_t);break;
		case APL_INT:CAST_LP_CMPX(int32_t);break;
		case APL_DBL:CAST_LP_CMPX(double);break;
		default:
			CHK(99, fail, "Unexpected stretch source type");
		}break;
	case APL_CHAR16:
		switch (src->type) {
		case APL_CHAR8:CAST_LP(uint16_t, uint8_t);break;
		default:
			CHK(99, fail, "Unexpected stretch source type");
		}break;
	case APL_CHAR32:
		switch (src->type) {
		case APL_CHAR8:CAST_LP(uint32_t, uint8_t);break;
		case APL_CHAR16:CAST_LP(uint32_t, uint16_t);break;
		default:
			CHK(99, fail, "Unexpected stretch source type");
		}break;
	case APL_NESTED:
		switch (src->type) {
		case APL_BOOL:CAST_LP_NST(int8_t);break;
		case APL_SINT:CAST_LP_NST(int16_t);break;
		case APL_INT:CAST_LP_NST(int32_t);break;
		case APL_DBL:CAST_LP_NST(double);break;
		case APL_CMPX:CAST_LP_NST(struct apl_cmpx);break;				
		case APL_CHAR8:CAST_LP_NST(uint8_t);break;
		case APL_CHAR16:CAST_LP_NST(uint16_t);break;
		case APL_CHAR32:CAST_LP_NST(uint32_t);break;
		default:
			CHK(99, fail, "Unexpected stretch source type");
		}
	default:
		CHK(99, fail, "Unexpected stretch target type");
	}

	*dst = t;

	return 0;

fail:
	release_array(t);

	return err;
}

int
squeeze_values_device(struct cell_array *arr, enum array_type type)
{
	af_array newv, v;
	int err;
	unsigned char is_cmpx;
	
	is_cmpx = 0;
	v = arr->values;
	
	CHKAF(af_is_complex(&is_cmpx, arr->values), fail);
	
	if (is_cmpx)
		CHKAF(af_real(&v, arr->values), fail);
	
	CHKAF(af_cast(&newv, v, array_type_af_dtype(type)), fail);
	CHKAF(af_release_array(arr->values), fail);
	
	arr->type = type;
	arr->values = newv;
	
	err = 0;
	
fail:
	if (is_cmpx)
		af_release_array(v);
		
	return err;
}

int
squeeze_values_host(struct cell_array *arr, enum array_type out_type)
{
	size_t count, in_size, out_size;
	int err;
	
	err = 0;
	
	count = array_values_count(arr);
	in_size = count * array_element_size_type(arr->type);
	out_size = count * array_element_size_type(out_type);

	if (out_size >= in_size)
		CHK(99, fail, "Squeezing to a larger or equal size.");

	if (out_size > array_values_space(arr))
		CHK(99, fail, "No room to squeeze array.");

	if (arr->values != &arr->shape[arr->rank])
		CHK(99, fail, "Cannot squeeze a linked array.");

	#define SQZ_LP(tt, st) {				\
		tt *tv = arr->values;			\
		st *rv = arr->values;			\
		for (size_t i = 0; i < count; i++)		\
			tv[i] = rv[i];			\
	}

	#define SQZ_LP_CMPX(tt) {				\
		tt *tv = arr->values;			\
		struct apl_cmpx *rv = arr->values;	\
		for (size_t i = 0; i < count; i++)		\
			tv[i] = rv[i].real;		\
	}

	#define SQZ_LP_NST(tt, get) {			\
		tt *tv = arr->values;			\
		struct cell_array **rv = arr->values;	\
		for (size_t i = 0; i < count; i++) {		\
			struct cell_array *v = rv[i];	\
			CHKFN(get(&tv[i], v, 0), fail);	\
			CHKFN(release_array(v), fail);	\
		}					\
	}


	switch (out_type) {
	case ARR_BOOL:{
		switch (arr->type) {
		case ARR_SINT:SQZ_LP(int8_t, int16_t);break;
		case ARR_INT:SQZ_LP(int8_t, int32_t);break;
		case ARR_DBL:SQZ_LP(int8_t, double);break;
		case ARR_CMPX:SQZ_LP_CMPX(int8_t);break;
		case ARR_NESTED:SQZ_LP_NST(int8_t, get_scalar_int8);break;
		default:CHK(99, fail, "Cannot squeeze type to Boolean.");
		}
	}break;
	case ARR_SINT:{
		switch (arr->type) {
		case ARR_INT:SQZ_LP(int16_t, int32_t);break;
		case ARR_DBL:SQZ_LP(int16_t, double);break;
		case ARR_CMPX:SQZ_LP_CMPX(int16_t);break;
		case ARR_NESTED:SQZ_LP_NST(int16_t, get_scalar_int16);break;
		default:CHK(99, fail, "Cannot squeeze type to small integer.");
		}
	}break;
	case ARR_INT:{
		switch (arr->type) {
		case ARR_DBL:SQZ_LP(int32_t, double);break;
		case ARR_CMPX:SQZ_LP_CMPX(int32_t);break;
		case ARR_NESTED:SQZ_LP_NST(int32_t, get_scalar_int32);break;
		default:CHK(99, fail, "Cannot squeeze type to integer.");
		}
	}break;
	case ARR_DBL:{
		switch (arr->type) {
		case ARR_CMPX:SQZ_LP_CMPX(double);break;
		case ARR_NESTED:SQZ_LP_NST(double, get_scalar_double);break;
		default:CHK(99, fail, "Cannot squeeze type to double.");
		}
	}break;
	case ARR_CMPX:{
		switch (arr->type) {
		case ARR_NESTED:SQZ_LP_NST(struct apl_cmpx, get_scalar_cmpx);break;
		default:CHK(99, fail, "Cannot squeeze type to complex.");
		}
	}break;
	case ARR_CHAR8:{
		switch (arr->type) {
		case ARR_CHAR16:SQZ_LP(uint8_t, uint16_t);break;
		case ARR_CHAR32:SQZ_LP(uint8_t, uint32_t);break;
		case ARR_NESTED:SQZ_LP_NST(uint8_t, get_scalar_char8);break;
		default:CHK(99, fail, "Cannot squeeze type to char8.");
		}
	}break;
	case ARR_CHAR16:{
		uint16_t *tv = arr->values;
		switch (arr->type) {
		case ARR_CHAR32:SQZ_LP(uint16_t, uint32_t);break;
		case ARR_NESTED:SQZ_LP_NST(uint16_t, get_scalar_char16);break;
		default:CHK(99, fail, "Cannot squeeze type to char16.");
		}
	}break;
	case ARR_CHAR32:{
		switch (arr->type) {
		case ARR_NESTED:SQZ_LP_NST(uint32_t, get_scalar_char32);break;
		default:CHK(99, fail, "Cannot squeeze type to char32.");
		}
	}break;
	default:CHK(99, fail, "Unexpected squeeze output type.");
	}

	arr->type = out_type;

fail:
	return err;
}

int
squeeze_values(struct cell_array *arr, enum array_type type)
{
	int err;
	
	switch (arr->storage) {
	case STG_DEVICE:
		CHKFN(squeeze_values_device(arr, type), fail);
		break;
	case STG_HOST:
		CHKFN(squeeze_values_host(arr, type), fail);
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

	if (arr->values != &arr->shape[arr->rank])
		return 0;
	
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
	case ARR_NESTED:
		break;
	default:
		return 99;
	}
	
	if (arr->type == ARR_NESTED) {
		struct cell_array **vals = arr->values;
		enum array_type type = vals[0]->type;
		
		for (size_t i = 0; i < count; i++) {
			struct cell_array *t = vals[i];
			
			CHKFN(squeeze_array(t), fail);
			
			if (t->rank != 0 || t->type == ARR_NESTED || 
			    t->type == ARR_MIXED || t->type == ARR_SPAN)
				return 0;
			
			type = array_max_type(type, t->type);
		}

		CHKFN(squeeze_values(arr, type), fail);

		return 0;
	}
	
	CHKFN(find_minmax(&min_real, &max_real, &is_real, &is_int, arr),
	    fail);
	
	if (!is_real)
		return 0;
	
	if (!is_int) {
		CHKFN(squeeze_values(arr, ARR_DBL), fail);
		return err;
	}
	
	if (is_char_array(arr)) {
		if (0 <= min_real && max_real <= UINT8_MAX) {
			CHKFN(squeeze_values(arr, ARR_CHAR8), fail);
			return err;
		}
		
		if (0 <= min_real && max_real <= UINT16_MAX) {
			CHKFN(squeeze_values(arr, ARR_CHAR16), fail);
			return err;
		}
		
		return 0;
	}
	
	if (0 <= min_real && max_real <= 1) {
		CHKFN(squeeze_values(arr, ARR_BOOL), fail);
		return err;
	}
	
	if (INT16_MIN <= min_real && max_real <= INT16_MAX) {
		CHKFN(squeeze_values(arr, ARR_SINT), fail);
		return err;
	}
	
	if (INT32_MIN <= min_real && max_real <= INT32_MAX) {
		CHKFN(squeeze_values(arr, ARR_INT), fail);
		return err;
	}
	
	CHKFN(squeeze_values(arr, ARR_DBL), fail);
	
fail:
	return err;
}

void
print_array_stats(void)
{
	printf("\tarrays made: %zd freed: %zd malloc: %zd realloc: %zd\n", 
	    mk_array_count, free_array_count, malloc_array_count, realloc_array_count);
	printf("\tarray_cur: %d array_end: %d\n", array_cur, array_end);
}
