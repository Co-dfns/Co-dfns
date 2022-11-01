#include "codfns.h"

EXPORT int
DyalogGetInterpreterFunctions(void *p)
{
    return set_dwafns(p);
}

extern struct cell_func *q_signal_ibeam;
extern struct cell_func *q_dr_ibeam;
extern struct cell_func *q_veach_ibeam;
extern struct cell_func *q_ambiv_ibeam;
extern struct cell_func *shp_ibeam;
extern struct cell_func *cat_ibeam;
extern struct cell_func *eqv_ibeam;
extern struct cell_func *nqv_ibeam;
extern struct cell_func *is_simple_ibeam;
extern struct cell_func *max_shp_ibeam;
extern struct cell_func *conjugate_vec;
extern struct cell_func *add_vec;

int ptr208(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr209(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr211(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr212(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr213(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr210(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);

int cdf_prim_flag = 0;

EXPORT struct cdf_prim_loc {
	unsigned int __count;
	wchar_t **__names;
	struct cell_func *q_signal;
	struct cell_func *q_dr;
	struct cell_func *q_veach;
	struct cell_func *q_ambiv;
	struct cell_func *rho;
	struct cell_func *cat;
	struct cell_func *eqv;
	struct cell_func *nqv;
	struct cell_func *is_simple;
	struct cell_func *max_shp;
	struct cell_func *chk_scl;
	struct cell_func *both_simple;
	struct cell_func *scalar;
	struct cell_func *conjugate;
	struct cell_func *add;
	struct cell_func *rgt;
	struct cell_func *lft;
} cdf_prim;

wchar_t *cdf_prim_names[] = {L"q_signal", L"q_dr", L"q_veach", L"q_ambiv", L"rho", L"cat", L"eqv", L"nqv", L"is_simple", L"max_shp", L"chk_scl", L"both_simple", L"scalar", L"conjugate", L"add", L"rgt", L"lft"};

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

	loc.__count = 17;
	loc.__names = cdf_prim_names;
	loc.q_signal = NULL;
	loc.q_dr = NULL;
	loc.q_veach = NULL;
	loc.q_ambiv = NULL;
	loc.rho = NULL;
	loc.cat = NULL;
	loc.eqv = NULL;
	loc.nqv = NULL;
	loc.is_simple = NULL;
	loc.max_shp = NULL;
	loc.chk_scl = NULL;
	loc.both_simple = NULL;
	loc.scalar = NULL;
	loc.conjugate = NULL;
	loc.add = NULL;
	loc.rgt = NULL;
	loc.lft = NULL;

	err = 0;

	loc.q_signal = *stkhd++ = retain_cell(q_signal_ibeam);
	release_cell(*--stkhd);
	
	loc.q_dr = *stkhd++ = retain_cell(q_dr_ibeam);
	release_cell(*--stkhd);
	
	loc.q_veach = *stkhd++ = retain_cell(q_veach_ibeam);
	release_cell(*--stkhd);
	
	loc.q_ambiv = *stkhd++ = retain_cell(q_ambiv_ibeam);
	release_cell(*--stkhd);
	
	loc.rho = *stkhd++ = retain_cell(shp_ibeam);
	release_cell(*--stkhd);
	
	loc.cat = *stkhd++ = retain_cell(cat_ibeam);
	release_cell(*--stkhd);
	
	loc.eqv = *stkhd++ = retain_cell(eqv_ibeam);
	release_cell(*--stkhd);
	
	loc.nqv = *stkhd++ = retain_cell(nqv_ibeam);
	release_cell(*--stkhd);
	
	loc.is_simple = *stkhd++ = retain_cell(is_simple_ibeam);
	release_cell(*--stkhd);
	
	loc.max_shp = *stkhd++ = retain_cell(max_shp_ibeam);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr208, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	loc.chk_scl = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr209, 1);
	
		if (err)
			goto cleanup;
	
		fn->fv[0] = retain_cell(loc.is_simple);
	
		*stkhd++ = fn;
	}
	
	loc.both_simple = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr210, 3);
	
		if (err)
			goto cleanup;
	
		fn->fv[0] = retain_cell(loc.both_simple);
		fn->fv[1] = retain_cell(loc.chk_scl);
		fn->fv[2] = retain_cell(loc.max_shp);
	
		*stkhd++ = fn;
	}
	
	loc.scalar = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr211, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	loc.conjugate = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *x = add_vec;
		struct cell_func *op = loc.scalar;
		struct cell_func **dst = (struct cell_func **)stkhd++;
	
		err = apply_mop(dst, op, x);
	
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_func *x = loc.conjugate;
		struct cell_func *op = cdf_prim.q_ambiv;
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
	
		err = mk_func(&fn, ptr212, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	loc.rgt = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr213, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	loc.lft = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	

	cdf_prim = loc;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr208(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	stkhd = &stk[0];
	err = -1;

	{
		struct cell_func *fn = cdf_prim.rho;
		struct cell_array *arg = omega;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_func *fn = cdf_prim.rho;
		struct cell_array *arg = alpha;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_array *x = *--stkhd;
		struct cell_func *fn = cdf_prim.eqv;
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
			
			err = -1;
			goto cleanup;
		}
	}
	
	{
		struct cell_func *fn = cdf_prim.cat;
		struct cell_array *arg = alpha;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_func *fn = cdf_prim.nqv;
		struct cell_array *arg = *--stkhd;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	}
	
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
		struct cell_array *x = *--stkhd;
		struct cell_func *fn = cdf_prim.eqv;
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
			
			err = -1;
			goto cleanup;
		}
	}
	
	{
		struct cell_func *fn = cdf_prim.cat;
		struct cell_array *arg = omega;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_func *fn = cdf_prim.nqv;
		struct cell_array *arg = *--stkhd;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	}
	
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
		struct cell_array *x = *--stkhd;
		struct cell_func *fn = cdf_prim.eqv;
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
			
			err = -1;
			goto cleanup;
		}
	}
	
	{
		struct cell_func *fn = cdf_prim.rho;
		struct cell_array *arg = omega;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_func *fn = cdf_prim.nqv;
		struct cell_array *arg = *--stkhd;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_func *fn = cdf_prim.rho;
		struct cell_array *arg = alpha;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_func *fn = cdf_prim.nqv;
		struct cell_array *arg = *--stkhd;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_array *x = *--stkhd;
		struct cell_func *fn = cdf_prim.eqv;
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
			
			err = -1;
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
	release_env(stk, stkhd);
	return err;
}

