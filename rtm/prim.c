#include "codfns.h"

EXPORT int
DyalogGetInterpreterFunctions(void *p)
{
    return set_dwafns(p);
}

extern struct cell_func *q_signal_ibeam;
extern struct cell_func *q_dr_ibeam;
extern struct cell_func *rnk_eqv_ibeam;
extern struct cell_func *shp_eqv_ibeam;
extern struct cell_func *is_empty_ibeam;
extern struct cell_func *count_ibeam;
extern struct cell_func *is_simple_ibeam;
extern struct cell_func *elem_ibeam;
extern struct cell_func *incr_ibeam;
extern struct cell_func *shaped_ibeam;
extern struct cell_func *store_ibeam;
extern struct cell_func *squeeze_ibeam;
extern struct cell_func *is_bound_ibeam;
extern struct cell_func *can_ext_by_ibeam;
extern struct cell_func *conjugate_vec;
extern struct cell_func *add_vec;
extern struct cell_func *eql_vec;

int ptr331(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr333(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr335(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr336(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr337(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr338(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr339(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr332(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr330(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr334(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);

int cdf_prim_flag = 0;

EXPORT struct cdf_prim_loc {
	unsigned int __count;
	wchar_t **__names;
	struct cell_func *q_signal;
	struct cell_func *q_dr;
	struct cell_func *rnk_eqv;
	struct cell_func *shp_eqv;
	struct cell_func *is_empty;
	struct cell_func *count;
	struct cell_func *is_simple;
	struct cell_func *elem;
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
	struct cell_func *eql;
} cdf_prim;

wchar_t *cdf_prim_names[] = {L"q_signal", L"q_dr", L"rnk_eqv", L"shp_eqv", L"is_empty", L"count", L"is_simple", L"elem", L"incr", L"shaped", L"store", L"squeeze", L"is_bound", L"can_ext_by", L"ambiv", L"chk_ext_scl", L"elem_map", L"scalar", L"conjugate", L"add", L"rgt", L"eql"};

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

	loc.__count = 22;
	loc.__names = cdf_prim_names;
	loc.q_signal = NULL;
	loc.q_dr = NULL;
	loc.rnk_eqv = NULL;
	loc.shp_eqv = NULL;
	loc.is_empty = NULL;
	loc.count = NULL;
	loc.is_simple = NULL;
	loc.elem = NULL;
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
	loc.eql = NULL;

	err = 0;

	loc.q_signal = *stkhd++ = retain_cell(q_signal_ibeam);
	release_cell(*--stkhd);
	
	loc.q_dr = *stkhd++ = retain_cell(q_dr_ibeam);
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
	
	err = mk_func((struct cell_func **)stkhd++, ptr330, 0);
	if (err)
		goto cleanup;
	
	loc.ambiv = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	err = mk_func((struct cell_func **)stkhd++, ptr331, 0);
	if (err)
		goto cleanup;
	
	loc.chk_ext_scl = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	err = mk_func((struct cell_func **)stkhd++, ptr332, 0);
	if (err)
		goto cleanup;
	
	loc.elem_map = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	err = mk_func((struct cell_func **)stkhd++, ptr334, 0);
	if (err)
		goto cleanup;
	
	loc.scalar = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	err = mk_func((struct cell_func **)stkhd++, ptr336, 0);
	if (err)
		goto cleanup;
	
	loc.conjugate = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	err = mk_func((struct cell_func **)stkhd++, ptr337, 0);
	if (err)
		goto cleanup;
	
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
	
	err = mk_func((struct cell_func **)stkhd++, ptr338, 0);
	if (err)
		goto cleanup;
	
	loc.rgt = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	err = mk_func((struct cell_func **)stkhd++, ptr339, 0);
	if (err)
		goto cleanup;
	
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
	

	cdf_prim = loc;

cleanup:
	return err;
}

int
ptr330(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *alphaalpha, *omegaomega;
	void *stk[128];
	void **stkhd;
	int err;

	alphaalpha = self->fv[0];
	omegaomega = self->fv[1];

	struct lex_vars {
		struct cell_func *is_bound;
	} *lex;
	
	lex = (struct lex_vars *)&self->fv[2];
	
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
ptr331(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	struct lex_vars {
		struct cell_func *shp_eqv;
		struct cell_func *can_ext_by;
		struct cell_func *shaped;
		struct cell_func *rnk_eqv;
	} *lex;
	
	lex = (struct lex_vars *)&self->fv[0];
	
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
ptr332(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *alphaalpha;
	void *stk[128];
	void **stkhd;
	int err;

	alphaalpha = self->fv[0];

	struct {
		struct cell_array *z;
		struct cell_array *x;
		struct cell_array *y;
		struct cell_func *fn;
		struct cell_array *cnt;
		struct cell_array *_;
	} loc;
	
	struct lex_vars {
		struct cell_func *shaped;
		struct cell_func *count;
		struct cell_func *incr;
		struct cell_func *elem;
		struct cell_func *store;
		struct cell_func *squeeze;
	} *lex;
	
	lex = (struct lex_vars *)&self->fv[1];
	
	stkhd = &stk[0];
	err = 0;

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
		struct cell_func *fn = cdf_prim.rgt;
		struct cell_array *arg = *--stkhd;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	}
	
	err = mk_func((struct cell_func **)stkhd++, ptr333, 0);
	if (err)
		goto cleanup;
	
	{
		struct cell_func *x = *--stkhd;
		struct cell_func *op = cdf_prim.pow;
		struct cell_array *y = loc.cnt;
		struct cell_func **dst = (struct cell_func **)stkhd++;
	
		err = apply_dop(dst, op, x, y);
	
		release_func(x);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_func *fn = *--stkhd;
		struct cell_array *arg = *--stkhd;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, NULL, arg, fn);
	
		release_func(fn);
		release_array(arg);
	
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
ptr333(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	struct lex_vars {
		struct cell_func *incr;
		struct cell_array *z;
		struct cell_func *elem;
		struct cell_func *store;
		struct cell_array *x;
		struct cell_func *fn;
		struct cell_array *y;
	} *lex;
	
	lex = (struct lex_vars *)&self->fv[0];
	
	stkhd = &stk[0];
	err = 0;

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
		struct cell_func *fn = lex->elem;
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
	
	*z = *--stkhd;
	goto cleanup;
	
cleanup:
	return err;
}

int
ptr334(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *alphaalpha, *omegaomega;
	void *stk[128];
	void **stkhd;
	int err;

	alphaalpha = self->fv[0];
	omegaomega = self->fv[1];

	struct {
		struct cell_array *x;
		struct cell_array *y;
	} loc;
	
	struct lex_vars {
		struct cell_func *chk_ext_scl;
		struct cell_func *is_empty;
		struct cell_func *shaped;
		struct cell_func *is_simple;
		struct cell_func *elem_map;
	} *lex;
	
	lex = (struct lex_vars *)&self->fv[2];
	
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
	
	*--stkhd = *stkhd++ = retain_cell(*--stkhd);
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
	
	err = mk_func((struct cell_func **)stkhd++, ptr335, 0);
	if (err)
		goto cleanup;
	
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
		struct cell_func *x = cdf_prim.del;
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
ptr335(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	struct lex_vars {
		struct cell_func *is_simple;
	} *lex;
	
	lex = (struct lex_vars *)&self->fv[0];
	
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
	
	*z = *--stkhd;
	goto cleanup;
	
cleanup:
	return err;
}

int
ptr336(struct cell_array **z,
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
ptr337(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	stkhd = &stk[0];
	err = 0;

	*z = *--stkhd;
	goto cleanup;
	
cleanup:
	return err;
}

int
ptr338(struct cell_array **z,
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
ptr339(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	stkhd = &stk[0];
	err = 0;

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

