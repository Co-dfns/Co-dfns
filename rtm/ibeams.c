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
		if (err = alloc_array(t))
			return err;
		
		double *tvals = t->values;
		struct apl_cmpx *rvals = r->values;
		size_t count = array_values_count(t);
		
		for (size_t i = 0; i < count; i++) {
			tvals[i] = rvals[i].real;
		}
		
		break;
	default:
		return 99;
	}
	
	return 0;
}

int
conjugate_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	return monadic_scalar_apply(z, r, conjugate_values);
}

DEF_MON(conjugate_func_mon, conjugate_func)

struct cell_func conjugate_closure = {
	CELL_FUNC, 1, conjugate_func_mon, conjugate_func, 0
};
struct cell_func *conjugate_vec = &conjugate_closure;

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

int
add_type(enum array_type *type, struct cell_array *l, struct cell_array *r)
{
	*type = l->type > r->type ? l->type : r->type;
	
	return 0;
}

int
add_device(af_array *z, af_array l, af_array r)
{
	return af_add(z, l, r, 0);
}

int
add_host(struct cell_array *t, size_t count, 
    struct cell_array *l, size_t lc, struct cell_array *r, size_t rc)
{
#define ADD_LOCALS(ztype, ltype, rtype) \
	ztype *tvals = t->values;	\
	ltype *lvals = l->values;	\
	rtype *rvals = r->values;
	
#define ADD_LOOP(ztype, ltype, rtype) {					\
	ADD_LOCALS(ztype, ltype, rtype)					\
									\
	for (size_t i = 0; i < count; i++)				\
		tvals[i] = (ztype)lvals[i % lc] + (ztype)rvals[i % rc];	\
}

#define ADD_CMPX(ztype, ltype, rtype) {					\
	ADD_LOCALS(ztype, ltype, rtype)					\
									\
	for (size_t i = 0; i < count; i++) {				\
		tvals[i].real = lvals[i % lc].real + rvals[i % rc].real;\
		tvals[i].imag = lvals[i % lc].imag + rvals[i % rc].imag;\
	}								\
}
		
#define ADD_LCMPX(ztype, ltype, rtype) {				\
	ADD_LOCALS(ztype, ltype, rtype)					\
									\
	for (size_t i = 0; i < count; i++) {				\
		tvals[i].real = lvals[i % lc].real + rvals[i % rc];	\
		tvals[i].imag = lvals[i % lc].imag;			\
	}								\
}
	
#define ADD_RCMPX(ztype, ltype, rtype) {				\
	ADD_LOCALS(ztype, ltype, rtype)					\
									\
	for (size_t i = 0; i < count; i++) {				\
		tvals[i].real = lvals[i % lc] + rvals[i % rc].real;	\
		tvals[i].imag = rvals[i % rc].imag;			\
	}								\
}

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
	return dyadic_scalar_apply(z, l, r, add_type, add_device, add_host);
}

DEF_MON(add_func_mon, add_func)

struct cell_func add_closure = {CELL_FUNC, 1, add_func_mon, add_func, 0};
struct cell_func *add_vec_ibeam = &add_closure;

int
mul_type(enum array_type *type, struct cell_array *l, struct cell_array *r)
{
	*type = l->type > r->type ? l->type : r->type;
	
	return 0;
}

int
mul_device(af_array *z, af_array l, af_array r)
{
	return af_mul(z, l, r, 0);
}

int
mul_host(struct cell_array *t, size_t count, 
    struct cell_array *l, size_t lc, struct cell_array *r, size_t rc)
{
#define MUL_LOCALS(ztype, ltype, rtype) \
	ztype *tvals = t->values;	\
	ltype *lvals = l->values;	\
	rtype *rvals = r->values;
	
#define MUL_LOOP(ztype, ltype, rtype) {					\
	MUL_LOCALS(ztype, ltype, rtype)					\
									\
	for (size_t i = 0; i < count; i++)				\
		tvals[i] = (ztype)lvals[i % lc] * (ztype)rvals[i % rc];	\
}

#define MUL_CMPX(ztype, ltype, rtype) {					\
	MUL_LOCALS(ztype, ltype, rtype)					\
									\
	for (size_t i = 0; i < count; i++) {				\
		struct apl_cmpx lv = lvals[i % lc];			\
		struct apl_cmpx rv = rvals[i % rc];			\
									\
		tvals[i].real  = lv.real * rv.real;			\
		tvals[i].real += -lv.imag * rv.imag;			\
		tvals[i].imag  = lv.imag * rv.real;			\
		tvals[i].imag += lv.real * rv.imag;			\
	}								\
}
		
