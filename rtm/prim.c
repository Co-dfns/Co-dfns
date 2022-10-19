#include "codfns.h"

EXPORT int
DyalogGetInterpreterFunctions(void *p)
{
    return set_dwafns(p);
}

extern struct cell_func *q_signal_ibeam;
extern struct cell_func *q_dr_ibeam;
extern struct cell_func *eqv_ibeam;
extern struct cell_func *rnk_eqv_ibeam;
extern struct cell_func *shp_eqv_ibeam;
extern struct cell_func *is_empty_ibeam;
extern struct cell_func *count_ibeam;
extern struct cell_func *is_simple_ibeam;
extern struct cell_func *elem_ibeam;
extern struct cell_func *eptr_ibeam;
extern struct cell_func *incr_ibeam;
extern struct cell_func *shaped_ibeam;
extern struct cell_func *store_ibeam;
extern struct cell_func *squeeze_ibeam;
extern struct cell_func *is_bound_ibeam;
extern struct cell_func *can_ext_by_ibeam;
extern struct cell_func *conjugate_vec;
extern struct cell_func *add_vec;
extern struct cell_func *eql_vec;
extern struct cell_func *enclose_ibeam;

int ptr384(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr386(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr388(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr389(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr390(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr391(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr392(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr393(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr394(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr385(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr383(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr387(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);

int cdf_prim_flag = 0;

EXPORT struct cdf_prim_loc {
	unsigned int __count;
	wchar_t **__names;
	struct cell_func *q_signal;
	struct cell_func *q_dr;
	struct cell_func *eqv;
	struct cell_func *rnk_eqv;
	struct cell_func *shp_eqv;
	struct cell_func *is_empty;
	struct cell_func *count;
	struct cell_func *is_simple;
	struct cell_func *elem;
	struct cell_func *eptr;
	struct cell_func *incr;
	struct cell_func *shaped;
	struct cell_func *store;
	struct cell_func *squeeze;
	struct cell_func *is_bound;
	struct cell_func *can_ext_by;
	struct cell_func *ambiv;
	struct cell_func *chk_ext_scl;
	struct cell_func *elem_map;
	struct cell_func *scalar;
	struct cell_func *conjugate;
	struct cell_func *add;
	struct cell_func *rgt;
	struct cell_func *lft;
	struct cell_func *eql;
	struct cell_func *enclose;
	struct cell_func *par;
} cdf_prim;

wchar_t *cdf_prim_names[] = {L"q_signal", L"q_dr", L"eqv", L"rnk_eqv", L"shp_eqv", L"is_empty", L"count", L"is_simple", L"elem", L"eptr", L"incr", L"shaped", L"store", L"squeeze", L"is_bound", L"can_ext_by", L"ambiv", L"chk_ext_scl", L"elem_map", L"scalar", L"conjugate", L"add", L"rgt", L"lft", L"eql", L"enclose", L"par"};

EXPORT int
cdf_prim_init(void)
{
	struct cdf_prim_loc loc;
	void *stk[128];
	void **stkhd;
	int err;

	if (cdf_prim_flag)
		return 0;

	stkhd = &stk[0];
	cdf_prim_flag = 1;
	cdf_prim_init();

	loc.__count = 27;
	loc.__names = cdf_prim_names;
	loc.q_signal = NULL;
	loc.q_dr = NULL;
	loc.eqv = NULL;
	loc.rnk_eqv = NULL;
	loc.shp_eqv = NULL;
	loc.is_empty = NULL;
	loc.count = NULL;
	loc.is_simple = NULL;
	loc.elem = NULL;
	loc.eptr = NULL;
	loc.incr = NULL;
	loc.shaped = NULL;
	loc.store = NULL;
	loc.squeeze = NULL;
	loc.is_bound = NULL;
	loc.can_ext_by = NULL;
	loc.ambiv = NULL;
	loc.chk_ext_scl = NULL;
	loc.elem_map = NULL;
	loc.scalar = NULL;
	loc.conjugate = NULL;
	loc.add = NULL;
	loc.rgt = NULL;
	loc.lft = NULL;
	loc.eql = NULL;
	loc.enclose = NULL;
	loc.par = NULL;

	err = 0;

	loc.q_signal = *stkhd++ = retain_cell(q_signal_ibeam);
	release_cell(*--stkhd);
	
	loc.q_dr = *stkhd++ = retain_cell(q_dr_ibeam);
	release_cell(*--stkhd);
	
	loc.eqv = *stkhd++ = retain_cell(eqv_ibeam);
	release_cell(*--stkhd);
	
	loc.rnk_eqv = *stkhd++ = retain_cell(rnk_eqv_ibeam);
	release_cell(*--stkhd);
	
	loc.shp_eqv = *stkhd++ = retain_cell(shp_eqv_ibeam);
	release_cell(*--stkhd);
	
	loc.is_empty = *stkhd++ = retain_cell(is_empty_ibeam);
	release_cell(*--stkhd);
	
	loc.count = *stkhd++ = retain_cell(count_ibeam);
	release_cell(*--stkhd);
	
	loc.is_simple = *stkhd++ = retain_cell(is_simple_ibeam);
	release_cell(*--stkhd);
	
	loc.elem = *stkhd++ = retain_cell(elem_ibeam);
	release_cell(*--stkhd);
	
	loc.eptr = *stkhd++ = retain_cell(eptr_ibeam);
	release_cell(*--stkhd);
	
	loc.incr = *stkhd++ = retain_cell(incr_ibeam);
	release_cell(*--stkhd);
	
	loc.shaped = *stkhd++ = retain_cell(shaped_ibeam);
	release_cell(*--stkhd);
	
	loc.store = *stkhd++ = retain_cell(store_ibeam);
	release_cell(*--stkhd);
	
	loc.squeeze = *stkhd++ = retain_cell(squeeze_ibeam);
	release_cell(*--stkhd);
	
	loc.is_bound = *stkhd++ = retain_cell(is_bound_ibeam);
	release_cell(*--stkhd);
	
	loc.can_ext_by = *stkhd++ = retain_cell(can_ext_by_ibeam);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr383, 1);
	
		if (err)
			goto cleanup;
	
		fn->fv[0] = retain_cell(loc.is_bound);
	
		*stkhd++ = fn;
	}
	
	loc.ambiv = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr384, 4);
	
		if (err)
			goto cleanup;
	
		fn->fv[0] = retain_cell(loc.can_ext_by);
		fn->fv[1] = retain_cell(loc.shaped);
		fn->fv[2] = retain_cell(loc.shp_eqv);
		fn->fv[3] = retain_cell(loc.rnk_eqv);
	
		*stkhd++ = fn;
	}
	
	loc.chk_ext_scl = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr385, 7);
	
		if (err)
			goto cleanup;
	
		fn->fv[0] = retain_cell(loc.squeeze);
		fn->fv[1] = retain_cell(loc.store);
		fn->fv[2] = retain_cell(loc.shaped);
		fn->fv[3] = retain_cell(loc.incr);
		fn->fv[4] = retain_cell(loc.eptr);
		fn->fv[5] = retain_cell(loc.elem);
		fn->fv[6] = retain_cell(loc.count);
	
		*stkhd++ = fn;
	}
	
	loc.elem_map = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr387, 6);
	
		if (err)
			goto cleanup;
	
		fn->fv[0] = retain_cell(loc.elem_map);
		fn->fv[1] = retain_cell(loc.chk_ext_scl);
		fn->fv[2] = retain_cell(loc.shaped);
		fn->fv[3] = retain_cell(loc.elem);
		fn->fv[4] = retain_cell(loc.is_simple);
		fn->fv[5] = retain_cell(loc.is_empty);
	
		*stkhd++ = fn;
	}
	
	loc.scalar = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr389, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	loc.conjugate = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr390, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	{
		struct cell_func *x = add_vec;
		struct cell_func *op = loc.scalar;
		struct cell_func *y = *--stkhd;
		struct cell_func **dst = (struct cell_func **)stkhd++;
	
		err = apply_dop(dst, op, x, y);
	
		release_func(y);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_func *x = loc.conjugate;
		struct cell_func *op = loc.ambiv;
		struct cell_func *y = *--stkhd;
		struct cell_func **dst = (struct cell_func **)stkhd++;
	
		err = apply_dop(dst, op, x, y);
	
		release_func(y);
	
		if (err)
			goto cleanup;
	}
	
	loc.add = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr391, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	loc.rgt = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr392, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	loc.lft = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr393, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	{
		struct cell_func *x = eql_vec;
		struct cell_func *op = loc.scalar;
		struct cell_func *y = *--stkhd;
		struct cell_func **dst = (struct cell_func **)stkhd++;
	
		err = apply_dop(dst, op, x, y);
	
		release_func(y);
	
		if (err)
			goto cleanup;
	}
	
	loc.eql = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	loc.enclose = *stkhd++ = retain_cell(enclose_ibeam);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr394, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	{
		struct cell_func *x = loc.enclose;
		struct cell_func *op = loc.ambiv;
		struct cell_func *y = *--stkhd;
		struct cell_func **dst = (struct cell_func **)stkhd++;
	
		err = apply_dop(dst, op, x, y);
	
		release_func(y);
	
		if (err)
			goto cleanup;
	}
	
	loc.par = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	

	cdf_prim = loc;

cleanup:
	return err;
}

int
ptr383(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	struct cell_func *deldel;
	void *alphaalpha, *omegaomega;
	void *stk[128];
	void **stkhd;
	int err;

	deldel = self->fv[0];
	alphaalpha = self->fv[1];
	omegaomega = self->fv[2];

	struct lex_vars {
		struct cell_func *is_bound;
	} *lex;
	
	lex = (struct lex_vars *)deldel->fv;
	
	stkhd = &stk[0];
	err = 0;

	{
		struct cell_func *fn = lex->is_bound;
		struct cell_array *arg = alpha;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_array *x = *--stkhd;
	
		err = guard_check(x);
	
		release_array(x);
	
		if (err > 0)
			goto cleanup;
	
		if (!err) {
			{
				struct cell_array *x = alpha;
				struct cell_func *fn = omegaomega;
				struct cell_array *y = omega;
				struct cell_array **dst = (struct cell_array **)stkhd++;
			
				err = (fn->fptr)(dst, x, y, fn);
			
				if (err)
					goto cleanup;
			}
			
			*z = *--stkhd;
			goto cleanup;
			
		}
	}
	
	{
		struct cell_func *fn = alphaalpha;
		struct cell_array *arg = omega;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
cleanup:
	return err;
}

int
ptr384(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	struct lex_vars {
		struct cell_func *can_ext_by;
		struct cell_func *shaped;
		struct cell_func *shp_eqv;
		struct cell_func *rnk_eqv;
	} *lex;
	
	lex = (struct lex_vars *)self->fv;
	
	stkhd = &stk[0];
	err = 0;

	{
		struct cell_array *x = alpha;
		struct cell_func *fn = lex->shp_eqv;
		struct cell_array *y = omega;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, x, y, fn);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_array *x = *--stkhd;
	
		err = guard_check(x);
	
		release_array(x);
	
		if (err > 0)
			goto cleanup;
	
		if (!err) {
			{
				struct cell_array *arr, **dat;
			
				unsigned int rnk = 1;
				size_t shp[] = {2};
			
				err = mk_array(&arr, ARR_NESTED, STG_HOST, 1, shp);
			
				if (err)
					goto cleanup;
			
				dat = arr->values;
			
				dat[0] = alpha;
				dat[1] = omega;
			
				retain_cell(alpha);
				retain_cell(omega);
			
				*stkhd++ = arr;
			}
			
			*z = *--stkhd;
			goto cleanup;
			
		}
	}
	
	{
		struct cell_array *x = alpha;
		struct cell_func *fn = lex->can_ext_by;
		struct cell_array *y = omega;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, x, y, fn);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_array *x = *--stkhd;
	
		err = guard_check(x);
	
		release_array(x);
	
		if (err > 0)
			goto cleanup;
	
		if (!err) {
			{
				struct cell_array *x = omega;
				struct cell_func *fn = lex->shaped;
				struct cell_array *y = alpha;
				struct cell_array **dst = (struct cell_array **)stkhd++;
			
				err = (fn->fptr)(dst, x, y, fn);
			
				if (err)
					goto cleanup;
			}
			
			{
				struct cell_array *arr, **dat;
			
				unsigned int rnk = 1;
				size_t shp[] = {2};
			
				err = mk_array(&arr, ARR_NESTED, STG_HOST, 1, shp);
			
				if (err)
					goto cleanup;
			
				dat = arr->values;
			
				dat[0] = *--stkhd;
				dat[1] = omega;
			
				retain_cell(omega);
			
				*stkhd++ = arr;
			}
			
			*z = *--stkhd;
			goto cleanup;
			
		}
	}
	
	{
		struct cell_array *x = omega;
		struct cell_func *fn = lex->can_ext_by;
		struct cell_array *y = alpha;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, x, y, fn);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_array *x = *--stkhd;
	
		err = guard_check(x);
	
		release_array(x);
	
		if (err > 0)
			goto cleanup;
	
		if (!err) {
			{
				struct cell_array *x = alpha;
				struct cell_func *fn = lex->shaped;
				struct cell_array *y = omega;
				struct cell_array **dst = (struct cell_array **)stkhd++;
			
				err = (fn->fptr)(dst, x, y, fn);
			
				if (err)
					goto cleanup;
			}
			
			{
				struct cell_array *arr, **dat;
			
				unsigned int rnk = 1;
				size_t shp[] = {2};
			
				err = mk_array(&arr, ARR_NESTED, STG_HOST, 1, shp);
			
				if (err)
					goto cleanup;
			
				dat = arr->values;
			
				dat[0] = alpha;
				dat[1] = *--stkhd;
			
				retain_cell(alpha);
			
				*stkhd++ = arr;
			}
			
			*z = *--stkhd;
			goto cleanup;
			
		}
	}
	
	{
		struct cell_array *x = alpha;
		struct cell_func *fn = lex->rnk_eqv;
		struct cell_array *y = omega;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, x, y, fn);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_array *x = *--stkhd;
	
		err = guard_check(x);
	
		release_array(x);
	
		if (err > 0)
			goto cleanup;
	
		if (!err) {
			{
				struct cell_array *arr;
			
				enum array_type typ = ARR_SINT;
				unsigned int rnk = 0;
				size_t *shp = NULL;
				int16_t dat[] = {5};
			
				err = mk_array(&arr, typ, STG_DEVICE, rnk, shp);
			
				if (err)
					goto cleanup;
			
				err = fill_array(arr, dat);
			
				if (err)
					goto cleanup;
			
				*stkhd++ = arr;
			}
			{
				struct cell_func *fn = cdf_prim.q_signal;
				struct cell_array *arg = *--stkhd;
				struct cell_array **dst = (struct cell_array **)stkhd++;
			
				err = (fn->fptr)(dst, NULL, arg, fn);
			
				release_array(arg);
			
				if (err)
					goto cleanup;
			}
			
			*z = *--stkhd;
			goto cleanup;
			
		}
	}
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		size_t *shp = NULL;
		int16_t dat[] = {4};
	
		err = mk_array(&arr, typ, STG_DEVICE, rnk, shp);
	
		if (err)
			goto cleanup;
	
		err = fill_array(arr, dat);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = arr;
	}
	{
		struct cell_func *fn = cdf_prim.q_signal;
		struct cell_array *arg = *--stkhd;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
cleanup:
	return err;
}

