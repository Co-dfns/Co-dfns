#include <complex.h>
#include <float.h>
#include <math.h>
#include <string.h>

#include "internal.h"

int
error_syntax_mon(struct cell_array **z, struct cell_array *r, 
    struct cell_func *self)
{
	return 2;
}

int
error_syntax_dya(struct cell_array **z, 
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	return 2;
}

#define DEF_MON(mf, fn)							\
int									\
mf(struct cell_array **z, struct cell_array *r, struct cell_func *self)	\
{									\
	return fn(z, NULL, r, self);					\
}									\

int
q_signal_func(struct cell_array **z, 
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	int err;
	int32_t val;
	
	if (r->rank > 1)
		return 4;
	
	if (!array_count(r)) {
		*z = retain_cell(r);
		return 0;
	}
	
	if (err = squeeze_array(r))
		return err;
	
	if (!is_integer_array(r))
		return 11;
	
	if (l) {
		if (!is_char_array(l))
			return 11;
		
		if (l->rank > 1)
			return 4;
	}
	
	if (err = get_scalar_int(&val, r))
		return err;
	
	return val;
}

DEF_MON(q_signal_func_mon, q_signal_func)

struct cell_func q_signal_closure = {
	CELL_FUNC, 1, q_signal_func_mon, q_signal_func, 0
};
struct cell_func *q_signal_ibeam = &q_signal_closure;

int
q_dr_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	int16_t val;
	
	if (l)
		return 16;
		
	switch (r->type) {
	case ARR_SPAN:
		val = 323;
		break;
	case ARR_BOOL:
		val = 11;
		break;
	case ARR_SINT:
		val = 163;
	case ARR_INT:
		val = 323;
		break;
	case ARR_DBL:
		val = 645;
		break;
	case ARR_CMPX:
		val = 1289;
		break;
	case ARR_CHAR8:
		val = 80;
		break;
	case ARR_CHAR16:
		val = 160;
		break;
	case ARR_CHAR32:
		val = 320;
		break;
	case ARR_MIXED:
	case ARR_NESTED:
		val = 326;
		break;
	default:
		return 99;
	}
	
	return mk_scalar_sint(z, val);
}

DEF_MON(q_dr_func_mon, q_dr_func)

struct cell_func q_dr_closure = {CELL_FUNC, 1, q_dr_func_mon, q_dr_func, 0};
struct cell_func *q_dr_ibeam = &q_dr_closure;

int
is_simple_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	return mk_scalar_bool(z, r->type != ARR_NESTED);
}

DEF_MON(is_simple_func_mon, is_simple_func)

struct cell_func is_simple_closure = {
	CELL_FUNC, 1, is_simple_func_mon, is_simple_func, 0
};
struct cell_func *is_simple_ibeam = &is_simple_closure;

int
is_numeric_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	if (is_numeric_array(r))
		return mk_scalar_bool(z, 1);
	
	return mk_scalar_bool(z, 0);
}

DEF_MON(is_numeric_func_mon, is_numeric_func)

struct cell_func is_numeric_closure = {
	CELL_FUNC, 1, is_numeric_func_mon, is_numeric_func, 0
};
struct cell_func *is_numeric_ibeam = &is_numeric_closure;

int
is_char_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	if (is_char_array(r))
		return mk_scalar_bool(z, 1);
	
	return mk_scalar_bool(z, 0);
}

DEF_MON(is_char_func_mon, is_char_func)

struct cell_func is_char_closure = {
	CELL_FUNC, 1, is_char_func_mon, is_char_func, 0
};
struct cell_func *is_char_ibeam = &is_char_closure;

int
is_integer_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	if (is_integer_array(r))
		return mk_scalar_bool(z, 1);
	
	return mk_scalar_bool(z, 0);
}

DEF_MON(is_integer_func_mon, is_integer_func)

struct cell_func is_integer_closure = {
	CELL_FUNC, 1, is_integer_func_mon, is_integer_func, 0
};
struct cell_func *is_integer_ibeam = &is_integer_closure;

int
shape_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	struct cell_array *t;
	enum array_type type;
	int err;
	
	type = ARR_BOOL;
	t = NULL;
	
	for (size_t i = 0; i < r->rank; i++) {
		size_t dim = r->shape[i];
		
		if (dim <= 1)
			continue;
		
		if (dim <= INT16_MAX && type < ARR_SINT) {
			type = ARR_SINT;
			continue;
		}
		
		if (dim <= INT32_MAX && type < ARR_INT) {
			type = ARR_INT;
			continue;
		}
		
		if (dim <= DBL_MAX && type < ARR_DBL) {
			type = ARR_DBL;
			continue;
		}
		
		CHK(10, fail, L"Shape exceeds DBL range");
	}
	
	CHK(mk_array(&t, type, STG_HOST, 1), fail,
	    L"mk_array(&t, type, STG_HOST, 1)");
	
	t->shape[0] = r->rank;
	
	CHK(alloc_array(t), fail, L"alloc_array(t)");
	
#define SHAPE_CASE(vt) {			\
	vt *shp = t->values;			\
						\
	for (size_t i = 0; i < r->rank; i++)	\
		shp[i] = (vt)r->shape[i];	\
						\
	break;					\
}
	
	switch (type) {
	case ARR_BOOL:SHAPE_CASE(int8_t);
	case ARR_SINT:SHAPE_CASE(int16_t);
	case ARR_INT:SHAPE_CASE(int32_t);
	case ARR_DBL:SHAPE_CASE(double);
	default:
		CHK(99, fail, L"Unexpected type");
	}
	
	*z = t;
	
	return 0;

fail:
	release_array(t);
	return err;
}

DEF_MON(shape_func_mon, shape_func)
    
struct cell_func shape_closure = {CELL_FUNC, 1, shape_func_mon, shape_func, 0};
struct cell_func *shape_ibeam = &shape_closure;

int
max_shp_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	size_t lc, rc;
	
	lc = array_count(l);
	rc = array_count(r);
	
	if (lc != 1)
		return shape_func(z, NULL, l, shape_ibeam);
	
	if (rc != 1)
		return shape_func(z, NULL, r, shape_ibeam);
	
	if (r->rank > l->rank)
		return shape_func(z, NULL, r, shape_ibeam);
	
	return shape_func(z, NULL, l, shape_ibeam);
}

DEF_MON(max_shp_func_mon, max_shp_func)

struct cell_func max_shp_closure = {
	CELL_FUNC, 1, max_shp_func_mon, max_shp_func, 0
};
struct cell_func *max_shp_ibeam = &max_shp_closure;

int
ravel_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	struct cell_array *t;
	int err;

	if (err = mk_array(&t, r->type, r->storage, 1))
		return err;
	
	t->shape[0] = array_count(r);
	t->values = r->values;
	t->vrefc = r->vrefc;
	
	retain_array_data(t);
	
	*z = t;
	
	return 0;
}

DEF_MON(ravel_func_mon, ravel_func)

struct cell_func ravel_closure = {CELL_FUNC, 1, ravel_func_mon, ravel_func, 0};
struct cell_func *ravel_ibeam = &ravel_closure;

int
disclose_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	struct cell_array *t;
	int err;
		
	if (r->type == ARR_NESTED) {
		struct cell_array **vals = r->values;
		
		*z = retain_cell(vals[0]);
		
		return 0;
	}
	
	t = NULL;
	
	CHK(mk_array(&t, r->type, r->storage, 0), fail, L"mk_array");
	
	switch (r->storage) {
	case STG_DEVICE:
		af_seq idx = {0, 0, 1};
		CHK(af_index(&t->values, r->values, 1, &idx), fail,
		    L"af_index");
		break;
	case STG_HOST:
		CHK(fill_array(t, r->values), fail, L"fill_array");
		break;
	default:
		CHK(99, fail, L"Unknown storage type");
	}
	
	*z = t;
	
	return 0;
	
fail:
	release_array(t);
	
	return err;
}

DEF_MON(disclose_func_mon, disclose_func)

struct cell_func disclose_closure = {
	CELL_FUNC, 1, disclose_func_mon, disclose_func, 0
};
struct cell_func *disclose_ibeam = &disclose_closure;

int
enclose_func(struct cell_array **z,
    struct cell_array *r, struct cell_func *self)
{
	struct cell_array *tmp;
	int err;
	
	CHK(mk_array(&tmp, ARR_NESTED, STG_HOST, 0), done, 
	    L"Enclose non-simple array");
	
	CHK(fill_array(tmp, &r), done, L"Store array to enclose");
	retain_cell(r);
	
	*z = tmp;
	
done:
	return err;
}

struct cell_func enclose_closure = {
	CELL_FUNC, 1, enclose_func, error_syntax_dya, 0
};
struct cell_func *enclose_ibeam = &enclose_closure;


int
q_ambiv_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	struct cell_func *mop, *dop;
	
	mop = self->fv[1];
	dop = self->fv[2];
	
	if (l == NULL)
		return (mop->fptr_mon)(z, r, mop);
	
	return (dop->fptr_dya)(z, l, r, dop);
}

DEF_MON(q_ambiv_func_mon, q_ambiv_func)

struct cell_doper q_ambiv_closure = {
	CELL_DOPER, 1, 
	error_syntax_mon, error_syntax_dya, error_syntax_mon, error_syntax_dya,
	error_syntax_mon, error_syntax_dya, q_ambiv_func_mon, q_ambiv_func, 
	0
};
struct cell_doper *q_ambiv_ibeam = &q_ambiv_closure;