#define MUL_LCMPX(ztype, ltype, rtype) {				\
	MUL_LOCALS(ztype, ltype, rtype)					\
									\
	for (size_t i = 0; i < count; i++) {				\
		tvals[i].real = lvals[i % lc].real + rvals[i % rc];	\
		tvals[i].imag = lvals[i % lc].imag + rvals[i % rc];	\
	}								\
}
	
#define MUL_RCMPX(ztype, ltype, rtype) {				\
	MUL_LOCALS(ztype, ltype, rtype)					\
									\
	for (size_t i = 0; i < count; i++) {				\
		tvals[i].real = lvals[i % lc] + rvals[i % rc].real;	\
		tvals[i].imag = lvals[i % lc] + rvals[i % rc].imag;	\
	}								\
}

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
	return dyadic_scalar_apply(z, l, r, mul_type, mul_device, mul_host);
}

DEF_MON(mul_func_mon, mul_func)

struct cell_func mul_closure = {CELL_FUNC, 1, mul_func_mon, mul_func, 0};
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

int
div_host(struct cell_array *t, size_t count, 
    struct cell_array *l, size_t lc, struct cell_array *r, size_t rc)
{
#define DIV_LOCALS(ztype, ltype, rtype) \
	ztype *tvals = t->values;	\
	ltype *lvals = l->values;	\
	rtype *rvals = r->values;
	
#define DIV_LOOP(ztype, ltype, rtype) {					\
	DIV_LOCALS(ztype, ltype, rtype)					\
									\
	for (size_t i = 0; i < count; i++) {				\
		if (!rvals[i % rc]) {					\
			tvals[i] = 0;					\
			continue;					\
		}							\
									\
		tvals[i] = (ztype)lvals[i % lc] / (ztype)rvals[i % rc];	\
	}								\
}

#define DIV_CMPX(ztype, ltype, rtype) {					\
	DIV_LOCALS(ztype, ltype, rtype)					\
									\
	for (size_t i = 0; i < count; i++) {				\
		struct apl_cmpx lv = lvals[i % lc];			\
		struct apl_cmpx rv = rvals[i % rc];			\
		double quot = rv.real * rv.real + rv.imag * rv.imag;	\
									\
		if (!quot) {						\
			tvals[i].real = 0;				\
			tvals[i].imag = 0;				\
			continue;					\
		}							\
									\
		tvals[i].real = lv.real * rv.real + lv.imag * rv.imag;	\
		tvals[i].real /= quot;					\
		tvals[i].imag = lv.imag * rv.real - lv.real * rv.imag;	\
		tvals[i].imag /= quot;					\
	}								\
}
		
#define DIV_LCMPX(ztype, ltype, rtype) {				\
	DIV_LOCALS(ztype, ltype, rtype)					\
									\
	for (size_t i = 0; i < count; i++) {				\
		struct apl_cmpx lv = lvals[i % lc];			\
		double rv = rvals[i % rc];				\
									\
		if (!rv) {						\
			tvals[i].real = 0;				\
			tvals[i].imag = 0;				\
			continue;					\
		}							\
									\
		tvals[i].real = lv.real / rv;				\
		tvals[i].imag = lv.imag / rv;				\
	}								\
}

#define DIV_RCMPX(ztype, ltype, rtype) {				\
	DIV_LOCALS(ztype, ltype, rtype)					\
									\
	for (size_t i = 0; i < count; i++) {				\
		double lv = lvals[i % lc];				\
		struct apl_cmpx rv = rvals[i % rc];			\
		double quot = rv.real * rv.real + rv.imag * rv.imag;	\
									\
		if (!quot) {					\
			tvals[i].real = 0;				\
			tvals[i].imag = 0;				\
			continue;					\
		}							\
									\
		tvals[i].real = lv * rv.real / quot;			\
		tvals[i].imag = -lv * rv.imag / quot;			\
	}								\
}

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

DEF_MON(div_func_mon, div_func)

struct cell_func div_closure = {CELL_FUNC, 1, div_func_mon, div_func, 0};
struct cell_func *div_vec_ibeam = &div_closure;

int
sub_type(enum array_type *type, struct cell_array *l, struct cell_array *r)
{
	*type = l->type > r->type ? l->type : r->type;
	
	return 0;
}

int
sub_device(af_array *z, af_array l, af_array r)
{
	return af_sub(z, l, r, 0);
}