int
ptr385(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	struct cell_func *deldel;
	void *alphaalpha;
	void *stk[128];
	void **stkhd;
	int err;

	deldel = self->fv[0];
	alphaalpha = self->fv[1];

	struct {
		struct cell_array *z;
		struct cell_array *x;
		struct cell_array *y;
		struct cell_func *fn;
		struct cell_array *cnt;
		struct cell_array *_;
	} loc;
	
	struct lex_vars {
		struct cell_func *squeeze;
		struct cell_func *store;
		struct cell_func *shaped;
		struct cell_func *incr;
		struct cell_func *eptr;
		struct cell_func *elem;
		struct cell_func *count;
	} *lex;
	
	lex = (struct lex_vars *)deldel->fv;
	
	stkhd = &stk[0];
	err = 0;

	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 1;
		size_t shp[] = {0};
		int16_t dat[] = {0};
	
		err = mk_array(&arr, typ, STG_DEVICE, rnk, shp);
	
		if (err)
			goto cleanup;
	
		err = fill_array(arr, dat);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = arr;
	}
	{
		struct cell_func *fn = cdf_prim.par;
		struct cell_array *arg = *--stkhd;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_array *x = alpha;
		struct cell_func *fn = lex->shaped;
		struct cell_array *y = *--stkhd;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, x, y, fn);
	
		release_array(y);
	
		if (err)
			goto cleanup;
	}
	
	loc.z = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	loc.x = *stkhd++ = retain_cell(alpha);
	release_cell(*--stkhd);
	
	loc.y = *stkhd++ = retain_cell(omega);
	release_cell(*--stkhd);
	
	loc.fn = *stkhd++ = retain_cell(alphaalpha);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn = lex->count;
		struct cell_array *arg = loc.x;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	}
	
	loc.cnt = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		size_t *shp = NULL;
		int16_t dat[] = {0};
	
		err = mk_array(&arr, typ, STG_DEVICE, rnk, shp);
	
		if (err)
			goto cleanup;
	
		err = fill_array(arr, dat);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = arr;
	}
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr386, 8);
	
		if (err)
			goto cleanup;
	
		fn->fv[0] = retain_cell(loc.fn);
		fn->fv[1] = retain_cell(loc.y);
		fn->fv[2] = retain_cell(loc.x);
		fn->fv[3] = retain_cell(loc.z);
		fn->fv[4] = retain_cell(lex->store);
		fn->fv[5] = retain_cell(lex->incr);
		fn->fv[6] = retain_cell(lex->eptr);
		fn->fv[7] = retain_cell(lex->elem);
	
		*stkhd++ = fn;
	}
	
	{
		struct cell_array *x = loc.cnt;
		struct cell_func *fn = *--stkhd;
		struct cell_array *y = *--stkhd;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, x, y, fn);
	
		release_func(fn);
		release_array(y);
	
		if (err)
			goto cleanup;
	}
	
	loc._ = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn = lex->squeeze;
		struct cell_array *arg = loc.z;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
