#include <complex.h>
#include <float.h>
#include <math.h>
#include <string.h>

#include "internal.h"
#include "prim.h"

int
error_mon_syntax(struct cell_array **z, struct cell_array *r, 
    struct cell_func *self)
{
	return 2;
}

int
error_dya_syntax(struct cell_array **z, 
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	return 2;
}

int
error_mon_nonce(struct cell_array **z, struct cell_array *r,
    struct cell_func *self)
{
	return 16;
}

int
error_dya_nonce(struct cell_array **z, 
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	return 16;
}

int
q_signal_mon(struct cell_array **z, 
    struct cell_array *r, struct cell_func *self)
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
	
	if (err = get_scalar_int32(&val, r, 0))
		return err;
	
	return val;
}

int
q_signal_dya(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	int err;
	
	if (!is_char_array(l))
		CHK(11, fail, L"EXPECTED CHARACTER LEFT ARGUMENT");
	
	if (l->rank > 1)
		CHK(4, fail, L"EXPECTED VECTOR LEFT ARGUMENT");
	
	TRC(16, L"LEFT ARGUMENT NOT SUPPORTED FOR ⎕SIGNAL YET");

fail:
	return err;
}

DECL_FUNC(q_signal_ibeam, q_signal_mon, q_signal_dya)

int
q_dr_mon(struct cell_array **z,
    struct cell_array *r, struct cell_func *self)
{
	int16_t val;
	
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
	
	return mk_array_int16(z, val);
}

DECL_FUNC(q_dr_ibeam, q_dr_mon, error_dya_nonce)

struct cell_array span_array_value = {
	CELL_ARRAY, 1, STG_HOST, ARR_SPAN, NULL, NULL, 0
};
struct cell_array *cdf_span_array = &span_array_value;

int
eq_func(struct cell_array **z, struct cell_array *r,
    struct cell_func *self)
{
	void *aa, *ww;
	
	aa = self->fv[1];
	ww = self->fv[2];
	
	return mk_array_int8(z, aa == ww);
}

DECL_DOPER(eq_ibeam, 
    eq_func, error_dya_syntax, eq_func, error_dya_syntax,
    eq_func, error_dya_syntax, eq_func, error_dya_syntax
)

#define DEFN_PRED_IBEAM(name, expr)				\
int								\
name##_func(struct cell_array **z, struct cell_array *r,	\
    struct cell_func *self)					\
{								\
	return mk_array_int8(z, (expr));			\
}								\
								\
DECL_FUNC(name##_ibeam, name##_func, error_dya_syntax)		\

DEFN_PRED_IBEAM(is_simple, r->type != ARR_NESTED)
DEFN_PRED_IBEAM(is_numeric, is_numeric_array(r))
DEFN_PRED_IBEAM(is_char, is_char_array(r))
DEFN_PRED_IBEAM(is_integer, is_integer_array(r))
DEFN_PRED_IBEAM(is_span, r->type == ARR_SPAN)

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
		
		if (dim <= 1) {
		} else if (dim <= INT16_MAX) {
			if (type < ARR_SINT) 
				type = ARR_SINT;
		} else if (dim <= INT32_MAX) {
			if (type < ARR_INT)
				type = ARR_INT;
		} else if (dim <= DBL_MAX) {
			if (type < ARR_DBL) 
				type = ARR_DBL;
		} else {
			CHK(10, fail, L"Shape exceeds DBL range");
		}
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

DECL_FUNC(shape_ibeam, shape_func, error_dya_syntax)

int
max_shp_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	size_t lc, rc;
	
	lc = array_count(l);
	rc = array_count(r);
	
	if (lc != 1)
		return shape_func(z, l, cdf_shape_ibeam);
	
	if (rc != 1)
		return shape_func(z, r, cdf_shape_ibeam);
	
	if (r->rank > l->rank)
		return shape_func(z, r, cdf_shape_ibeam);
	
	return shape_func(z, l, cdf_shape_ibeam);
}

DECL_FUNC(max_shp_ibeam, error_mon_syntax, max_shp_func)

int
any_monadic(struct cell_array **z, struct cell_array *r, 
    struct cell_func *self)
{
	size_t count;
	int err;
	int8_t *vals;
	
	if (r->type != ARR_BOOL) {
		#define ANY_ERROR(oper, kind, type, sfx, fail)		\
			CHK(99, fail,					\
			    L"Expected Boolean, found " #sfx L" type");
		MONADIC_TYPE_SWITCH(r->type, ANY_ERROR,, done);
	}
	
	if (r->storage == STG_DEVICE) {
		double real, imag;
		
		CHKAF(af_any_true_all(&real, &imag, r->values), done);
		CHKFN(mk_array_int8(z, (int8_t)real), done);
		    
		return 0;
	}
	
	if (r->storage != STG_HOST)
		CHK(99, done, L"Unknown storage type.");
	
	count = array_count(r);
	vals = r->values;
	
	for (size_t i = 0; i < count; i++) {
		if (vals[i]) {
			CHKFN(mk_array_int8(z, 1), done);
			
			return 0;
		}
	}
	
	CHKFN(mk_array_int8(z, 0), done);
	
done:
	return err;
}

DECL_FUNC(any_ibeam, any_monadic, error_dya_nonce)


int
set_idx_val(struct cell_array **z, struct cell_array *idx,
    struct cell_array *r)
{
	struct cell_array *tgt, *tmp, *val;
	enum array_type mtype;
	size_t count;
	int err;
	
	err = 0;
	tgt = *z;
	tmp = NULL;
	val = r;
	
	if (idx->type == ARR_SPAN) {
		EXPORT int cdf_rho(struct cell_array **,
		    struct cell_array *, struct cell_array *);
		    
		CHKFN(cdf_rho(&tmp, NULL, tgt), done);
		CHKFN(cdf_rho(z, tmp, val), done);
		
		goto done;
	}
	
	if (!(count = array_count(idx))) {
		retain_cell(tgt);
		return 0;
	}
	    
	if (tgt->refc > 1) {
		CHKFN(array_shallow_copy(&tgt, tgt), done);
	} else {
		retain_cell(tgt);
	}
	
	mtype = array_max_type(tgt->type, val->type);
	
	if (val->type != mtype) {
		CHKFN(array_shallow_copy(&val, val), done);
	}

	CHKFN(array_promote_storage(idx, tgt), done);
	CHKFN(array_promote_storage(val, tgt), done);
	CHKFN(array_promote_storage(idx, val), done);

	CHKFN(cast_values(tgt, mtype), done);
	CHKFN(cast_values(val, mtype), done);
	    
	switch (tgt->storage) {
	case STG_DEVICE:{
		af_index_t *idxs;
		af_array out, tgt_d, val_d, idx_d;

		tgt_d = tgt->values;
		idx_d = idx->values;
		val_d = val->values;
		
		CHKAF(af_cast(&idx_d, idx_d, s64), done);
		CHKAF(af_create_indexers(&idxs), done);
		CHKAF(af_set_array_indexer(idxs, idx_d, 0), dev_fail);		
		CHKAF(af_assign_gen(&out, tgt_d, 1, idxs, val_d), dev_fail);
		
		CHKAF(af_sync(-1), dev_fail);

		CHKAF(af_release_array(tgt_d), dev_fail);
		
		tgt->values = out;
		
dev_fail:
		af_release_array(idx_d);
		af_release_indexers(idxs);
		
		break;
	}
	case STG_HOST:{
		size_t rc;
		
		rc = array_count(r);
		
		if (*tgt->vrefc > 1) {
			void *vals = tgt->values;
			
			CHKFN(release_array_data(tgt), done);
			CHKFN(alloc_array(tgt), done);
			CHKFN(fill_array(tgt, vals), done);
		}
		
		#define SET_GETIDX_real(sfx, fail) idx = (int64_t)lv[i];
		#define SET_GETIDX_char(sfx, fail) BAD_ELEM(sfx, fail)
		#define SET_GETIDX_cmpx(sfx, fail) BAD_ELEM(sfx, fail)
		#define SET_GETIDX_cell(sfx, fail) BAD_ELEM(sfx, fail)
		
		#define SET_ASSIGN_real(fail) tv[idx] = rv[i % rc];
		#define SET_ASSIGN_char(fail) tv[idx] = rv[i % rc];
		#define SET_ASSIGN_cmpx(fail) tv[idx] = rv[i % rc];
		#define SET_ASSIGN_cell(fail)				\
			retain_cell(rv[i % rc]);			\
			CHKFN(release_array(tv[idx]), fail);		\
			tv[idx] = rv[i % rc];				\
		
		#define SET_LOOP(op, tk, tt, ts, lk, lt, ls, fail) {	\
			tt *tv = tgt->values;				\
			lt *lv = idx->values;				\
			tt *rv = val->values;				\
									\
			for (size_t i = 0; i < count; i++) {		\
				int64_t idx = 0;			\
									\
				SET_GETIDX_##lk(#ls, fail);		\
				SET_GETIDX_##lk(#ls, fail);		\
				SET_ASSIGN_##tk(fail);			\
			}						\
		}							\
	
		DYADIC_TYPE_SWITCH(tgt->type, idx->type, SET_LOOP,, done);

		break;
	}
	default:
		CHK(99, done, L"Unknown storage type");
	}
	
	if (!err)
		*z = tgt;
	
done:
	release_array(tmp);
	
	if (val != r)
		release_array(val);
	
	return err;
}

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

DECL_FUNC(ravel_ibeam, ravel_func, error_dya_syntax)

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

DECL_FUNC(disclose_ibeam, disclose_func, error_dya_syntax)

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

DECL_FUNC(enclose_ibeam, enclose_func, error_dya_syntax)

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
	
	CHKFN(mk_array(&t, r->type, r->storage, rank), fail);
	
	if (rank) {
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
	}
	
	if (!array_count(t)) {
		t->storage = STG_HOST;
		
		if (is_numeric_array(r)) {
			t->type = ARR_BOOL;
			
			CHKFN(alloc_array(t), fail);
		}
		
		if (is_char_array(r)) {
			uint8_t *val;
			
			t->type = ARR_CHAR8;
			
			CHKFN(alloc_array(t), fail);
			
			val = t->values;
			*val = ' ';
		}
		
		if (r->type == ARR_NESTED) {
			struct cell_array **tgt, **src;
			struct cell_func *proto;
			
			t->type = ARR_NESTED;
			
			CHKFN(alloc_array(t), fail);
			
			proto = cdf_prim.cdf_prototype;
			tgt = t->values;
			src = r->values;
			
			CHKFN(proto->fptr_mon(tgt, *src, proto), fail);
		}
		
		goto done;
	}
	
	tc = array_values_count(t);
	rc = array_values_count(r);
	
	if (r->type == ARR_SPAN && rank) {
		struct cell_array **tv;
		
		t->storage = STG_HOST;
		t->type = ARR_NESTED;
		
		CHKFN(alloc_array(t), fail);
		
		tv = t->values;
		
		for (size_t i = 0; i < tc; i++)
			tv[i] = retain_cell(r);
		
		goto done;
	}
	
	if (tc == rc) {
		t->values = r->values;
		t->vrefc = r->vrefc;
		
		CHKFN(retain_array_data(t), fail);
		
		goto done;
	}
	
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
	
	CHKFN(alloc_array(t), fail);
	
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

DECL_FUNC(reshape_ibeam, error_mon_syntax, reshape_func)

int
same_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	int err;
	int8_t is_same;
	
	CHKFN(array_is_same(&is_same, l, r), done);
	CHKFN(mk_array_int8(z, is_same), done);
	
done:
	return err;
}

DECL_FUNC(same_ibeam, error_mon_syntax, same_func)

int
nqv_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	int err;
	int8_t is_same;
	
	CHKFN(array_is_same(&is_same, l, r), done);
	CHKFN(mk_array_int8(z, !is_same), done);
	
done:
	return err;
}

DECL_FUNC(nqv_ibeam, error_mon_syntax, nqv_func)

int
veach_monadic(struct cell_array **z,
    struct cell_array *r, struct cell_func *self)
{
	struct cell_func *oper;
	struct cell_array *t, *x, **tv;
	void *buf;
	size_t count;
	int err, fb;
	
	oper	= self->fv[1];
	fb	= 0;
	t	= NULL;
	tv	= NULL;
	
	if (r->type == ARR_SPAN || r->type == ARR_MIXED)
		CHK(99, fail, L"Unexpected (SPAN | MIXED) type array");
	
	CHKFN(array_get_host_buffer(&buf, &fb, r), fail);
	CHKFN(mk_array(&t, ARR_NESTED, STG_HOST, 1), fail);
	
	t->shape[0] = count = array_values_count(r);
	
	CHKFN(alloc_array(t), fail);
	
	tv	= t->values;
	
	#define VEACH_MON_LOOP(op, kd, tp, sfx, fail) {			\
		tp *rv = buf;						\
									\
		for (size_t i = 0; i < count; i++) {			\
			CHKFN(mk_array_##sfx(&x, rv[i]), fail);		\
			CHKFN((oper->fptr_mon)(tv + i, x, oper), fail);	\
			CHKFN(release_array(x), fail);			\
		}							\
	}								\
	
	MONADIC_TYPE_SWITCH(r->type, VEACH_MON_LOOP,, fail);
		
	err = 0;
	*z = t;
	
fail:
	if (fb)
		free(buf);
	
	if (err)
		release_array(t);
	
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
	int err, fl, fr;
	
	oper = self->fv[1];

	t = NULL;
	fl = fr = 0;
		
	if (l->type == ARR_SPAN || r->type == ARR_SPAN ||
	    l->type == ARR_MIXED || r->type == ARR_MIXED)
		CHK(99, fail, L"Unexpected (SPAN | MIXED) type array");
		
	CHKFN(array_get_host_buffer(&lbuf, &fl, l), fail);
	CHKFN(array_get_host_buffer(&rbuf, &fr, r), fail);
	CHKFN(mk_array(&t, ARR_NESTED, STG_HOST, 1), fail);
	
	lc = array_values_count(l);
	rc = array_values_count(r);
	t->shape[0] = count = lc > rc ? lc : rc;
	
	CHKFN(alloc_array(t), fail);
	
	tvals = t->values;
	
#define VEACH_DYA_LOOP(op, lk, lt, ls, rk, rt, rs, fail) {		\
	lt *lvals = lbuf;						\
	rt *rvals = rbuf;						\
									\
	for (size_t i = 0; i < count; i++) {				\
		CHKFN(mk_array_##ls(&x, lvals[i % lc]), fail);		\
		CHKFN(mk_array_##rs(&y, rvals[i % rc]), fail);		\
		CHKFN((oper->fptr_dya)(tvals + i, x, y, oper), fail);	\
		CHKFN(release_array(x), fail);				\
		CHKFN(release_array(y), fail);				\
	}								\
}									\

	DYADIC_TYPE_SWITCH(l->type, r->type, VEACH_DYA_LOOP,, fail);

	err = 0;
	*z = t;

fail:
	if (fl)
		free(lbuf);
	
	if (fr)
		free(rbuf);
	
	if (err)
		release_array(t);
	
	return err;
}

DECL_MOPER(veach_ibeam, error_mon_syntax, error_dya_syntax, veach_monadic, veach_dyadic)

int
squeeze_func(struct cell_array **z,
    struct cell_array *r, struct cell_func *self)
{
	int err;
	
	CHKFN(squeeze_array(r), done);
	
	*z = retain_cell(r);
	
done:	
	return err;
}

DECL_FUNC(squeeze_ibeam, squeeze_func, error_dya_syntax)

int
has_nat_vals_func(struct cell_array **z,
    struct cell_array *r, struct cell_func *self)
{
	int err, is_nat;
	