int
reshape_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	struct cell_array *t;
	char *buf;
	size_t tc, rc, blocks, tail, rsize;
	af_array rvals;
	int err;
	unsigned int rank;
	
	rank = 1;
	rvals = NULL;	
	t = NULL;
	
	if (l->rank == 1) {
		if (l->shape[0] > UINT_MAX)
			CHK(10, fail, L"Rank exceeds UINT range");

		rank = (unsigned int)l->shape[0];
	}
	
	CHK(mk_array(&t, r->type, r->storage, rank), fail,
	    L"mk_array(&t, r->type, r->storage, rank)");
	
	switch (l->storage) {
	case STG_DEVICE:
		af_array l64;
		
		CHKAF(af_eval(l->values), fail);
		CHKAF(af_cast(&l64, l->values, u64), fail);
		CHKAF(af_get_data_ptr(t->shape, l64), fail);
		CHKAF(af_release_array(l64), fail);
		
		break;
	case STG_HOST:
	#define RESHAPE_SHAPE_CASE(tp) {			\
		tp *vals = (tp *)l->values;			\
								\
		for (unsigned int i = 0; i < rank; i++)		\
			t->shape[i] = (size_t)vals[i];		\
								\
		break;						\
	}

		switch (l->type) {
		case ARR_BOOL:RESHAPE_SHAPE_CASE(int8_t);
		case ARR_SINT:RESHAPE_SHAPE_CASE(int16_t);
		case ARR_INT:RESHAPE_SHAPE_CASE(int32_t);
		case ARR_DBL:RESHAPE_SHAPE_CASE(double);
		default:
			CHK(99, fail, L"Unexpected shape type");
		}
	
		break;
	default:
		CHK(99, fail, L"Unknown storage type");
	}
	
	tc = array_values_count(t);
	rc = array_values_count(r);
	
	if (tc == rc) {
		t->values = r->values;
		t->vrefc = r->vrefc;
		
		CHK(retain_array_data(t), fail, L"retain_array_data(t)");
		
		goto done;
	}
	
	CHK(alloc_array(t), fail, L"alloc_array(t)");
	
	if (t->storage == STG_DEVICE) {
		if (t->type == ARR_NESTED)
			CHK(99, fail, L"Unexpected nested array");
		
		if (tc > DBL_MAX)
			CHK(10, fail, L"Count exceeds DBL range");
		
		af_seq idx = {0, (double)tc - 1, 1};
		size_t tiles = (tc + rc - 1) / rc;
		
		if (tiles > UINT_MAX)
			CHK(10, fail, L"Tiles exceed UINT range");
		
		CHKAF(
		    af_tile(&rvals, r->values, (unsigned int)tiles, 1, 1, 1), 
		    fail);
		CHKAF(af_index(&t->values, rvals, 1, &idx), fail);
		CHKAF(af_release_array(rvals), fail);

		goto done;
	}
	
	if (t->storage != STG_HOST)
		CHK(99, fail, L"Unexpected storage type");
	
	blocks = tc / rc;
	tail = tc % rc;
	rsize = rc * array_element_size(r);
	buf = t->values;
	
	for (size_t i = 0; i < blocks; i++) {
		memcpy(buf, r->values, rsize);
		buf += rsize;
	}
	
	if (tail)
		memcpy(buf, r->values, tail * array_element_size(t));
	
	if (t->type == ARR_NESTED) {
		struct cell_array **vals = t->values;
		
		for (size_t i = 0; i < tc; i++)
			retain_cell(vals[i]);
	}

done:
	*z = t;
	
	return 0;
	
fail:
	if (rvals)
		af_release_array(rvals);
	
	release_array(t);
	return err;
}

DEF_MON(reshape_func_mon, reshape_func)

struct cell_func reshape_closure = {
	CELL_FUNC, 1, reshape_func_mon, reshape_func, 0
};
struct cell_func *reshape_ibeam = &reshape_closure;

int
same_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	int err;
	int8_t is_same;
	
	CHK(array_is_same(&is_same, l, r), done, 
	    L"array_is_same(&is_same, l, r)");
	
	CHK(mk_scalar_bool(z, is_same), done, 
	    L"mk_scalar_bool(z, is_same)");
	
done:
	return err;
}

struct cell_func same_closure = {CELL_FUNC, 1, error_syntax_mon, same_func, 0};
struct cell_func *same_ibeam = &same_closure;

int
nqv_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	int err;
	int8_t is_same;
	
	CHK(array_is_same(&is_same, l, r), done, 
	    L"array_is_same(&is_same, l, r)");
	
	CHK(mk_scalar_bool(z, !is_same), done, 
	    L"mk_scalar_bool(z, !is_same)");
	
done:
	return err;
}

struct cell_func nqv_closure = {CELL_FUNC, 1, error_syntax_mon, nqv_func, 0};
struct cell_func *nqv_ibeam = &nqv_closure;

#define NOOP(zt, lt, rt)