cleanup:
	return err;
}

int
ptr386(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	struct lex_vars {
		struct cell_func *fn;
		struct cell_array *y;
		struct cell_array *x;
		struct cell_array *z;
		struct cell_func *store;
		struct cell_func *incr;
		struct cell_func *eptr;
		struct cell_func *elem;
	} *lex;
	
	lex = (struct lex_vars *)self->fv;
	
	stkhd = &stk[0];
	err = 0;

	{
		struct cell_array *x = alpha;
		struct cell_func *fn = cdf_prim.eqv;
		struct cell_array *y = omega;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, x, y, fn);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_array *x = *--stkhd;
	
		err = guard_check(x);
	
		release_array(x);
	
		if (err > 0)
			goto cleanup;
	
		if (!err) {
			{
				struct cell_array *arr;
			
				enum array_type typ = ARR_SINT;
				unsigned int rnk = 1;
				size_t shp[] = {0};
				int16_t dat[] = {0};
			
				err = mk_array(&arr, typ, STG_DEVICE, rnk, shp);
			
				if (err)
					goto cleanup;
			
				err = fill_array(arr, dat);
			
				if (err)
					goto cleanup;
			
				*stkhd++ = arr;
			}
			*z = *--stkhd;
			goto cleanup;
			
		}
	}
	
	{
		struct cell_array *x = lex->y;
		struct cell_func *fn = lex->elem;
		struct cell_array *y = omega;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, x, y, fn);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_array *x = lex->x;
		struct cell_func *fn = lex->elem;
		struct cell_array *y = omega;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, x, y, fn);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_array *x = *--stkhd;
		struct cell_func *fn = lex->fn;
		struct cell_array *y = *--stkhd;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, x, y, fn);
	
		release_array(x);
		release_array(y);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_array *x = lex->z;
		struct cell_func *fn = lex->eptr;
		struct cell_array *y = omega;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, x, y, fn);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_array *x = *--stkhd;
		struct cell_func *fn = lex->store;
		struct cell_array *y = *--stkhd;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, x, y, fn);
	
		release_array(x);
		release_array(y);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_array *x = omega;
		struct cell_func *fn = cdf_prim.lft;
		struct cell_array *y = *--stkhd;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, x, y, fn);
	
		release_array(y);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_func *fn = lex->incr;
		struct cell_array *arg = *--stkhd;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_array *x = alpha;
		struct cell_func *fn = self;
		struct cell_array *y = *--stkhd;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, x, y, fn);
	
		release_array(y);
	
		if (err)
			goto cleanup;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
