#include <complex.h>
#include <float.h>
#include <math.h>
#include <string.h>

#include "internal.h"
#include "prim.h"

#define DECL_FUNC(name, mon, dya)						\
struct cell_func name##_closure = {CELL_FUNC, 1, mon, dya, NULL, NULL, 0};	\
struct cell_func *name = &name##_closure;					\

#define DECL_MOPER(name, am, ad, fm, fd)				\
struct cell_moper name##_closure = {CELL_MOPER, 1, am, ad, fm, fd, 0};	\
struct cell_moper *name = &name##_closure;				\

#define DECL_DOPER(name, aam, aad, afm, afd, fam, fad, ffm, ffd)	\
struct cell_doper name##_closure = {CELL_DOPER, 1, 			\
	aam, aad, afm, afd, fam, fad, ffm, ffd, 0			\
};									\
struct cell_doper *name = &name##_closure;				\

#define DEF_MON(mf, fn)							\
int									\
mf(struct cell_array **z, struct cell_array *r, struct cell_func *self)	\
{									\
	return fn(z, NULL, r, self);					\
}									\

int
error_mon(struct cell_array **z, struct cell_array *r, 
    struct cell_func *self)
{
	return 2;
}

int
error_dya(struct cell_array **z, 
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	return 2;
}

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
DECL_FUNC(q_signal_ibeam, q_signal_func_mon, q_signal_func)

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
DECL_FUNC(q_dr_ibeam, q_dr_func_mon, q_dr_func)

int
is_simple_func(struct cell_array **z,
    struct cell_array *r, struct cell_func *self)
{
	return mk_scalar_bool(z, r->type != ARR_NESTED);
}

DECL_FUNC(is_simple_ibeam, is_simple_func, error_dya)

int
is_numeric_func(struct cell_array **z,
    struct cell_array *r, struct cell_func *self)
{
	if (is_numeric_array(r))
		return mk_scalar_bool(z, 1);
	
	return mk_scalar_bool(z, 0);
}

DECL_FUNC(is_numeric_ibeam, is_numeric_func, error_dya)

int
is_char_func(struct cell_array **z,
    struct cell_array *r, struct cell_func *self)
{
	if (is_char_array(r))
		return mk_scalar_bool(z, 1);
	
	return mk_scalar_bool(z, 0);
}

DECL_FUNC(is_char_ibeam, is_char_func, error_dya)

int
is_integer_func(struct cell_array **z,
    struct cell_array *r, struct cell_func *self)
{
	if (is_integer_array(r))
		return mk_scalar_bool(z, 1);
	
	return mk_scalar_bool(z, 0);
}

DECL_FUNC(is_integer_ibeam, is_integer_func, error_dya)

int
shape_func(struct cell_array **z,
    struct cell_array *r, struct cell_func *self)
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

DECL_FUNC(shape_ibeam, shape_func, error_dya)

int
max_shp_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	size_t lc, rc;
	
	lc = array_count(l);
	rc = array_count(r);
	
	if (lc != 1)
		return shape_func(z, l, shape_ibeam);
	
	if (rc != 1)
		return shape_func(z, r, shape_ibeam);
	
	if (r->rank > l->rank)
		return shape_func(z, r, shape_ibeam);
	
	return shape_func(z, l, shape_ibeam);
}

DECL_FUNC(max_shp_ibeam, error_mon, max_shp_func)

int
identity_func(struct cell_array **z,
    struct cell_array *r, struct cell_func *self)
{
	struct cell_func *oper;
	int err;
	
	err = 0;
	
	oper = self->fv[1];
	
	#define ID_CASE(prim, id)			\
	if (oper == cdf_prim.##prim) {			\
		CHK(mk_scalar_bool(z, id), done,	\
		    L"mk_scalar_bool(z, " L#id L")");	\
							\
		goto done;				\
	}						\
	
	ID_CASE(lor, 0)
	ID_CASE(mul, 1)
	
	CHK(16, done, L"Unknown primitive identity");
	
done:
	return err;
}

DECL_MOPER(identity_ibeam, error_mon, error_dya, identity_func, error_dya)

#define STMT_LOOP(zt, lt, rt, stmts) {		\
	zt *tv = t->values;			\
	lt *lv = l->values;			\
	rt *rv = r->values;			\
						\
	for (size_t i = 0; i < count; i++)	\
		stmts;				\
}						\