int
ptr209(struct cell_array **z,
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
	err = -1;

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
			
			err = -1;
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
	release_env(stk, stkhd);
	return err;
}

int
ptr210(struct cell_array **z,
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
		struct cell_array *s;
	} loc;
	
	struct lex_vars {
		struct cell_func *both_simple;
		struct cell_func *chk_scl;
		struct cell_func *max_shp;
	} *lex;
	
	lex = (struct lex_vars *)deldel->fv;
	
	loc.s = NULL;
	stkhd = &stk[0];
	err = -1;

	{
		struct cell_array *x = alpha;
		struct cell_func *fn = lex->chk_scl;
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
			err = -1;
			goto cleanup;
		}
	}
	
	{
		struct cell_array *x = alpha;
		struct cell_func *fn = lex->max_shp;
		struct cell_array *y = omega;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, x, y, fn);
	
		if (err)
			goto cleanup;
	}
	
	loc.s = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_array *x = alpha;
		struct cell_func *fn = lex->both_simple;
		struct cell_array *y = omega;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, x, y, fn);
	
		if (err)
			goto cleanup;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	{
		struct cell_array *x = *--stkhd;
	
		err = guard_check(x);
	
		release_array(x);
	
		if (err > 0)
			goto cleanup;
	
		if (!err) {
			{
				struct cell_array *x = alpha;
				struct cell_func *fn = alphaalpha;
				struct cell_array *y = omega;
				struct cell_array **dst = (struct cell_array **)stkhd++;
			
				err = (fn->fptr)(dst, x, y, fn);
			
				if (err)
					goto cleanup;
			}
			
			{
				struct cell_array *x = loc.s;
				struct cell_func *fn = cdf_prim.rho;
				struct cell_array *y = *--stkhd;
				struct cell_array **dst = (struct cell_array **)stkhd++;
			
				err = (fn->fptr)(dst, x, y, fn);
			
				release_array(y);
			
				if (err)
					goto cleanup;
			}
			
			err = -1;
			goto cleanup;
		}
	}
	
	{
		struct cell_func *x = self;
		struct cell_func *op = cdf_prim.q_veach;
		struct cell_func **dst = (struct cell_func **)stkhd++;
	
		err = apply_mop(dst, op, x);
	
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_array *x = alpha;
		struct cell_func *fn = *--stkhd;
		struct cell_array *y = omega;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, x, y, fn);
	
		release_func(fn);
	
		if (err)
			goto cleanup;
	}
	
	{
		struct cell_array *x = loc.s;
		struct cell_func *fn = cdf_prim.rho;
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
	release_env(stk, stkhd);
	release_env((void **)&loc, (void **)(&loc + 1));
	return err;
}