cleanup:
	return err;
}

int
ptr387(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	struct cell_func *deldel;
	void *alphaalpha, *omegaomega;
	void *stk[128];
	void **stkhd;
	int err;

	deldel = self->fv[0];
	alphaalpha = self->fv[1];
	omegaomega = self->fv[2];

	struct {
		struct cell_array *xy;
		struct cell_array *x;
		struct cell_array *y;
	} loc;
	
	struct lex_vars {
		struct cell_func *elem_map;
		struct cell_func *chk_ext_scl;
		struct cell_func *shaped;
		struct cell_func *elem;
		struct cell_func *is_simple;
		struct cell_func *is_empty;
	} *lex;
	
	lex = (struct lex_vars *)deldel->fv;
	
	stkhd = &stk[0];
	err = 0;

	{
		struct cell_array *x = alpha;
		struct cell_func *fn = lex->chk_ext_scl;
		struct cell_array *y = omega;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, x, y, fn);
	
		if (err)
			goto cleanup;
	}
	
	loc.xy = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		size_t *shp = NULL;
		int16_t dat[] = {0};
	
		err = mk_array(&arr, typ, STG_DEVICE, rnk, shp);
	
		if (err)
			goto cleanup;
	
		err = fill_array(arr, dat);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = arr;
	}
	{
		struct cell_array *x = loc.xy;
		struct cell_func *fn = lex->elem;
		struct cell_array *y = *--stkhd;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, x, y, fn);
	
		release_array(y);
	
		if (err)
			goto cleanup;
	}
	
	loc.x = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		size_t *shp = NULL;
		int16_t dat[] = {1};
	
		err = mk_array(&arr, typ, STG_DEVICE, rnk, shp);
	
		if (err)
			goto cleanup;
	
		err = fill_array(arr, dat);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = arr;
	}
	{
		struct cell_array *x = loc.xy;
		struct cell_func *fn = lex->elem;
		struct cell_array *y = *--stkhd;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, x, y, fn);
	
		release_array(y);
	
		if (err)
			goto cleanup;
	}
	
	loc.y = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn = lex->is_empty;
		struct cell_array *arg = loc.x;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_array *x = *--stkhd;
	
		err = guard_check(x);
	
		release_array(x);
	
		if (err > 0)
			goto cleanup;
	
		if (!err) {
			{
				struct cell_array *arr;
			
				enum array_type typ = ARR_SINT;
				unsigned int rnk = 1;
				size_t shp[] = {0};
				int16_t dat[] = {0};
			
				err = mk_array(&arr, typ, STG_DEVICE, rnk, shp);
			
				if (err)
					goto cleanup;
			
				err = fill_array(arr, dat);
			
				if (err)
					goto cleanup;
			
				*stkhd++ = arr;
			}
			{
				struct cell_func *fn = omegaomega;
				struct cell_array *arg = *--stkhd;
				struct cell_array **dst = (struct cell_array **)stkhd++;
			
				err = (fn->fptr)(dst, NULL, arg, fn);
			
				release_array(arg);
			
				if (err)
					goto cleanup;
			}
			
			{
				struct cell_array *x = loc.x;
				struct cell_func *fn = lex->shaped;
				struct cell_array *y = *--stkhd;
				struct cell_array **dst = (struct cell_array **)stkhd++;
			
				err = (fn->fptr)(dst, x, y, fn);
			
				release_array(y);
			
				if (err)
					goto cleanup;
			}
			
			*z = *--stkhd;
			goto cleanup;
			
		}
	}
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr388, 1);
	
		if (err)
			goto cleanup;
	
		fn->fv[0] = retain_cell(lex->is_simple);
	
		*stkhd++ = fn;
	}
	
	{
		struct cell_array *x = loc.x;
		struct cell_func *fn = *--stkhd;
		struct cell_array *y = loc.y;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, x, y, fn);
	
		release_func(fn);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_array *x = *--stkhd;
	
		err = guard_check(x);
	
		release_array(x);
	
		if (err > 0)
			goto cleanup;
	
		if (!err) {
			{
				struct cell_array *x = loc.x;
				struct cell_func *fn = alphaalpha;
				struct cell_array *y = loc.y;
				struct cell_array **dst = (struct cell_array **)stkhd++;
			
				err = (fn->fptr)(dst, x, y, fn);
			
				if (err)
					goto cleanup;
			}
			
			*z = *--stkhd;
			goto cleanup;
			
		}
	}
	
	{
		struct cell_func *x = self;
		struct cell_func *op = lex->elem_map;
		struct cell_func **dst = (struct cell_func **)stkhd++;
	
		err = apply_mop(dst, op, x);
	
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_array *x = loc.x;
		struct cell_func *fn = *--stkhd;
		struct cell_array *y = loc.y;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, x, y, fn);
	
		release_func(fn);
	
		if (err)
			goto cleanup;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