#define SIMPLE_SWITCH(LOOP, CMPX_LOOP, LCMPX_LOOP, RCMPX_LOOP, zt, lt, rt, def_expr)			\
	switch (type_pair((lt), (rt))) {								\
	case type_pair(ARR_SPAN, ARR_BOOL):LOOP(zt,	    int, int8_t);break;				\
	case type_pair(ARR_SPAN, ARR_SINT):LOOP(zt,	    int, int16_t);break;			\
	case type_pair(ARR_SPAN, ARR_INT):LOOP(zt,	    int, int32_t);break;			\
	case type_pair(ARR_SPAN, ARR_DBL):LOOP(zt,	    int, double);break;				\
	case type_pair(ARR_SPAN, ARR_CMPX):RCMPX_LOOP(zt,   int, struct apl_cmpx);break;		\
	case type_pair(ARR_SPAN, ARR_CHAR8):LOOP(zt,	    int, uint8_t);break;			\
	case type_pair(ARR_SPAN, ARR_CHAR16):LOOP(zt,	    int, uint16_t);break;			\
	case type_pair(ARR_SPAN, ARR_CHAR32):LOOP(zt,	    int, uint32_t);break;			\
	case type_pair(ARR_BOOL, ARR_BOOL):LOOP(zt,	    int8_t, int8_t);break;			\
	case type_pair(ARR_BOOL, ARR_SINT):LOOP(zt,	    int8_t, int16_t);break;			\
	case type_pair(ARR_BOOL, ARR_INT):LOOP(zt,	    int8_t, int32_t);break;			\
	case type_pair(ARR_BOOL, ARR_DBL):LOOP(zt,	    int8_t, double);break;			\
	case type_pair(ARR_BOOL, ARR_CMPX):RCMPX_LOOP(zt,   int8_t, struct apl_cmpx);break;		\
	case type_pair(ARR_BOOL, ARR_CHAR8):LOOP(zt,	    int8_t, uint8_t);break;			\
	case type_pair(ARR_BOOL, ARR_CHAR16):LOOP(zt,	    int8_t, uint16_t);break;			\
	case type_pair(ARR_BOOL, ARR_CHAR32):LOOP(zt,	    int8_t, uint32_t);break;			\
	case type_pair(ARR_SINT, ARR_BOOL):LOOP(zt,	    int16_t, int8_t);break;			\
	case type_pair(ARR_SINT, ARR_SINT):LOOP(zt,	    int16_t, int16_t);break;			\
	case type_pair(ARR_SINT, ARR_INT):LOOP(zt,	    int16_t, int32_t);break;			\
	case type_pair(ARR_SINT, ARR_DBL):LOOP(zt,	    int16_t, double);break;			\
	case type_pair(ARR_SINT, ARR_CMPX):RCMPX_LOOP(zt,   int16_t, struct apl_cmpx);break;		\
	case type_pair(ARR_SINT, ARR_CHAR8):LOOP(zt,	    int16_t, uint8_t);break;			\
	case type_pair(ARR_SINT, ARR_CHAR16):LOOP(zt,	    int16_t, uint16_t);break;			\
	case type_pair(ARR_SINT, ARR_CHAR32):LOOP(zt,	    int16_t, uint32_t);break;			\
	case type_pair(ARR_INT, ARR_BOOL):LOOP(zt,	    int32_t, int8_t);break;			\
	case type_pair(ARR_INT, ARR_SINT):LOOP(zt,	    int32_t, int16_t);break;			\
	case type_pair(ARR_INT, ARR_INT):LOOP(zt,	    int32_t, int32_t);break;			\
	case type_pair(ARR_INT, ARR_DBL):LOOP(zt,	    int32_t, double);break;			\
	case type_pair(ARR_INT, ARR_CMPX):RCMPX_LOOP(zt,    int32_t, struct apl_cmpx);break;		\
	case type_pair(ARR_INT, ARR_CHAR8):LOOP(zt,	    int32_t, uint8_t);break;			\
	case type_pair(ARR_INT, ARR_CHAR16):LOOP(zt,	    int32_t, uint16_t);break;			\
	case type_pair(ARR_INT, ARR_CHAR32):LOOP(zt,	    int32_t, uint32_t);break;			\
	case type_pair(ARR_DBL, ARR_BOOL):LOOP(zt,	    double, int8_t);break;			\
	case type_pair(ARR_DBL, ARR_SINT):LOOP(zt,	    double, int16_t);break;			\
	case type_pair(ARR_DBL, ARR_INT):LOOP(zt,	    double, int32_t);break;			\
	case type_pair(ARR_DBL, ARR_DBL):LOOP(zt,	    double, double);break;			\
	case type_pair(ARR_DBL, ARR_CMPX):RCMPX_LOOP(zt,    double, struct apl_cmpx);break;		\
	case type_pair(ARR_DBL, ARR_CHAR8):LOOP(zt,	    double, uint8_t);break;			\
	case type_pair(ARR_DBL, ARR_CHAR16):LOOP(zt,	    double, uint16_t);break;			\
	case type_pair(ARR_DBL, ARR_CHAR32):LOOP(zt,	    double, uint32_t);break;			\
	case type_pair(ARR_CMPX, ARR_BOOL):LCMPX_LOOP(zt,   struct apl_cmpx, int8_t);break;		\
	case type_pair(ARR_CMPX, ARR_SINT):LCMPX_LOOP(zt,   struct apl_cmpx, int16_t);break;		\
	case type_pair(ARR_CMPX, ARR_INT):LCMPX_LOOP(zt,    struct apl_cmpx, int32_t);break;		\
	case type_pair(ARR_CMPX, ARR_DBL):LCMPX_LOOP(zt,    struct apl_cmpx, double);break;		\
	case type_pair(ARR_CMPX, ARR_CMPX):CMPX_LOOP(zt,    struct apl_cmpx, struct apl_cmpx);break;	\
	case type_pair(ARR_CMPX, ARR_CHAR8):LCMPX_LOOP(zt,  struct apl_cmpx, uint8_t);break;		\
	case type_pair(ARR_CMPX, ARR_CHAR16):LCMPX_LOOP(zt, struct apl_cmpx, uint16_t);break;		\
	case type_pair(ARR_CMPX, ARR_CHAR32):LCMPX_LOOP(zt, struct apl_cmpx, uint32_t);break;		\
	case type_pair(ARR_CHAR8, ARR_BOOL):LOOP(zt,	    uint8_t, int8_t);break;			\
	case type_pair(ARR_CHAR8, ARR_SINT):LOOP(zt,	    uint8_t, int16_t);break;			\
	case type_pair(ARR_CHAR8, ARR_INT):LOOP(zt,	    uint8_t, int32_t);break;			\
	case type_pair(ARR_CHAR8, ARR_DBL):LOOP(zt,	    uint8_t, double);break;			\
	case type_pair(ARR_CHAR8, ARR_CMPX):RCMPX_LOOP(zt,  uint8_t, struct apl_cmpx);break;		\
	case type_pair(ARR_CHAR8, ARR_CHAR8):LOOP(zt,	    uint8_t, uint8_t);break;			\
	case type_pair(ARR_CHAR8, ARR_CHAR16):LOOP(zt,	    uint8_t, uint16_t);break;			\
	case type_pair(ARR_CHAR8, ARR_CHAR32):LOOP(zt,	    uint8_t, uint32_t);break;			\
	case type_pair(ARR_CHAR16, ARR_BOOL):LOOP(zt,	    uint16_t, int8_t);break;			\
	case type_pair(ARR_CHAR16, ARR_SINT):LOOP(zt,	    uint16_t, int16_t);break;			\
	case type_pair(ARR_CHAR16, ARR_INT):LOOP(zt,	    uint16_t, int32_t);break;			\
	case type_pair(ARR_CHAR16, ARR_DBL):LOOP(zt,	    uint16_t, double);break;			\
	case type_pair(ARR_CHAR16, ARR_CMPX):RCMPX_LOOP(zt, uint16_t, struct apl_cmpx);break;		\
	case type_pair(ARR_CHAR16, ARR_CHAR8):LOOP(zt,	    uint16_t, uint8_t);break;			\
	case type_pair(ARR_CHAR16, ARR_CHAR16):LOOP(zt,	    uint16_t, uint16_t);break;			\
	case type_pair(ARR_CHAR16, ARR_CHAR32):LOOP(zt,	    uint16_t, uint32_t);break;			\
	case type_pair(ARR_CHAR32, ARR_BOOL):LOOP(zt,	    uint32_t, int8_t);break;			\
	case type_pair(ARR_CHAR32, ARR_SINT):LOOP(zt,	    uint32_t, int16_t);break;			\
	case type_pair(ARR_CHAR32, ARR_INT):LOOP(zt,	    uint32_t, int32_t);break;			\
	case type_pair(ARR_CHAR32, ARR_DBL):LOOP(zt,	    uint32_t, double);break;			\
	case type_pair(ARR_CHAR32, ARR_CMPX):RCMPX_LOOP(zt, uint32_t, struct apl_cmpx);break;		\
	case type_pair(ARR_CHAR32, ARR_CHAR8):LOOP(zt,	    uint32_t, uint8_t);break;			\
	case type_pair(ARR_CHAR32, ARR_CHAR16):LOOP(zt,	    uint32_t, uint16_t);break;			\
	case type_pair(ARR_CHAR32, ARR_CHAR32):LOOP(zt,	    uint32_t, uint32_t);break;			\
	default:											\
		def_expr;										\
	}

int
q_veach_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	struct cell_func *oper;
	struct cell_array *t, *x, *y, **tvals;
	void *lbuf, *rbuf;
	size_t count, lc, rc;
	int err, fl, fr, fy, fx;
	
	if (l->type == ARR_SPAN || r->type == ARR_SPAN) {
		TRC(99, L"Unexpected SPAN array type");
		return 99;
	}
	
	oper = self->fv[1];

	t = x = y = NULL;
	
	lc = array_values_count(l);
	rc = array_values_count(r);
	
	lbuf = l->values;
	rbuf = r->values;
	fl = 0;
	fr = 0;
	fy = 0;
	fx = 0;
	
	if (l->storage == STG_DEVICE) {
		lbuf = malloc(lc * array_element_size(l));
		
		CHK(lbuf == NULL, fail, L"Failed to allocate ⍵ buffer");
		
		fl = 1;
		
		CHK(af_eval(l->values), fail, L"af_eval(l->values)");
		CHK(af_get_data_ptr(lbuf, l->values), fail, 
		    L"af_get_data_ptr(lbuf, l->values)");
	}
	
	if (r->storage == STG_DEVICE) {
		rbuf = malloc(rc * array_element_size(r));
		
		CHK(rbuf == NULL, fail, L"Failed to allocate ⍺ buffer");
		
		fr = 1;
		
		CHK(af_eval(r->values), fail, L"af_eval(r->values)");
		CHK(af_get_data_ptr(rbuf, r->values), fail, 
		    L"af_get_data_ptr(rbuf, r->values)");
	}
	
	CHK(mk_array(&t, ARR_NESTED, STG_HOST, 1), fail,
	    L"mk_array(&t, ARR_NESTED, STG_HOST, 1)");
	
	t->shape[0] = count = lc > rc ? lc : rc;
	
	CHK(alloc_array(t), fail, L"alloc_array(t)");
	
	tvals = t->values;
	
	if (l->type == ARR_NESTED && r->type == ARR_NESTED) {
		struct cell_array **lvals = lbuf;
		struct cell_array **rvals = rbuf;
		
		for (size_t i = 0; i < count; i++) {
			x = lvals[i % lc];
			y = rvals[i % rc];
			
			CHK((oper->fptr_dya)(tvals + i, x, y, oper), fail,
			    L"tvals[i] ← ⍺[lc|i] ⍺⍺ ⍵[rc|i] ⍝ NST/NST");
		}
		
		goto done;
	}
	
	if (l->type != ARR_NESTED) {
		CHK(mk_array(&x, l->type, STG_HOST, 0), fail,
		    L"mk_array(&x, l->type, STG_HOST, 0)");

		fx = 1;
		
		CHK(alloc_array(x), fail, L"alloc_array(x)");
	}
	
	if (r->type != ARR_NESTED) {
		CHK(mk_array(&y, r->type, STG_HOST, 0), fail,
		    L"mk_array(&y, r->type, STG_HOST, 0)");
		
		fy = 1;
		
		CHK(alloc_array(y), fail, L"alloc_array(y)");
	}
	
	if (l->type == ARR_NESTED) {
		struct cell_array **lvals = lbuf;
		
#define VEACH_LNESTED_LOOP(type) {					\
	type *rvals, *yvals;						\
									\
	rvals = rbuf;							\
	yvals = y->values;						\
									\
	for (size_t i = 0; i < count; i++) {				\
		x = lvals[i % lc];					\
		yvals[0] = rvals[i % rc];				\
									\
		CHK((oper->fptr_dya)(tvals + i, x, y, oper), fail,	\
		    L"tvals[i] ← ⍺[lc|i] ⍺⍺ ⍵[rc|i] ⍝ NST/" L#type);	\
	}								\
									\
	break;								\
}
		
		switch (r->type) {
		case ARR_BOOL:VEACH_LNESTED_LOOP(int8_t);
		case ARR_SINT:VEACH_LNESTED_LOOP(int16_t);
		case ARR_INT:VEACH_LNESTED_LOOP(int32_t);
		case ARR_DBL:VEACH_LNESTED_LOOP(double);
		case ARR_CMPX:VEACH_LNESTED_LOOP(struct apl_cmpx);
		case ARR_CHAR8:VEACH_LNESTED_LOOP(uint8_t);
		case ARR_CHAR16:VEACH_LNESTED_LOOP(uint16_t);
		case ARR_CHAR32:VEACH_LNESTED_LOOP(uint32_t);
		default:
			CHK(99, fail, L"Unknown simple type for ⍵");
		}
		
		goto done;
	}
	
	if (r->type == ARR_NESTED) {
		struct cell_array **rvals = rbuf;
		
#define VEACH_RNESTED_LOOP(type) {					\
	type *lvals, *xvals;						\
									\
	lvals = lbuf;							\
	xvals = x->values;						\
									\
	for (size_t i = 0; i < count; i++) {				\
		xvals[0] = lvals[i % lc];				\
		y = rvals[i % rc];					\
									\
		CHK((oper->fptr_dya)(tvals + i, x, y, oper), fail,	\
		    L"tvals[i]←⍺[lc|i] ⍺⍺ ⍵[rc|i] ⍝ " L#type L"/NST");	\
	}								\
									\
	break;								\
}
		
		switch (l->type) {
		case ARR_BOOL:VEACH_RNESTED_LOOP(int8_t);
		case ARR_SINT:VEACH_RNESTED_LOOP(int16_t);
		case ARR_INT:VEACH_RNESTED_LOOP(int32_t);
		case ARR_DBL:VEACH_RNESTED_LOOP(double);
		case ARR_CMPX:VEACH_RNESTED_LOOP(struct apl_cmpx);
		case ARR_CHAR8:VEACH_RNESTED_LOOP(uint8_t);
		case ARR_CHAR16:VEACH_RNESTED_LOOP(uint16_t);
		case ARR_CHAR32:VEACH_RNESTED_LOOP(uint32_t);
		default:
			CHK(99, fail, L"Unknown simple type for ⍺");
		}
		
		goto done;
	}
	
