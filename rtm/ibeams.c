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
	int err;
	unsigned int rank;
	
	rvals = NULL;	
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

int
same_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	int err;
	int8_t is_same;
	
	if (err = array_is_same(&is_same, l, r))
		return err;
	
	return mk_scalar_bool(z, is_same);
}

struct cell_func same_closure = {CELL_FUNC, 1, same_func, 0};
struct cell_func *same_ibeam = &same_closure;

#define SIMPLE_SWITCH(LOOP, CMPX_LOOP, LCMPX_LOOP, RCMPX_LOOP, zt, lt, rt, def_expr)			\
	switch (type_pair((lt), (rt))) {								\
	case type_pair(ARR_SPAN, ARR_BOOL):LOOP(zt,         int, int8_t);break;				\
	case type_pair(ARR_SPAN, ARR_SINT):LOOP(zt,         int, int16_t);break;			\
	case type_pair(ARR_SPAN, ARR_INT):LOOP(zt,          int, int32_t);break;			\
	case type_pair(ARR_SPAN, ARR_DBL):LOOP(zt,          int, double);break;				\
	case type_pair(ARR_SPAN, ARR_CMPX):RCMPX_LOOP(zt,   int, struct apl_cmpx);break;		\
	case type_pair(ARR_SPAN, ARR_CHAR8):LOOP(zt,        int, uint8_t);break;			\
	case type_pair(ARR_SPAN, ARR_CHAR16):LOOP(zt,       int, uint16_t);break;			\
	case type_pair(ARR_SPAN, ARR_CHAR32):LOOP(zt,       int, uint32_t);break;			\
	case type_pair(ARR_BOOL, ARR_BOOL):LOOP(zt,         int8_t, int8_t);break;			\
	case type_pair(ARR_BOOL, ARR_SINT):LOOP(zt,         int8_t, int16_t);break;			\
	case type_pair(ARR_BOOL, ARR_INT):LOOP(zt,          int8_t, int32_t);break;			\
	case type_pair(ARR_BOOL, ARR_DBL):LOOP(zt,          int8_t, double);break;			\
	case type_pair(ARR_BOOL, ARR_CMPX):RCMPX_LOOP(zt,   int8_t, struct apl_cmpx);break;		\
	case type_pair(ARR_BOOL, ARR_CHAR8):LOOP(zt,        int8_t, uint8_t);break;			\
	case type_pair(ARR_BOOL, ARR_CHAR16):LOOP(zt,       int8_t, uint16_t);break;			\
	case type_pair(ARR_BOOL, ARR_CHAR32):LOOP(zt,       int8_t, uint32_t);break;			\
	case type_pair(ARR_SINT, ARR_BOOL):LOOP(zt,         int16_t, int8_t);break;			\
	case type_pair(ARR_SINT, ARR_SINT):LOOP(zt,         int16_t, int16_t);break;			\
	case type_pair(ARR_SINT, ARR_INT):LOOP(zt,          int16_t, int32_t);break;			\
	case type_pair(ARR_SINT, ARR_DBL):LOOP(zt,          int16_t, double);break;			\
	case type_pair(ARR_SINT, ARR_CMPX):RCMPX_LOOP(zt,   int16_t, struct apl_cmpx);break;		\
	case type_pair(ARR_SINT, ARR_CHAR8):LOOP(zt,        int16_t, uint8_t);break;			\
	case type_pair(ARR_SINT, ARR_CHAR16):LOOP(zt,       int16_t, uint16_t);break;			\
	case type_pair(ARR_SINT, ARR_CHAR32):LOOP(zt,       int16_t, uint32_t);break;			\
	case type_pair(ARR_INT, ARR_BOOL):LOOP(zt,          int32_t, int8_t);break;			\
	case type_pair(ARR_INT, ARR_SINT):LOOP(zt,          int32_t, int16_t);break;			\
	case type_pair(ARR_INT, ARR_INT):LOOP(zt,           int32_t, int32_t);break;			\
	case type_pair(ARR_INT, ARR_DBL):LOOP(zt,           int32_t, double);break;			\
	case type_pair(ARR_INT, ARR_CMPX):RCMPX_LOOP(zt,    int32_t, struct apl_cmpx);break;		\
	case type_pair(ARR_INT, ARR_CHAR8):LOOP(zt,         int32_t, uint8_t);break;			\
	case type_pair(ARR_INT, ARR_CHAR16):LOOP(zt,        int32_t, uint16_t);break;			\
	case type_pair(ARR_INT, ARR_CHAR32):LOOP(zt,        int32_t, uint32_t);break;			\
	case type_pair(ARR_DBL, ARR_BOOL):LOOP(zt,          double, int8_t);break;			\
	case type_pair(ARR_DBL, ARR_SINT):LOOP(zt,          double, int16_t);break;			\
	case type_pair(ARR_DBL, ARR_INT):LOOP(zt,           double, int32_t);break;			\
	case type_pair(ARR_DBL, ARR_DBL):LOOP(zt,           double, double);break;			\
	case type_pair(ARR_DBL, ARR_CMPX):RCMPX_LOOP(zt,    double, struct apl_cmpx);break;		\
	case type_pair(ARR_DBL, ARR_CHAR8):LOOP(zt,         double, uint8_t);break;			\
	case type_pair(ARR_DBL, ARR_CHAR16):LOOP(zt,        double, uint16_t);break;			\
	case type_pair(ARR_DBL, ARR_CHAR32):LOOP(zt,        double, uint32_t);break;			\
	case type_pair(ARR_CMPX, ARR_BOOL):LCMPX_LOOP(zt,   struct apl_cmpx, int8_t);break;		\
	case type_pair(ARR_CMPX, ARR_SINT):LCMPX_LOOP(zt,   struct apl_cmpx, int16_t);break;		\
	case type_pair(ARR_CMPX, ARR_INT):LCMPX_LOOP(zt,    struct apl_cmpx, int32_t);break;		\
	case type_pair(ARR_CMPX, ARR_DBL):LCMPX_LOOP(zt,    struct apl_cmpx, double);break;		\
	case type_pair(ARR_CMPX, ARR_CMPX):CMPX_LOOP(zt,    struct apl_cmpx, struct apl_cmpx);break;	\
	case type_pair(ARR_CMPX, ARR_CHAR8):LCMPX_LOOP(zt,  struct apl_cmpx, uint8_t);break;		\
	case type_pair(ARR_CMPX, ARR_CHAR16):LCMPX_LOOP(zt, struct apl_cmpx, uint16_t);break;		\
	case type_pair(ARR_CMPX, ARR_CHAR32):LCMPX_LOOP(zt, struct apl_cmpx, uint32_t);break;		\
	case type_pair(ARR_CHAR8, ARR_BOOL):LOOP(zt,        uint8_t, int8_t);break;			\
	case type_pair(ARR_CHAR8, ARR_SINT):LOOP(zt,        uint8_t, int16_t);break;			\
	case type_pair(ARR_CHAR8, ARR_INT):LOOP(zt,         uint8_t, int32_t);break;			\
	case type_pair(ARR_CHAR8, ARR_DBL):LOOP(zt,         uint8_t, double);break;			\
	case type_pair(ARR_CHAR8, ARR_CMPX):RCMPX_LOOP(zt,  uint8_t, struct apl_cmpx);break;		\
	case type_pair(ARR_CHAR8, ARR_CHAR8):LOOP(zt,       uint8_t, uint8_t);break;			\
	case type_pair(ARR_CHAR8, ARR_CHAR16):LOOP(zt,      uint8_t, uint16_t);break;			\
	case type_pair(ARR_CHAR8, ARR_CHAR32):LOOP(zt,      uint8_t, uint32_t);break;			\
	case type_pair(ARR_CHAR16, ARR_BOOL):LOOP(zt,       uint16_t, int8_t);break;			\
	case type_pair(ARR_CHAR16, ARR_SINT):LOOP(zt,       uint16_t, int16_t);break;			\
	case type_pair(ARR_CHAR16, ARR_INT):LOOP(zt,        uint16_t, int32_t);break;			\
	case type_pair(ARR_CHAR16, ARR_DBL):LOOP(zt,        uint16_t, double);break;			\
	case type_pair(ARR_CHAR16, ARR_CMPX):RCMPX_LOOP(zt, uint16_t, struct apl_cmpx);break;		\
	case type_pair(ARR_CHAR16, ARR_CHAR8):LOOP(zt,      uint16_t, uint8_t);break;			\
	case type_pair(ARR_CHAR16, ARR_CHAR16):LOOP(zt,     uint16_t, uint16_t);break;			\
	case type_pair(ARR_CHAR16, ARR_CHAR32):LOOP(zt,     uint16_t, uint32_t);break;			\
	case type_pair(ARR_CHAR32, ARR_BOOL):LOOP(zt,       uint32_t, int8_t);break;			\
	case type_pair(ARR_CHAR32, ARR_SINT):LOOP(zt,       uint32_t, int16_t);break;			\
	case type_pair(ARR_CHAR32, ARR_INT):LOOP(zt,        uint32_t, int32_t);break;			\
	case type_pair(ARR_CHAR32, ARR_DBL):LOOP(zt,        uint32_t, double);break;			\
	case type_pair(ARR_CHAR32, ARR_CMPX):RCMPX_LOOP(zt, uint32_t, struct apl_cmpx);break;		\
	case type_pair(ARR_CHAR32, ARR_CHAR8):LOOP(zt,      uint32_t, uint8_t);break;			\
	case type_pair(ARR_CHAR32, ARR_CHAR16):LOOP(zt,     uint32_t, uint16_t);break;			\
	case type_pair(ARR_CHAR32, ARR_CHAR32):LOOP(zt,     uint32_t, uint32_t);break;			\
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
	
	if (l->type == ARR_SPAN || r->type == ARR_SPAN)
		return 99;
	
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
		
		if (lbuf == NULL) {
			err = 1;
			goto fail;
		}
		
		fl = 1;
		
		if (err = af_eval(l))
			goto fail;
		
		if (err = af_get_data_ptr(lbuf, l->values))
			goto fail;
	}
	
	if (r->storage == STG_DEVICE) {
		rbuf = malloc(rc * array_element_size(r));
		
		if (rbuf == NULL) {
			err = 1;
			goto fail;
		}
		
		fr = 1;
		
		if (err = af_eval(r))
			goto fail;
		
		if (err = af_get_data_ptr(rbuf, r->values))
			goto fail;
	}
	
	if (err = mk_array(&t, ARR_NESTED, STG_HOST, 1))
		return err;
	
	t->shape[0] = count = lc > rc ? lc : rc;
	
	if (err = alloc_array(t))
		goto fail;
	
	tvals = t->values;
	
	if (l->type == ARR_NESTED && r->type == ARR_NESTED) {
		struct cell_array **lvals = lbuf;
		struct cell_array **rvals = rbuf;
		
		for (size_t i = 0; i < count; i++) {
			x = lvals[i % lc];
			y = rvals[i % rc];
			
			if (err = (oper->fptr)(tvals + i, x, y, oper))
				goto fail;
		}
		
		goto done;
	}
	
	if (l->type != ARR_NESTED) {
		if (err = mk_array(&x, l->type, STG_HOST, 0))
			goto fail;
		
		fx = 1;
		
		if (err = alloc_array(x))
			goto fail;
	}
	
	if (r->type != ARR_NESTED) {
		if (err = mk_array(&y, r->type, STG_HOST, 0))
			goto fail;
		
		fy = 1;
		
		if (err = alloc_array(y))
			goto fail;
	}
	
	if (l->type == ARR_NESTED) {
		struct cell_array **lvals = lbuf;
		
#define VEACH_LNESTED_LOOP(type) {				\
	type *rvals, *yvals;					\
								\
	rvals = rbuf;						\
	yvals = y->values;					\
								\
	for (size_t i = 0; i < count; i++) {			\
		x = lvals[i % lc];				\
		yvals[0] = rvals[i % rc];			\
								\
		if (err = (oper->fptr)(tvals + i, x, y, oper))	\
			goto fail;				\
	}							\
								\
	break;							\
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
			err = 99;
			goto fail;
		}
		
		goto done;
	}
	
	if (r->type == ARR_NESTED) {
		struct cell_array **rvals = rbuf;
		
#define VEACH_RNESTED_LOOP(type) {				\
	type *lvals, *xvals;					\
								\
	lvals = lbuf;						\
	xvals = x->values;					\
								\
	for (size_t i = 0; i < count; i++) {			\
		xvals[0] = lvals[i % lc];			\
		y = rvals[i % rc];				\
								\
		if (err = (oper->fptr)(tvals + i, x, y, oper))	\
			goto fail;				\
	}							\
								\
	break;							\
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
			err = 99;
			goto fail;
		}
		
		goto done;
	}
	
