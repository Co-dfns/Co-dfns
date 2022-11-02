#include <float.h>
#include <string.h>

#include "internal.h"

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

struct cell_func q_signal_closure = {CELL_FUNC, 1, q_signal_func, 0};
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
		val = 83;
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

struct cell_func q_dr_closure = {CELL_FUNC, 1, q_dr_func, 0};
struct cell_func *q_dr_ibeam = &q_dr_closure;

int
is_simple_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	return mk_scalar_bool(z, r->type != ARR_NESTED);
}

struct cell_func is_simple_closure = {CELL_FUNC, 1, is_simple_func, 0};
struct cell_func *is_simple_ibeam = &is_simple_closure;

int
shape_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	struct cell_array *t;
	enum array_type type;
	int err;
	
	type = ARR_BOOL;
	
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
		
		return 10;
	}
	
	if (err = mk_array(&t, type, STG_HOST, 1))
		return err;
	
	t->shape[0] = r->rank;

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
		release_array(t);
		return 99;
	}
	
	*z = t;
	
	return 0;
}
    
struct cell_func shape_closure = {CELL_FUNC, 1, shape_func, 0};
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

struct cell_func max_shp_closure = {CELL_FUNC, 1, max_shp_func, 0};
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
	
	return 0;
}

struct cell_func ravel_closure = {CELL_FUNC, 1, ravel_func, 0};
struct cell_func *ravel_ibeam = &ravel_closure;

int
disclose_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	struct cell_array *t;
	int err;
	
	if (r->type == ARR_NESTED) {
		struct cell_array **vals = r->values;
		
		t = retain_cell(vals[0]);
		
		return 0;
	}
	
	if (err = mk_array(&t, r->type, r->storage, 0))
		return err;
	
	switch (r->storage) {
	case STG_DEVICE:
		af_seq idx = {0, 0, 1};
		err = af_index(&t->values, r->values, 1, &idx);
		break;
	case STG_HOST:
		err = fill_array(t, r->values);
		break;
	default:
		err = 99;
	}
	
	if (err) {
		release_array(t);
		return err;
	}
	
	*z = t;
	
	return 0;
}

struct cell_func disclose_closure = {CELL_FUNC, 1, disclose_func, 0};
struct cell_func *disclose_ibeam = &disclose_closure;

int
q_ambiv_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	struct cell_func *mop, *dop;
	
	mop = self->fv[1];
	dop = self->fv[2];
	
	if (l == NULL)
		return (mop->fptr)(z, l, r, mop);
	
	return (dop->fptr)(z, l, r, dop);
}

struct cell_func q_ambiv_closure = {CELL_FUNC, 1, q_ambiv_func, 0};
struct cell_func *q_ambiv_ibeam = &q_ambiv_closure;

int
reshape_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	struct cell_array *t;
	char *buf;
	size_t tc, rc, blocks, tail, rsize;
	af_array rvals;
	int err, is_nat;
	unsigned int rank;
	
	rvals = NULL;
	
	if (l->rank > 1)
		return 4;
	
	if (err = has_natural_values(&is_nat, l))
		return err;
	
	if (!is_nat)
		return 11;	
	
	rank = 1;
	
	if (l->rank == 1) {
		if (l->shape[0] > UINT_MAX) {
			return 10;
		}

		rank = (unsigned int)l->shape[0];
	}
	
	if (err = mk_array(&t, r->type, r->storage, rank))
		return err;
	
	switch (l->storage) {
	case STG_DEVICE:
		buf = (char *)t->shape;
		
		if (err = af_eval(l->values))
			goto fail;
		
		if (err = af_get_data_ptr(buf, l->values))
			goto fail;
		
		break;
	case STG_HOST:
		buf = l->values;
		break;
	default:
		err = 99;
		goto fail;
	}
	
#define RESHAPE_SHAPE_CASE(tp) {		\
	tp *vals = (tp *)buf;			\
						\
	for (unsigned int i = rank; i != 0;) {	\
		i--;				\
		t->shape[i] = (size_t)vals[i];	\
	}					\
						\
	break;					\
}

	switch (l->type) {
	case ARR_BOOL:RESHAPE_SHAPE_CASE(int8_t);
	case ARR_SINT:RESHAPE_SHAPE_CASE(int16_t);
	case ARR_INT:RESHAPE_SHAPE_CASE(int32_t);
	case ARR_DBL:RESHAPE_SHAPE_CASE(double);
	default:
		err = 99;
		goto fail;
	}
	
	tc = array_values_count(t);
	rc = array_values_count(r);
	
	if (tc == rc) {
		t->values = r->values;
		t->vrefc = r->vrefc;
		
		retain_array_data(t);
		goto done;
	}
	
	if (err = alloc_array(t))
		goto fail;
	
	if (t->storage == STG_DEVICE) {
		if (tc > DBL_MAX) {
			err = 10;
			goto fail;
		}
		
		af_seq idx = {0, (double)tc - 1, 1};
		size_t tiles = (tc + rc - 1) / rc;
		
		if (tiles > UINT_MAX) {
			err = 10;
			goto fail;
		}
		
		if (err = af_tile(&rvals, r->values, (unsigned int)tiles, 1, 1, 1))
			goto fail;
		
		if (err = af_index(&t->values, rvals, 1, &idx))
			goto fail;
		
		if (t->type == ARR_NESTED) {
			err = 99;
			goto fail;
		}
		
		af_release_array(rvals);
		goto done;
	}
	
	if (t->storage != STG_HOST) {
		err = 99;
		goto fail;
	}
	
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

struct cell_func reshape_closure = {CELL_FUNC, 1, reshape_func, 0};
struct cell_func *reshape_ibeam = &reshape_closure;