cleanup:
	return err;
}

int
ptr388(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	struct lex_vars {
		struct cell_func *is_simple;
	} *lex;
	
	lex = (struct lex_vars *)self->fv;
	
	stkhd = &stk[0];
	err = 0;

	{
		struct cell_func *fn = lex->is_simple;
		struct cell_array *arg = alpha;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_array *x = *--stkhd;
	
		err = guard_check(x);
	
		release_array(x);
	
		if (err > 0)
			goto cleanup;
	
		if (!err) {
			{
				struct cell_func *fn = lex->is_simple;
				struct cell_array *arg = omega;
				struct cell_array **dst = (struct cell_array **)stkhd++;
			
				err = (fn->fptr)(dst, NULL, arg, fn);
			
				if (err)
					goto cleanup;
			}
			
			*z = *--stkhd;
			goto cleanup;
			
		}
	}
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		size_t *shp = NULL;
		int16_t dat[] = {0};
	
		err = mk_array(&arr, typ, STG_DEVICE, rnk, shp);
	
		if (err)
			goto cleanup;
	
		err = fill_array(arr, dat);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = arr;
	}
	*z = *--stkhd;
	goto cleanup;
	
cleanup:
	return err;
}

int
ptr389(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	stkhd = &stk[0];
	err = 0;

	{
		struct cell_func *fn = cdf_prim.q_dr;
		struct cell_array *arg = omega;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		size_t *shp = NULL;
		int16_t dat[] = {1289};
	
		err = mk_array(&arr, typ, STG_DEVICE, rnk, shp);
	
		if (err)
			goto cleanup;
	
		err = fill_array(arr, dat);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = arr;
	}
	{
		struct cell_array *x = *--stkhd;
		struct cell_func *fn = cdf_prim.eql;
		struct cell_array *y = *--stkhd;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, x, y, fn);
	
		release_array(x);
		release_array(y);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_array *x = *--stkhd;
	
		err = guard_check(x);
	
		release_array(x);
	
		if (err > 0)
			goto cleanup;
	
		if (!err) {
			{
				struct cell_func *fn = conjugate_vec;
				struct cell_array *arg = omega;
				struct cell_array **dst = (struct cell_array **)stkhd++;
			
				err = (fn->fptr)(dst, NULL, arg, fn);
			
				if (err)
					goto cleanup;
			}
			
			*z = *--stkhd;
			goto cleanup;
			
		}
	}
	
	*z = omega;
	retain_cell(omega);
	goto cleanup;
	