#define VEACH_LOOP(ztype, ltype, rtype) {				\
	ltype *lvals, *xvals;						\
	rtype *rvals, *yvals;						\
									\
	lvals = lbuf;							\
	rvals = rbuf;							\
	xvals = x->values;						\
	yvals = y->values;						\
									\
	for (size_t i = 0; i < count; i++) {				\
		xvals[0] = lvals[i % lc];				\
		yvals[0] = rvals[i % rc];				\
									\
		CHK((oper->fptr_dya)(tvals + i, x, y, oper), fail,	\
		    L"tvals[i]←⍺[lc|i] ⍺⍺ ⍵[rc|i] ⍝ " 			\
		    L#ltype L"/" L#rtype);				\
	}								\
}

	SIMPLE_SWITCH(VEACH_LOOP,VEACH_LOOP,VEACH_LOOP,VEACH_LOOP,,
	    l->type, r->type, 
	    CHK(99, fail, L"Unknown simple type combo"))
	
done:
	CHK(squeeze_array(t), fail, L"squeeze_array(t)");
	
	*z = t;

fail:
	if (fl)
		free(lbuf);
	
	if (fr)
		free(rbuf);
	
	if (fy)
		release_array(y);
	
	if (fx)
		release_array(x);
	
	if (err)
		release_array(t);
	
	return err;
}

DEF_MON(q_veach_func_mon, q_veach_func)

struct cell_moper q_veach_closure = {
	CELL_FUNC, 1, 
	error_syntax_mon, error_syntax_dya, q_veach_func_mon, q_veach_func, 
	0
};
struct cell_moper *q_veach_ibeam = &q_veach_closure;

int
squeeze_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	int err;
	
	if (err = squeeze_array(r))
		return err;
	
	*z = retain_cell(r);
	
	return 0;
}

DEF_MON(squeeze_func_mon, squeeze_func)

struct cell_func squeeze_closure = {
	CELL_FUNC, 1, squeeze_func_mon, squeeze_func, 0
};
struct cell_func *squeeze_ibeam = &squeeze_closure;

int
has_nat_vals_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	int err, is_nat;
	
	if (err = has_natural_values(&is_nat, r))
		return err;
	
	return mk_scalar_bool(z, is_nat);
}

DEF_MON(has_nat_vals_func_mon, has_nat_vals_func)

struct cell_func has_nat_vals_closure = {
	CELL_FUNC, 1, has_nat_vals_func_mon, has_nat_vals_func, 0
};
struct cell_func *has_nat_vals_ibeam = &has_nat_vals_closure;

int
index_gen_func(struct cell_array **z, struct cell_array *r, struct cell_func *self)
{
	struct cell_array *t;
	size_t dim, tile;
	enum array_type ztype;
	af_dtype aftype;
	int err;
	
	err = 0;
	t = NULL;
	
	CHK(get_scalar_u64(&dim, r), fail,
	    L"get_scalar_u64(&dim, r)");
	
	ztype = closest_numeric_array_type((double)dim);
	
	if (ztype == ARR_BOOL)
		ztype = ARR_SINT;
	
	CHK(mk_array(&t, ztype, STG_DEVICE, 1), fail,
	    L"mk_array(&t, ztype, STG_DEVICE, 1)");
	
	t->shape[0] = dim;
	tile = 1;
	aftype = array_af_dtype(t);
	
	CHKAF(af_iota(&t->values, 1, &dim, 1, &tile, aftype), fail);
	
	*z = t;
	
	return 0;

fail:
	release_array(t);
	
	return err;
}

struct cell_func index_gen_closure = {
	CELL_FUNC, 1, index_gen_func, error_syntax_dya, 0
};
struct cell_func *index_gen_vec = &index_gen_closure;

int
index_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	struct cell_array *t;
	int err;

	if (err = mk_array(&t, r->type, r->storage, 1))
		return err;
	
	t->shape[0] = array_values_count(l);
	
	if (err = array_promote_storage(l, r))
		goto fail;

	if (l->storage == STG_DEVICE) {
		if (err = af_lookup(&t->values, r->values, l->values, 0))
			goto fail;
		
		goto done;
	}
	
	if (err = alloc_array(t))
		goto fail;
	
#define INDEX_LOOP(ztype, ltype, rtype) {			\
	ltype *lvals = l->values;			\
	rtype *rvals = r->values;			\
	rtype *tvals = t->values;			\
							\
	for (size_t i = 0; i < t->shape[0]; i++)	\
		tvals[i] = rvals[(ztype)lvals[i]];	\
}

	if (r->type == ARR_NESTED) {
		struct cell_array **rvals = r->values;
		
		switch (l->type) {
		case ARR_BOOL:
			INDEX_LOOP(int8_t, int8_t, struct cell_array *);
			break;
		case ARR_SINT:
			INDEX_LOOP(int16_t, int16_t, struct cell_array *);
			break;
		case ARR_INT:
			INDEX_LOOP(int32_t, int32_t, struct cell_array *);
			break;
		case ARR_DBL:
			INDEX_LOOP(size_t, double, struct cell_array *);
			break;
		default:
			err = 99;
			goto fail;
		}
		
		goto done;
	}

	SIMPLE_SWITCH(INDEX_LOOP, NOOP, NOOP, INDEX_LOOP,
	    size_t, l->type, r->type,
	    {err = 99; goto fail;})

done:
	*z = t;
	
	return 0;
	
fail:
	release_array(t);
	return err;
}

DEF_MON(index_func_mon, index_func)

struct cell_func index_closure = {
	CELL_FUNC, 1, index_func_mon, index_func, 0
};
struct cell_func *index_ibeam = &index_closure;

int
monadic_scalar_apply(struct cell_array **z, struct cell_array *r,
    int (*fn)(struct cell_array *, struct cell_array *))
{
	struct cell_array *t;
	int err;
		
	if (err = mk_array(&t, ARR_SPAN, r->storage, r->rank))
		return err;
	
	for (unsigned int i = 0; i < r->rank; i++)
		t->shape[i] = r->shape[i];
	
	if (err = fn(t, r))
		goto fail;
	
	*z = t;
	
	return 0;

fail:
	release_array(t);
	
	return err;
}

int
dyadic_scalar_apply(struct cell_array **z, 
    struct cell_array *l, struct cell_array *r, 
    int (*scl_type)(enum array_type *, struct cell_array *, struct cell_array *), 
    int (*scl_device)(af_array *, af_array, af_array),
    int (*scl_host)(struct cell_array *, size_t, 
	struct cell_array *, size_t, struct cell_array *, size_t))
{
	struct cell_array *t;
	size_t lc, rc;
	enum array_type ztype;
	int err;
	
	if (err = array_promote_storage(l, r))
		return err;
	
	if (err = scl_type(&ztype, l, r))
		return err;
	
	if (err = mk_array(&t, ztype, l->storage, 1))
		return err;
	
	lc = array_values_count(l);
	rc = array_values_count(r);
	t->shape[0] = lc > rc ? lc : rc;
	
	if (t->storage == STG_DEVICE) {
		unsigned int ltc, rtc;
		af_array ltile, rtile, lcast, rcast, za;
		af_dtype type;
		
		ltile = rtile = lcast = rcast = za = NULL;
		
		if (rc > UINT_MAX || lc > UINT_MAX) {
			err = 10;
			goto fail;
		}
		
		ltc = (unsigned int)(rc > lc ? rc : 1);
		
		if (err = af_tile(&ltile, l->values, ltc, 1, 1, 1))
			goto device_done;
		
		rtc = (unsigned int)(lc > rc ? lc : 1);
		
		if (err = af_tile(&rtile, r->values, rtc, 1, 1, 1))
			goto device_done;

		type = array_af_dtype(t);
		
		if (err = af_cast(&lcast, ltile, type))
			goto device_done;
		
		if (err = af_cast(&rcast, rtile, type))
			goto device_done;
		
		if (err = scl_device(&za, lcast, rcast))
			goto device_done;
		
		t->values = za;

device_done:
		af_release_array(rcast);
		af_release_array(lcast);
		af_release_array(rtile);
		af_release_array(ltile);
		
		if (err)
			goto fail;

		goto done;
	}
	
	if (t->storage != STG_HOST)
		return 99;
	
	if (err = alloc_array(t)) 
		goto fail;
	