	CHKFN(has_natural_values(&is_nat, r), fail);
	CHKFN(mk_array_int8(z, is_nat), fail);
	
fail:
	return err;
}

DECL_FUNC(has_nat_vals_ibeam, has_nat_vals_func, error_dya_syntax)

int
index_gen_func(struct cell_array **z, struct cell_array *r, struct cell_func *self)
{
	struct cell_array *t;
	size_t dim;
	int err;
	enum array_storage stg;
	enum array_type ztype;
	
	err = 0;
	t = NULL;
	
	CHKFN(get_scalar_u64(&dim, r, 0), fail);
	
	ztype = closest_numeric_array_type((double)dim);
	
	if (ztype == ARR_BOOL)
		ztype = ARR_SINT;
	
	stg = dim > STORAGE_DEVICE_THRESHOLD ? STG_DEVICE : STG_HOST;
	
	CHKFN(mk_array(&t, ztype, stg, 1), fail);
	
	t->shape[0] = dim;
	
	switch (t->storage) {
	case STG_DEVICE:{
		size_t tile;
		af_dtype aftype;
		
		tile = 1;
		aftype = array_af_dtype(t);
		
		CHKAF(af_iota(&t->values, 1, &dim, 1, &tile, aftype), fail);
	}break;
	case STG_HOST:{
		CHKFN(alloc_array(t), fail);
		
		#define INDEX_GEN_LOOP(tp) {		\
			tp *v;				\
							\
			v = t->values;			\
							\
			for (tp i = 0; i < dim; i++)	\
				*v++ = i;		\
		}
		
		switch (t->type) {
		case ARR_BOOL:INDEX_GEN_LOOP(int8_t);break;
		case ARR_SINT:INDEX_GEN_LOOP(int16_t);break;
		case ARR_INT:INDEX_GEN_LOOP(int32_t);break;
		case ARR_DBL:INDEX_GEN_LOOP(double);break;
		default:
			CHK(99, fail, L"Unexpected non-real type");
		}
	}break;
	default:
		CHK(99, fail, L"Unknown storage type");
	}
	
	*z = t;
	
fail:
	if (err)
		release_array(t);
	
	return err;
}

DECL_FUNC(index_gen_vec, index_gen_func, error_dya_syntax)

int
simple_index_offset(size_t *res, struct cell_array *tgt, struct cell_array *l)
{
	size_t idx, *sp, lc;
	int err;
	
	CHKFN(array_migrate_storage(l, STG_HOST), fail);
	
	sp = tgt->shape;
	lc = array_count(l);
	idx = 0;
	
	#define IDX_SIMP_OFFSET(lt) {				\
		lt *lv = l->values;				\
								\
		for (size_t i = 0; i < lc; i++)			\
			idx = idx * *sp++ + (size_t)*lv++;	\
	}
	
	switch (l->type) {
	case ARR_BOOL:IDX_SIMP_OFFSET(int8_t);break;
	case ARR_SINT:IDX_SIMP_OFFSET(int16_t);break;
	case ARR_INT:IDX_SIMP_OFFSET(int32_t);break;
	case ARR_DBL:IDX_SIMP_OFFSET(double);break;
	default:
		CHK(99, fail, L"Unexpected non-real type");
	}
	
	*res = idx;
	
fail:
	return err;
}

int
merge_indices(size_t *ic_p, size_t *bc_p, struct cell_array ***idx_p, size_t **sp_p, 
    size_t **cnt_p, size_t **ci_p, int *f_p,
    struct cell_array *tgt, struct cell_array *l, 
    size_t lim)
{
	struct cell_array **idx, **lv;
	size_t ic, bc, *sp, *cnt, *ci, lc;
	int err, f;
	
	err = 0;
	f = 0;
	lv = l->values;
	ic = 1;
	lc = array_count(l);
	
	for (size_t i = 1; i < lc; i++)
		if (lv[i]->type == ARR_SPAN)
			ic += lv[i-1]->type != ARR_SPAN;
		else
			ic++;
	
	idx = *idx_p;
	sp = *sp_p;
	cnt = *cnt_p;
	ci = *ci_p;
	
	if (ic > lim) {
		f = 1;
		idx = NULL;
		sp = cnt = ci = NULL;
		
		idx = calloc(ic, sizeof(struct cell_array *));
		CHK(idx == NULL, fail, L"Cannot allocate memory for idx");
		
		sp = calloc(ic, sizeof(size_t));
		CHK(sp == NULL, fail, L"Cannot allocate memory for sp");

		cnt = calloc(ic, sizeof(size_t));
		CHK(cnt == NULL, fail, L"Cannot allocate memory for cnt");

		ci = calloc(ic, sizeof(size_t));
		CHK(ci == NULL, fail, L"Cannot allocate memory for ci");
	}
	
	for (size_t i = 0; i < ic; i++) {
		sp[i] = 1;
		ci[i] = 0;
	}
	
	ic = 0;
	
	for (size_t i = 0; i < lc; ic++) {
		idx[ic] = lv[i];
		sp[ic] *= tgt->shape[i];
					
		if (lv[i++]->type == ARR_SPAN) {
			while (i < lc && lv[i]->type == ARR_SPAN)
				sp[ic] *= tgt->shape[i++];
		}
	}
	
	bc = 1;
	
	for (size_t i = 0; i < ic; i++)
		if (idx[i]->type == ARR_SPAN)
			bc *= cnt[i] = sp[i];
		else
			bc *= cnt[i] = array_count(idx[i]);
	
	*ic_p = ic;
	*bc_p = bc;
	*idx_p = idx;
	*sp_p = sp;
	*cnt_p = cnt;
	*ci_p = ci;
	*f_p = f;
	
fail:
	if (err && f) {
		free(idx);
		free(sp);
		free(cnt);
		free(ci);
	}
	
	return err;
}

int
index_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	struct cell_array *idx_[32];
	size_t sp_[32], cnt_[32], ci_[32];
	struct cell_array *arr, **lv, **idx;
	size_t lc, zc, ic, *sp, *cnt, csz, bc, ccount, *ci;
	unsigned int zr;
	int err, f;
	char *zv, *rv;
	
	arr = NULL;
	f = 0;
	
	lc = array_count(l);
	sp = r->shape;
	ccount = 1;
	
	for (size_t i = lc; i < r->rank; i++)
		ccount *= sp[i];
	
	if (l->type != ARR_NESTED) {
		size_t idx;
		unsigned int rnk;
		
		rnk = (unsigned int)(r->rank - lc);
		bc = 1;
		
		for (size_t i = 0; i < lc; i++)
			bc *= sp[i];
		
		CHKFN(simple_index_offset(&idx, r, l), fail);
		CHKFN(mk_array(&arr, r->type, r->storage, rnk), fail);
		
		for (size_t i = 0; i < rnk; i++)
			arr->shape[i] = r->shape[lc + i];
		
		switch (arr->storage) {
		case STG_DEVICE:{
			dim_t asp[2] = {ccount, bc};
			af_seq ix[2] = {
				{0, (double)ccount - 1, 1}, 
				{(double)idx, (double)idx, 1}
			};
			af_array t;
			
			CHKAF(af_moddims(&arr->values, r->values, 2, asp), fail);
			
			t = arr->values;
			CHKAF(af_index(&arr->values, t, 2, ix), sdev_fail);
			CHKAF(af_release_array(t), sdev_fail);
			
			t = arr->values;
			CHKAF(af_flat(&arr->values, t), sdev_fail);
		
		sdev_fail:
			TRCAF(af_release_array(t));
			
			if (err)
				goto fail;
		}break;			
		case STG_HOST:{
			size_t elem_size, byte_count, byte_offset;
			char *src;
			
			CHKFN(alloc_array(arr), fail);
			
			elem_size = array_element_size(arr);
			byte_count = ccount * elem_size;
			byte_offset = idx * byte_count;
			src = r->values;
			
			memcpy(arr->values, src + byte_offset, byte_count);
		}break;
		default:
			CHK(99, fail, L"Unknown storage type");
		}
		
		goto done;
	}
	
	lv = l->values;
	zr = (unsigned int)(r->rank - lc);
	
	for (size_t i = 0; i < lc; i++)
		if (lv[i]->type == ARR_SPAN)
			zr++;
		else 
			zr += lv[i]->rank;
	
	CHKFN(mk_array(&arr, r->type, r->storage, zr), fail);
	
	sp = arr->shape;
	
	for (size_t i = 0; i < lc; i++)
		if (lv[i]->type == ARR_SPAN)
			*sp++ = r->shape[i];
		else
			for (unsigned int j = 0; j < lv[i]->rank; j++)
				*sp++ = lv[i]->shape[j];
	
	for (size_t i = lc; i < r->rank; i++)
		*sp++ = r->shape[i];
	
	zc = array_count(arr);
	
	if (!zc) {
		arr->type = ARR_SINT;
		arr->storage = STG_HOST;
		
		CHKFN(alloc_array(arr), fail);

		goto done;
	}
	
	if (zc > STORAGE_DEVICE_THRESHOLD && arr->type != ARR_NESTED)
		arr->storage = STG_DEVICE;
	
	CHKFN(array_migrate_storage(r, arr->storage), fail);
	
	for (size_t i = 0; i < lc; i++)
		if (lv[i]->type != ARR_SPAN)
			CHKFN(array_migrate_storage(lv[i], arr->storage), fail);
		
	idx = idx_;
	sp = sp_;
	cnt = cnt_;
	ci = ci_;
	
	CHKFN(merge_indices(&ic, &bc, &idx, &sp, &cnt, &ci, &f, r, l, 32), fail);
	
	if ((ic < 4 || ic <= 4 && lc == r->rank) && arr->storage == STG_DEVICE) {
		af_index_t *ix;
		af_array t;
		dim_t asp[4];
		
		CHKAF(af_create_indexers(&ix), fail);
		
		if (lc < r->rank) {
			sp[ic] = ccount;
			idx[ic] = cdf_span_array;
			ic++;
		}
		
		for (size_t i = 0; i < ic; i++) {
			size_t j;
			af_array v;
			
			j = ic - (i + 1);
			asp[j] = sp[i];
			
			if (idx[i]->type != ARR_SPAN) {
				CHKAF(af_cast(&v, idx[i]->values, s64), dev4_fail);
				CHKAF(af_set_array_indexer(ix, v, j), dev4_fail);
			}
		}
		
		t = NULL;
		CHKAF(af_moddims(&t, r->values, (unsigned int)ic, asp), dev4_fail);
		CHKAF(af_index_gen(&arr->values, t, ic, ix), dev4_fail);
		CHKAF(af_release_array(t), dev4_fail);
		
		t = arr->values;
		CHKAF(af_flat(&arr->values, t), dev4_fail);
				
	dev4_fail:
		for (size_t i = 0; i < ic; i++)
			if (idx[i]->type != ARR_SPAN)
				af_release_array(ix[ic - (i + 1)].idx.arr);
		
		af_release_array(t);
		af_release_indexers(ix);
		
		if (err)
			goto fail;
		
		goto done;
	}
	
	if (arr->storage == STG_DEVICE) {
		CHK(16, fail, L"High rank device indexing not supported yet.");
	}
	
	if (arr->storage != STG_HOST)
		CHK(99, fail, L"Unknown storage type.");
	
	CHKFN(alloc_array(arr), fail);
	
	zv = arr->values;
	rv = r->values;
	csz = ccount * array_element_size(arr);
		
	for (size_t i = 0; i < bc; i++) {		
		size_t ix = 0;
		
		for (size_t j = 0; j < ic; j++) {
			size_t x;
			
			if (idx[j]->type == ARR_SPAN)
				x = ci[j];
			else
				CHKFN(get_scalar_u64(&x, idx[j], ci[j]), fail);
			
			ix = ix * sp[j] + x;
		}
		
		memcpy(zv + i * csz, rv + ix * csz, csz);
		
		for (size_t j = ic - 1; j >= 0; j--)
			if (++ci[j] == cnt[j])
				ci[j] = 0;
			else
				break;
	}
	
done:	
	if (arr->type == ARR_NESTED) {
		size_t count;
		struct cell_array **zv;

		zv = arr->values;
		count = array_count(arr);
		
		for (size_t i = 0; i < count; i++)
			retain_cell(*zv++);
	}
	
	*z = arr;
	
fail:
	if (err)
		release_array(arr);
	
	if (f) {
		free(idx);
		free(sp);
		free(cnt);
		free(ci);
	}

	return err;
}

DECL_FUNC(index_ibeam, error_mon_syntax, index_func)