cleanup:
	return err;
}

int
ptr390(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	stkhd = &stk[0];
	err = 0;

	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		size_t *shp = NULL;
		int16_t dat[] = {0};
	
		err = mk_array(&arr, typ, STG_DEVICE, rnk, shp);
	
		if (err)
			goto cleanup;
	
		err = fill_array(arr, dat);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = arr;
	}
	*z = *--stkhd;
	goto cleanup;
	
cleanup:
	return err;
}

int
ptr391(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	stkhd = &stk[0];
	err = 0;

	*z = omega;
	retain_cell(omega);
	goto cleanup;
	
cleanup:
	return err;
}

int
ptr392(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	stkhd = &stk[0];
	err = 0;

	*z = alpha;
	retain_cell(alpha);
	goto cleanup;
	
cleanup:
	return err;
}

int
ptr393(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	stkhd = &stk[0];
	err = 0;

	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		size_t *shp = NULL;
		int16_t dat[] = {1};
	
		err = mk_array(&arr, typ, STG_DEVICE, rnk, shp);
	
		if (err)
			goto cleanup;
	
		err = fill_array(arr, dat);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = arr;
	}
	*z = *--stkhd;
	goto cleanup;
	
cleanup:
	return err;
}

int
ptr394(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	stkhd = &stk[0];
	err = 0;

	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		size_t *shp = NULL;
		int16_t dat[] = {16};
	
		err = mk_array(&arr, typ, STG_DEVICE, rnk, shp);
	
		if (err)
			goto cleanup;
	
		err = fill_array(arr, dat);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = arr;
	}
	{
		struct cell_func *fn = cdf_prim.q_signal;
		struct cell_array *arg = *--stkhd;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
cleanup:
	return err;
}