	if (err = scl_host(t, t->shape[0], l, lc, r, rc))
		goto fail;

done:
	*z = t;
	
	return 0;

fail:
	release_array(t);
	
	return err;
}

#define MON_LOOP(zt, rt, expr) {		\
	zt *tvals = t->values;			\
	rt *rvals = r->values;			\
						\
	for (size_t i = 0; i < count; i++) {	\
		rt x = rvals[i];		\
						\
		tvals[i] = (expr);		\
	}					\
}						\

#define LOOP_LOCALS(ztype, ltype, rtype)	\
	ztype *tvals = t->values;		\
	ltype *lvals = l->values;		\
	rtype *rvals = r->values;		\
	
#define EXPR_LOOP(ztype, ltype, rtype, expr) {	\
	LOOP_LOCALS(ztype, ltype, rtype)	\
						\
	for (size_t i = 0; i < count; i++) {	\
		ltype x = lvals[i % lc];	\
		rtype y = rvals[i % rc];	\
						\
		tvals[i] = (expr);		\
	}					\
}						\

#define RCMPX_LOOP(ztype, ltype, expr) {		\
	LOOP_LOCALS(ztype, ltype, struct apl_cmpx)	\
							\
	for (size_t i = 0; i < count; i++) {		\
		struct apl_cmpx x = {lvals[i % lc], 0};	\
		struct apl_cmpx y = rvals[i % rc];	\
							\
		tvals[i] = (expr);			\
	}						\
}							\

#define LCMPX_LOOP(ztype, rtype, expr) {		\
	LOOP_LOCALS(ztype, struct apl_cmpx, rtype)	\
							\
	for (size_t i = 0; i < count; i++) {		\
		struct apl_cmpx x = lvals[i % lc];	\
		struct apl_cmpx y = {rvals[i % rc], 0};	\
							\
		tvals[i] = (expr);			\
	}						\
}							\

int
conjugate_values(struct cell_array *t, struct cell_array *r)
{
	int err;
	
	t->type = ARR_DBL;
	
	switch (r->storage) {
	case STG_DEVICE:
		if (err = af_conjg(&t->values, r->values))
			return err;
		
		break;
	case STG_HOST:
		size_t count = array_values_count(t);

		if (err = alloc_array(t))
			return err;
		
		MON_LOOP(double, struct apl_cmpx, x.real);
		
		break;
	default:
		return 99;
	}
	
	return 0;
}

int
conjugate_func(struct cell_array **z,
    struct cell_array *r, struct cell_func *self)
{
	return monadic_scalar_apply(z, r, conjugate_values);
}

struct cell_func conjugate_closure = {
	CELL_FUNC, 1, conjugate_func, error_syntax_dya, 0
};
struct cell_func *conjugate_vec = &conjugate_closure;

int
max_type(enum array_type *type, struct cell_array *l, struct cell_array *r)
{
	*type = l->type > r->type ? l->type : r->type;
	
	return 0;
}

int
add_device(af_array *z, af_array l, af_array r)
{
	return af_add(z, l, r, 0);
}

struct apl_cmpx
add_cmpx(struct apl_cmpx x, struct apl_cmpx y)
{
	struct apl_cmpx z = {x.real + y.real, x.imag + y.imag};
	
	return z;
}

#define ADD_LOOP(zt, lt, rt) EXPR_LOOP(zt, lt, rt, (zt)x + (zt)y)
#define ADD_CMPX(zt, lt, rt) EXPR_LOOP(zt, lt, rt, add_cmpx(x, y))
#define ADD_RCMPX(zt, lt, rt) RCMPX_LOOP(zt, lt, add_cmpx(x, y))
#define ADD_LCMPX(zt, lt, rt) LCMPX_LOOP(zt, rt, add_cmpx(x, y))

int
add_host(struct cell_array *t, size_t count, 
    struct cell_array *l, size_t lc, struct cell_array *r, size_t rc)
{
	switch (t->type) {
	case ARR_BOOL:
		SIMPLE_SWITCH(ADD_LOOP, NOOP, NOOP, NOOP, 
		    int8_t, l->type, r->type, return 99);
		break;
	case ARR_SINT:
		SIMPLE_SWITCH(ADD_LOOP, NOOP, NOOP, NOOP, 
		     int16_t, l->type, r->type, return 99);
		break;
	case ARR_INT:
		SIMPLE_SWITCH(ADD_LOOP, NOOP, NOOP, NOOP, 
		     int32_t, l->type, r->type, return 99);
		break;
	case ARR_DBL:
		SIMPLE_SWITCH(ADD_LOOP, NOOP, NOOP, NOOP, 
		     double, l->type, r->type, return 99);
		break;
	case ARR_CMPX:
		SIMPLE_SWITCH(NOOP, ADD_CMPX, ADD_LCMPX, ADD_RCMPX, 
		     struct apl_cmpx, l->type, r->type, return 99);
		break;
	default:
		return 99;
	}
	
	return 0;
}

int
add_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	return dyadic_scalar_apply(z, l, r, max_type, add_device, add_host);
}

struct cell_func add_closure = {CELL_FUNC, 1, error_syntax_mon, add_func, 0};
struct cell_func *add_vec_ibeam = &add_closure;

int
mul_device(af_array *z, af_array l, af_array r)
{
	return af_mul(z, l, r, 0);
}

struct apl_cmpx
mul_cmpx(struct apl_cmpx x, struct apl_cmpx y)
{
	struct apl_cmpx z;
	
	z.real = x.real * y.real - x.imag * y.imag;
	z.imag = x.imag * y.real + x.real * y.imag;
	
	return z;
}

#define MUL_LOOP(zt, lt, rt) EXPR_LOOP(zt, lt, rt, (zt)x * (zt)y)
#define MUL_CMPX(zt, lt, rt) EXPR_LOOP(zt, lt, rt, mul_cmpx(x, y))
#define MUL_LCMPX(zt, lt, rt) LCMPX_LOOP(zt, rt, mul_cmpx(x, y))
#define MUL_RCMPX(zt, lt, rt) RCMPX_LOOP(zt, lt, mul_cmpx(x, y))

int
mul_host(struct cell_array *t, size_t count, 
    struct cell_array *l, size_t lc, struct cell_array *r, size_t rc)
{
	switch (t->type) {
	case ARR_BOOL:
		SIMPLE_SWITCH(MUL_LOOP, NOOP, NOOP, NOOP, 
		    int8_t, l->type, r->type, return 99);
		break;
	case ARR_SINT:
		SIMPLE_SWITCH(MUL_LOOP, NOOP, NOOP, NOOP, 
		     int16_t, l->type, r->type, return 99);
		break;
	case ARR_INT:
		SIMPLE_SWITCH(MUL_LOOP, NOOP, NOOP, NOOP, 
		     int32_t, l->type, r->type, return 99);
		break;
	case ARR_DBL:
		SIMPLE_SWITCH(MUL_LOOP, NOOP, NOOP, NOOP, 
		     double, l->type, r->type, return 99);
		break;
	case ARR_CMPX:
		SIMPLE_SWITCH(NOOP, MUL_CMPX, MUL_LCMPX, MUL_RCMPX, 
		     struct apl_cmpx, l->type, r->type, return 99);
		break;
	default:
		return 99;
	}
	
	return 0;
}

int
mul_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	return dyadic_scalar_apply(z, l, r, max_type, mul_device, mul_host);
}

struct cell_func mul_closure = {CELL_FUNC, 1, error_syntax_mon, mul_func, 0};
struct cell_func *mul_vec_ibeam = &mul_closure;

int
div_type(enum array_type *type, struct cell_array *l, struct cell_array *r)
{
	if (r->type == ARR_BOOL) {
		*type = l->type;
		return 0;
	}
	
	if (l->type == ARR_CMPX || r->type == ARR_CMPX) {
		*type = ARR_CMPX;
		return 0;
	}
	
	*type = ARR_DBL;
	
	return 0;
}

int
div_device(af_array *z, af_array l, af_array r)
{
	return af_div(z, l, r, 0);
}

struct apl_cmpx
div_cmpx(struct apl_cmpx x, struct apl_cmpx y)
{
	struct apl_cmpx z;
	double quot;
	
	quot = y.real * y.real + y.imag * y.imag;
	
	if (!quot) {
		z.real = 0;
		z.imag = 0;
		return z;
	}
	
	z.real = (x.real * y.real + x.imag * y.imag) / quot;
	z.imag = (x.imag * y.real - x.real * y.imag) / quot;
	
	return z;
}

#define DIV_LOOP(zt, lt, rt) EXPR_LOOP(zt, lt, rt, y ? (zt)x / (zt)y : 0)
#define DIV_CMPX(zt, lt, rt) EXPR_LOOP(zt, lt, rt, div_cmpx(x, y))
#define DIV_LCMPX(zt, lt, rt) LCMPX_LOOP(zt, rt, div_cmpx(x, y))
#define DIV_RCMPX(zt, lt, rt) RCMPX_LOOP(zt, lt, div_cmpx(x, y))