int
sub_host(struct cell_array *t, size_t count, 
    struct cell_array *l, size_t lc, struct cell_array *r, size_t rc)
{
#define SUB_LOCALS(ztype, ltype, rtype) \
	ztype *tvals = t->values;	\
	ltype *lvals = l->values;	\
	rtype *rvals = r->values;
	
#define SUB_LOOP(ztype, ltype, rtype) {					\
	SUB_LOCALS(ztype, ltype, rtype)					\
									\
	for (size_t i = 0; i < count; i++)				\
		tvals[i] = (ztype)lvals[i % lc] - (ztype)rvals[i % rc];	\
}

#define SUB_CMPX(ztype, ltype, rtype) {					\
	SUB_LOCALS(ztype, ltype, rtype)					\
									\
	for (size_t i = 0; i < count; i++) {				\
		tvals[i].real = lvals[i % lc].real - rvals[i % rc].real;\
		tvals[i].imag = lvals[i % lc].imag - rvals[i % rc].imag;\
	}								\
}
		
#define SUB_LCMPX(ztype, ltype, rtype) {				\
	SUB_LOCALS(ztype, ltype, rtype)					\
									\
	for (size_t i = 0; i < count; i++) {				\
		tvals[i].real = lvals[i % lc].real - rvals[i % rc];	\
		tvals[i].imag = lvals[i % lc].imag;			\
	}								\
}
	
#define SUB_RCMPX(ztype, ltype, rtype) {				\
	SUB_LOCALS(ztype, ltype, rtype)					\
									\
	for (size_t i = 0; i < count; i++) {				\
		tvals[i].real = lvals[i % lc] - rvals[i % rc].real;	\
		tvals[i].imag = rvals[i % rc].imag;			\
	}								\
}

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
	return dyadic_scalar_apply(z, l, r, sub_type, sub_device, sub_host);
}

DEF_MON(sub_func_mon, sub_func)

struct cell_func sub_closure = {CELL_FUNC, 1, sub_func_mon, sub_func, 0};
struct cell_func *sub_vec_ibeam = &sub_closure;

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

int
pow_type(enum array_type *type, struct cell_array *l, struct cell_array *r)
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

int
pow_host(struct cell_array *t, size_t count, 
    struct cell_array *l, size_t lc, struct cell_array *r, size_t rc)
{
#define POW_LOCALS(ztype, ltype, rtype) \
	ztype *tvals = t->values;	\
	ltype *lvals = l->values;	\
	rtype *rvals = r->values;
	
#define POW_LOOP(ztype, ltype, rtype) {		\
	POW_LOCALS(ztype, ltype, rtype)		\
						\
	for (size_t i = 0; i < count; i++) {	\
		double x = lvals[i % lc];       \
		double y = rvals[i % rc];       \
						\
		tvals[i] = pow(x, y);           \
	}					\
}

#define POW_CMPX(ztype, ltype, rtype) {			\
	POW_LOCALS(ztype, ltype, rtype)			\
							\
	for (size_t i = 0; i < count; i++) {		\
		struct apl_cmpx x = lvals[i % lc];	\
		struct apl_cmpx y = rvals[i % rc];	\
							\
		tvals[i] = pow_cmpx(x, y);		\
	}						\
}
		
#define POW_LCMPX(ztype, ltype, rtype) {		\
	POW_LOCALS(ztype, ltype, rtype)			\
							\
	for (size_t i = 0; i < count; i++) {		\
		struct apl_cmpx x = lvals[i % lc];	\
		struct apl_cmpx y = {rvals[i % rc], 0};	\
							\
		tvals[i] = pow_cmpx(x, y);		\
	}						\
}
	
#define POW_RCMPX(ztype, ltype, rtype) {		\
	POW_LOCALS(ztype, ltype, rtype)			\
							\
	for (size_t i = 0; i < count; i++) {		\
		struct apl_cmpx x = {lvals[i % lc], 0};	\
		struct apl_cmpx y = rvals[i % rc];	\
							\
		tvals[i] = pow_cmpx(x, y);		\
	}						\
}

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
	return dyadic_scalar_apply(z, l, r, pow_type, pow_device, pow_host);
}

DEF_MON(pow_func_mon, pow_func)