int
set_host_values(struct cell_array *t,
    struct cell_array *l, struct cell_array *r)
{
	size_t count, rc, range;
	int err;
	
	err = 0;
	retain_cell(t);
	range = array_count(t);
	count = array_count(l);
	rc = array_count(r);
	
	#define IDX_CHK_LOOP(lt) {					\
		lt *lv = l->values;					\
									\
		for (size_t i = 0; i < count; i++) 			\
			if (lv[i] >= range)				\
				CHK(3, fail, L"Index out of range");	\
	}								\
	
	switch(l->type) {
	case ARR_BOOL:IDX_CHK_LOOP(int8_t);break;
	case ARR_SINT:IDX_CHK_LOOP(int16_t);break;
	case ARR_INT:IDX_CHK_LOOP(int32_t);break;
	case ARR_DBL:IDX_CHK_LOOP(double);break;
	default:
		CHK(99, fail, L"Unexpected index element type");
	}
	
	#define SET_LOOP_NESTED(lt) 					\
	STMT_LOOP(struct cell_array *, lt, struct cell_array *, {	\
		retain_cell(rv[i]);					\
		release_array(tv[(int64_t)lv[i]]);			\
		tv[(int64_t)lv[i]] = rv[i];				\
	});								\
	break;								\
	
	#define SET_LOOP(zt, lt)					\
	STMT_LOOP(zt, lt, zt, {tv[(int64_t)lv[i]] = rv[i % rc];});	\
	break;								\
	
	switch(type_pair(t->type, l->type)) {
	case type_pair(ARR_BOOL, ARR_BOOL):SET_LOOP(int8_t, int8_t);
	case type_pair(ARR_BOOL, ARR_SINT):SET_LOOP(int8_t, int16_t);
	case type_pair(ARR_BOOL, ARR_INT ):SET_LOOP(int8_t, int32_t);
	case type_pair(ARR_BOOL, ARR_DBL ):SET_LOOP(int8_t, double);
	case type_pair(ARR_SINT, ARR_BOOL):SET_LOOP(int16_t, int8_t);
	case type_pair(ARR_SINT, ARR_SINT):SET_LOOP(int16_t, int16_t);
	case type_pair(ARR_SINT, ARR_INT ):SET_LOOP(int16_t, int32_t);
	case type_pair(ARR_SINT, ARR_DBL ):SET_LOOP(int16_t, double);
	case type_pair(ARR_INT, ARR_BOOL):SET_LOOP(int32_t, int8_t);
	case type_pair(ARR_INT, ARR_SINT):SET_LOOP(int32_t, int16_t);
	case type_pair(ARR_INT, ARR_INT ):SET_LOOP(int32_t, int32_t);
	case type_pair(ARR_INT, ARR_DBL ):SET_LOOP(int32_t, double);
	case type_pair(ARR_DBL, ARR_BOOL):SET_LOOP(double, int8_t);
	case type_pair(ARR_DBL, ARR_SINT):SET_LOOP(double, int16_t);
	case type_pair(ARR_DBL, ARR_INT ):SET_LOOP(double, int32_t);
	case type_pair(ARR_DBL, ARR_DBL ):SET_LOOP(double, double);
	case type_pair(ARR_CMPX, ARR_BOOL):SET_LOOP(struct apl_cmpx, int8_t);
	case type_pair(ARR_CMPX, ARR_SINT):SET_LOOP(struct apl_cmpx, int16_t);
	case type_pair(ARR_CMPX, ARR_INT ):SET_LOOP(struct apl_cmpx, int32_t);
	case type_pair(ARR_CMPX, ARR_DBL ):SET_LOOP(struct apl_cmpx, double);
	case type_pair(ARR_CHAR8, ARR_BOOL):SET_LOOP(uint8_t, int8_t);
	case type_pair(ARR_CHAR8, ARR_SINT):SET_LOOP(uint8_t, int16_t);
	case type_pair(ARR_CHAR8, ARR_INT ):SET_LOOP(uint8_t, int32_t);
	case type_pair(ARR_CHAR8, ARR_DBL ):SET_LOOP(uint8_t, double);
	case type_pair(ARR_CHAR16, ARR_BOOL):SET_LOOP(uint16_t, int8_t);
	case type_pair(ARR_CHAR16, ARR_SINT):SET_LOOP(uint16_t, int16_t);
	case type_pair(ARR_CHAR16, ARR_INT ):SET_LOOP(uint16_t, int32_t);
	case type_pair(ARR_CHAR16, ARR_DBL ):SET_LOOP(uint16_t, double);
	case type_pair(ARR_CHAR32, ARR_BOOL):SET_LOOP(uint32_t, int8_t);
	case type_pair(ARR_CHAR32, ARR_SINT):SET_LOOP(uint32_t, int16_t);
	case type_pair(ARR_CHAR32, ARR_INT ):SET_LOOP(uint32_t, int32_t);
	case type_pair(ARR_CHAR32, ARR_DBL ):SET_LOOP(uint32_t, double);
	case type_pair(ARR_NESTED, ARR_BOOL):SET_LOOP_NESTED(int8_t);
	case type_pair(ARR_NESTED, ARR_SINT):SET_LOOP_NESTED(int16_t);
	case type_pair(ARR_NESTED, ARR_INT ):SET_LOOP_NESTED(int32_t);
	case type_pair(ARR_NESTED, ARR_DBL ):SET_LOOP_NESTED(double);
	default:
		CHK(99, fail, L"Unexpected type combination");
	}