int
div_host(struct cell_array *t, size_t count, 
    struct cell_array *l, size_t lc, struct cell_array *r, size_t rc)
{
	switch (t->type) {
	case ARR_BOOL:
		SIMPLE_SWITCH(DIV_LOOP, NOOP, NOOP, NOOP, 
		    int8_t, l->type, r->type, return 99);
		break;
	case ARR_SINT:
		SIMPLE_SWITCH(DIV_LOOP, NOOP, NOOP, NOOP, 
		     int16_t, l->type, r->type, return 99);
		break;
	case ARR_INT:
		SIMPLE_SWITCH(DIV_LOOP, NOOP, NOOP, NOOP, 
		     int32_t, l->type, r->type, return 99);
		break;
	case ARR_DBL:
		SIMPLE_SWITCH(DIV_LOOP, NOOP, NOOP, NOOP, 
		     double, l->type, r->type, return 99);
		break;
	case ARR_CMPX:
		SIMPLE_SWITCH(NOOP, DIV_CMPX, DIV_LCMPX, DIV_RCMPX, 
		     struct apl_cmpx, l->type, r->type, return 99);
		break;
	default:
		return 99;
	}
	
	return 0;
}

int
div_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	return dyadic_scalar_apply(z, l, r, div_type, div_device, div_host);
}

struct cell_func div_closure = {CELL_FUNC, 1, error_syntax_mon, div_func, 0};
struct cell_func *div_vec_ibeam = &div_closure;

int
sub_device(af_array *z, af_array l, af_array r)
{
	return af_sub(z, l, r, 0);
}

struct apl_cmpx
sub_cmpx(struct apl_cmpx x, struct apl_cmpx y)
{
	struct apl_cmpx z = {x.real - y.real, x.imag - y.imag};
	
	return z;
}

#define SUB_LOOP(zt, lt, rt) EXPR_LOOP(zt, lt, rt, (zt)x - (zt)y)
#define SUB_CMPX(zt, lt, rt) EXPR_LOOP(zt, lt, rt, sub_cmpx(x, y))
#define SUB_LCMPX(zt, lt, rt) LCMPX_LOOP(zt, rt, sub_cmpx(x, y))
#define SUB_RCMPX(zt, lt, rt) RCMPX_LOOP(zt, lt, sub_cmpx(x, y))

int
sub_host(struct cell_array *t, size_t count, 
    struct cell_array *l, size_t lc, struct cell_array *r, size_t rc)
{
	switch (t->type) {
	case ARR_BOOL:
		SIMPLE_SWITCH(SUB_LOOP, NOOP, NOOP, NOOP, 
		    int8_t, l->type, r->type, return 99);
		break;
	case ARR_SINT:
		SIMPLE_SWITCH(SUB_LOOP, NOOP, NOOP, NOOP, 
		     int16_t, l->type, r->type, return 99);
		break;
	case ARR_INT:
		SIMPLE_SWITCH(SUB_LOOP, NOOP, NOOP, NOOP, 
		     int32_t, l->type, r->type, return 99);
		break;
	case ARR_DBL:
		SIMPLE_SWITCH(SUB_LOOP, NOOP, NOOP, NOOP, 
		     double, l->type, r->type, return 99);
		break;
	case ARR_CMPX:
		SIMPLE_SWITCH(NOOP, SUB_CMPX, SUB_LCMPX, SUB_RCMPX, 
		     struct apl_cmpx, l->type, r->type, return 99);
		break;
	default:
		return 99;
	}
	
	return 0;
}

int
sub_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	return dyadic_scalar_apply(z, l, r, max_type, sub_device, sub_host);
}

struct cell_func sub_closure = {CELL_FUNC, 1, error_syntax_mon, sub_func, 0};
struct cell_func *sub_vec_ibeam = &sub_closure;

int
dbl_cmpx_type(enum array_type *type, 
    struct cell_array *l, struct cell_array *r)
{
	*type = ARR_DBL;
	
	if (l->type == ARR_CMPX || r->type == ARR_CMPX)
		*type = ARR_CMPX;
	
	return 0;
}

int
pow_device(af_array *z, af_array l, af_array r)
{
	return af_pow(z, l, r, 0);
}

struct apl_cmpx
pow_cmpx(struct apl_cmpx x, struct apl_cmpx y)
{
	struct apl_cmpx z;

#ifdef _MSC_VER
	_Dcomplex tx = {x.real, x.imag};
	_Dcomplex ty = {y.real, y.imag};
	_Dcomplex tz;
#else
	double complex tx, ty, tz;

	tx = x.real + x.imag * I;
	ty = y.real + y.imag * I;
#endif

	tz = cpow(tx, ty);	

	z.real = creal(tz);	
	z.imag = cimag(tz);	

	return z;		
}				

#define POW_LOOP(zt, lt, rt) EXPR_LOOP(zt, lt, rt, pow(x, y))
#define POW_CMPX(zt, lt, rt) EXPR_LOOP(zt, lt, rt, pow_cmpx(x, y))
#define POW_LCMPX(zt, lt, rt) LCMPX_LOOP(zt, rt, pow_cmpx(x, y))
#define POW_RCMPX(zt, lt, rt) RCMPX_LOOP(zt, lt, pow_cmpx(x, y))

int
pow_host(struct cell_array *t, size_t count, 
    struct cell_array *l, size_t lc, struct cell_array *r, size_t rc)
{
	switch (t->type) {
	case ARR_DBL:
		SIMPLE_SWITCH(POW_LOOP, NOOP, NOOP, NOOP, 
		     double, l->type, r->type, return 99);
		break;
	case ARR_CMPX:
		SIMPLE_SWITCH(NOOP, POW_CMPX, POW_LCMPX, POW_RCMPX, 
		     struct apl_cmpx, l->type, r->type, return 99);
		break;
	default:
		return 99;
	}
	
	return 0;
}

int
pow_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	return dyadic_scalar_apply(z, l, r, dbl_cmpx_type, pow_device, pow_host);
}

struct cell_func pow_closure = {CELL_FUNC, 1, error_syntax_mon, pow_func, 0};
struct cell_func *pow_vec_ibeam = &pow_closure;

int
log_device(af_array *z, af_array l, af_array r)
{
	af_array l64, r64, a, b;
	int err, code;
	
	a = b = l64 = r64 = NULL;
	
	CHKAF(af_cast(&r64, r, f64), cleanup);
	CHKAF(af_cast(&l64, l, f64), cleanup);
	CHKAF(af_log(&a, r64), cleanup);
	CHKAF(af_log(&b, l64), cleanup);
	CHKAF(af_div(z, a, b, 0), cleanup);

	err = 0;
	
cleanup:
	code = err;
	
	CHKAF(af_release_array(a), fail);
	CHKAF(af_release_array(b), fail);
	CHKAF(af_release_array(r64), fail);
	CHKAF(af_release_array(l64), fail);
	
	return code; 
	
fail:
	return err;
}

struct apl_cmpx
log_cmpx(struct apl_cmpx x, struct apl_cmpx y)
{
	struct apl_cmpx a, b;

#ifdef _MSC_VER
	_Dcomplex tx = {x.real, x.imag};
	_Dcomplex ty = {y.real, y.imag};
	_Dcomplex tz;
#else
	double complex tx, ty, tz;

	tx = x.real + x.imag * I;
	ty = y.real + y.imag * I;
#endif

	tz = clog(tx);
	a.real = creal(tz);
	a.imag = cimag(tz);
	
	tz = clog(ty);
	b.real = creal(tz);
	b.imag = cimag(tz);
	
	return div_cmpx(a, b);
}				

#define LOG_LOOP(zt, lt, rt) EXPR_LOOP(zt, lt, rt, log(y) / log(x))
#define LOG_CMPX(zt, lt, rt) EXPR_LOOP(zt, lt, rt, log_cmpx(y, x))
#define LOG_LCMPX(zt, lt, rt) LCMPX_LOOP(zt, rt, log_cmpx(y, x))
#define LOG_RCMPX(zt, lt, rt) RCMPX_LOOP(zt, lt, log_cmpx(y, x))

int
log_host(struct cell_array *t, size_t count, 
    struct cell_array *l, size_t lc, struct cell_array *r, size_t rc)
{
	switch (t->type) {
	case ARR_DBL:
		SIMPLE_SWITCH(LOG_LOOP, NOOP, NOOP, NOOP, 
		     double, l->type, r->type, return 99);
		break;
	case ARR_CMPX:
		SIMPLE_SWITCH(NOOP, LOG_CMPX, LOG_LCMPX, LOG_RCMPX, 
		     struct apl_cmpx, l->type, r->type, return 99);
		break;
	default:
		return 99;
	}
	
	return 0;
}

int
log_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	return dyadic_scalar_apply(z, l, r, dbl_cmpx_type, log_device, log_host);
}

struct cell_func log_closure = {CELL_FUNC, 1, error_syntax_mon, log_func, 0};
struct cell_func *log_vec_ibeam = &log_closure;

struct apl_cmpx
exp_cmpx(struct apl_cmpx x)
{
	struct apl_cmpx z;
	
#ifdef _MSC_VER
	_Dcomplex tx = {x.real, x.imag};	
	_Dcomplex tz;
#else
	double complex tz, tx;

	tx = x.real + x.imag * I;
#endif
	
	tz = cexp(tx);
	
	z.real = creal(tz);
	z.imag = cimag(tz);
	
	return z;
}

#define EXP_LOOP(rt) MON_LOOP(double, rt, exp(x));