struct cell_func pow_closure = {CELL_FUNC, 1, pow_func_mon, pow_func, 0};
struct cell_func *pow_vec_ibeam = &pow_closure;

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
	
	if (r->type == ARR_CMPX) {
		struct apl_cmpx *tvals = t->values;
		struct apl_cmpx *rvals = r->values;
		
		for (size_t i = 0; i < count; i++)
			tvals[i] = exp_cmpx(rvals[i]);
		
		goto done;
	}

	#define EXP_LOOP(rtype) {			\
		double *tvals = t->values;		\
		rtype *rvals = r->values;		\
							\
		for (size_t i = 0; i < count; i++)	\
			tvals[i] = exp(rvals[i]);	\
							\
		break;					\
	}						\
	
	switch (r->type) {
	case ARR_BOOL:EXP_LOOP(int8_t);
	case ARR_SINT:EXP_LOOP(int16_t);
	case ARR_INT:EXP_LOOP(int32_t);
	case ARR_DBL:EXP_LOOP(double);
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

int
cmp_type(enum array_type *type, struct cell_array *l, struct cell_array *r)
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
	return dyadic_scalar_apply(z, l, r, cmp_type, name##_device, name##_host);      \
}                                                                                       \
											\
struct cell_func name##_closure = {CELL_FUNC, 1, error_syntax_mon, name##_func, 0};     \
struct cell_func *name##_vec_ibeam = &name##_closure;                                   \

#define CMP_LOOP(ztype, ltype, rtype, expr) {	\
	ztype *tvals = t->values;		\
	ltype *lvals = l->values;		\
	rtype *rvals = r->values;		\
						\
	for (size_t i = 0; i < count; i++) {	\
		ltype x = lvals[i % lc];	\
		rtype y = rvals[i % rc];	\
						\
		tvals[i] = (expr);		\
	}					\
}						\

#define LOR_LOOP(zt, lt, rt) CMP_LOOP(zt, lt, rt, x || y)
#define LTH_LOOP(zt, lt, rt) CMP_LOOP(zt, lt, rt, (double)x < (double)y)
#define LTE_LOOP(zt, lt, rt) CMP_LOOP(zt, lt, rt, (double)x <= (double)y)
#define GTH_LOOP(zt, lt, rt) CMP_LOOP(zt, lt, rt, (double)x > (double)y)
#define GTE_LOOP(zt, lt, rt) CMP_LOOP(zt, lt, rt, (double)x >= (double)y)
#define EQL_LOOP(zt, lt, rt) CMP_LOOP(zt, lt, rt, x == y)
#define EQL_CMPX(zt, lt, rt) CMP_LOOP(zt, lt, rt, x.real == y.real && x.imag == y.imag)
#define EQL_LCMPX(zt, lt, rt) CMP_LOOP(zt, lt, rt, x.real == y && x.imag == 0)
#define EQL_RCMPX(zt, lt, rt) CMP_LOOP(zt, lt, rt, x == y.real && 0 == y.imag)
#define NEQ_LOOP(zt, lt, rt) CMP_LOOP(zt, lt, rt, x != y)
#define NEQ_CMPX(zt, lt, rt) CMP_LOOP(zt, lt, rt, x.real != y.real || x.imag != y.imag)
#define NEQ_LCMPX(zt, lt, rt) CMP_LOOP(zt, lt, rt, x.real != y || x.imag != 0)
#define NEQ_RCMPX(zt, lt, rt) CMP_LOOP(zt, lt, rt, x != y.real || 0 != y.imag)

DEF_CMP_IBEAM(lor, af_or, LOR_LOOP, NOOP, NOOP, NOOP);
DEF_CMP_IBEAM(lth, af_lt, LTH_LOOP, NOOP, NOOP, NOOP);
DEF_CMP_IBEAM(lte, af_le, LTE_LOOP, NOOP, NOOP, NOOP);
DEF_CMP_IBEAM(gth, af_gt, GTH_LOOP, NOOP, NOOP, NOOP);
DEF_CMP_IBEAM(gte, af_ge, GTE_LOOP, NOOP, NOOP, NOOP);
DEF_CMP_IBEAM(eql, af_eq, EQL_LOOP, EQL_CMPX, EQL_LCMPX, EQL_RCMPX);
DEF_CMP_IBEAM(neq, af_neq, NEQ_LOOP, NEQ_CMPX, NEQ_LCMPX, NEQ_RCMPX);

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
		int8_t *tvals = t->values;
		int8_t *rvals = r->values;
		
		for (size_t i = 0; i < count; i++)
			tvals[i] = !rvals[i];
		
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

#define ABS_LOOP(abs, type) {			\
	type *tvals = t->values;		\
	type *rvals = r->values;		\
						\
	for (size_t i = 0; i < count; i++)	\
		tvals[i] = abs(rvals[i]);	\
}						\

		switch (r->type) {
		case ARR_BOOL:
			ABS_LOOP(abs, int8_t);
			break;
		case ARR_SINT:
			ABS_LOOP(abs, int16_t);
			break;
		case ARR_INT:
			ABS_LOOP(abs, int32_t);
			break;
		case ARR_DBL:
			ABS_LOOP(fabs, double);
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