int
set_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	struct cell_array *arr, *sp, *tgt, **lv, *idx_[32];
	struct cell_func *idx_rnk_check, *idx_rng_check;
	size_t sp_[32], cnt_[32], ci_[32];
	size_t lc, rc, zc, ic, bc, csz, *isp, *cnt, *ci;
	char *zv, *rv;
	int err, f;
	enum array_type mtype;
	
	tgt = *z;
	arr = NULL;
	sp = NULL;
	f = 0;
	
	idx_rnk_check = cdf_prim.cdf_idx_rnk_check->value;
	CHK((idx_rnk_check->fptr_dya)(&arr, tgt, l, idx_rnk_check), fail,
	    L"z idx_rnk_check ⍺:");
	CHKFN(release_array(arr), fail);arr = NULL;
	
	CHKFN(shape_func(&sp, tgt, NULL), fail);
	
	idx_rng_check = cdf_prim.cdf_idx_rng_check->value;
	CHK((idx_rng_check->fptr_dya)(&arr, sp, l, idx_rng_check), fail,
	    L"(⍴z) idx_rng_check ⍺:");
	CHKFN(release_array(sp), fail);sp = NULL;
	CHKFN(release_array(arr), fail);arr = NULL;
	
	CHKFN(squeeze_array(l), fail);
		
	if (l->type == ARR_NESTED) {
		lv = l->values;
		lc = array_count(l);

		if (r->rank) {
			size_t zr, *rsp;

			zr = 0;
			
			for (size_t i = 0; i < lc; i++)
				if (lv[i]->type == ARR_SPAN)
					zr++;
				else
					zr += lv[i]->rank;
			
			if (zr != r->rank)
				CHK(4, fail, 
				    L"Index rank does not match value rank");

			rsp = r->shape;
			
			for (size_t i = 0; i < lc; i++) {
				size_t lr, *ls;
				wchar_t msg[] = 
				    L"Index shape does not match value shape.";
				
				if (lv[i]->type == ARR_SPAN) {
					if (tgt->shape[i] != *rsp++)
						CHK(5, fail, msg);
					
					continue;
				}
				
				lr = lv[i]->rank;
				ls = lv[i]->shape;
				
				for (size_t j = 0; j < lr; j++)
					if (*ls++ != *rsp++)
						CHK(5, fail, msg);
			}
		}
		
		zc = 1;
		
		for (size_t i = 0; i < lc; i++)
			if (lv[i]->type == ARR_SPAN)
				zc *= tgt->shape[i];
			else
				zc *= array_count(lv[i]);
		
		if (!zc) {
			retain_cell(tgt);
			goto done;
		}
	} else {
		if (r->rank)
			CHK(4, fail, L"Non-scalar assigned to scalar index");
	}
	
	if (tgt->refc > 1) {
		CHKFN(array_shallow_copy(&tgt, tgt), fail);
	} else {
		retain_cell(tgt);
	}
	
	if (tgt->storage == STG_HOST && *tgt->vrefc > 1) {
		void *vals = tgt->values;
		
		CHKFN(release_array_data(tgt), fail);
		CHKFN(alloc_array(tgt), fail);
		CHKFN(fill_array(tgt, vals), fail);
	}

	mtype = array_max_type(tgt->type, r->type);
	
	if (r->type != mtype)
		CHKFN(array_shallow_copy(&r, r), fail);
	
	if (l->type != ARR_NESTED) {
		size_t idx;
		
		CHKFN(simple_index_offset(&idx, tgt, l), fail);
		CHKFN(array_migrate_storage(r, tgt->storage), fail);
		CHKFN(cast_values(tgt, mtype), fail);
		CHKFN(cast_values(r, mtype), fail);
		
		switch (tgt->storage) {
		case STG_DEVICE:{
			af_seq seq = {(double)idx, (double)idx, 1};
			af_array tmp;
			
			CHKAF(af_assign_seq(&tmp, tgt->values, 1, &seq, r->values),
			    fail);
			CHKAF(af_release_array(tgt->values), fail);
			
			tgt->values = tmp;			
		}break;
		case STG_HOST:{
			size_t elem_size;
			char *dst;
			
			elem_size = array_element_size(r);
			dst = tgt->values;
			
			memcpy(dst + idx * elem_size, r->values, elem_size);
			
			if (r->type == ARR_NESTED)
				retain_cell(*(struct cell_array **)r->values);
		}break;
		default:
			CHK(99, fail, L"Unknown storage type.");
		}
		
		goto done;
	}
	
	if (zc > STORAGE_DEVICE_THRESHOLD && tgt->type != ARR_NESTED)
		CHKFN(array_migrate_storage(tgt, STG_DEVICE), fail);
	
	CHKFN(array_promote_storage(tgt, r), fail);
	CHKFN(cast_values(tgt, mtype), fail);
	CHKFN(cast_values(r, mtype), fail);
	
	for (size_t i = 0; i < lc; i++)
		if (lv[i]->type != ARR_SPAN)
			CHKFN(array_migrate_storage(lv[i], tgt->storage), fail);
	
	lv = idx_;
	isp = sp_;
	cnt = cnt_;
	ci = ci_;
	
	CHKFN(merge_indices(&ic, &bc, &lv, &isp, &cnt, &ci, &f, tgt, l, 32), fail);
	
	if (ic <= 4 && tgt->storage == STG_DEVICE) {
		af_index_t *ix;
		af_array t, rv4;
		dim_t asp[4], rsp[4];
		unsigned int afrk;
		
		CHKAF(af_create_indexers(&ix), fail);

		t = NULL;
		rv4 = NULL;
		
		for (size_t i = 0; i < ic; i++) {
			size_t j;
			af_array v;
			
			j = ic - (i + 1);
			asp[j] = isp[i];
			rsp[j] = cnt[i];
			
			if (lv[i]->type != ARR_SPAN) {
				CHKAF(af_cast(&v, lv[i]->values, s64), dev4_fail);
				CHKAF(af_set_array_indexer(ix, v, j), dev4_fail);
			}
		}
		
		afrk = 0;
		
		for (unsigned int i = 0; i < ic; i++)
			if (asp[i] > 1 || rsp[i] > 1)
				afrk = i;
			
		afrk++;
				
		if (!r->rank) {
			CHKAF(af_tile(&t, r->values, (unsigned)bc, 1, 1, 1), dev4_fail);
		} else {
			t = r->values;
		}
		
		CHKAF(af_moddims(&rv4, t, (unsigned int)ic, rsp), dev4_fail);
		
		if (!r->rank)
			CHKAF(af_release_array(t), dev4_fail);
		
		t = NULL;
		CHKAF(af_moddims(&t, tgt->values, (unsigned int)ic, asp), dev4_fail);
		CHKAF(af_assign_gen(&tgt->values, t, afrk, ix, rv4), dev4_fail);
		CHKAF(af_release_array(rv4), dev4_fail);rv4 = NULL;
		CHKAF(af_release_array(t), dev4_fail);
		
		t = tgt->values;
		CHKAF(af_flat(&tgt->values, t), dev4_fail);
				
	dev4_fail:
		for (size_t i = 0; i < ic; i++)
			if (lv[i]->type != ARR_SPAN)
				af_release_array(ix[ic - (i + 1)].idx.arr);
		
		af_release_array(t);
		af_release_array(rv4);
		af_release_indexers(ix);
		
		if (err)
			goto fail;
		
		goto done;
	}
	
	if (tgt->storage == STG_DEVICE) {
		CHK(16, fail, L"High rank device indexing not finished.");
	}
	
	if (tgt->storage != STG_HOST)
		CHK(99, fail, L"Unknown storage type.");
	
	zv = tgt->values;
	rv = r->values;
	csz = array_element_size(tgt);
	rc = array_count(r);
	
	for (size_t i = 0; i < bc; i++) {
		size_t ix = 0;
		char *rve, *zve;
		
		for (size_t j = 0; j < ic; j++) {
			size_t x;
			
			if (lv[j]->type == ARR_SPAN)
				x = ci[j];
			else
				CHKFN(get_scalar_u64(&x, lv[j], ci[j]), fail);
			
			ix = ix * isp[j] + x;
		}
		
		rve = rv + (i % rc) * csz;
		zve = zv + ix * csz;
		
		if (r->type == ARR_NESTED) {
			retain_cell(*(struct cell_array **)rve);
			CHKFN(release_array(*(struct cell_array **)zve), fail);
		}
		
		memcpy(zve, rve, csz);
		
		for (size_t j = ic - 1; j >= 0; j--)
			if (++ci[j] == cnt[j])
				ci[j] = 0;
			else
				break;
	}
	
done:
	*z = tgt;
	
fail:
	if (f) {
		free(lv);
		free(isp);
		free(cnt);
		free(ci);
	}
	
	if (err) {
		release_array(sp);
		release_array(arr);
	}
	
	return err;
}

DECL_FUNC(set_ibeam, error_mon_syntax, set_func)

int
mst_oper(struct cell_array **z, 
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	struct cell_array *idx, *val, *idx_vals, **iv;
	struct cell_func *oper, *get_idx_vals;
	struct cell_doper *mst_vals;
	int err;
	
	get_idx_vals = NULL;
	idx_vals = NULL;
	oper = self->fv[1];
	mst_vals = cdf_prim.cdf_mst_vals;
	
	CHK(apply_dop(&get_idx_vals, mst_vals,
	    mst_vals->fptr_fam, mst_vals->fptr_fad, l, oper),
	    fail, L"get_idx_vals←idx mst_vals op");
	CHK((get_idx_vals->fptr_dya)(&idx_vals, *z, r, get_idx_vals), fail,
	    L"(idx vals)←(*z)(idx mst_vals op)⍵");

	iv = idx_vals->values;
	idx = iv[0];
	val = iv[1];
	
	CHKFN(set_func(z, idx, val, NULL), fail);
	
fail:
	release_func(get_idx_vals);
	release_array(idx_vals);
	
	return err;
}

DECL_MOPER(mst_ibeam, 
    error_mon_syntax, error_dya_syntax, error_mon_syntax, mst_oper)

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
	
	CHKFN(fn(t, r), fail);
	
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
		CHKFN(scl_device(&za, lcast, rcast), device_done);
		
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

int
add_type(enum array_type *type, struct cell_array *l, struct cell_array *r)
{
	*type = l->type > r->type ? l->type : r->type;
	
	if (*type < ARR_DBL)
		(*type)++;
	
	return 0;
}

struct apl_cmpx
add_cmpx(struct apl_cmpx x, struct apl_cmpx y)
{
	struct apl_cmpx z = {x.real + y.real, x.imag + y.imag};
	
	return z;
}

#define add_real(x, y) ((x) + (y))
#define add_af(z, l, r) af_add(z, l, r, 0)

#define ADD_SWITCH_real(typ, sfx, fail) SCALAR_SWITCH(sfx, typ, add_real, fail)
#define ADD_SWITCH_cmpx(typ, sfx, fail) SCALAR_SWITCH(cmpx, typ, add_cmpx, fail)
#define ADD_SWITCH_char(typ, sfx, fail) BAD_ELEM(sfx, fail)
#define ADD_SWITCH_cell(typ, sfx, fail) BAD_ELEM(sfx, fail)

DEFN_DYADIC_SCALAR(add, ADD, add_type)

int
mul_type(enum array_type *type, struct cell_array *l, struct cell_array *r)
{
	*type = l->type > r->type ? l->type : r->type;
	
	if (*type < ARR_DBL && r->type != ARR_BOOL && l->type != ARR_BOOL)
		(*type)++;
	
	return 0;
}

struct apl_cmpx
mul_cmpx(struct apl_cmpx x, struct apl_cmpx y)
{
	struct apl_cmpx z;
	
	z.real = x.real * y.real - x.imag * y.imag;
	z.imag = x.imag * y.real + x.real * y.imag;
	
	return z;
}

#define mul_real(x, y) ((x) * (y))
#define mul_af(z, l, r) af_mul(z, l, r, 0)

#define MUL_SWITCH_real(typ, sfx, fail) SCALAR_SWITCH(sfx, typ, mul_real, fail)
#define MUL_SWITCH_cmpx(typ, sfx, fail) SCALAR_SWITCH(cmpx, typ, mul_cmpx, fail)
#define MUL_SWITCH_char(typ, sfx, fail) BAD_ELEM(sfx, fail)
#define MUL_SWITCH_cell(typ, sfx, fail) BAD_ELEM(sfx, fail)

DEFN_DYADIC_SCALAR(mul, MUL, mul_type)

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

#define div_real(x, y) ((y) ? (double)(x) / (double)(y) : 0 * (x))
#define div_af(z, l, r) af_div(z, l, r, 0)

#define DIV_SWITCH_real(typ, sfx, fail) SCALAR_SWITCH(sfx, typ, div_real, fail)
#define DIV_SWITCH_cmpx(typ, sfx, fail) SCALAR_SWITCH(cmpx, typ, div_cmpx, fail)
#define DIV_SWITCH_char(typ, sfx, fail) BAD_ELEM(sfx, fail)
#define DIV_SWITCH_cell(typ, sfx, fail) BAD_ELEM(sfx, fail)

DEFN_DYADIC_SCALAR(div, DIV, div_type)

struct apl_cmpx
sub_cmpx(struct apl_cmpx x, struct apl_cmpx y)
{
	struct apl_cmpx z = {x.real - y.real, x.imag - y.imag};
	
	return z;
}

#define sub_real(x, y) ((x) - (y))
#define sub_af(z, l, r) af_sub(z, l, r, 0)

#define SUB_SWITCH_real(typ, sfx, fail) SCALAR_SWITCH(sfx, typ, sub_real, fail)
#define SUB_SWITCH_cmpx(typ, sfx, fail) SCALAR_SWITCH(cmpx, typ, sub_cmpx, fail)
#define SUB_SWITCH_char(typ, sfx, fail) BAD_ELEM(sfx, fail)
#define SUB_SWITCH_cell(typ, sfx, fail) BAD_ELEM(sfx, fail)

DEFN_DYADIC_SCALAR(sub, SUB, add_type)

int
dbl_cmpx_type(enum array_type *type, 
    struct cell_array *l, struct cell_array *r)
{
	*type = ARR_DBL;
	
	if (l->type == ARR_CMPX || r->type == ARR_CMPX)
		*type = ARR_CMPX;
	
	return 0;
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

#define pow_af(z, l, r) af_pow(z, l, r, 0)

#define POW_SWITCH_real(typ, sfx, fail) SCALAR_SWITCH(sfx, typ, pow, fail)
#define POW_SWITCH_cmpx(typ, sfx, fail) SCALAR_SWITCH(cmpx, typ, pow_cmpx, fail)
#define POW_SWITCH_char(typ, sfx, fail) BAD_ELEM(sfx, fail)
#define POW_SWITCH_cell(typ, sfx, fail) BAD_ELEM(sfx, fail)

DEFN_DYADIC_SCALAR(pow, POW, dbl_cmpx_type)

int
log_af(af_array *z, af_array l, af_array r)
{
	af_array a, b;
	int err, code;
	
	a = b = NULL;
	
	CHKAF(af_log(&a, r), cleanup);
	CHKAF(af_log(&b, l), cleanup);
	CHKAF(af_div(z, a, b, 0), cleanup);

	err = 0;
	
cleanup:
	code = err;
	
	CHKAF(af_release_array(a), fail);
	CHKAF(af_release_array(b), fail);
	
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
	
	return div_cmpx(b, a);
}

#define log_real(x, y) (log(y) / log(x))

#define LOG_SWITCH_real(typ, sfx, fail) SCALAR_SWITCH(sfx, typ, log_real, fail)
#define LOG_SWITCH_cmpx(typ, sfx, fail) SCALAR_SWITCH(cmpx, typ, log_cmpx, fail)
#define LOG_SWITCH_char(typ, sfx, fail) BAD_ELEM(sfx, fail)
#define LOG_SWITCH_cell(typ, sfx, fail) BAD_ELEM(sfx, fail)

DEFN_DYADIC_SCALAR(log, LOG, dbl_cmpx_type)

int
bitand_type(enum array_type *type, struct cell_array *l, struct cell_array *r)
{
	*type = l->type > r->type ? l->type : r->type;
	
	return 0;
}

#define bitand_real(x, y) (((int64_t)x) & ((int64_t)y))
#define bitand_af(z, l, r) af_bitand(z, l, r, 0)

#define BITAND_SWITCH_real(typ, sfx, fail) SCALAR_SWITCH(sfx, typ, bitand_real, fail)
#define BITAND_SWITCH_cmpx(typ, sfx, fail) BAD_ELEM(sfx, fail)
#define BITAND_SWITCH_char(typ, sfx, fail) BAD_ELEM(sfx, fail)
#define BITAND_SWITCH_cell(typ, sfx, fail) BAD_ELEM(sfx, fail)

DEFN_DYADIC_SCALAR(bitand, BITAND, bitand_type)

int
max_type(enum array_type *type, struct cell_array *l, struct cell_array *r)
{
	*type = l->type > r->type ? l->type : r->type;
	
	return 0;
}

#define min_real(x, y) ((x) < (y) ? (x) : (y))
#define min_af(z, l, r) af_minof(z, l, r, 0)

#define MIN_SWITCH_real(typ, sfx, fail) SCALAR_SWITCH(sfx, typ, min_real, fail)
#define MIN_SWITCH_cmpx(typ, sfx, fail) BAD_ELEM(sfx, fail)
#define MIN_SWITCH_char(typ, sfx, fail) BAD_ELEM(sfx, fail)
#define MIN_SWITCH_cell(typ, sfx, fail) BAD_ELEM(sfx, fail)

DEFN_DYADIC_SCALAR(min, MIN, max_type)

#define max_real(x, y) ((x) > (y) ? (x) : (y))
#define max_af(z, l, r) af_maxof(z, l, r, 0)

#define MAX_SWITCH_real(typ, sfx, fail) SCALAR_SWITCH(sfx, typ, max_real, fail)
#define MAX_SWITCH_cmpx(typ, sfx, fail) BAD_ELEM(sfx, fail)
#define MAX_SWITCH_char(typ, sfx, fail) BAD_ELEM(sfx, fail)
#define MAX_SWITCH_cell(typ, sfx, fail) BAD_ELEM(sfx, fail)

DEFN_DYADIC_SCALAR(max, MAX, max_type)

int
bool_type(enum array_type *type, struct cell_array *l, struct cell_array *r)
{
	*type = ARR_BOOL;
	
	return 0;
}

#define cmp_real_real(cmp, x, y) ((x) cmp (y))
#define cmp_real_char(cmp, x, y) ((x) cmp (int64_t)(y))
#define cmp_real_cmpx(cmp, x, y) ((x) cmp (y).real && 0 cmp (y).imag)
#define cmp_real_cell(cmp, x, y) ((x) cmp (int64_t)(y))
#define cmp_char_real(cmp, x, y) ((int64_t)(x) cmp (y))
#define cmp_char_char(cmp, x, y) ((x) cmp (y))
#define cmp_char_cmpx(cmp, x, y) ((x) cmp (y).real && 0 cmp (y).imag)
#define cmp_char_cell(cmp, x, y) ((x) cmp (uint64_t)(y))
#define cmp_cmpx_real(cmp, x, y) ((x).real cmp (y) && (x).imag cmp 0)
#define cmp_cmpx_char(cmp, x, y) ((x).real cmp (y) && (x).imag cmp 0)
#define cmp_cmpx_cmpx(cmp, x, y) ((x).real cmp (y).real && (x).imag cmp (y).imag)
#define cmp_cmpx_cell(cmp, x, y) ((x).real cmp (int64_t)(y) && (x).imag cmp 0)
#define cmp_cell_real(cmp, x, y) ((int64_t)(x) cmp (y))
#define cmp_cell_char(cmp, x, y) ((uint64_t)(x) cmp (y))
#define cmp_cell_cmpx(cmp, x, y) ((int64_t)(x) cmp (y).real && 0 cmp (y).imag)
#define cmp_cell_cell(cmp, x, y) ((x) cmp (y))

#define CMP_LOOP(op, lk, lt, ls, rk, rt, rs, fail) \
	DYADIC_SCALAR_LOOP(lt, rt, cmp_##lk##_##rk(op, x, y))

DEF_CMP_IBEAM(eql, af_eq, ==);
DEF_CMP_IBEAM(neq, af_neq, !=);
DEF_CMP_IBEAM(and, af_and, &&);
DEF_CMP_IBEAM(lor, af_or, ||);
DEF_CMP_IBEAM(lth, af_lt, <);
DEF_CMP_IBEAM(lte, af_le, <=);
DEF_CMP_IBEAM(gth, af_gt, >);
DEF_CMP_IBEAM(gte, af_ge, >=);

int
conjugate_values(struct cell_array *t, struct cell_array *r)
{
	int err;
	
	t->type = ARR_DBL;
	
	switch (r->storage) {
	case STG_DEVICE:
		CHKAF(af_conjg(&t->values, r->values), fail);
		break;
	case STG_HOST:
		size_t count;
		double *tv;
		
		CHKFN(alloc_array(t), fail);

		count = array_values_count(t);
		tv = t->values;
		
		MONADIC_SCALAR_LOOP(struct apl_cmpx, x.real);
		break;
	default:
		return 99;
	}

fail:
	return 0;
}

DEFN_MONADIC_SCALAR(conjugate)

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
	
	#define EXP_SWITCH_real(typ, sfx, fail) MONADIC_SWITCH(exp, double, typ)
	#define EXP_SWITCH_cmpx(typ, sfx, fail) MONADIC_SWITCH(exp_cmpx, typ, typ)
	#define EXP_SWITCH_char(typ, sfx, fail) BAD_ELEM(sfx, fail)
	#define EXP_SWITCH_cell(typ, sfx, fail) BAD_ELEM(sfx, fail)
	
	MONADIC_TYPE_SWITCH(r->type, HOST_SWITCH, EXP, done);
	
	err = 0;
	
done:
	return err;
}

DEFN_MONADIC_SCALAR(exp)

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
	