int
exp_values(struct cell_array *t, struct cell_array *r)
{
	int err;
	
	t->type = r->type == ARR_CMPX ? ARR_CMPX : ARR_DBL;
	
	if (r->storage == STG_DEVICE) {
		af_array tmp;
		CHKAF(af_cast(&tmp, r->values, f64), done);
		CHKAF(af_exp(&t->values, tmp), done);
		CHKAF(af_release_array(tmp), done);
		
		goto done;
	}
	
	if (r->storage != STG_HOST)
		CHK(99, done, L"Unknown storage type");
	
	CHK(alloc_array(t), done, L"alloc_array(t)");
	
	size_t count = array_values_count(t);
	
	switch (r->type) {
	case ARR_CMPX:
		MON_LOOP(struct apl_cmpx, struct apl_cmpx, exp_cmpx(x));
		break;
	case ARR_BOOL:
		EXP_LOOP(int8_t);
		break;
	case ARR_SINT:
		EXP_LOOP(int16_t);
		break;
	case ARR_INT:
		EXP_LOOP(int32_t);
		break;
	case ARR_DBL:
		EXP_LOOP(double);
		break;
	default:
		CHK(99, done, L"Unexpected element type");
	}
	
	err = 0;
	
done:
	return err;
}

int
exp_func(struct cell_array **z,
    struct cell_array *r, struct cell_func *self)
{
	return monadic_scalar_apply(z, r, exp_values);
}

struct cell_func exp_closure = {CELL_FUNC, 1, exp_func, error_syntax_dya, 0};
struct cell_func *exp_vec_ibeam = &exp_closure;

struct apl_cmpx
nlg_cmpx(struct apl_cmpx x)
{
	struct apl_cmpx z;
	
#ifdef _MSC_VER
	_Dcomplex tx = {x.real, x.imag};	
	_Dcomplex tz;
#else
	double complex tz, tx;

	tx = x.real + x.imag * I;
#endif
	
	tz = clog(tx);
	
	z.real = creal(tz);
	z.imag = cimag(tz);
	
	return z;
}

#define NLG_LOOP(rt) MON_LOOP(double, rt, log(x));

int
nlg_values(struct cell_array *t, struct cell_array *r)
{
	int err;
	
	t->type = r->type == ARR_CMPX ? ARR_CMPX : ARR_DBL;
	
	if (r->storage == STG_DEVICE) {
		af_array tmp;
		CHKAF(af_cast(&tmp, r->values, f64), done);
		CHKAF(af_log(&t->values, tmp), done);
		CHKAF(af_release_array(tmp), done);
		
		goto done;
	}
	
	if (r->storage != STG_HOST)
		CHK(99, done, L"Unknown storage type");
	
	CHK(alloc_array(t), done, L"alloc_array(t)");
	
	size_t count = array_values_count(t);
	
	switch (r->type) {
	case ARR_CMPX:
		MON_LOOP(struct apl_cmpx, struct apl_cmpx, nlg_cmpx(x));
		break;
	case ARR_BOOL:
		NLG_LOOP(int8_t);
		break;
	case ARR_SINT:
		NLG_LOOP(int16_t);
		break;
	case ARR_INT:
		NLG_LOOP(int32_t);
		break;
	case ARR_DBL:
		NLG_LOOP(double);
		break;
	default:
		CHK(99, done, L"Unexpected element type");
	}
	
	err = 0;
	
done:
	return err;
}

int
nlg_func(struct cell_array **z,
    struct cell_array *r, struct cell_func *self)
{
	return monadic_scalar_apply(z, r, nlg_values);
}

struct cell_func nlg_closure = {CELL_FUNC, 1, nlg_func, error_syntax_dya, 0};
struct cell_func *nlg_vec_ibeam = &nlg_closure;

int
bool_type(enum array_type *type, struct cell_array *l, struct cell_array *r)
{
	*type = ARR_BOOL;
	
	return 0;
}

#define DEF_CMP_IBEAM(name, cmp_dev, loop, loop_cmpx, loop_lcmpx, loop_rcmpx)		\
int                                                                                     \
name##_device(af_array *z, af_array l, af_array r)                                      \
{                                                                                       \
	return cmp_dev(z, l, r, 0);                                                     \
}                                                                                       \
											\
int                                                                                     \
name##_host(struct cell_array *t, size_t count,                                         \
    struct cell_array *l, size_t lc, struct cell_array *r, size_t rc)                   \
{                                                                                       \
											\
	switch (t->type) {                                                              \
	case ARR_BOOL:                                                                  \
		SIMPLE_SWITCH(loop, loop_cmpx, loop_lcmpx, loop_rcmpx,             	\
		    int8_t, l->type, r->type, return 99);                               \
		break;                                                                  \
	default:                                                                        \
		return 99;                                                              \
	}                                                                               \
											\
	return 0;                                                                       \
}                                                                                       \
											\
int                                                                                     \
name##_func(struct cell_array **z,                                                      \
    struct cell_array *l, struct cell_array *r, struct cell_func *self)                 \
{                                                                                       \
	return dyadic_scalar_apply(z, l, r, bool_type, name##_device, name##_host);      \
}                                                                                       \
											\
struct cell_func name##_closure = {CELL_FUNC, 1, error_syntax_mon, name##_func, 0};     \
struct cell_func *name##_vec_ibeam = &name##_closure;                                   \

#define AND_LOOP(zt, lt, rt) EXPR_LOOP(zt, lt, rt, x && y)
#define LOR_LOOP(zt, lt, rt) EXPR_LOOP(zt, lt, rt, x || y)
#define LTH_LOOP(zt, lt, rt) EXPR_LOOP(zt, lt, rt, (double)x < (double)y)
#define LTE_LOOP(zt, lt, rt) EXPR_LOOP(zt, lt, rt, (double)x <= (double)y)
#define GTH_LOOP(zt, lt, rt) EXPR_LOOP(zt, lt, rt, (double)x > (double)y)
#define GTE_LOOP(zt, lt, rt) EXPR_LOOP(zt, lt, rt, (double)x >= (double)y)
#define EQL_LOOP(zt, lt, rt) EXPR_LOOP(zt, lt, rt, x == y)
#define EQL_CMPX(zt, lt, rt) EXPR_LOOP(zt, lt, rt, x.real == y.real && x.imag == y.imag)
#define EQL_LCMPX(zt, lt, rt) EXPR_LOOP(zt, lt, rt, x.real == y && x.imag == 0)
#define EQL_RCMPX(zt, lt, rt) EXPR_LOOP(zt, lt, rt, x == y.real && 0 == y.imag)
#define NEQ_LOOP(zt, lt, rt) EXPR_LOOP(zt, lt, rt, x != y)
#define NEQ_CMPX(zt, lt, rt) EXPR_LOOP(zt, lt, rt, x.real != y.real || x.imag != y.imag)
#define NEQ_LCMPX(zt, lt, rt) EXPR_LOOP(zt, lt, rt, x.real != y || x.imag != 0)
#define NEQ_RCMPX(zt, lt, rt) EXPR_LOOP(zt, lt, rt, x != y.real || 0 != y.imag)

DEF_CMP_IBEAM(and, af_and, AND_LOOP, NOOP, NOOP, NOOP);
DEF_CMP_IBEAM(lor, af_or, LOR_LOOP, NOOP, NOOP, NOOP);
DEF_CMP_IBEAM(lth, af_lt, LTH_LOOP, NOOP, NOOP, NOOP);
DEF_CMP_IBEAM(lte, af_le, LTE_LOOP, NOOP, NOOP, NOOP);
DEF_CMP_IBEAM(gth, af_gt, GTH_LOOP, NOOP, NOOP, NOOP);
DEF_CMP_IBEAM(gte, af_ge, GTE_LOOP, NOOP, NOOP, NOOP);
DEF_CMP_IBEAM(eql, af_eq, EQL_LOOP, EQL_CMPX, EQL_LCMPX, EQL_RCMPX);
DEF_CMP_IBEAM(neq, af_neq, NEQ_LOOP, NEQ_CMPX, NEQ_LCMPX, NEQ_RCMPX);

#define MIN_LOOP(zt, lt, rt) EXPR_LOOP(zt, lt, rt, (double)x < (double)y ? (zt)x : (zt)y)
#define MAX_LOOP(zt, lt, rt) EXPR_LOOP(zt, lt, rt, (double)x > (double)y ? (zt)x : (zt)y)

int
min_device(af_array *z, af_array l, af_array r)
{
	return af_minof(z, l, r, 0);
}

int
min_host(struct cell_array *t, size_t count, 
    struct cell_array *l, size_t lc, struct cell_array *r, size_t rc)
{
	switch (t->type) {
	case ARR_BOOL:
		SIMPLE_SWITCH(MIN_LOOP, NOOP, NOOP, NOOP, 
		    int8_t, l->type, r->type, return 99);
		break;
	case ARR_SINT:
		SIMPLE_SWITCH(MIN_LOOP, NOOP, NOOP, NOOP, 
		     int16_t, l->type, r->type, return 99);
		break;
	case ARR_INT:
		SIMPLE_SWITCH(MIN_LOOP, NOOP, NOOP, NOOP, 
		     int32_t, l->type, r->type, return 99);
		break;
	case ARR_DBL:
		SIMPLE_SWITCH(MIN_LOOP, NOOP, NOOP, NOOP, 
		     double, l->type, r->type, return 99);
		break;
	default:
		return 99;
	}
	
	return 0;
}

int
min_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	return dyadic_scalar_apply(z, l, r, max_type, min_device, min_host);
}

struct cell_func min_closure = {CELL_FUNC, 1, error_syntax_mon, min_func, 0};
struct cell_func *min_vec_ibeam = &min_closure;

int
max_device(af_array *z, af_array l, af_array r)
{
	return af_maxof(z, l, r, 0);
}