#define VEACH_LOOP(ztype, ltype, rtype) {			\
	ltype *lvals, *xvals;					\
	rtype *rvals, *yvals;					\
								\
	lvals = lbuf;						\
	rvals = rbuf;						\
	xvals = x->values;					\
	yvals = y->values;					\
								\
	for (size_t i = 0; i < count; i++) {			\
		xvals[0] = lvals[i % lc];			\
		yvals[0] = rvals[i % rc];			\
								\
		if (err = (oper->fptr)(tvals + i, x, y, oper))	\
			goto fail;				\
	}							\
}

	SIMPLE_SWITCH(VEACH_LOOP,VEACH_LOOP,VEACH_LOOP,VEACH_LOOP,,
	    l->type, r->type, {err = 99; goto fail;})
	
done:
	if (err = squeeze_array(t))
		goto fail;
	
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

struct cell_func q_veach_closure = {CELL_FUNC, 1, q_veach_func, 0};
struct cell_func *q_veach_ibeam = &q_veach_closure;

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

struct cell_func squeeze_closure = {CELL_FUNC, 1, squeeze_func, 0};
struct cell_func *squeeze_ibeam = &squeeze_closure;

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

struct cell_func conjugate_closure = {CELL_FUNC, 1, conjugate_func, 0};
struct cell_func *conjugate_vec = &conjugate_closure;