	#define NLG_SWITCH_real(typ, sfx, fail) MONADIC_SWITCH(log, double, typ)
	#define NLG_SWITCH_cmpx(typ, sfx, fail) MONADIC_SWITCH(nlg_cmpx, typ, typ)
	#define NLG_SWITCH_char(typ, sfx, fail) BAD_ELEM(sfx, fail)
	#define NLG_SWITCH_cell(typ, sfx, fail) BAD_ELEM(sfx, fail)
	
	MONADIC_TYPE_SWITCH(r->type, HOST_SWITCH, NLG, done);
	
	err = 0;
	
done:
	return err;
}

DEFN_MONADIC_SCALAR(nlg)

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
		
		double *tv = t->values;
	
		switch (r->type) {
		case ARR_DBL:
			MONADIC_SCALAR_LOOP(double, floor(x));
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

DEFN_MONADIC_SCALAR(floor)

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
		
		double *tv = t->values;
	
		switch (r->type) {
		case ARR_DBL:
			MONADIC_SCALAR_LOOP(double, ceil(x));
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

DEFN_MONADIC_SCALAR(ceil)

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
		
		int8_t *tv = t->values;
		
		MONADIC_SCALAR_LOOP(int8_t, !x);
		
		break;
	default:
		TRC(99, L"Unknown storage type");
	}
	
done:
	return err;
}

DEFN_MONADIC_SCALAR(not)

int
abs_values_device(struct cell_array *t, struct cell_array *r)
{
	int err;
	af_array tmp;
	
	tmp = NULL;
	
	CHKAF(af_abs(&tmp, r->values), fail);
	CHKAF(af_cast(&t->values, tmp, array_af_dtype(t)), fail);
	
fail:
	af_release_array(tmp);
	
	return err;
}

int
abs_values_host(struct cell_array *t, struct cell_array *r) 
{
	size_t count;
	int err;
	
	CHKFN(alloc_array(t), fail);
	
	count = array_values_count(t);
	
	#define ABS_SWITCH_real(typ, sfx, fail) MONADIC_SWITCH((typ)fabs, typ, typ)
	#define ABS_SWITCH_cmpx(typ, sfx, fail) BAD_ELEM(sfx, fail)
	#define ABS_SWITCH_char(typ, sfx, fail) BAD_ELEM(sfx, fail)
	#define ABS_SWITCH_cell(typ, sfx, fail) BAD_ELEM(sfx, fail)
	
	MONADIC_TYPE_SWITCH(r->type, HOST_SWITCH, ABS, fail);
	
fail:
	return err;
}

int
abs_values(struct cell_array *t, struct cell_array *r)
{
	int err;
	
	t->type = r->type;
	err = 0;
	
	switch (r->storage) {
	case STG_DEVICE:
		CHKFN(abs_values_device(t, r), fail);
		break;
	case STG_HOST:
		CHKFN(abs_values_host(t, r), fail);
		break;
	default:
		CHK(99, fail, L"Unknown storage type");
	}

fail:
	return err;
}
	
DEFN_MONADIC_SCALAR(abs)

int
factorial_values_device(struct cell_array *t, struct cell_array *r)
{
	af_array t64, t64_1, one;
	int err;
	
	t64 = t64_1 = one = NULL;
	
	CHKAF(af_cast(&t64, r->values, f64), fail);
	
	if (is_integer_array(r)) {
		CHKAF(af_factorial(&t->values, t64), fail);
	} else {
		dim_t d;
		
		CHKAF(af_get_elements(&d, t64), fail);
		CHKAF(af_constant(&one, 1, 1, &d, f64), fail);
		CHKAF(af_add(&t64_1, t64, one, 0), fail);
		CHKAF(af_tgamma(&t->values, t64_1), fail);
	}
	
fail:
	af_release_array(t64);
	af_release_array(t64_1);
	af_release_array(one);
	
	return err;
}


int
factorial_values_host(struct cell_array *t, struct cell_array *r)
{
	double *tv;
	size_t count;
	int err;
	
	CHKFN(alloc_array(t), fail);
	
	count = array_values_count(t);
	tv = t->values;
	
	#define fac_gamma(x) tgamma(x+1)
	
	#define FAC_SWITCH_real(typ, sfx, fail) MONADIC_SWITCH(fac_gamma, double, typ)
	#define FAC_SWITCH_cmpx(typ, sfx, fail) BAD_ELEM(sfx, fail)
	#define FAC_SWITCH_char(typ, sfx, fail) BAD_ELEM(sfx, fail)
	#define FAC_SWITCH_cell(typ, sfx, fail) BAD_ELEM(sfx, fail)
	
	MONADIC_TYPE_SWITCH(r->type, HOST_SWITCH, FAC, fail);

fail:
	return err;
}

int
factorial_values(struct cell_array *t, struct cell_array *r)
{
	int err;
	
	if (!is_real_array(r))
		CHK(16, fail, L"Complex gamma not implemented yet.");
	
	t->type = ARR_DBL;
	
	switch (r->storage) {
	case STG_DEVICE:
		CHKFN(factorial_values_device(t, r), fail);
		break;
	case STG_HOST:
		CHKFN(factorial_values_host(t, r), fail);
		break;
	default:
		CHK(99, fail, L"Unknown storage type");
	}

fail:
	return err;
}

DEFN_MONADIC_SCALAR(factorial)

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
		
		double *tv = t->values;
		
		MONADIC_SCALAR_LOOP(struct apl_cmpx, x.imag);

		break;
	default:
		TRC(99, L"Unknown storage type");
	}
	
done:
	return err;
}

DEFN_MONADIC_SCALAR(imagpart)

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
		
		double *tv = t->values;
		
		MONADIC_SCALAR_LOOP(struct apl_cmpx, x.real);

		break;
	default:
		TRC(99, L"Unknown storage type");
	}
	
done:
	return err;
}

DEFN_MONADIC_SCALAR(realpart)

#define TRIG_LOOP_real(oper, typ, sfx, fail) MONADIC_SCALAR_LOOP(typ, oper(x))
#define TRIG_LOOP_cmpx(oper, typ, sfx, fail) BAD_ELEM(sfx, fail)
#define TRIG_LOOP_char(oper, typ, sfx, fail) BAD_ELEM(sfx, fail)
#define TRIG_LOOP_cell(oper, typ, sfx, fail) BAD_ELEM(sfx, fail)
#define TRIG_LOOP(oper, knd, typ, sfx, fail) TRIG_LOOP_##knd(oper, typ, #sfx, fail)

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
		double *tv = t->values;					\
									\
		MONADIC_TYPE_SWITCH(r->type, TRIG_LOOP, stdc_fun, done);\
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
DECL_FUNC(name##_vec_ibeam, name##_func, error_dya_syntax)		\

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

int
roll_func(struct cell_array **z, struct cell_array *r, struct cell_func *self)
{
	struct cell_array *arr;
	af_random_engine engine;
	dim_t count;
	int err;
	
	CHKFN(mk_array(&arr, ARR_DBL, STG_DEVICE, r->rank), fail);
	
	for (unsigned int i = 0; i < r->rank; i++)
		arr->shape[i] = r->shape[i];
	
	count = array_values_count(arr);
	
	CHKAF(af_get_default_random_engine(&engine), fail);
	CHKAF(af_random_uniform(&arr->values, 1, &count, f64, engine), fail);

	*z = arr;
	
fail:
	if (err)
		release_array(arr);
	
	return err;
}

DECL_FUNC(roll_ibeam, roll_func, error_dya_syntax)

int
where_nz_func(struct cell_array **z, struct cell_array *r, struct cell_func *self)
{
	struct cell_array *arr;
	int err;
	
	arr = NULL;
	
	switch (r->storage) {
	case STG_DEVICE:{
		af_array res, res32;
		dim_t elems;
		
		CHKAF(af_where(&res, r->values), done);
		CHKAF(af_cast(&res32, res, s32), af_done);
		CHKAF(af_get_elements(&elems, res32), af_done);		
		CHKFN(mk_array(&arr, ARR_INT, STG_DEVICE, 1), af_done);
		
		arr->shape[0] = elems;
		arr->values = res32;
		
		if (!elems) {
			dim_t sp[1] = {1};
			
			CHKAF(af_release_array(res32), af_done);
			CHKAF(af_constant(&arr->values, 0, 1, sp, s32), af_done);
		}
		
af_done:
		int err2 = err;
		
		TRCAF(af_release_array(res));
		
		err = err2;
		
		break;
	}
	case STG_HOST:{
		size_t nzcnt, count;
		int32_t *tv;
		
		count = array_count(r);
		nzcnt = 0;
		
		#define WHRCNT_SWITCH_real(typ, sfx, fail) {	\
			typ *rv = r->values;			\
								\
			for (size_t i = 0; i < count; i++)	\
				if (rv[i])			\
					nzcnt += 1;		\
		}
		#define WHRCNT_SWITCH_cmpx(typ, sfx, fail) BAD_ELEM(sfx, fail)
		#define WHRCNT_SWITCH_char(typ, sfx, fail) BAD_ELEM(sfx, fail)
		#define WHRCNT_SWITCH_cell(typ, sfx, fail) BAD_ELEM(sfx, fail)
		
		MONADIC_TYPE_SWITCH(r->type, HOST_SWITCH, WHRCNT, done);
		
		CHKFN(mk_array(&arr, ARR_INT, STG_HOST, 1), done);
		
		arr->shape[0] = nzcnt;
		
		CHKFN(alloc_array(arr), done);
		
		tv = arr->values;
		
		if (!nzcnt) {
			*tv = 0;
			break;
		}
		
		#define WHERE_SWITCH_real(typ, sfx, fail) {	\
			typ *rv = r->values;			\
								\
			for (size_t i = 0; i < count; i++)	\
				if (rv[i])			\
					*tv++ = (int32_t)i;	\
		}
		#define WHERE_SWITCH_cmpx(typ, sfx, fail) BAD_ELEM(sfx, fail)
		#define WHERE_SWITCH_char(typ, sfx, fail) BAD_ELEM(sfx, fail)
		#define WHERE_SWITCH_cell(typ, sfx, fail) BAD_ELEM(sfx, fail)
		
		MONADIC_TYPE_SWITCH(r->type, HOST_SWITCH, WHERE, done);
		
		break;
	}
	default:
		CHK(99, done, L"Unknown storage type");
	}
	
	if (!err)
		*z = arr;

done:
	if (err)
		release_array(arr);
	
	return err;
}

DECL_FUNC(where_nz_ibeam, where_nz_func, error_dya_syntax)

int
grade_vec(int up, struct cell_array **z, 
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	struct cell_array *arr;
	af_array iv, mt, lv, rv;
	int err;

	err = 0;
	arr = NULL;
	mt = lv = rv = iv = NULL;
	
	CHKFN(array_migrate_storage(l, STG_DEVICE), fail);
	CHKFN(array_migrate_storage(r, STG_DEVICE), fail);

	lv = l->values;
	rv = r->values;

	CHKAF(af_sort_by_key(&mt, &iv, lv, rv, 0, up), fail);
	
	CHKFN(mk_array(&arr, r->type, STG_DEVICE, 1), fail);
	
	arr->shape[0] = r->shape[0];
	arr->values = iv;
	*z = arr;
	
fail:
	af_release_array(mt);

	if (err) {
		release_array(arr);
		af_release_array(iv);
	}

	return err;
}

int
gradedown_vec_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	return grade_vec(0, z, l, r, self);
}

DECL_FUNC(gradedown_vec_ibeam, error_mon_syntax, gradedown_vec_func)

int
gradeup_vec_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	return grade_vec(1, z, l, r, self);
}

DECL_FUNC(gradeup_vec_ibeam, error_mon_syntax, gradeup_vec_func)

int
matrix_inverse_func(struct cell_array **z, struct cell_array *r, 
    struct cell_func *self)
{
	struct cell_array *tgt;
	af_array arr;
	dim_t shp[2];
	int err;
	
	arr = NULL;
	tgt = NULL;
	
	shp[0] = r->shape[1];
	shp[1] = r->shape[0];
	
	CHKFN(array_migrate_storage(r, STG_DEVICE), fail);
	
	CHKAF(af_moddims(&arr, r->values, 2, shp), fail);
	CHKAF(af_inverse(&arr, arr, AF_MAT_NONE), fail);
	/* CHKAF(af_release_array(arr), fail); */
	CHKAF(af_flat(&arr, arr), fail);
	/* CHKAF(af_release_array(arr), fail); */
	
	CHKFN(mk_array(&tgt, ARR_DBL, STG_DEVICE, 2), fail);
	
	tgt->shape[0] = r->shape[0];
	tgt->shape[1] = r->shape[1];
	tgt->values = arr;
	
	*z = tgt;
	
fail:
	if (err) {
		af_release_array(arr);
		release_array(tgt);
	}
	
	return err;
}

DECL_FUNC(matrix_inverse_ibeam, matrix_inverse_func, error_dya_syntax)

int
count_vec_func(struct cell_array **z, struct cell_array *r, 
    struct cell_func *self)
{
	double sum, mt;
	int err;
		