fail:	
	return err;
}

int
set_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	struct cell_array *idx, *tgt;
	size_t idx_count, val_count;
	enum array_type mtype;
	int err;
	
	err = 0;
	
	if (l->type != ARR_NESTED)
		CHK(99, done, L"Expected nested array type");
	
	if (array_count(l) != 1)
		CHK(99, done, L"Expected single array value");

	idx = *(struct cell_array **)l->values;
	idx_count = array_count(idx);
	val_count = array_count(r);
	
	if (val_count != 1 && idx_count != val_count)
		CHK(99, done, L"Mismatched values and indices");
	
	tgt = *z;
	
	CHK(array_migrate_storage(idx, tgt->storage), done,
	    L"Migrate indices to target storage");
	CHK(array_migrate_storage(r, tgt->storage), done,
	    L"Migrate values to target storage");
	    
	mtype = array_max_type(tgt->type, r->type);
	
	CHK(cast_values(tgt, mtype), done, L"cast_values(tgt, mtype)");
	CHK(cast_values(r, mtype), done, L"cast_values(r, mtype)");
	
	switch (tgt->storage) {
	case STG_DEVICE:
		CHK(16, done, L"Device assignment");
		break;
	case STG_HOST:
		CHK(set_host_values(tgt, idx, r), done, 
		    L"set_host_values(tgt, idx, r)");
		break;
	default:
		CHK(99, done, L"Unknown storage type");
	}
	
done:
	return err;
}

DECL_FUNC(set_ibeam, error_mon, set_func)

int
ravel_func(struct cell_array **z,
    struct cell_array *r, struct cell_func *self)
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

DECL_FUNC(ravel_ibeam, ravel_func, error_dya)

int
disclose_func(struct cell_array **z,
    struct cell_array *r, struct cell_func *self)
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

DECL_FUNC(disclose_ibeam, disclose_func, error_dya)

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

DECL_FUNC(enclose_ibeam, enclose_func, error_dya)

int
ambiv_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	struct cell_func *mop, *dop;
	
	mop = self->fv[1];
	dop = self->fv[2];
	
	if (l == NULL)
		return (mop->fptr_mon)(z, r, mop);
	
	return (dop->fptr_dya)(z, l, r, dop);
}

DEF_MON(ambiv_func_mon, ambiv_func)
DECL_DOPER(ambiv_ibeam, 
	error_mon, error_dya, error_mon, error_dya, error_mon, error_dya,
	ambiv_func_mon, ambiv_func
)

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

DECL_FUNC(reshape_ibeam, error_mon, reshape_func)

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

DECL_FUNC(same_ibeam, error_mon, same_func)

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