EXPORT int
q_signal(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.q_signal;

	return self->fptr(z, l, r, self);
}

EXPORT int
q_signal_dwa(void *z, void *l, void *r)
{
	return call_dwa(q_signal, z, l, r);
}

EXPORT int
q_dr(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.q_dr;

	return self->fptr(z, l, r, self);
}

EXPORT int
q_dr_dwa(void *z, void *l, void *r)
{
	return call_dwa(q_dr, z, l, r);
}

EXPORT int
eqv(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.eqv;

	return self->fptr(z, l, r, self);
}

EXPORT int
eqv_dwa(void *z, void *l, void *r)
{
	return call_dwa(eqv, z, l, r);
}

EXPORT int
rnk_eqv(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.rnk_eqv;

	return self->fptr(z, l, r, self);
}

EXPORT int
rnk_eqv_dwa(void *z, void *l, void *r)
{
	return call_dwa(rnk_eqv, z, l, r);
}

EXPORT int
shp_eqv(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.shp_eqv;

	return self->fptr(z, l, r, self);
}

EXPORT int
shp_eqv_dwa(void *z, void *l, void *r)
{
	return call_dwa(shp_eqv, z, l, r);
}

EXPORT int
is_empty(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.is_empty;

	return self->fptr(z, l, r, self);
}