	switch (r->storage) {
	case STG_DEVICE:{
		CHKAF(af_count_all(&sum, &mt, r->values), fail);
	}break;
	case STG_HOST:{
		size_t count, accum;
		int8_t *vals;
		
		count = array_count(r);
		vals = r->values;
		accum = 0;
		
		for (size_t i = 0; i < count; i++)
			accum += vals[i];
		
		sum = (double)accum;
	}break;
	default:
		CHK(99, fail, L"Unknown storage device");
	}
	
	return mk_array_real(z, sum);
	
fail:
	return err;
}

DECL_FUNC(count_vec, count_vec_func, error_dya_syntax)

int
sum_vec_func(struct cell_array **z, struct cell_array *r, 
    struct cell_func *self)
{
	double real, imag;
	int err;
		
	switch (r->storage) {
	case STG_DEVICE:{
		CHKAF(af_sum_all(&real, &imag, r->values), fail);
	}break;
	case STG_HOST:{
		size_t count;
		
		real = imag = 0;
		count = array_count(r);
		
		switch (r->type) {
		case ARR_SINT:{
			int16_t *vals = r->values;
			
			for (size_t i = 0; i < count; i++)
				real += vals[i];
		}break;
		case ARR_INT:{
			int32_t *vals = r->values;
			
			for (size_t i = 0; i < count; i++)
				real += vals[i];
		}break;
		case ARR_DBL:{
			double *vals = r->values;
			
			for (size_t i = 0; i < count; i++)
				real += vals[i];
		}break;
		case ARR_CMPX:{
			struct apl_cmpx accum = {real, imag};
			struct apl_cmpx *vals = r->values;
			
			for (size_t i = 0; i < count; i++)
				accum = add_cmpx(accum, vals[i]);
			
			real = accum.real;
			imag = accum.imag;
		}break;
		default:
			CHK(99, fail, L"Unexpected array type");
		}
	}break;
	default:
		CHK(99, fail, L"Unknown storage device");
	}
	
	if (r->type == ARR_CMPX) {
		struct apl_cmpx val = {real, imag};
		return mk_array_cmpx(z, val);
	}
	
	return mk_array_real(z, real);
	
fail:
	return err;
}

DECL_FUNC(sum_vec, sum_vec_func, error_dya_syntax)

int
product_vec_func(struct cell_array **z, struct cell_array *r, 
    struct cell_func *self)
{
	double real, imag;
	int err;
		
	switch (r->storage) {
	case STG_DEVICE:{
		af_array vals;
		af_dtype dtype;
		
		dtype = r->type == ARR_CMPX ? c64 : f64;
		
		CHKAF(af_cast(&vals, r->values, dtype), fail);
		CHKAF(af_product_all(&real, &imag, vals), device_fail);
		CHKAF(af_release_array(vals), fail);
		
		break;
		
	device_fail:
		af_release_array(vals);
		goto fail;
	}break;
	case STG_HOST:{
		size_t count;
		
		real = 1; imag = 0;
		count = array_count(r);
		
		switch (r->type) {
		case ARR_SINT:{
			int16_t *vals = r->values;
			
			for (size_t i = 0; i < count; i++)
				real *= vals[i];
		}break;
		case ARR_INT:{
			int32_t *vals = r->values;
			
			for (size_t i = 0; i < count; i++)
				real *= vals[i];
		}break;
		case ARR_DBL:{
			double *vals = r->values;
			
			for (size_t i = 0; i < count; i++)
				real *= vals[i];
		}break;
		case ARR_CMPX:{
			struct apl_cmpx accum = {real, imag};
			struct apl_cmpx *vals = r->values;
			
			for (size_t i = 0; i < count; i++)
				accum = mul_cmpx(accum, vals[i]);
			
			real = accum.real;
			imag = accum.imag;
		}break;
		default:
			CHK(99, fail, L"Unexpected array type");
		}
	}break;
	default:
		CHK(99, fail, L"Unknown storage device");
	}
	
	if (r->type == ARR_CMPX) {
		struct apl_cmpx val = {real, imag};
		return mk_array_cmpx(z, val);
	}
	
	return mk_array_real(z, real);
	
fail:
	return err;
}

DECL_FUNC(product_vec, product_vec_func, error_dya_syntax)

int
min_vec_func(struct cell_array **z, struct cell_array *r, 
    struct cell_func *self)
{
	double real, imag;
	int err;
		
	switch (r->storage) {
	case STG_DEVICE:{
		CHKAF(af_min_all(&real, &imag, r->values), fail);
	}break;
	case STG_HOST:{
		size_t count;
		
		real = imag = DBL_MAX;
		count = array_count(r);
		
		switch (r->type) {
		case ARR_SINT:{
			int16_t *vals = r->values;
			
			for (size_t i = 0; i < count; i++)
				real = min_real(real, vals[i]);
		}break;
		case ARR_INT:{
			int32_t *vals = r->values;
			
			for (size_t i = 0; i < count; i++)
				real = min_real(real, vals[i]);
		}break;
		case ARR_DBL:{
			double *vals = r->values;
			
			for (size_t i = 0; i < count; i++)
				real = min_real(real, vals[i]);
		}break;
		default:
			CHK(99, fail, L"Unexpected array type");
		}
	}break;
	default:
		CHK(99, fail, L"Unknown storage device");
	}
	
	return mk_array_real(z, real);
	
fail:
	return err;
}

DECL_FUNC(min_vec, min_vec_func, error_dya_syntax)

int
max_vec_func(struct cell_array **z, struct cell_array *r, 
    struct cell_func *self)
{
	double real, imag;
	int err;
	
	switch (r->storage) {
	case STG_DEVICE:{
		CHKAF(af_max_all(&real, &imag, r->values), fail);
	}break;
	case STG_HOST:{
		size_t count;
		
		real = imag = DBL_MIN;
		count = array_count(r);
		
		switch (r->type) {
		case ARR_SINT:{
			int16_t *vals = r->values;
			
			for (size_t i = 0; i < count; i++)
				real = max_real(real, vals[i]);
		}break;
		case ARR_INT:{
			int32_t *vals = r->values;
			
			for (size_t i = 0; i < count; i++)
				real = max_real(real, vals[i]);
		}break;
		case ARR_DBL:{
			double *vals = r->values;
			
			for (size_t i = 0; i < count; i++)
				real = max_real(real, vals[i]);
		}break;
		default:
			CHK(99, fail, L"Unexpected array type");
		}
	}break;
	default:
		CHK(99, fail, L"Unknown storage device");
	}
	
	return mk_array_real(z, real);
	
fail:
	return err;
}

DECL_FUNC(max_vec, max_vec_func, error_dya_syntax)

int
all_true_vec_func(struct cell_array **z, struct cell_array *r, 
    struct cell_func *self)
{
	int8_t result;
	int err;
	
	switch (r->storage) {
	case STG_DEVICE:{
		double real, imag;
				
		CHKAF(af_all_true_all(&real, &imag, r->values), fail);
		
		result = (int8_t)real;
	}break;
	case STG_HOST:{
		size_t count;
		int8_t *vals;
		
		count = array_count(r);
		vals = r->values;
		result = 1;
		
		for (size_t i = 0; i < count; i++) {
			if (!vals[i]) {
				result = 0;
				break;
			}
		}
	}break;
	default:
		CHK(99, fail, L"Unknown storage device");
	}
	
	return mk_array_int8(z, result);
	
fail:
	return err;
}

DECL_FUNC(all_true_vec, all_true_vec_func, error_dya_syntax)

int
any_true_vec_func(struct cell_array **z, struct cell_array *r, 
    struct cell_func *self)
{
	int8_t result;
	int err;
	
	switch (r->storage) {
	case STG_DEVICE:{
		double real, imag;
				
		CHKAF(af_any_true_all(&real, &imag, r->values), fail);
		
		result = (int8_t)real;
	}break;
	case STG_HOST:{
		size_t count;
		int8_t *vals;
		
		count = array_count(r);
		vals = r->values;
		result = 0;
		
		for (size_t i = 0; i < count; i++) {
			if (vals[i]) {
				result = 1;
				break;
			}
		}
	}break;
	default:
		CHK(99, fail, L"Unknown storage device");
	}
	
	return mk_array_int8(z, result);
	
fail:
	return err;
}

DECL_FUNC(any_true_vec, any_true_vec_func, error_dya_syntax)

int
count_array_func(struct cell_array **z, struct cell_array *r,
    struct cell_func *self)
{
	struct cell_array *arr;
	int err;
	
	arr = NULL;
	
	switch (r->storage) {
	case STG_DEVICE:{
		dim_t sp[3] = {r->shape[2], r->shape[1], r->shape[0]};
		af_array vals;
					
		CHKFN(mk_array(&arr, ARR_DBL, STG_DEVICE, 1), fail);
		
		arr->shape[0] = r->shape[0] * r->shape[2];
		
		vals = r->values;
		CHKAF(af_moddims(&arr->values, vals, 3, sp), fail);
		
		vals = arr->values;
		CHKAF(af_count(&arr->values, vals, 1), fail);
		CHKAF(af_release_array(vals), fail);
		
		vals = arr->values;
		CHKAF(af_cast(&arr->values, vals, f64), fail);
		CHKAF(af_release_array(vals), fail);
		
		vals = arr->values;
		CHKAF(af_flat(&arr->values, vals), fail);
		CHKAF(af_release_array(vals), fail);
	}break;
	case STG_HOST:{
		size_t sc, sr, lc, rc;
		int8_t *vals;
		
		vals = r->values;
		lc = r->shape[0];
		sc = r->shape[1];
		rc = r->shape[2];
		sr = sc * rc;
		
		#define COUNT_ARRAY_LOOP(ct, at) {			\
			ct *tgt;					\
									\
			CHKFN(mk_array(&arr, at, STG_HOST, 1), fail);	\
									\
			arr->shape[0] = lc * rc;			\
									\
			CHKFN(alloc_array(arr), fail);			\
									\
			tgt = arr->values;				\
									\
			for (size_t i = 0; i < lc; i++) {		\
				for (size_t j = 0; j < rc; j++) {	\
					ct x = 0;			\
									\
					for (size_t k = 0; k < sc; k++)	\
						x += vals[i*sr+k*rc+j];	\
									\
					tgt[i*rc+j] = x;		\
				}					\
			}						\
		}
		
		if (sc <= INT16_MAX)
			COUNT_ARRAY_LOOP(int16_t, ARR_SINT)
		else if (sc <= INT32_MAX)
			COUNT_ARRAY_LOOP(int32_t, ARR_INT)
		else
			COUNT_ARRAY_LOOP(double, ARR_DBL)
	}break;
	default:
		CHK(99, fail, L"Unknown storage type");
	}
	
	*z = arr;
	
fail:
	if (err)
		release_array(arr);
	
	return err;
}

DECL_FUNC(count_array, count_array_func, error_dya_syntax)

int
sum_array_func(struct cell_array **z, struct cell_array *r,
    struct cell_func *self)
{
	struct cell_array *arr;
	enum array_type type;
	int err;
	
	arr = NULL;
	
	switch (r->storage) {
	case STG_DEVICE:{
		dim_t sp[3] = {r->shape[2], r->shape[1], r->shape[0]};
		af_array vals;
		af_dtype dtype;
		
		type = ARR_DBL; dtype = f64;
		
		if (r->type == ARR_CMPX) {
			type = ARR_CMPX; dtype = c64;
		}
			
		CHKFN(mk_array(&arr, type, STG_DEVICE, 1), fail);

		arr->shape[0] = r->shape[0] * r->shape[2];
		
		vals = r->values;
		CHKAF(af_moddims(&arr->values, vals, 3, sp), fail);
		
		vals = arr->values;
		CHKAF(af_cast(&arr->values, vals, dtype), fail);
		CHKAF(af_release_array(vals), fail);
		
		vals = arr->values;
		CHKAF(af_sum(&arr->values, vals, 1), fail);
		CHKAF(af_release_array(vals), fail);
		
		vals = arr->values;
		CHKAF(af_flat(&arr->values, vals), fail);
		CHKAF(af_release_array(vals), fail);
	}break;
	case STG_HOST:{
		size_t sc, sr, lc, rc;
		
		lc = r->shape[0];
		sc = r->shape[1];
		rc = r->shape[2];
		sr = sc * rc;
		
		#define SUM_ARRAY_LOOP(ct, at, st, init, sfx) {				\
			ct *tgt;							\
			st *vals;							\
											\
			CHKFN(mk_array(&arr, at, STG_HOST, 1), fail);			\
											\
			arr->shape[0] = lc * rc;					\
											\
			CHKFN(alloc_array(arr), fail);					\
											\
			vals = r->values;						\
			tgt = arr->values;						\
											\
			for (size_t i = 0; i < lc; i++) {				\
				for (size_t j = 0; j < rc; j++) {			\
					ct x = init;					\
											\
					for (size_t k = 0; k < sc; k++)			\
						x = add_##sfx(x, vals[i*sr+k*rc+j]);	\
											\
					tgt[i*rc+j] = x;				\
				}							\
			}								\
		}
		
		switch (r->type) {
		case ARR_SINT:
			SUM_ARRAY_LOOP(int32_t, ARR_INT, int16_t, 0, real);break;
		case ARR_INT:
			SUM_ARRAY_LOOP(double, ARR_DBL, int32_t, 0, real);break;
		case ARR_DBL:
			SUM_ARRAY_LOOP(double, ARR_DBL, double, 0, real);break;
		case ARR_CMPX:
			#define MT_CMPX {0, 0}
			SUM_ARRAY_LOOP(struct apl_cmpx, ARR_CMPX, 
			    struct apl_cmpx, MT_CMPX, cmpx);break;
		default:
			CHK(99, fail, L"Unexpected array type");
		}
	}break;
	default:
		CHK(99, fail, L"Unknown storage type");
	}
	
	*z = arr;
	
fail:
	if (err)
		release_array(arr);
	
	return err;
}

DECL_FUNC(sum_array, sum_array_func, error_dya_syntax)

int
product_array_func(struct cell_array **z, struct cell_array *r,
    struct cell_func *self)
{
	struct cell_array *arr;
	enum array_type type;
	int err;
	
	arr = NULL;
	
	switch (r->storage) {
	case STG_DEVICE:{
		dim_t sp[3] = {r->shape[2], r->shape[1], r->shape[0]};
		af_array vals;
		af_dtype dtype;
		
		type = ARR_DBL; dtype = f64;
		
		if (r->type == ARR_CMPX) {
			type = ARR_CMPX; dtype = c64;
		}
			
		CHKFN(mk_array(&arr, type, STG_DEVICE, 1), fail);

		arr->shape[0] = r->shape[0] * r->shape[2];
		
		vals = r->values;
		CHKAF(af_moddims(&arr->values, vals, 3, sp), fail);
		
		vals = arr->values;
		CHKAF(af_cast(&arr->values, vals, dtype), fail);
		CHKAF(af_release_array(vals), fail);
		
		vals = arr->values;
		CHKAF(af_product(&arr->values, vals, 1), fail);
		CHKAF(af_release_array(vals), fail);
		
		vals = arr->values;
		CHKAF(af_flat(&arr->values, vals), fail);
		CHKAF(af_release_array(vals), fail);
	}break;
	case STG_HOST:{
		size_t sc, sr, lc, rc;
		
		lc = r->shape[0];
		sc = r->shape[1];
		rc = r->shape[2];
		sr = sc * rc;
		
		#define PRODUCT_ARRAY_LOOP(ct, at, st, init, sfx) {				\
			ct *tgt;							\
			st *vals;							\
											\
			CHKFN(mk_array(&arr, at, STG_HOST, 1), fail);			\
											\
			arr->shape[0] = lc * rc;					\
											\
			CHKFN(alloc_array(arr), fail);					\
											\
			vals = r->values;						\
			tgt = arr->values;						\
											\
			for (size_t i = 0; i < lc; i++) {				\
				for (size_t j = 0; j < rc; j++) {			\
					ct x = init;					\
											\
					for (size_t k = 0; k < sc; k++)			\
						x = mul_##sfx(x, vals[i*sr+k*rc+j]);	\
											\
					tgt[i*rc+j] = x;				\
				}							\
			}								\
		}
		
		switch (r->type) {
		case ARR_SINT:
			PRODUCT_ARRAY_LOOP(double, ARR_DBL, int16_t, 1, real);break;
		case ARR_INT:
			PRODUCT_ARRAY_LOOP(double, ARR_DBL, int32_t, 1, real);break;
		case ARR_DBL:
			PRODUCT_ARRAY_LOOP(double, ARR_DBL, double, 1, real);break;
		case ARR_CMPX:
			PRODUCT_ARRAY_LOOP(struct apl_cmpx, ARR_CMPX, 
			    struct apl_cmpx, MT_CMPX, cmpx);break;
		default:
			CHK(99, fail, L"Unexpected array type");
		}
	}break;
	default:
		CHK(99, fail, L"Unknown storage type");
	}
	
	*z = arr;
	