int
ptr211(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	stkhd = &stk[0];
	err = -1;

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
		struct cell_func *fn = cdf_prim.eqv;
		struct cell_array *y = *--stkhd;
		struct cell_array **dst = (struct cell_array **)stkhd++;
	
		err = (fn->fptr)(dst, x, y, fn);
	
		release_array(x);
		release_array(y);
	
		if (err)
			goto cleanup;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
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
			
			err = -1;
			goto cleanup;
		}
	}
	
	*z = omega;
	retain_cell(omega);
	goto cleanup;
	
cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr212(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	stkhd = &stk[0];
	err = -1;

	*z = omega;
	retain_cell(omega);
	goto cleanup;
	
cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr213(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	stkhd = &stk[0];
	err = -1;

	*z = alpha;
	retain_cell(alpha);
	goto cleanup;
	
cleanup:
	release_env(stk, stkhd);
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
q_veach(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.q_veach;

	return self->fptr(z, l, r, self);
}

EXPORT int
q_veach_dwa(void *z, void *l, void *r)
{
	return call_dwa(q_veach, z, l, r);
}

EXPORT int
q_ambiv(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.q_ambiv;

	return self->fptr(z, l, r, self);
}

EXPORT int
q_ambiv_dwa(void *z, void *l, void *r)
{
	return call_dwa(q_ambiv, z, l, r);
}

EXPORT int
rho(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.rho;

	return self->fptr(z, l, r, self);
}

EXPORT int
rho_dwa(void *z, void *l, void *r)
{
	return call_dwa(rho, z, l, r);
}

EXPORT int
cat(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.cat;

	return self->fptr(z, l, r, self);
}

EXPORT int
cat_dwa(void *z, void *l, void *r)
{
	return call_dwa(cat, z, l, r);
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
nqv(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.nqv;

	return self->fptr(z, l, r, self);
}

EXPORT int
nqv_dwa(void *z, void *l, void *r)
{
	return call_dwa(nqv, z, l, r);
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
max_shp(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.max_shp;

	return self->fptr(z, l, r, self);
}

EXPORT int
max_shp_dwa(void *z, void *l, void *r)
{
	return call_dwa(max_shp, z, l, r);
}

EXPORT int
chk_scl(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.chk_scl;

	return self->fptr(z, l, r, self);
}

EXPORT int
chk_scl_dwa(void *z, void *l, void *r)
{
	return call_dwa(chk_scl, z, l, r);
}

EXPORT int
both_simple(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.both_simple;

	return self->fptr(z, l, r, self);
}

EXPORT int
both_simple_dwa(void *z, void *l, void *r)
{
	return call_dwa(both_simple, z, l, r);
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