int
max_host(struct cell_array *t, size_t count, 
    struct cell_array *l, size_t lc, struct cell_array *r, size_t rc)
{
	switch (t->type) {
	case ARR_BOOL:
		SIMPLE_SWITCH(MIN_LOOP, NOOP, NOOP, NOOP, 
		    int8_t, l->type, r->type, return 99);
		break;
	case ARR_SINT:
		SIMPLE_SWITCH(MIN_LOOP, NOOP, NOOP, NOOP, 
		     int16_t, l->type, r->type, return 99);
		break;
	case ARR_INT:
		SIMPLE_SWITCH(MIN_LOOP, NOOP, NOOP, NOOP, 
		     int32_t, l->type, r->type, return 99);
		break;
	case ARR_DBL:
		SIMPLE_SWITCH(MIN_LOOP, NOOP, NOOP, NOOP, 
		     double, l->type, r->type, return 99);
		break;
	default:
		return 99;
	}
	
	return 0;
}

int
max_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	return dyadic_scalar_apply(z, l, r, max_type, max_device, max_host);
}

struct cell_func max_closure = {CELL_FUNC, 1, error_syntax_mon, max_func, 0};
struct cell_func *max_vec_ibeam = &max_closure;

struct apl_cmpx
floor_cmpx(struct apl_cmpx x)
{
	struct apl_cmpx t;
	
	t.real = floor(x.real);
	t.imag = floor(x.imag);
	
	return t;
}

int
floor_values(struct cell_array *t, struct cell_array *r)
{
	int err;
	
	t->type = r->type;
	err = 0;
	
	switch (r->storage) {
	case STG_DEVICE:
		CHK(af_floor(&t->values, r->values), done, L"⌊⍵ ⍝ DEVICE");
		break;
	case STG_HOST:
		size_t count = array_values_count(t);
		CHK(alloc_array(t), done, L"alloc_array(t)");
	
		switch (r->type) {
		case ARR_DBL:
			MON_LOOP(double, double, floor(x));
			break;
		case ARR_CMPX:
			MON_LOOP(struct apl_cmpx, struct apl_cmpx, floor_cmpx(x));
			break;
		default:
			TRC(99, L"Expected non-complex numeric type");
		}
		
		break;
	default:
		TRC(99, L"Unknown storage type");
	}
	
done:
	return err;
}

int
floor_func(struct cell_array **z, struct cell_array *r, struct cell_func *self)
{
	return monadic_scalar_apply(z, r, floor_values);
}

struct cell_func floor_closure = {CELL_FUNC, 1, floor_func, error_syntax_dya, 0};
struct cell_func *floor_vec_ibeam = &floor_closure;

struct apl_cmpx
ceil_cmpx(struct apl_cmpx x)
{
	struct apl_cmpx t;
	
	t.real = ceil(x.real);
	t.imag = ceil(x.imag);
	
	return t;
}

int
ceil_values(struct cell_array *t, struct cell_array *r)
{
	int err;
	
	t->type = r->type;
	err = 0;
	
	switch (r->storage) {
	case STG_DEVICE:
		CHK(af_ceil(&t->values, r->values), done, L"⌊⍵ ⍝ DEVICE");
		break;
	case STG_HOST:
		size_t count = array_values_count(t);
		CHK(alloc_array(t), done, L"alloc_array(t)");
	
		switch (r->type) {
		case ARR_DBL:
			MON_LOOP(double, double, ceil(x));
			break;
		case ARR_CMPX:
			MON_LOOP(struct apl_cmpx, struct apl_cmpx, ceil_cmpx(x));
			break;
		default:
			TRC(99, L"Expected non-complex numeric type");
		}
		
		break;
	default:
		TRC(99, L"Unknown storage type");
	}
	
done:
	return err;
}

int
ceil_func(struct cell_array **z, struct cell_array *r, struct cell_func *self)
{
	return monadic_scalar_apply(z, r, ceil_values);
}

struct cell_func ceil_closure = {CELL_FUNC, 1, ceil_func, error_syntax_dya, 0};
struct cell_func *ceil_vec_ibeam = &ceil_closure;

int
not_values(struct cell_array *t, struct cell_array *r)
{
	int err;
	
	t->type = ARR_BOOL;
	err = 0;
	
	switch (r->storage) {
	case STG_DEVICE:
		CHK(af_not(&t->values, r->values), done, L"~⍵ ⍝ DEVICE");
		break;
	case STG_HOST:
		CHK(alloc_array(t), done, L"alloc_array(t)");

		size_t count = array_values_count(t);
		
		MON_LOOP(int8_t, int8_t, !x);
		
		break;
	default:
		TRC(99, L"Unknown storage type");
	}
	
done:
	return err;
}

int
not_func(struct cell_array **z, struct cell_array *r, struct cell_func *self)
{
	return monadic_scalar_apply(z, r, not_values);
}

struct cell_func not_closure = {CELL_FUNC, 1, not_func, error_syntax_dya, 0};
struct cell_func *not_vec_ibeam = &not_closure;

int
abs_values(struct cell_array *t, struct cell_array *r)
{
	int err;
	
	t->type = r->type;
	err = 0;
	
	switch (r->storage) {
	case STG_DEVICE:
		CHK(af_abs(&t->values, r->values), done, L"|⍵ ⍝ DEVICE");
		break;
	case STG_HOST:
		CHK(alloc_array(t), done, L"alloc_array(t)");
		size_t count = array_values_count(t);

		switch (r->type) {
		case ARR_BOOL:
			MON_LOOP(int8_t, int8_t, abs(x));
			break;
		case ARR_SINT:
			MON_LOOP(int16_t, int16_t, abs(x));
			break;
		case ARR_INT:
			MON_LOOP(int32_t, int32_t, abs(x));
			break;
		case ARR_DBL:
			MON_LOOP(double, double, fabs(x));
			break;
		default:
			TRC(99, L"Expected non-complex numeric type");
		}
		
		break;
	default:
		TRC(99, L"Unknown storage type");
	}
	
done:
	return err;
}

int
abs_func(struct cell_array **z, struct cell_array *r, struct cell_func *self)
{
	return monadic_scalar_apply(z, r, abs_values);
}

struct cell_func abs_closure = {CELL_FUNC, 1, abs_func, error_syntax_dya, 0};
struct cell_func *abs_ibeam = &abs_closure;

int
factorial_real_values(struct cell_array *t, struct cell_array *r)
{
	int err;
	
	t->type = ARR_DBL;
	err = 0;
	
	switch (r->storage) {
	case STG_DEVICE:{
		af_array t64, t64_1, one;
		int err2;
		
		t64 = t64_1 = one = NULL;
		
		CHKAF(af_cast(&t64, r->values, f64), done);
		
		if (is_integer_array(r)) {
			CHKAF(af_factorial(&t->values, t64), af_done);
		} else {
			dim_t d;
			
			CHKAF(af_get_elements(&d, t64), af_done);
			CHKAF(af_constant(&one, 1, 1, &d, f64), af_done);
			CHKAF(af_add(&t64_1, t64, one, 0), af_done);
			CHKAF(af_tgamma(&t->values, t64_1), af_done);
		}
af_done:
		err2 = err;
		
		TRCAF(af_release_array(t64)); err2 = err ? err : err2;
		TRCAF(af_release_array(t64_1)); err2 = err ? err : err2;
		TRCAF(af_release_array(one)); err2 = err ? err : err2;
		
		err = err2;
				
		break;
	}
	case STG_HOST:
		CHK(alloc_array(t), done, L"alloc_array(t)");
		size_t count = array_values_count(t);
		
		switch (r->type) {
		case ARR_BOOL:
			MON_LOOP(double, int8_t, tgamma(x+1));
			break;
		case ARR_SINT:
			MON_LOOP(double, int16_t, tgamma(x+1));
			break;
		case ARR_INT:
			MON_LOOP(double, int32_t, tgamma(x+1));
			break;
		case ARR_DBL:
			MON_LOOP(double, double, tgamma(x+1));
			break;
		default:
			TRC(99, L"Expected non-complex numeric type");
		}

		break;
	default:
		TRC(99, L"Unknown storage type");
	}

done:
	return err;
}

int
factorial_cmpx_values(struct cell_array *t, struct cell_array *r)
{
	int err;
	
	TRC(16, L"Complex factorial/gamma function not implemented yet");
	
	return err;
}

int
factorial_values(struct cell_array *t, struct cell_array *r)
{
	if (is_real_array(r))
		return factorial_real_values(t, r);
	
	return factorial_cmpx_values(t, r);
}

int
factorial_func(struct cell_array **z, struct cell_array *r, struct cell_func *self)
{
	return monadic_scalar_apply(z, r, factorial_values);
}

struct cell_func factorial_closure = {CELL_FUNC, 1, factorial_func, error_syntax_dya, 0};
struct cell_func *factorial_vec_ibeam = &factorial_closure;

int
imagpart_values(struct cell_array *t, struct cell_array *r)
{
	int err;
	
	t->type = ARR_DBL;
	err = 0;
	
	switch (r->storage) {
	case STG_DEVICE:
		CHK(af_imag(&t->values, r->values), done, L"11○⍵ ⍝ DEVICE");
		break;
	case STG_HOST:
		CHK(alloc_array(t), done, L"alloc_array(t)");
		size_t count = array_values_count(t);
		
		MON_LOOP(double, struct apl_cmpx, x.imag);

		break;
	default:
		TRC(99, L"Unknown storage type");
	}
	
done:
	return err;
}

int
imagpart_func(struct cell_array **z, struct cell_array *r, struct cell_func *self)
{
	return monadic_scalar_apply(z, r, imagpart_values);
}

struct cell_func imagpart_closure = {CELL_FUNC, 1, imagpart_func, error_syntax_dya, 0};
struct cell_func *imagpart_vec_ibeam = &imagpart_closure;