fail:
	if (err)
		release_array(arr);
	
	return err;
}

DECL_FUNC(product_array, product_array_func, error_dya_syntax)

int
all_true_array_func(struct cell_array **z, struct cell_array *r,
    struct cell_func *self)
{
	struct cell_array *arr;
	int err;
	
	arr = NULL;
	
	switch (r->storage) {
	case STG_DEVICE:{
		dim_t sp[3] = {r->shape[2], r->shape[1], r->shape[0]};
		af_array vals;
					
		CHKFN(mk_array(&arr, ARR_BOOL, STG_DEVICE, 1), fail);
		
		arr->shape[0] = r->shape[0] * r->shape[2];
		
		vals = r->values;
		CHKAF(af_moddims(&arr->values, vals, 3, sp), fail);
		
		vals = arr->values;
		CHKAF(af_all_true(&arr->values, vals, 1), fail);
		CHKAF(af_release_array(vals), fail);
		
		vals = arr->values;
		CHKAF(af_flat(&arr->values, vals), fail);
		CHKAF(af_release_array(vals), fail);
	}break;
	case STG_HOST:{
		size_t sc, sr, lc, rc;
		int8_t *vals, *tgt;
		
		lc = r->shape[0];
		sc = r->shape[1];
		rc = r->shape[2];
		sr = sc * rc;
		
		CHKFN(mk_array(&arr, ARR_BOOL, STG_HOST, 1), fail);
		
		arr->shape[0] = lc * rc;
		
		CHKFN(alloc_array(arr), fail);
		
		vals = r->values;
		tgt = arr->values;
		
		for (size_t i = 0; i < lc; i++) {
			for (size_t j = 0; j < rc; j++) {
				int8_t x = 1;
				
				for (size_t k = 0; k < sc; k++)
					if (!vals[i*sr + k*rc + j]) {
						x = 0;
						break;
					}
					
				tgt[i*rc + j] = x;
			}
		}
	}break;
	default:
		CHK(99, fail, L"Unknown storage type");
	}
	
	*z = arr;
	
fail:
	if (err)
		release_array(arr);
	
	return err;
}

DECL_FUNC(all_true_array, all_true_array_func, error_dya_syntax)

int
any_true_array_func(struct cell_array **z, struct cell_array *r,
    struct cell_func *self)
{
	struct cell_array *arr;
	int err;
	
	arr = NULL;
	
	switch (r->storage) {
	case STG_DEVICE:{
		dim_t sp[3] = {r->shape[2], r->shape[1], r->shape[0]};
		af_array vals;
					
		CHKFN(mk_array(&arr, ARR_BOOL, STG_DEVICE, 1), fail);

		arr->shape[0] = r->shape[0] * r->shape[2];
		
		vals = r->values;
		CHKAF(af_moddims(&arr->values, vals, 3, sp), fail);
		
		vals = arr->values;
		CHKAF(af_any_true(&arr->values, vals, 1), fail);
		CHKAF(af_release_array(vals), fail);
		
		vals = arr->values;
		CHKAF(af_flat(&arr->values, vals), fail);
		CHKAF(af_release_array(vals), fail);
	}break;
	case STG_HOST:{
		size_t sc, sr, lc, rc;
		int8_t *vals, *tgt;
		
		lc = r->shape[0];
		sc = r->shape[1];
		rc = r->shape[2];
		sr = sc * rc;
		
		CHKFN(mk_array(&arr, ARR_BOOL, STG_HOST, 1), fail);
		
		arr->shape[0] = lc * rc;
		
		CHKFN(alloc_array(arr), fail);
		
		vals = r->values;
		tgt = arr->values;
		
		for (size_t i = 0; i < lc; i++) {
			for (size_t j = 0; j < rc; j++) {
				int8_t x = 0;
				
				for (size_t k = 0; k < sc; k++)
					if (vals[i*sr + k*rc + j]) {
						x = 1;
						break;
					}
					
				tgt[i*rc + j] = x;
			}
		}
	}break;
	default:
		CHK(99, fail, L"Unknown storage type");
	}
	
	*z = arr;
	
fail:
	if (err)
		release_array(arr);
	
	return err;
}

DECL_FUNC(any_true_array, any_true_array_func, error_dya_syntax)

int
min_array_func(struct cell_array **z, struct cell_array *r,
    struct cell_func *self)
{
	struct cell_array *arr;
	int err;
	
	arr = NULL;
	
	switch (r->storage) {
	case STG_DEVICE:{
		dim_t sp[3] = {r->shape[2], r->shape[1], r->shape[0]};
		af_array vals;
		
		CHKFN(mk_array(&arr, r->type, STG_DEVICE, 1), fail);
		
		arr->shape[0] = r->shape[0] * r->shape[2];
	
		vals = r->values;
		CHKAF(af_moddims(&arr->values, vals, 3, sp), fail);
		
		vals = arr->values;
		CHKAF(af_min(&arr->values, vals, 1), fail);
		CHKAF(af_release_array(vals), fail);
		
		vals = arr->values;
		CHKAF(af_flat(&arr->values, vals), fail);
		CHKAF(af_release_array(vals), fail);
	}break;
	case STG_HOST:{
		size_t sc, sr, lc, rc;
		
		lc = r->shape[0];
		sc = r->shape[1];
		rc = r->shape[2];
		sr = sc * rc;
		
		#define MIN_ARRAY_LOOP(ct, at, init) {				\
			ct *tgt, *vals;							\
											\
			CHKFN(mk_array(&arr, at, STG_HOST, 1), fail);			\
											\
			arr->shape[0] = lc * rc;					\
											\
			CHKFN(alloc_array(arr), fail);					\
											\
			vals = r->values;						\
			tgt = arr->values;						\
											\
			for (size_t i = 0; i < lc; i++) {				\
				for (size_t j = 0; j < rc; j++) {			\
					ct x = init;					\
											\
					for (size_t k = 0; k < sc; k++)			\
						x = min_real(x, vals[i*sr+k*rc+j]);	\
											\
					tgt[i*rc+j] = x;				\
				}							\
			}								\
		}
		
		switch (r->type) {
		case ARR_SINT:
			MIN_ARRAY_LOOP(int16_t, ARR_SINT, INT16_MAX);break;
		case ARR_INT:
			MIN_ARRAY_LOOP(int32_t, ARR_INT, INT32_MAX);break;
		case ARR_DBL:
			MIN_ARRAY_LOOP(double, ARR_DBL, DBL_MAX);break;
		default:
			CHK(99, fail, L"Unexpected array type");
		}
	}break;
	default:
		CHK(99, fail, L"Unknown storage type");
	}
	
	*z = arr;
	
fail:
	if (err)
		release_array(arr);
	
	return err;
}

DECL_FUNC(min_array, min_array_func, error_dya_syntax)

int
max_array_func(struct cell_array **z, struct cell_array *r,
    struct cell_func *self)
{
	struct cell_array *arr;
	int err;
	
	arr = NULL;
	
	switch (r->storage) {
	case STG_DEVICE:{
		dim_t sp[3] = {r->shape[2], r->shape[1], r->shape[0]};
		af_array vals;
		
		CHKFN(mk_array(&arr, r->type, STG_DEVICE, 1), fail);
		
		arr->shape[0] = r->shape[0] * r->shape[2];
		
		vals = r->values;
		CHKAF(af_moddims(&arr->values, vals, 3, sp), fail);
		
		vals = arr->values;
		CHKAF(af_max(&arr->values, vals, 1), fail);
		CHKAF(af_release_array(vals), fail);
		
		vals = arr->values;
		CHKAF(af_flat(&arr->values, vals), fail);
		CHKAF(af_release_array(vals), fail);
	}break;
	case STG_HOST:{
		size_t sc, sr, lc, rc;
		
		lc = r->shape[0];
		sc = r->shape[1];
		rc = r->shape[2];
		sr = sc * rc;
		
		#define MAX_ARRAY_LOOP(ct, at, init) {				\
			ct *tgt, *vals;							\
											\
			CHKFN(mk_array(&arr, at, STG_HOST, 1), fail);			\
											\
			arr->shape[0] = lc * rc;					\
											\
			CHKFN(alloc_array(arr), fail);					\
											\
			vals = r->values;						\
			tgt = arr->values;						\
											\
			for (size_t i = 0; i < lc; i++) {				\
				for (size_t j = 0; j < rc; j++) {			\
					ct x = init;					\
											\
					for (size_t k = 0; k < sc; k++)			\
						x = max_real(x, vals[i*sr+k*rc+j]);	\
											\
					tgt[i*rc+j] = x;				\
				}							\
			}								\
		}
		
		switch (r->type) {
		case ARR_SINT:
			MAX_ARRAY_LOOP(int16_t, ARR_SINT, INT16_MIN);break;
		case ARR_INT:
			MAX_ARRAY_LOOP(int32_t, ARR_INT, INT32_MIN);break;
		case ARR_DBL:
			MAX_ARRAY_LOOP(double, ARR_DBL, DBL_MIN);break;
		default:
			CHK(99, fail, L"Unexpected array type");
		}
	}break;
	default:
		CHK(99, fail, L"Unknown storage type");
	}
	
	*z = arr;
	
fail:
	if (err)
		release_array(arr);
	
	return err;
}

DECL_FUNC(max_array, max_array_func, error_dya_syntax)

int
plus_scan_vec_func(struct cell_array **z, struct cell_array *r, 
    struct cell_func *self)
{
	struct cell_array *arr;
	int err;
	
	arr = NULL;
	
	switch (r->storage) {
	case STG_DEVICE:{
		size_t count;
		af_array vals;
		enum array_type type;
		af_dtype dtype;
		
		count = array_count(r);
		
		switch (r->type) {
		case ARR_BOOL:
			if (count <= INT32_MAX) {
				type = ARR_INT;
				dtype = s32; 
			} else {
				type = ARR_DBL;
				dtype = f64;
			}
			break;
		case ARR_SINT:
			if (count <= INT16_MAX) {
				type = ARR_INT;
				dtype = s32;
			} else {
				type = ARR_DBL;
				dtype = f64;
			}
			break;
		case ARR_INT:
			type = ARR_DBL;
			dtype = f64;
			break;
		case ARR_DBL:
			type = ARR_DBL;
			dtype = f64;
			break;
		case ARR_CMPX:
			type = ARR_CMPX;
			dtype = c64;
			break;
		default:
			CHK(99, fail, L"Unexpected array type");
		}
		
		CHKFN(mk_array(&arr, type, STG_DEVICE, 1), fail);
		
		arr->shape[0] = count;
		
		vals = r->values;
		CHKAF(af_cast(&arr->values, vals, dtype), fail);
		
		vals = arr->values;
		CHKAF(af_accum(&arr->values, vals, 0), fail);
		CHKAF(af_release_array(vals), fail);
	}break;
	case STG_HOST:{
		size_t count;
		
		count = array_count(r);
		
		#define PLUS_SCAN_VEC_LOOP(ct, at, st, sfx) {		\
			st *vals;                                       \
			ct *tgt;                                        \
									\
			CHKFN(mk_array(&arr, at, STG_HOST, 1), fail);   \
									\
			arr->shape[0] = count;				\
									\
			CHKFN(alloc_array(arr), fail);                  \
									\
			vals = r->values;                               \
			tgt = arr->values;                              \
									\
			*tgt = *vals;                                   \
									\
			for (size_t i = 1; i < count; i++)              \
				tgt[i] = add_##sfx(tgt[i-1], vals[i]);  \
		}
		
		switch (r->type) {
		case ARR_BOOL:PLUS_SCAN_VEC_LOOP(int16_t, ARR_SINT, int8_t, real);break;
		case ARR_SINT:PLUS_SCAN_VEC_LOOP(int32_t, ARR_INT, int16_t, real);break;
		case ARR_INT:PLUS_SCAN_VEC_LOOP(double, ARR_DBL, int32_t, real);break;
		case ARR_DBL:PLUS_SCAN_VEC_LOOP(double, ARR_DBL, double, real);break;
		case ARR_CMPX:
			PLUS_SCAN_VEC_LOOP(struct apl_cmpx, ARR_CMPX, 
			    struct apl_cmpx, cmpx);
			break;
		default:
			CHK(99, fail, L"Unexpected array type");
		}
	}break;
	default:
		CHK(99, fail, L"Unknown storage device");
	}
	
	*z = arr;
	
fail:
	if (err)
		release_array(arr);
	
	return err;
}

DECL_FUNC(plus_scan_vec, plus_scan_vec_func, error_dya_syntax)

int
plus_scan_array_func(struct cell_array **z, struct cell_array *r, 
    struct cell_func *self)
{
	struct cell_array *arr;
	int err;
	
	arr = NULL;
	
	switch (r->storage) {
	case STG_DEVICE:{
		size_t count;
		af_array vals;
		enum array_type type;
		af_dtype dtype;
		dim_t sp[3] = {r->shape[2], r->shape[1], r->shape[0]};
				
		count = array_count(r);
		
		switch (r->type) {
		case ARR_BOOL:
			if (count <= INT32_MAX) {
				type = ARR_INT;
				dtype = s32; 
			} else {
				type = ARR_DBL;
				dtype = f64;
			}
			break;
		case ARR_SINT:
			if (count <= INT16_MAX) {
				type = ARR_INT;
				dtype = s32;
			} else {
				type = ARR_DBL;
				dtype = f64;
			}
			break;
		case ARR_INT:
			type = ARR_DBL;
			dtype = f64;
			break;
		case ARR_DBL:
			type = ARR_DBL;
			dtype = f64;
			break;
		case ARR_CMPX:
			type = ARR_CMPX;
			dtype = c64;
			break;
		default:
			CHK(99, fail, L"Unexpected array type");
		}
		
		CHKFN(mk_array(&arr, type, STG_DEVICE, 1), fail);
		
		arr->shape[0] = count;
		
		vals = r->values;
		CHKAF(af_cast(&arr->values, vals, dtype), fail);
		
		vals = arr->values;
		CHKAF(af_moddims(&arr->values, vals, 3, sp), fail);
		CHKAF(af_release_array(vals), fail);
		
		vals = arr->values;
		CHKAF(af_accum(&arr->values, vals, 1), fail);
		CHKAF(af_release_array(vals), fail);
		
		vals = arr->values;
		CHKAF(af_flat(&arr->values, vals), fail);
		CHKAF(af_release_array(vals), fail);
	}break;
	case STG_HOST:{
		size_t count, lc, c, rc, cr;
		
		count = array_count(r);
		lc = r->shape[0];
		c = r->shape[1];
		rc = r->shape[2];
		cr = c * rc;
		
		#define PLUS_SCAN_ARRAY_LOOP(ct, at, st, sfx) {		\
			st *vals;                                       \
			ct *tgt;                                        \
									\
			CHKFN(mk_array(&arr, at, STG_HOST, 1), fail);   \
									\
			arr->shape[0] = count;				\
									\
			CHKFN(alloc_array(arr), fail);                  \
									\
			vals = r->values;                               \
			tgt = arr->values;                              \
									\
			for (size_t i = 0; i < lc; i++)			\
				for (size_t j = 0; j < rc; j++) {	\
					size_t ij = i*cr + j;		\
					tgt[ij] = vals[ij];		\
									\
					for (size_t k = 1; k < c; k++) {\
						size_t x_1, x;		\
									\
						x_1 = ij + (k-1)*rc;	\
						x = x_1 + rc;		\
									\
						tgt[x] = add_##sfx(	\
						    tgt[x_1], vals[x]	\
						);			\
					}				\
				}					\
		}
		