DECL_FUNC(nqv_ibeam, error_mon, nqv_func)

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
veach_monadic(struct cell_array **z,
    struct cell_array *r, struct cell_func *self)
{
	int err;
	
	CHK(16, done, L"Monadic veach is not ready.");
	
done:
	return err;
}

int
veach_dyadic(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	struct cell_func *oper;
	struct cell_array *t, *x, *y, **tvals;
	void *lbuf, *rbuf;
	size_t count, lc, rc;
	int err, fl, fr, fy, fx;
	
	oper = self->fv[1];

	t = x = y = NULL;
	fl = fr = fy = fx = 0;
	
	lbuf = l->values;
	rbuf = r->values;
	
	if (l->type == ARR_SPAN || r->type == ARR_SPAN) {
		TRC(99, L"Unexpected SPAN array type");
		return 99;
	}
	
	lc = array_values_count(l);
	rc = array_values_count(r);
	
	if (l->storage == STG_DEVICE) {
		lbuf = malloc(lc * array_element_size(l));
		
		CHK(lbuf == NULL, fail, L"Failed to allocate ⍺ buffer");
		
		fl = 1;
		
		CHK(af_eval(l->values), fail, L"af_eval(l->values)");
		CHK(af_get_data_ptr(lbuf, l->values), fail, 
		    L"af_get_data_ptr(lbuf, l->values)");
	}
	
	if (r->storage == STG_DEVICE) {
		rbuf = malloc(rc * array_element_size(r));
		
		CHK(rbuf == NULL, fail, L"Failed to allocate ⍵ buffer");
		
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
		    L"tvals[i]←⍺[lc|i] ⍺⍺ ⍵[rc|i] ⍝ "			\
		    L#ltype L"/" L#rtype);				\
	}								\
}

	SIMPLE_SWITCH(VEACH_LOOP,VEACH_LOOP,VEACH_LOOP,VEACH_LOOP,,
	    l->type, r->type, 
	    CHK(99, fail, L"Unknown simple type combo"))
	
done:
	err = 0;
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

DECL_MOPER(veach_ibeam, error_mon, error_dya, veach_monadic, veach_dyadic)

int
squeeze_func(struct cell_array **z,
    struct cell_array *r, struct cell_func *self)
{
	int err;
	
	if (err = squeeze_array(r))
		return err;
	
	*z = retain_cell(r);
	
	return 0;
}

DECL_FUNC(squeeze_ibeam, squeeze_func, error_dya)

int
has_nat_vals_func(struct cell_array **z,
    struct cell_array *r, struct cell_func *self)
{
	int err, is_nat;
	
	if (err = has_natural_values(&is_nat, r))
		return err;
	
	return mk_scalar_bool(z, is_nat);
}

DECL_FUNC(has_nat_vals_ibeam, has_nat_vals_func, error_dya)

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

DECL_FUNC(index_gen_vec, index_gen_func, error_dya)

int
index_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	struct cell_array *t;
	size_t range, count;
	int err;
	
	t = NULL;
	
	CHK(array_promote_storage(l, r), fail, L"array_promote_storage(l, r)");
	
	CHK(mk_array(&t, r->type, r->storage, 1), fail,
	    L"mk_array(&t, r->type, r->storage, 1)");

	t->shape[0] = count = array_count(l);
	range = array_count(r);
	
	if (l->storage == STG_DEVICE) {
		af_array idx;
		
		CHKAF(af_cast(&idx, l->values, s64), fail);
		CHKAF(af_lookup(&t->values, r->values, idx, 0), device_fail);
		CHKAF(af_release_array(idx), fail);
		
		goto done;

device_fail:
		CHKAF(af_release_array(idx), fail);
		
		goto fail;
	}
	
	switch(l->type) {
	case ARR_BOOL:IDX_CHK_LOOP(int8_t);break;
	case ARR_SINT:IDX_CHK_LOOP(int16_t);break;
	case ARR_INT:IDX_CHK_LOOP(int32_t);break;
	case ARR_DBL:IDX_CHK_LOOP(double);break;
	default:
		CHK(99, fail, L"Unexpected index element type");
	}

	CHK(alloc_array(t), fail, L"alloc_array(t)");
	