int
is_numeric_func(struct cell_array **z,
    struct cell_array *l, struct cell_array *r, struct cell_func *self)
{
	if (is_numeric_array(r))
		return mk_scalar_bool(z, 1);
	
	return mk_scalar_bool(z, 0);
}

struct cell_func is_numeric_closure = {CELL_FUNC, 1, is_numeric_func, 0};
struct cell_func *is_numeric_ibeam = &is_numeric_closure;

int
dyadic_scalar_apply(struct cell_array **z, 
    struct cell_array *l, struct cell_array *r, 
    int (*scl_type)(enum array_type *, struct cell_array *, struct cell_array *), 
    int (*scl_device)(struct cell_array *, struct cell_array *, struct cell_array *),
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
	
	if (t->storage == STG_DEVICE)
		if (err = scl_device(t, l, r))
			goto fail;
	
	if (t->storage != STG_HOST)
		return 99;
	
	if (err = alloc_array(t)) 
		goto fail;
	
	if (err = scl_host(t, t->shape[0], l, lc, r, rc))
		goto fail;
	
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
add_device(struct cell_array *z, struct cell_array *l, struct cell_array *r)
{
	af_array x, y;
	af_dtype type;
	int err;
	
	type = array_af_dtype(z);
	
	if (err = af_cast(&x, l->values, type))
		return err;
	
	if (err = af_cast(&y, r->values, type))
		return err;
	
	if (err = af_add(&z->values, x, y, 0))
		return err;
	
	return 0;
}

int
add_host(struct cell_array *t, size_t count, 
    struct cell_array *l, size_t lc, struct cell_array *r, size_t rc)
{
#define ADD_LOCALS(ztype, ltype, rtype) \
	ztype *tvals = t->values;       \
	ltype *lvals = l->values;       \
	rtype *rvals = r->values;
	
#define ADD_LOOP(ztype, ltype, rtype) {					\
	ADD_LOCALS(ztype, ltype, rtype)					\
									\
	for (size_t i = 0; i < count; i++)                              \
		tvals[i] = (ztype)lvals[i % lc] + (ztype)rvals[i % rc];	\
}

#define ADD_CMPX(ztype, ltype, rtype) {					\
	ADD_LOCALS(ztype, ltype, rtype)					\
									\
	for (size_t i = 0; i < count; i++) {                            \
		tvals[i].real = lvals[i % lc].real + rvals[i % rc].real;\
		tvals[i].imag = lvals[i % lc].imag + rvals[i % rc].imag;\
	}                                                               \
}
		
#define ADD_LCMPX(ztype, ltype, rtype) {				\
	ADD_LOCALS(ztype, ltype, rtype)					\
									\
	for (size_t i = 0; i < count; i++) {                            \
		tvals[i].real = lvals[i % lc].real + rvals[i % rc];	\
		tvals[i].imag = lvals[i % lc].imag;                     \
	}                                                               \
}
	
#define ADD_RCMPX(ztype, ltype, rtype) {				\
	ADD_LOCALS(ztype, ltype, rtype)					\
									\
	for (size_t i = 0; i < count; i++) {                            \
		tvals[i].real = lvals[i % lc] + rvals[i % rc].real;	\
		tvals[i].imag = rvals[i % rc].imag;                     \
	}                                                               \
}

#define NOOP(zt, lt, rt)

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

struct cell_func add_closure = {CELL_FUNC, 1, add_func, 0};
struct cell_func *add_vec_ibeam = &add_closure;