		switch (r->type) {
		case ARR_BOOL:PLUS_SCAN_ARRAY_LOOP(int16_t, ARR_SINT, int8_t, real);break;
		case ARR_SINT:PLUS_SCAN_ARRAY_LOOP(int32_t, ARR_INT, int16_t, real);break;
		case ARR_INT:PLUS_SCAN_ARRAY_LOOP(double, ARR_DBL, int32_t, real);break;
		case ARR_DBL:PLUS_SCAN_ARRAY_LOOP(double, ARR_DBL, double, real);break;
		case ARR_CMPX:
			PLUS_SCAN_ARRAY_LOOP(struct apl_cmpx, ARR_CMPX, 
			    struct apl_cmpx, cmpx);
			break;
		default:
			CHK(99, fail, L"Unexpected array type");
		}
	}break;
	default:
		CHK(99, fail, L"Unknown storage device");
	}
	
	*z = arr;
	
fail:
	if (err)
		release_array(arr);
	
	return err;
}

DECL_FUNC(plus_scan_array, plus_scan_array_func, error_dya_syntax)

int
times_scan_vec_func(struct cell_array **z, struct cell_array *r, 
    struct cell_func *self)
{
	struct cell_array *arr;
	int err;
	
	arr = NULL;
	
	switch (r->storage) {
	case STG_DEVICE:{
		size_t count;
		af_array vals;
		enum array_type type;
		af_dtype dtype;
		
		count = array_count(r);
		type = ARR_DBL;
		dtype = f64;
		
		if (r->type == ARR_CMPX) {
			type = ARR_CMPX;
			dtype = c64;
		}
		
		CHKFN(mk_array(&arr, type, STG_DEVICE, 1), fail);
		
		arr->shape[0] = count;
		
		vals = r->values;
		CHKAF(af_cast(&arr->values, vals, dtype), fail);
		
		vals = arr->values;
		CHKAF(af_scan(&arr->values, vals, 0, AF_BINARY_MUL, 1), fail);
		CHKAF(af_release_array(vals), fail);
	}break;
	case STG_HOST:{
		size_t count;
		
		count = array_count(r);
		
		#define TIMES_SCAN_VEC_LOOP(ct, at, st, sfx) {		\
			st *vals;                                       \
			ct *tgt;                                        \
									\
			CHKFN(mk_array(&arr, at, STG_HOST, 1), fail);   \
									\
			arr->shape[0] = count;				\
									\
			CHKFN(alloc_array(arr), fail);                  \
									\
			vals = r->values;                               \
			tgt = arr->values;                              \
									\
			*tgt = *vals;                                   \
									\
			for (size_t i = 1; i < count; i++)              \
				tgt[i] = mul_##sfx(tgt[i-1], vals[i]);  \
		}
		
		switch (r->type) {
		case ARR_BOOL:TIMES_SCAN_VEC_LOOP(double, ARR_DBL, int8_t, real);break;
		case ARR_SINT:TIMES_SCAN_VEC_LOOP(double, ARR_DBL, int16_t, real);break;
		case ARR_INT:TIMES_SCAN_VEC_LOOP(double, ARR_DBL, int32_t, real);break;
		case ARR_DBL:TIMES_SCAN_VEC_LOOP(double, ARR_DBL, double, real);break;
		case ARR_CMPX:
			TIMES_SCAN_VEC_LOOP(struct apl_cmpx, ARR_CMPX, 
			    struct apl_cmpx, cmpx);
			break;
		default:
			CHK(99, fail, L"Unexpected array type");
		}
	}break;
	default:
		CHK(99, fail, L"Unknown storage device");
	}
	
	*z = arr;
	
fail:
	if (err)
		release_array(arr);
	
	return err;
}

DECL_FUNC(times_scan_vec, times_scan_vec_func, error_dya_syntax)

int
times_scan_array_func(struct cell_array **z, struct cell_array *r, 
    struct cell_func *self)
{
	struct cell_array *arr;
	int err;
	
	arr = NULL;
	
	switch (r->storage) {
	case STG_DEVICE:{
		size_t count;
		af_array vals;
		enum array_type type;
		af_dtype dtype;
		dim_t sp[3] = {r->shape[2], r->shape[1], r->shape[0]};
				
		count = array_count(r);
		type = ARR_DBL;
		dtype = f64;
		
		if (r->type == ARR_CMPX) {
			type = ARR_CMPX;
			dtype = c64;
		}
		
		CHKFN(mk_array(&arr, type, STG_DEVICE, 1), fail);
		
		arr->shape[0] = count;
		
		vals = r->values;
		CHKAF(af_cast(&arr->values, vals, dtype), fail);
		
		vals = arr->values;
		CHKAF(af_moddims(&arr->values, vals, 3, sp), fail);
		CHKAF(af_release_array(vals), fail);
		
		vals = arr->values;
		CHKAF(af_scan(&arr->values, vals, 1, AF_BINARY_MUL, 1), fail);
		CHKAF(af_release_array(vals), fail);
	}break;
	case STG_HOST:{
		size_t count, lc, c, rc, cr;
		
		count = array_count(r);
		lc = r->shape[0];
		c = r->shape[1];
		rc = r->shape[2];
		cr = c * rc;
		
		#define TIMES_SCAN_ARRAY_LOOP(ct, at, st, sfx) {		\
			st *vals;                                       \
			ct *tgt;                                        \
									\
			CHKFN(mk_array(&arr, at, STG_HOST, 1), fail);   \
									\
			arr->shape[0] = count;				\
									\
			CHKFN(alloc_array(arr), fail);                  \
									\
			vals = r->values;                               \
			tgt = arr->values;                              \
									\
			for (size_t i = 0; i < lc; i++)			\
				for (size_t j = 0; j < rc; j++) {	\
					size_t ij = i*cr + j;		\
					tgt[ij] = vals[ij];		\
									\
					for (size_t k = 1; k < c; k++) {\
						size_t x_1, x;		\
									\
						x_1 = ij + (k-1)*rc;	\
						x = x_1 + rc;		\
									\
						tgt[x] = mul_##sfx(	\
						    tgt[x_1], vals[x]	\
						);			\
					}				\
				}					\
		}
		
		switch (r->type) {
		case ARR_BOOL:TIMES_SCAN_ARRAY_LOOP(double, ARR_DBL, int8_t, real);break;
		case ARR_SINT:TIMES_SCAN_ARRAY_LOOP(double, ARR_DBL, int16_t, real);break;
		case ARR_INT:TIMES_SCAN_ARRAY_LOOP(double, ARR_DBL, int32_t, real);break;
		case ARR_DBL:TIMES_SCAN_ARRAY_LOOP(double, ARR_DBL, double, real);break;
		case ARR_CMPX:
			TIMES_SCAN_ARRAY_LOOP(struct apl_cmpx, ARR_CMPX, 
			    struct apl_cmpx, cmpx);
			break;
		default:
			CHK(99, fail, L"Unexpected array type");
		}
	}break;
	default:
		CHK(99, fail, L"Unknown storage device");
	}
	
	*z = arr;
	
fail:
	if (err)
		release_array(arr);
	
	return err;
}

DECL_FUNC(times_scan_array, times_scan_array_func, error_dya_syntax)

#define min_bool(x, y) (x) && (y)

int
min_scan_vec_func(struct cell_array **z, struct cell_array *r, 
    struct cell_func *self)
{
	struct cell_array *arr;
	int err;
	
	arr = NULL;
	
	switch (r->storage) {
	case STG_DEVICE:{
		af_array vals;
		
		CHKFN(mk_array(&arr, r->type, STG_DEVICE, 1), fail);
		
		arr->shape[0] = array_count(r);
		
		vals = r->values;
		CHKAF(af_scan(&arr->values, vals, 0, AF_BINARY_MIN, 1), fail);
		
		vals = arr->values;
		CHKAF(af_cast(&arr->values, vals, array_af_dtype(r)), fail);
		CHKAF(af_release_array(vals), fail);
	}break;
	case STG_HOST:{
		size_t count;
		
		count = array_count(r);
		
		#define MIN_SCAN_VEC_LOOP(ct, at, sfx) {			\
			ct *vals, *tgt;					\
									\
			CHKFN(mk_array(&arr, at, STG_HOST, 1), fail);   \
									\
			arr->shape[0] = count;				\
									\
			CHKFN(alloc_array(arr), fail);			\
									\
			vals = r->values;                               \
			tgt = arr->values;                              \
									\
			*tgt = *vals;                                   \
									\
			for (size_t i = 1; i < count; i++)              \
				tgt[i] = min_##sfx(tgt[i-1], vals[i]);	\
		}
		
		switch (r->type) {
		case ARR_BOOL:MIN_SCAN_VEC_LOOP(int8_t, ARR_BOOL, bool);break;
		case ARR_SINT:MIN_SCAN_VEC_LOOP(int16_t, ARR_SINT, real);break;
		case ARR_INT:MIN_SCAN_VEC_LOOP(int32_t, ARR_INT, real);break;
		case ARR_DBL:MIN_SCAN_VEC_LOOP(double, ARR_DBL, real);break;
		default:
			CHK(99, fail, L"Unexpected array type");
		}
	}break;
	default:
		CHK(99, fail, L"Unknown storage device");
	}
	
	*z = arr;
	
fail:
	if (err)
		release_array(arr);
	
	return err;
}

DECL_FUNC(min_scan_vec, min_scan_vec_func, error_dya_syntax)

int
min_scan_array_func(struct cell_array **z, struct cell_array *r, 
    struct cell_func *self)
{
	struct cell_array *arr;
	int err;
	
	arr = NULL;
	
	switch (r->storage) {
	case STG_DEVICE:{
		af_array vals;
		dim_t sp[3] = {r->shape[2], r->shape[1], r->shape[0]};
						
		CHKFN(mk_array(&arr, r->type, STG_DEVICE, 1), fail);
		
		arr->shape[0] = array_count(r);
		
		vals = r->values;
		CHKAF(af_moddims(&arr->values, vals, 3, sp), fail);
		
		vals = arr->values;
		CHKAF(af_scan(&arr->values, vals, 1, AF_BINARY_MIN, 1), fail);
		CHKAF(af_release_array(vals), fail);
		
		vals = arr->values;
		CHKAF(af_cast(&arr->values, vals, array_af_dtype(r)), fail);
		CHKAF(af_release_array(vals), fail);
	}break;
	case STG_HOST:{
		size_t count, lc, c, rc, cr;
		
		count = array_count(r);
		lc = r->shape[0];
		c = r->shape[1];
		rc = r->shape[2];
		cr = c * rc;
		
		#define MIN_SCAN_ARRAY_LOOP(at, st, sfx) {		\
			st *vals, *tgt;					\
									\
			CHKFN(mk_array(&arr, at, STG_HOST, 1), fail);   \
									\
			arr->shape[0] = count;				\
									\
			CHKFN(alloc_array(arr), fail);                  \
									\
			vals = r->values;                               \
			tgt = arr->values;                              \
									\
			for (size_t i = 0; i < lc; i++)			\
				for (size_t j = 0; j < rc; j++) {	\
					size_t ij = i*cr + j;		\
					tgt[ij] = vals[ij];		\
									\
					for (size_t k = 1; k < c; k++) {\
						size_t x_1, x;		\
									\
						x_1 = ij + (k-1)*rc;	\
						x = x_1 + rc;		\
									\
						tgt[x] = min_##sfx(	\
						    tgt[x_1], vals[x]	\
						);			\
					}				\
				}					\
		}
		
		switch (r->type) {
		case ARR_BOOL:MIN_SCAN_ARRAY_LOOP(ARR_BOOL, int8_t, bool);break;
		case ARR_SINT:MIN_SCAN_ARRAY_LOOP(ARR_SINT, int16_t, real);break;
		case ARR_INT:MIN_SCAN_ARRAY_LOOP(ARR_INT, int32_t, real);break;
		case ARR_DBL:MIN_SCAN_ARRAY_LOOP(ARR_DBL, double, real);break;
		default:
			CHK(99, fail, L"Unexpected array type");
		}
	}break;
	default:
		CHK(99, fail, L"Unknown storage device");
	}
	
	*z = arr;
	
fail:
	if (err)
		release_array(arr);
	
	return err;
}

DECL_FUNC(min_scan_array, min_scan_array_func, error_dya_syntax)

#define max_bool(x, y) (x) || (y)

int
max_scan_vec_func(struct cell_array **z, struct cell_array *r, 
    struct cell_func *self)
{
	struct cell_array *arr;
	int err;
	
	arr = NULL;
	
	switch (r->storage) {
	case STG_DEVICE:{
		af_array vals;
		
		CHKFN(mk_array(&arr, r->type, STG_DEVICE, 1), fail);
		
		arr->shape[0] = array_count(r);
		
		vals = r->values;
		CHKAF(af_scan(&arr->values, vals, 0, AF_BINARY_MAX, 1), fail);
		
		vals = arr->values;
		CHKAF(af_cast(&arr->values, vals, array_af_dtype(r)), fail);
		CHKAF(af_release_array(vals), fail);
	}break;
	case STG_HOST:{
		size_t count;
		
		count = array_count(r);
		
		#define MAX_SCAN_VEC_LOOP(ct, at, sfx) {			\
			ct *vals, *tgt;					\
									\
			CHKFN(mk_array(&arr, at, STG_HOST, 1), fail);   \
									\
			arr->shape[0] = count;				\
									\
			CHKFN(alloc_array(arr), fail);			\
									\
			vals = r->values;                               \
			tgt = arr->values;                              \
									\
			*tgt = *vals;                                   \
									\
			for (size_t i = 1; i < count; i++)              \
				tgt[i] = max_##sfx(tgt[i-1], vals[i]);	\
		}
		
		switch (r->type) {
		case ARR_BOOL:MAX_SCAN_VEC_LOOP(int8_t, ARR_BOOL, bool);break;
		case ARR_SINT:MAX_SCAN_VEC_LOOP(int16_t, ARR_SINT, real);break;
		case ARR_INT:MAX_SCAN_VEC_LOOP(int32_t, ARR_INT, real);break;
		case ARR_DBL:MAX_SCAN_VEC_LOOP(double, ARR_DBL, real);break;
		default:
			CHK(99, fail, L"Unexpected array type");
		}
	}break;
	default:
		CHK(99, fail, L"Unknown storage device");
	}
	
	*z = arr;
	
fail:
	if (err)
		release_array(arr);
	
	return err;
}

DECL_FUNC(max_scan_vec, max_scan_vec_func, error_dya_syntax)

int
max_scan_array_func(struct cell_array **z, struct cell_array *r, 
    struct cell_func *self)
{
	struct cell_array *arr;
	int err;
	
	arr = NULL;
	