EXPORT int
is_empty_dwa(void *z, void *l, void *r)
{
	return call_dwa(is_empty, z, l, r);
}

EXPORT int
count(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.count;

	return self->fptr(z, l, r, self);
}

EXPORT int
count_dwa(void *z, void *l, void *r)
{
	return call_dwa(count, z, l, r);
}

EXPORT int
is_simple(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.is_simple;

	return self->fptr(z, l, r, self);
}

EXPORT int
is_simple_dwa(void *z, void *l, void *r)
{
	return call_dwa(is_simple, z, l, r);
}

EXPORT int
elem(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.elem;

	return self->fptr(z, l, r, self);
}

EXPORT int
elem_dwa(void *z, void *l, void *r)
{
	return call_dwa(elem, z, l, r);
}

EXPORT int
eptr(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.eptr;

	return self->fptr(z, l, r, self);
}

EXPORT int
eptr_dwa(void *z, void *l, void *r)
{
	return call_dwa(eptr, z, l, r);
}

EXPORT int
incr(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.incr;

	return self->fptr(z, l, r, self);
}

EXPORT int
incr_dwa(void *z, void *l, void *r)
{
	return call_dwa(incr, z, l, r);
}

EXPORT int
shaped(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.shaped;

	return self->fptr(z, l, r, self);
}

EXPORT int
shaped_dwa(void *z, void *l, void *r)
{
	return call_dwa(shaped, z, l, r);
}

EXPORT int
store(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.store;

	return self->fptr(z, l, r, self);
}

EXPORT int
store_dwa(void *z, void *l, void *r)
{
	return call_dwa(store, z, l, r);
}

EXPORT int
squeeze(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.squeeze;

	return self->fptr(z, l, r, self);
}

EXPORT int
squeeze_dwa(void *z, void *l, void *r)
{
	return call_dwa(squeeze, z, l, r);
}

EXPORT int
is_bound(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.is_bound;

	return self->fptr(z, l, r, self);
}

EXPORT int
is_bound_dwa(void *z, void *l, void *r)
{
	return call_dwa(is_bound, z, l, r);
}

EXPORT int
can_ext_by(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.can_ext_by;

	return self->fptr(z, l, r, self);
}

EXPORT int
can_ext_by_dwa(void *z, void *l, void *r)
{
	return call_dwa(can_ext_by, z, l, r);
}

EXPORT int
chk_ext_scl(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.chk_ext_scl;

	return self->fptr(z, l, r, self);
}

EXPORT int
chk_ext_scl_dwa(void *z, void *l, void *r)
{
	return call_dwa(chk_ext_scl, z, l, r);
}

EXPORT int
conjugate(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.conjugate;

	return self->fptr(z, l, r, self);
}

EXPORT int
conjugate_dwa(void *z, void *l, void *r)
{
	return call_dwa(conjugate, z, l, r);
}

EXPORT int
add(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.add;

	return self->fptr(z, l, r, self);
}

EXPORT int
add_dwa(void *z, void *l, void *r)
{
	return call_dwa(add, z, l, r);
}

EXPORT int
rgt(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.rgt;

	return self->fptr(z, l, r, self);
}

EXPORT int
rgt_dwa(void *z, void *l, void *r)
{
	return call_dwa(rgt, z, l, r);
}

EXPORT int
lft(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.lft;

	return self->fptr(z, l, r, self);
}

EXPORT int
lft_dwa(void *z, void *l, void *r)
{
	return call_dwa(lft, z, l, r);
}

EXPORT int
eql(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.eql;

	return self->fptr(z, l, r, self);
}

EXPORT int
eql_dwa(void *z, void *l, void *r)
{
	return call_dwa(eql, z, l, r);
}

EXPORT int
enclose(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.enclose;

	return self->fptr(z, l, r, self);
}

EXPORT int
enclose_dwa(void *z, void *l, void *r)
{
	return call_dwa(enclose, z, l, r);
}

EXPORT int
par(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.par;

	return self->fptr(z, l, r, self);
}

EXPORT int
par_dwa(void *z, void *l, void *r)
{
	return call_dwa(par, z, l, r);
}