#define INDEX_LOOP(ztype, ltype, rtype) {		\
	ltype *lvals = l->values;			\
	rtype *rvals = r->values;			\
	rtype *tvals = t->values;			\
							\
	for (size_t i = 0; i < t->shape[0]; i++)	\
		tvals[i] = rvals[(ztype)lvals[i]];	\
}							\

	if (r->type == ARR_NESTED) {		
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
			CHK(99, fail, L"Unsupported index element type");
		}
		
		goto done;
	}

	SIMPLE_SWITCH(INDEX_LOOP, NOOP, NOOP, INDEX_LOOP,
	    size_t, l->type, r->type,
	    CHK(99, fail, L"Unexpected element type"))

done:
	*z = t;
	
	return 0;
	
fail:
	release_array(t);
	
	return err;
}

DECL_FUNC(index_ibeam, error_mon, index_func)

int
monadic_scalar_apply(struct cell_array **z, struct cell_array *r,
    int (*fn)(struct cell_array *, struct cell_array *))
{
	struct cell_array *t;
	int err;
	
	t = NULL;
	
	CHK(mk_array(&t, ARR_SPAN, r->storage, r->rank), fail,
	     L"mk_array(&t, ARR_SPAN, r->storage, r->rank)");
		
	for (unsigned int i = 0; i < r->rank; i++)
		t->shape[i] = r->shape[i];
	
	CHK(fn(t, r), fail, L"fn(t, r)");
	
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
	
	t = NULL;
	
	CHK(array_promote_storage(l, r), fail, L"array_promote_storage(l, r)");
	CHK(scl_type(&ztype, l, r), fail, L"scl_type(&ztype, l, r)");
	CHK(mk_array(&t, ztype, l->storage, 1), fail, 
	    L"mk_array(&t, ztype, l->storage, 1)");
	
	lc = array_values_count(l);
	rc = array_values_count(r);
	t->shape[0] = lc > rc ? lc : rc;
	
	if (t->storage == STG_DEVICE) {
		unsigned int ltc, rtc;
		af_array ltile, rtile, lcast, rcast, za;
		enum array_type etype;
		af_dtype type;
		
		ltile = rtile = lcast = rcast = za = NULL;
		
		ltc = (unsigned int)(rc > lc ? rc : 1);
		rtc = (unsigned int)(lc > rc ? lc : 1);
		
		etype = array_max_type(l->type, r->type);
		
		if (array_element_size_type(etype) < array_element_size_type(ztype))
			etype = ztype;
		
		type = array_type_af_dtype(etype);
		
		if (rc > UINT_MAX || lc > UINT_MAX)
			CHK(10, fail, L"Count out of range for device");
		
		CHKAF(af_tile(&ltile, l->values, ltc, 1, 1, 1), device_done);
		CHKAF(af_tile(&rtile, r->values, rtc, 1, 1, 1), device_done);
		CHKAF(af_cast(&lcast, ltile, type), device_done);
		CHKAF(af_cast(&rcast, rtile, type), device_done);
		CHK(scl_device(&za, lcast, rcast), device_done,
		    L"scl_device(&za, lcast, rcast)");
		
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
		CHK(99, fail, L"Unknown storage type");
	
	CHK(alloc_array(t), fail, L"alloc_array(t)");
	CHK(scl_host(t, t->shape[0], l, lc, r, rc), fail,
	    L"scl_host(t, t->shape[0], l, lc, r, rc)");

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

DECL_FUNC(conjugate_vec, conjugate_func, error_dya)

int
max_type(enum array_type *type, struct cell_array *l, struct cell_array *r)
{
	*type = l->type > r->type ? l->type : r->type;
	
	return 0;
}

int
int16_max_type(enum array_type *type, struct cell_array *l, struct cell_array *r)
{
	max_type(type, l, r);
	
	if (*type == ARR_BOOL)
		*type = ARR_SINT;
	
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
		    int16_t, l->type, r->type, return 99);
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
	return dyadic_scalar_apply(z, l, r, int16_max_type, add_device, add_host);
}

DECL_FUNC(add_vec_ibeam, error_mon, add_func)

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

DECL_FUNC(mul_vec_ibeam, error_mon, mul_func)

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

DECL_FUNC(div_vec_ibeam, error_mon, div_func)

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
		    int16_t, l->type, r->type, return 99);
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
	return dyadic_scalar_apply(z, l, r, int16_max_type, sub_device, sub_host);
}