	switch (r->storage) {
	case STG_DEVICE:{
		af_array vals;
		dim_t sp[3] = {r->shape[2], r->shape[1], r->shape[0]};
						
		CHKFN(mk_array(&arr, r->type, STG_DEVICE, 1), fail);
		
		arr->shape[0] = array_count(r);
		
		vals = r->values;
		CHKAF(af_moddims(&arr->values, vals, 3, sp), fail);
		
		vals = arr->values;
		CHKAF(af_scan(&arr->values, vals, 1, AF_BINARY_MAX, 1), fail);
		CHKAF(af_release_array(vals), fail);
		
		vals = arr->values;
		CHKAF(af_cast(&arr->values, vals, array_af_dtype(r)), fail);
		CHKAF(af_release_array(vals), fail);
	}break;
	case STG_HOST:{
		size_t count, lc, c, rc, cr;
		
		count = array_count(r);
		lc = r->shape[0];
		c = r->shape[1];
		rc = r->shape[2];
		cr = c * rc;
		
		#define MAX_SCAN_ARRAY_LOOP(at, st, sfx) {		\
			st *vals, *tgt;					\
									\
			CHKFN(mk_array(&arr, at, STG_HOST, 1), fail);   \
									\
			arr->shape[0] = count;				\
									\
			CHKFN(alloc_array(arr), fail);                  \
									\
			vals = r->values;                               \
			tgt = arr->values;                              \
									\
			for (size_t i = 0; i < lc; i++)			\
				for (size_t j = 0; j < rc; j++) {	\
					size_t ij = i*cr + j;		\
					tgt[ij] = vals[ij];		\
									\
					for (size_t k = 1; k < c; k++) {\
						size_t x_1, x;		\
									\
						x_1 = ij + (k-1)*rc;	\
						x = x_1 + rc;		\
									\
						tgt[x] = max_##sfx(	\
						    tgt[x_1], vals[x]	\
						);			\
					}				\
				}					\
		}
		
		switch (r->type) {
		case ARR_BOOL:MAX_SCAN_ARRAY_LOOP(ARR_BOOL, int8_t, bool);break;
		case ARR_SINT:MAX_SCAN_ARRAY_LOOP(ARR_SINT, int16_t, real);break;
		case ARR_INT:MAX_SCAN_ARRAY_LOOP(ARR_INT, int32_t, real);break;
		case ARR_DBL:MAX_SCAN_ARRAY_LOOP(ARR_DBL, double, real);break;
		default:
			CHK(99, fail, L"Unexpected array type");
		}
	}break;
	default:
		CHK(99, fail, L"Unknown storage device");
	}
	
	*z = arr;
	
fail:
	if (err)
		release_array(arr);
	
	return err;
}

DECL_FUNC(max_scan_array, max_scan_array_func, error_dya_syntax)

int
dot_prod_func(struct cell_array **z, struct cell_array *l, struct cell_array *r,
    struct cell_func *self)
{
	size_t count;
	double real, imag;
	int err;
	
	count = array_count(l);
		
	CHKFN(array_promote_storage(l, r), fail);
	
	real = 0; imag = 0;
	
	switch (r->storage) {
	case STG_DEVICE:{
		af_array l64, r64;
		
		l64 = r64 = NULL;
		
		CHKAF(af_cast(&l64, l->values, f64), fail_device);
		CHKAF(af_cast(&r64, r->values, f64), fail_device);
		
		CHKAF(
		    af_dot_all(&real, &imag, l64, r64, AF_MAT_NONE, AF_MAT_NONE),
		    fail_device);
		    
	fail_device:
		af_release_array(l64);
		af_release_array(r64);
		
		if (err)
			goto fail;
	}break;
	case STG_HOST:{
		#define DOT_PROD_LOOP(lt, rt) {					\
			lt *lv;                                 		\
			rt *rv;                                 		\
										\
			lv = l->values;                         		\
			rv = r->values;                         		\
										\
			for (size_t i = 0; i < count; i++)      		\
				real += ((double)lv[i]) * ((double)rv[i]);	\
		}
		
		#define DOT_PROD_LOOP_CMPX(lt, rt, cl, cr) {		\
			lt *lv;                                         \
			rt *rv;                                         \
									\
			lv = l->values;                                 \
			rv = r->values;                                 \
									\
			struct apl_cmpx zv = {0, 0};                    \
									\
			for (size_t i = 0; i < count; i++)              \
				zv = add_cmpx(zv,                       \
				    mul_cmpx(cl(lv[i]), cr(rv[i])));	\
									\
			real = zv.real; imag = zv.imag;			\
		}
		
		switch (type_pair(l->type, r->type)) {
		case type_pair(ARR_BOOL, ARR_BOOL):DOT_PROD_LOOP(int8_t, int8_t);break;
		case type_pair(ARR_BOOL, ARR_SINT):DOT_PROD_LOOP(int8_t, int16_t);break;
		case type_pair(ARR_BOOL, ARR_INT): DOT_PROD_LOOP(int8_t, int32_t);break;
		case type_pair(ARR_BOOL, ARR_DBL): DOT_PROD_LOOP(int8_t, double);break;
		case type_pair(ARR_SINT, ARR_BOOL):DOT_PROD_LOOP(int16_t, int8_t);break;
		case type_pair(ARR_SINT, ARR_SINT):DOT_PROD_LOOP(int16_t, int16_t);break;
		case type_pair(ARR_SINT, ARR_INT): DOT_PROD_LOOP(int16_t, int32_t);break;
		case type_pair(ARR_SINT, ARR_DBL): DOT_PROD_LOOP(int16_t, double);break;
		case type_pair(ARR_INT , ARR_BOOL):DOT_PROD_LOOP(int32_t, int8_t);break;
		case type_pair(ARR_INT , ARR_SINT):DOT_PROD_LOOP(int32_t, int16_t);break;
		case type_pair(ARR_INT , ARR_INT): DOT_PROD_LOOP(int32_t, int32_t);break;
		case type_pair(ARR_INT , ARR_DBL): DOT_PROD_LOOP(int32_t, double);break;
		case type_pair(ARR_DBL , ARR_BOOL):DOT_PROD_LOOP(double, int8_t);break;
		case type_pair(ARR_DBL , ARR_SINT):DOT_PROD_LOOP(double, int16_t);break;
		case type_pair(ARR_DBL , ARR_INT): DOT_PROD_LOOP(double, int32_t);break;
		case type_pair(ARR_DBL , ARR_DBL): DOT_PROD_LOOP(double, double);break;
		case type_pair(ARR_BOOL, ARR_CMPX):
			DOT_PROD_LOOP_CMPX(int8_t, struct apl_cmpx, cast_cmpx, );
			break;
		case type_pair(ARR_SINT, ARR_CMPX):
			DOT_PROD_LOOP_CMPX(int16_t, struct apl_cmpx, cast_cmpx, );
			break;
		case type_pair(ARR_INT , ARR_CMPX):
			DOT_PROD_LOOP_CMPX(int32_t, struct apl_cmpx, cast_cmpx, );
			break;
		case type_pair(ARR_DBL , ARR_CMPX):
			DOT_PROD_LOOP_CMPX(double, struct apl_cmpx, cast_cmpx, );
			break;
		case type_pair(ARR_CMPX, ARR_BOOL):
			DOT_PROD_LOOP_CMPX(struct apl_cmpx, int8_t, , cast_cmpx);
			break;
		case type_pair(ARR_CMPX, ARR_SINT):
			DOT_PROD_LOOP_CMPX(struct apl_cmpx, int16_t, , cast_cmpx);
			break;
		case type_pair(ARR_CMPX, ARR_INT ):
			DOT_PROD_LOOP_CMPX(struct apl_cmpx, int32_t, , cast_cmpx);
			break;
		case type_pair(ARR_CMPX, ARR_DBL ):
			DOT_PROD_LOOP_CMPX(struct apl_cmpx, double, , cast_cmpx);
			break;
		case type_pair(ARR_CMPX, ARR_CMPX):
			DOT_PROD_LOOP_CMPX(struct apl_cmpx, struct apl_cmpx,,);
			break;
		default:
			CHK(99, fail, L"Unexpected non-numeric type");
		}
	}break;
	default:
		CHK(99, fail, L"Unexpected storage type");
	}
	
	if (!imag) {
		CHKFN(mk_array_real(z, real), fail);
	} else {
		struct apl_cmpx res = {real, imag};
		CHKFN(mk_array_cmpx(z, res), fail);
	}
	
fail:
	return err;
}

DECL_FUNC(dot_prod_ibeam, error_mon_syntax, dot_prod_func)

int
matmul_func(struct cell_array **z, struct cell_array *l, struct cell_array *r,
    struct cell_func *self)
{
	struct cell_array *arr;
	size_t lm, lrk, rm;
	enum array_type type;
	int err;

	lm = l->shape[0];
	lrk = l->shape[1];
	rm = r->shape[1];
	
	arr = NULL;
	
	CHKFN(array_promote_storage(l, r), fail);
	
	type = ARR_DBL;
	
	if (l->type == ARR_CMPX || r->type == ARR_CMPX)
		type = ARR_CMPX;
	
	CHKFN(mk_array(&arr, type, l->storage, 2), fail);
	
	arr->shape[0] = lm;
	arr->shape[1] = rm;
	
	switch (l->storage) {
	case STG_DEVICE:{
		af_array x, y, vals;
		af_dtype dtype;
		dim_t sp[2];
		
		dtype = f64;
		
		if (type == ARR_CMPX)
			dtype = c64;
		
		x = y = vals = NULL;
		
		sp[0] = lrk; sp[1] = lm;
		CHKAF(af_cast(&vals, l->values, dtype), fail_device);
		CHKAF(af_moddims(&x, vals, 2, sp), fail_device);
		CHKAF(af_release_array(vals), fail_device);vals = NULL;
		
		sp[0] = rm; sp[1] = lrk;
		CHKAF(af_cast(&vals, r->values, dtype), fail_device);
		CHKAF(af_moddims(&y, vals, 2, sp), fail_device);
		CHKAF(af_release_array(vals), fail_device);vals = NULL;
		
		CHKAF(af_matmul(&arr->values, y, x, AF_MAT_NONE, AF_MAT_NONE), 
		    fail_device);
		
		vals = arr->values;
		CHKAF(af_flat(&arr->values, vals), fail_device);
		    
	fail_device:
		af_release_array(x);
		af_release_array(y);
		af_release_array(vals);
		
		if (err)
			goto fail;
	}break;
	case STG_HOST:{
		CHKFN(alloc_array(arr), fail);
		
		#define MATMUL_LOOP(lt, rt) {					\
			rt *rv;							\
			lt *lv;							\
			double *zv;						\
										\
			rv = r->values;						\
			lv = l->values;						\
			zv = arr->values;					\
										\
			for (size_t i = 0; i < lm; i++)				\
				for (size_t k = 0; k < lrk; k++)		\
					for (size_t j = 0; j < rm; j++)		\
						zv[i*rm+j] += 			\
						    ((double)lv[i*lrk+k])	\
						    * ((double)rv[k*rm+j]);	\
		}

		#define MATMUL_LOOP_CMPX(lt, rt, cl, cr) {			\
			rt *rv;							\
			lt *lv;							\
			struct apl_cmpx *zv;					\
										\
			rv = r->values;						\
			lv = l->values;						\
			zv = arr->values;					\
										\
			for (size_t i = 0; i < lm; i++)				\
				for (size_t k = 0; k < lrk; k++)		\
					for (size_t j = 0; j < rm; j++)		\
						zv[i*rm+j] =			\
						    add_cmpx(zv[i*rm+j],	\
						        mul_cmpx(		\
						            cl(lv[i*lrk+k]),	\
							    cr(rv[k*rm+j])));	\
		}
		
		switch (type_pair(l->type, r->type)) {
		case type_pair(ARR_BOOL, ARR_BOOL):MATMUL_LOOP(int8_t, int8_t);break;
		case type_pair(ARR_BOOL, ARR_SINT):MATMUL_LOOP(int8_t, int16_t);break;
		case type_pair(ARR_BOOL, ARR_INT): MATMUL_LOOP(int8_t, int32_t);break;
		case type_pair(ARR_BOOL, ARR_DBL): MATMUL_LOOP(int8_t, double);break;
		case type_pair(ARR_SINT, ARR_BOOL):MATMUL_LOOP(int16_t, int8_t);break;
		case type_pair(ARR_SINT, ARR_SINT):MATMUL_LOOP(int16_t, int16_t);break;
		case type_pair(ARR_SINT, ARR_INT): MATMUL_LOOP(int16_t, int32_t);break;
		case type_pair(ARR_SINT, ARR_DBL): MATMUL_LOOP(int16_t, double);break;
		case type_pair(ARR_INT , ARR_BOOL):MATMUL_LOOP(int32_t, int8_t);break;
		case type_pair(ARR_INT , ARR_SINT):MATMUL_LOOP(int32_t, int16_t);break;
		case type_pair(ARR_INT , ARR_INT): MATMUL_LOOP(int32_t, int32_t);break;
		case type_pair(ARR_INT , ARR_DBL): MATMUL_LOOP(int32_t, double);break;
		case type_pair(ARR_DBL , ARR_BOOL):MATMUL_LOOP(double, int8_t);break;
		case type_pair(ARR_DBL , ARR_SINT):MATMUL_LOOP(double, int16_t);break;
		case type_pair(ARR_DBL , ARR_INT): MATMUL_LOOP(double, int32_t);break;
		case type_pair(ARR_DBL , ARR_DBL): MATMUL_LOOP(double, double);break;
		case type_pair(ARR_BOOL, ARR_CMPX):
			MATMUL_LOOP_CMPX(int8_t, struct apl_cmpx, cast_cmpx, );
			break;
		case type_pair(ARR_SINT, ARR_CMPX):
			MATMUL_LOOP_CMPX(int16_t, struct apl_cmpx, cast_cmpx, );
			break;
		case type_pair(ARR_INT , ARR_CMPX):
			MATMUL_LOOP_CMPX(int32_t, struct apl_cmpx, cast_cmpx, );
			break;
		case type_pair(ARR_DBL , ARR_CMPX):
			MATMUL_LOOP_CMPX(double, struct apl_cmpx, cast_cmpx, );
			break;
		case type_pair(ARR_CMPX, ARR_BOOL):
			MATMUL_LOOP_CMPX(struct apl_cmpx, int8_t, , cast_cmpx);
			break;
		case type_pair(ARR_CMPX, ARR_SINT):
			MATMUL_LOOP_CMPX(struct apl_cmpx, int16_t, , cast_cmpx);
			break;
		case type_pair(ARR_CMPX, ARR_INT ):
			MATMUL_LOOP_CMPX(struct apl_cmpx, int32_t, , cast_cmpx);
			break;
		case type_pair(ARR_CMPX, ARR_DBL ):
			MATMUL_LOOP_CMPX(struct apl_cmpx, double, , cast_cmpx);
			break;
		case type_pair(ARR_CMPX, ARR_CMPX):
			MATMUL_LOOP_CMPX(struct apl_cmpx, struct apl_cmpx,,);
			break;
		default:
			CHK(99, fail, L"Unexpected non-numeric type");
		}
	}break;
	default:
		CHK(99, fail, L"Unknown storage type");
	}
	
	*z = arr;
	
fail:
	if (err)
		release_array(arr);
	
	return err;
}

DECL_FUNC(matmul_ibeam, error_mon_syntax, matmul_func)

int
sqdset_func(struct cell_array **z, struct cell_array *r, struct cell_func *self)
{
	struct cell_array **args, *tgt, *idx, *val;
	int err;
	
	args = r->values;
	tgt = args[0];
	idx = args[1];
	val = args[2];
	
	CHKFN(release_array(tgt), fail);
	CHKFN(set_func(&tgt, idx, val, NULL), fail);
	
	*z = retain_cell(tgt);
	
fail:
	return err;
}

DECL_FUNC(sqdset_ibeam, sqdset_func, error_dya_syntax)