DECL_FUNC(sub_vec_ibeam, error_mon, sub_func)

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

DECL_FUNC(pow_vec_ibeam, error_mon, pow_func)

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

DECL_FUNC(log_vec_ibeam, error_mon, log_func)

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

DECL_FUNC(exp_vec_ibeam, exp_func, error_dya)

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

DECL_FUNC(nlg_vec_ibeam, nlg_func, error_dya)

int
bool_type(enum array_type *type, struct cell_array *l, struct cell_array *r)
{
	*type = ARR_BOOL;
	
	return 0;
}

#define DEF_CMP_IBEAM(name, cmp_dev, loop, loop_cmpx, loop_lcmpx, loop_rcmpx)		\
int											\
name##_device(af_array *z, af_array l, af_array r)					\
{											\
	return cmp_dev(z, l, r, 0);							\
}											\
											\
int											\
name##_host(struct cell_array *t, size_t count,						\
    struct cell_array *l, size_t lc, struct cell_array *r, size_t rc)			\
{											\
	switch (t->type) {								\
	case ARR_BOOL:									\
		SIMPLE_SWITCH(loop, loop_cmpx, loop_lcmpx, loop_rcmpx,			\
		    int8_t, l->type, r->type, return 99);				\
		break;									\
	default:									\
		return 99;								\
	}										\
											\
	return 0;									\
}											\
											\
int											\
name##_func(struct cell_array **z,							\
    struct cell_array *l, struct cell_array *r, struct cell_func *self)			\
{											\
	return dyadic_scalar_apply(z, l, r, bool_type, name##_device, name##_host);	\
}											\
											\
DECL_FUNC(name##_vec_ibeam, error_mon, name##_func)					\

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

DECL_FUNC(min_vec_ibeam, error_mon, min_func)

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
		SIMPLE_SWITCH(MAX_LOOP, NOOP, NOOP, NOOP, 
		    int8_t, l->type, r->type, return 99);
		break;
	case ARR_SINT:
		SIMPLE_SWITCH(MAX_LOOP, NOOP, NOOP, NOOP, 
		     int16_t, l->type, r->type, return 99);
		break;
	case ARR_INT:
		SIMPLE_SWITCH(MAX_LOOP, NOOP, NOOP, NOOP, 
		     int32_t, l->type, r->type, return 99);
		break;
	case ARR_DBL:
		SIMPLE_SWITCH(MAX_LOOP, NOOP, NOOP, NOOP, 
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

DECL_FUNC(max_vec_ibeam, error_mon, max_func)

int
floor_values(struct cell_array *t, struct cell_array *r)
{
	int err;
	
	t->type = r->type;
	err = 0;
	
	switch (r->storage) {
	case STG_DEVICE:
		CHKAF(af_floor(&t->values, r->values), done);
		break;
	case STG_HOST:
		size_t count = array_values_count(t);
		CHK(alloc_array(t), done, L"alloc_array(t)");
	
		switch (r->type) {
		case ARR_DBL:
			MON_LOOP(double, double, floor(x));
			break;
		default:
			TRC(99, L"Expected double numeric type");
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

DECL_FUNC(floor_vec_ibeam, floor_func, error_dya)

int
ceil_values(struct cell_array *t, struct cell_array *r)
{
	int err;
	
	t->type = r->type;
	err = 0;
	
	switch (r->storage) {
	case STG_DEVICE:
		CHKAF(af_ceil(&t->values, r->values), done);
		break;
	case STG_HOST:
		size_t count = array_values_count(t);
		CHK(alloc_array(t), done, L"alloc_array(t)");
	
		switch (r->type) {
		case ARR_DBL:
			MON_LOOP(double, double, ceil(x));
			break;
		default:
			TRC(99, L"Expected double numeric type");
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

DECL_FUNC(ceil_vec_ibeam, ceil_func, error_dya)

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

DECL_FUNC(not_vec_ibeam, not_func, error_dya)

int
abs_values(struct cell_array *t, struct cell_array *r)
{
	af_array tmp;
	int err;
	
	t->type = r->type;
	tmp = NULL;
	err = 0;
	
	switch (r->storage) {
	case STG_DEVICE:
		CHKAF(af_abs(&tmp, r->values), done);
		CHKAF(af_cast(&t->values, tmp, array_af_dtype(t)), done);
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
	CHKAF(af_release_array(tmp), fail);

fail:
	return err;
}

int
abs_func(struct cell_array **z, struct cell_array *r, struct cell_func *self)
{
	return monadic_scalar_apply(z, r, abs_values);
}

DECL_FUNC(abs_ibeam, abs_func, error_dya)

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

DECL_FUNC(factorial_vec_ibeam, factorial_func, error_dya)

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

DECL_FUNC(imagpart_vec_ibeam, imagpart_func, error_dya)

int
realpart_values(struct cell_array *t, struct cell_array *r)
{
	int err;
	
	t->type = ARR_DBL;
	err = 0;
	
	switch (r->storage) {
	case STG_DEVICE:
		CHK(af_real(&t->values, r->values), done, L"11○⍵ ⍝ DEVICE");
		break;
	case STG_HOST:
		CHK(alloc_array(t), done, L"alloc_array(t)");
		size_t count = array_values_count(t);
		
		MON_LOOP(double, struct apl_cmpx, x.real);

		break;
	default:
		TRC(99, L"Unknown storage type");
	}
	
done:
	return err;
}

int
realpart_func(struct cell_array **z, struct cell_array *r, struct cell_func *self)
{
	return monadic_scalar_apply(z, r, realpart_values);
}

DECL_FUNC(realpart_vec_ibeam, realpart_func, error_dya)

#define DEF_TRIG(name, af_fun, stdc_fun)				\
int									\
name##_values(struct cell_array *t, struct cell_array *r)		\
{									\
	int err;							\
									\
	t->type = ARR_DBL;						\
	err = 0;							\
									\
	switch (r->storage) {						\
	case STG_DEVICE:{						\
		af_array t64;						\
		int err2;						\
									\
		CHKAF(af_cast(&t64, r->values, f64), af_done);		\
		CHKAF(af_fun(&t->values, t64), af_done);		\
af_done:								\
		err2 = err;						\
									\
		TRCAF(af_release_array(t64)); err2 = err ? err : err2;	\
									\
		err = err2;						\
									\
		break;							\
	}								\
	case STG_HOST:							\
		CHK(alloc_array(t), done, L"alloc_array(t)");		\
		size_t count = array_values_count(t);			\
									\
		switch (r->type) {					\
		case ARR_BOOL:						\
			MON_LOOP(double, int8_t, stdc_fun(x));		\
			break;						\
		case ARR_SINT:						\
			MON_LOOP(double, int16_t, stdc_fun(x));		\
			break;						\
		case ARR_INT:						\
			MON_LOOP(double, int32_t, stdc_fun(x));		\
			break;						\
		case ARR_DBL:						\
			MON_LOOP(double, double, stdc_fun(x));		\
			break;						\
		default:						\
			TRC(16, L"Complex inputs not supported, yet.");	\
		}							\
									\
		break;							\
	default:							\
		TRC(99, L"Unknown storage type");			\
	}								\
									\
done:									\
	return err;							\
}									\
									\
int									\
name##_func(struct cell_array **z, struct cell_array *r,		\
    struct cell_func *self)						\
{									\
	return monadic_scalar_apply(z, r, name##_values);		\
}									\
									\
DECL_FUNC(name##_vec_ibeam, name##_func, error_dya)			\

DEF_TRIG(arctanh, af_atanh, atanh);
DEF_TRIG(tanh, af_tanh, tanh);
DEF_TRIG(arccosh, af_acosh, acosh);
DEF_TRIG(cosh, af_cosh, cosh);
DEF_TRIG(arcsinh, af_asinh, asinh);
DEF_TRIG(sinh, af_sinh, sinh);
DEF_TRIG(arctan, af_atan, atan);
DEF_TRIG(tan, af_tan, tan);
DEF_TRIG(arccos, af_acos, acos);
DEF_TRIG(cos, af_cos, cos);
DEF_TRIG(arcsin, af_asin, asin);
DEF_TRIG(sin, af_sin, sin);

