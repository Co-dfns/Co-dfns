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
extern struct cell_func *squeeze_ibeam;
extern struct cell_func *is_simple_ibeam;
extern struct cell_func *is_numeric_ibeam;
extern struct cell_func *max_shp_ibeam;
extern struct cell_func *has_nat_vals_ibeam;
extern struct cell_func *reshape_ibeam;
extern struct cell_func *shape_ibeam;
extern struct cell_func *ravel_ibeam;
extern struct cell_func *same_ibeam;
extern struct cell_func *index_gen_vec;
extern struct cell_func *disclose_ibeam;
extern struct cell_func *conjugate_vec;
extern struct cell_func *add_vec_ibeam;
extern struct cell_func *sub_vec_ibeam;
extern struct cell_func *mul_vec_ibeam;
extern struct cell_func *div_vec_ibeam;

int ptr782(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr783(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr784(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr785(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr786(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr787(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr790(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr791(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr792(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr793(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr794(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr795(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr796(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr797(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr798(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr799(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr800(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr801(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr802(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr803(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr804(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr805(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr806(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr807(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr808(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr809(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr810(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr814(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr788(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr789(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr811(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr812(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);
int ptr813(struct cell_array **,
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
	struct cell_func *squeeze;
	struct cell_func *is_simple;
	struct cell_func *is_numeric;
	struct cell_func *max_shp;
	struct cell_func *has_nat_vals;
	struct cell_func *chk_scl;
	struct cell_func *chk_valid_shape;
	struct cell_func *both_simple;
	struct cell_func *both_numeric;
	struct cell_func *numeric;
	struct cell_func *scalar;
	struct cell_func *rgt;
	struct cell_func *lft;
	struct cell_func *reshape;
	struct cell_func *rho;
	struct cell_func *cat;
	struct cell_func *eqv;
	struct cell_func *nqv;
	struct cell_func *index_gen;
	struct cell_func *index_of;
	struct cell_func *iot;
	struct cell_func *dis;
	struct cell_func *par;
	struct cell_func *conjugate;
	struct cell_func *add;
	struct cell_func *negate;
	struct cell_func *sub;
	struct cell_func *sign;
	struct cell_func *mul;
	struct cell_func *recip;
	struct cell_func *div;
	struct cell_func *split;
	struct cell_func *drop;
	struct cell_func *drp;
	struct cell_func *reverse_last;
	struct cell_func *rotate_last;
	struct cell_func *rot;
	struct cell_func *map_monadic;
	struct cell_func *map_dyadic;
	struct cell_func *map;
	struct cell_func *rdf;
} cdf_prim;

wchar_t *cdf_prim_names[] = {L"q_signal", L"q_dr", L"q_veach", L"q_ambiv", L"squeeze", L"is_simple", L"is_numeric", L"max_shp", L"has_nat_vals", L"chk_scl", L"chk_valid_shape", L"both_simple", L"both_numeric", L"numeric", L"scalar", L"rgt", L"lft", L"reshape", L"rho", L"cat", L"eqv", L"nqv", L"index_gen", L"index_of", L"iot", L"dis", L"par", L"conjugate", L"add", L"negate", L"sub", L"sign", L"mul", L"recip", L"div", L"split", L"drop", L"drp", L"reverse_last", L"rotate_last", L"rot", L"map_monadic", L"map_dyadic", L"map", L"rdf"};

EXPORT int
cdf_prim_init(void)
{
	struct cdf_prim_loc *loc;
	void *stk[128];
	void **stkhd;
	int err;

	if (cdf_prim_flag)
		return 0;

	stkhd = &stk[0];
	cdf_prim_flag = 1;
	cdf_prim_init();

	loc = &cdf_prim;
	loc->__count = 45;
	loc->__names = cdf_prim_names;
	loc->q_signal = NULL;
	loc->q_dr = NULL;
	loc->q_veach = NULL;
	loc->q_ambiv = NULL;
	loc->squeeze = NULL;
	loc->is_simple = NULL;
	loc->is_numeric = NULL;
	loc->max_shp = NULL;
	loc->has_nat_vals = NULL;
	loc->chk_scl = NULL;
	loc->chk_valid_shape = NULL;
	loc->both_simple = NULL;
	loc->both_numeric = NULL;
	loc->numeric = NULL;
	loc->scalar = NULL;
	loc->rgt = NULL;
	loc->lft = NULL;
	loc->reshape = NULL;
	loc->rho = NULL;
	loc->cat = NULL;
	loc->eqv = NULL;
	loc->nqv = NULL;
	loc->index_gen = NULL;
	loc->index_of = NULL;
	loc->iot = NULL;
	loc->dis = NULL;
	loc->par = NULL;
	loc->conjugate = NULL;
	loc->add = NULL;
	loc->negate = NULL;
	loc->sub = NULL;
	loc->sign = NULL;
	loc->mul = NULL;
	loc->recip = NULL;
	loc->div = NULL;
	loc->split = NULL;
	loc->drop = NULL;
	loc->drp = NULL;
	loc->reverse_last = NULL;
	loc->rotate_last = NULL;
	loc->rot = NULL;
	loc->map_monadic = NULL;
	loc->map_dyadic = NULL;
	loc->map = NULL;
	loc->rdf = NULL;

	err = 0;

	loc->q_signal = *stkhd++ = retain_cell(q_signal_ibeam);
	release_cell(*--stkhd);
	
	loc->q_dr = *stkhd++ = retain_cell(q_dr_ibeam);
	release_cell(*--stkhd);
	
	loc->q_veach = *stkhd++ = retain_cell(q_veach_ibeam);
	release_cell(*--stkhd);
	
	loc->q_ambiv = *stkhd++ = retain_cell(q_ambiv_ibeam);
	release_cell(*--stkhd);
	
	loc->squeeze = *stkhd++ = retain_cell(squeeze_ibeam);
	release_cell(*--stkhd);
	
	loc->is_simple = *stkhd++ = retain_cell(is_simple_ibeam);
	release_cell(*--stkhd);
	
	loc->is_numeric = *stkhd++ = retain_cell(is_numeric_ibeam);
	release_cell(*--stkhd);
	
	loc->max_shp = *stkhd++ = retain_cell(max_shp_ibeam);
	release_cell(*--stkhd);
	
	loc->has_nat_vals = *stkhd++ = retain_cell(has_nat_vals_ibeam);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr782, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	loc->chk_scl = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr783, 1);
	
		if (err)
			goto cleanup;
	
		fn->fv[0] = retain_cell(loc->has_nat_vals);
	
		*stkhd++ = fn;
	}
	
	loc->chk_valid_shape = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr786, 1);
	
		if (err)
			goto cleanup;
	
		fn->fv[0] = retain_cell(loc->is_simple);
	
		*stkhd++ = fn;
	}
	
	loc->both_simple = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr787, 1);
	
		if (err)
			goto cleanup;
	
		fn->fv[0] = retain_cell(loc->is_numeric);
	
		*stkhd++ = fn;
	}
	
	loc->both_numeric = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr788, 1);
	
		if (err)
			goto cleanup;
	
		fn->fv[0] = retain_cell(loc->both_numeric);
	
		*stkhd++ = fn;
	}
	
	loc->numeric = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr789, 3);
	
		if (err)
			goto cleanup;
	
		fn->fv[0] = retain_cell(loc->both_simple);
		fn->fv[1] = retain_cell(loc->chk_scl);
		fn->fv[2] = retain_cell(loc->max_shp);
	
		*stkhd++ = fn;
	}
	
	loc->scalar = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr790, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	loc->rgt = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr791, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	loc->lft = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr792, 1);
	
		if (err)
			goto cleanup;
	
		fn->fv[0] = retain_cell(loc->chk_valid_shape);
	
		*stkhd++ = fn;
	}
	
	loc->reshape = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *x = shape_ibeam;
		struct cell_func *op = cdf_prim.q_ambiv;
		struct cell_func *y = loc->reshape;
		struct cell_func *dst;
	
		err = apply_dop(&dst, op, x, y);
	
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	loc->rho = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr793, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	{
		struct cell_func *x = ravel_ibeam;
		struct cell_func *op = cdf_prim.q_ambiv;
		struct cell_func *y = *--stkhd;
		struct cell_func *dst;
	
		err = apply_dop(&dst, op, x, y);
	
		release_func(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	loc->cat = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr794, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	{
		struct cell_func *x = *--stkhd;
		struct cell_func *op = cdf_prim.q_ambiv;
		struct cell_func *y = same_ibeam;
		struct cell_func *dst;
	
		err = apply_dop(&dst, op, x, y);
	
		release_func(x);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	loc->eqv = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr796, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr795, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	{
		struct cell_func *x = *--stkhd;
		struct cell_func *op = cdf_prim.q_ambiv;
		struct cell_func *y = *--stkhd;
		struct cell_func *dst;
	
		err = apply_dop(&dst, op, x, y);
	
		release_func(x);
		release_func(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	loc->nqv = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr797, 1);
	
		if (err)
			goto cleanup;
	
		fn->fv[0] = retain_cell(loc->chk_valid_shape);
	
		*stkhd++ = fn;
	}
	
	loc->index_gen = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr798, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	loc->index_of = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *x = loc->index_gen;
		struct cell_func *op = cdf_prim.q_ambiv;
		struct cell_func *y = loc->index_of;
		struct cell_func *dst;
	
		err = apply_dop(&dst, op, x, y);
	
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	loc->iot = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr799, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	{
		struct cell_func *x = disclose_ibeam;
		struct cell_func *op = cdf_prim.q_ambiv;
		struct cell_func *y = *--stkhd;
		struct cell_func *dst;
	
		err = apply_dop(&dst, op, x, y);
	
		release_func(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	loc->dis = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr801, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr800, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	{
		struct cell_func *x = *--stkhd;
		struct cell_func *op = cdf_prim.q_ambiv;
		struct cell_func *y = *--stkhd;
		struct cell_func *dst;
	
		err = apply_dop(&dst, op, x, y);
	
		release_func(x);
		release_func(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	loc->par = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr802, 1);
	
		if (err)
			goto cleanup;
	
		fn->fv[0] = retain_cell(loc->squeeze);
	
		*stkhd++ = fn;
	}
	
	loc->conjugate = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *x = add_vec_ibeam;
		struct cell_func *op = loc->numeric;
		struct cell_func *dst;
	
		err = apply_mop(&dst, op, x);
	
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *x = *--stkhd;
		struct cell_func *op = loc->scalar;
		struct cell_func *dst;
	
		err = apply_mop(&dst, op, x);
	
		release_func(x);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *x = loc->conjugate;
		struct cell_func *op = cdf_prim.q_ambiv;
		struct cell_func *y = *--stkhd;
		struct cell_func *dst;
	
		err = apply_dop(&dst, op, x, y);
	
		release_func(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	loc->add = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr803, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	loc->negate = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *x = sub_vec_ibeam;
		struct cell_func *op = loc->numeric;
		struct cell_func *dst;
	
		err = apply_mop(&dst, op, x);
	
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *x = *--stkhd;
		struct cell_func *op = loc->scalar;
		struct cell_func *dst;
	
		err = apply_mop(&dst, op, x);
	
		release_func(x);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *x = loc->negate;
		struct cell_func *op = cdf_prim.q_ambiv;
		struct cell_func *y = *--stkhd;
		struct cell_func *dst;
	
		err = apply_dop(&dst, op, x, y);
	
		release_func(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	loc->sub = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr804, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	loc->sign = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *x = mul_vec_ibeam;
		struct cell_func *op = loc->numeric;
		struct cell_func *dst;
	
		err = apply_mop(&dst, op, x);
	
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *x = *--stkhd;
		struct cell_func *op = loc->scalar;
		struct cell_func *dst;
	
		err = apply_mop(&dst, op, x);
	
		release_func(x);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *x = loc->sign;
		struct cell_func *op = cdf_prim.q_ambiv;
		struct cell_func *y = *--stkhd;
		struct cell_func *dst;
	
		err = apply_dop(&dst, op, x, y);
	
		release_func(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	loc->mul = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr805, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	loc->recip = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *x = div_vec_ibeam;
		struct cell_func *op = loc->numeric;
		struct cell_func *dst;
	
		err = apply_mop(&dst, op, x);
	
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *x = *--stkhd;
		struct cell_func *op = loc->scalar;
		struct cell_func *dst;
	
		err = apply_mop(&dst, op, x);
	
		release_func(x);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *x = loc->recip;
		struct cell_func *op = cdf_prim.q_ambiv;
		struct cell_func *y = *--stkhd;
		struct cell_func *dst;
	
		err = apply_dop(&dst, op, x, y);
	
		release_func(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	loc->div = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr806, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	loc->split = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr807, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	loc->drop = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *x = loc->split;
		struct cell_func *op = cdf_prim.q_ambiv;
		struct cell_func *y = loc->drop;
		struct cell_func *dst;
	
		err = apply_dop(&dst, op, x, y);
	
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	loc->drp = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr808, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	loc->reverse_last = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr809, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	loc->rotate_last = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *x = loc->reverse_last;
		struct cell_func *op = cdf_prim.q_ambiv;
		struct cell_func *y = loc->rotate_last;
		struct cell_func *dst;
	
		err = apply_dop(&dst, op, x, y);
	
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	loc->rot = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr810, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	loc->map_monadic = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr811, 2);
	
		if (err)
			goto cleanup;
	
		fn->fv[0] = retain_cell(loc->chk_scl);
		fn->fv[1] = retain_cell(loc->max_shp);
	
		*stkhd++ = fn;
	}
	
	loc->map_dyadic = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr812, 1);
	
		if (err)
			goto cleanup;
	
		fn->fv[0] = retain_cell(loc->map_dyadic);
	
		*stkhd++ = fn;
	}
	
	loc->map = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr813, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	loc->rdf = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr782(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	stkhd = &stk[0];
	err = 0;

	{
		struct cell_func *fn = cdf_prim.rho;
		struct cell_array *arg = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *fn = cdf_prim.rho;
		struct cell_array *arg = alpha;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *x = *--stkhd;
		struct cell_func *fn = cdf_prim.eqv;
		struct cell_array *y = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(x);
		release_array(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
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
				int16_t dat[] = {0};
			
				err = mk_array(&arr, typ, STG_HOST, rnk);
			
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
	
		err = 0;
	}
	
	{
		struct cell_func *fn = cdf_prim.cat;
		struct cell_array *arg = alpha;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *fn = cdf_prim.nqv;
		struct cell_array *arg = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		int16_t dat[] = {1};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(x);
		release_array(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
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
				int16_t dat[] = {0};
			
				err = mk_array(&arr, typ, STG_HOST, rnk);
			
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
	
		err = 0;
	}
	
	{
		struct cell_func *fn = cdf_prim.cat;
		struct cell_array *arg = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *fn = cdf_prim.nqv;
		struct cell_array *arg = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		int16_t dat[] = {1};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(x);
		release_array(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
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
				int16_t dat[] = {0};
			
				err = mk_array(&arr, typ, STG_HOST, rnk);
			
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
	
		err = 0;
	}
	
	{
		struct cell_func *fn = cdf_prim.rho;
		struct cell_array *arg = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *fn = cdf_prim.nqv;
		struct cell_array *arg = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *fn = cdf_prim.rho;
		struct cell_array *arg = alpha;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *fn = cdf_prim.nqv;
		struct cell_array *arg = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *x = *--stkhd;
		struct cell_func *fn = cdf_prim.eqv;
		struct cell_array *y = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(x);
		release_array(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
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
				int16_t dat[] = {5};
			
				err = mk_array(&arr, typ, STG_HOST, rnk);
			
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
				struct cell_array *dst;
			
				err = (fn->fptr)(&dst, NULL, arg, fn);
			
				release_array(arg);
			
				if (err)
					goto cleanup;
			
				*stkhd++ = dst;
			}
			
			*z = *--stkhd;
			goto cleanup;
			
			err = -1;
			goto cleanup;
		}
	
		err = 0;
	}
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		int16_t dat[] = {4};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr783(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	struct lex_vars {
		struct cell_func *has_nat_vals;
	} *lex;
	
	lex = (struct lex_vars *)self->fv;
	
	stkhd = &stk[0];
	err = 0;

	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr784, 0);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = fn;
	}
	
	{
		struct cell_func *fn = *--stkhd;
		struct cell_array *arg = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_func(fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
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
				int16_t dat[] = {4};
			
				err = mk_array(&arr, typ, STG_HOST, rnk);
			
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
				struct cell_array *dst;
			
				err = (fn->fptr)(&dst, NULL, arg, fn);
			
				release_array(arg);
			
				if (err)
					goto cleanup;
			
				*stkhd++ = dst;
			}
			
			*z = *--stkhd;
			goto cleanup;
			
			err = -1;
			goto cleanup;
		}
	
		err = 0;
	}
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr785, 1);
	
		if (err)
			goto cleanup;
	
		fn->fv[0] = retain_cell(lex->has_nat_vals);
	
		*stkhd++ = fn;
	}
	
	{
		struct cell_func *fn = *--stkhd;
		struct cell_array *arg = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_func(fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
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
				int16_t dat[] = {11};
			
				err = mk_array(&arr, typ, STG_HOST, rnk);
			
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
				struct cell_array *dst;
			
				err = (fn->fptr)(&dst, NULL, arg, fn);
			
				release_array(arg);
			
				if (err)
					goto cleanup;
			
				*stkhd++ = dst;
			}
			
			*z = *--stkhd;
			goto cleanup;
			
			err = -1;
			goto cleanup;
		}
	
		err = 0;
	}
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		int16_t dat[] = {0};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr784(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	struct {
		struct cell_array *rnk;
	} loc_frm, *loc;
	
	loc = &loc_frm;
	
	loc->rnk = NULL;
	stkhd = &stk[0];
	err = 0;

	{
		struct cell_func *fn = cdf_prim.rho;
		struct cell_array *arg = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *fn = cdf_prim.nqv;
		struct cell_array *arg = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	loc->rnk = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		int16_t dat[] = {0};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *y = loc->rnk;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(x);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
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
				int16_t dat[] = {0};
			
				err = mk_array(&arr, typ, STG_HOST, rnk);
			
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
	
		err = 0;
	}
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		int16_t dat[] = {1};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *y = loc->rnk;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(x);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
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
				int16_t dat[] = {0};
			
				err = mk_array(&arr, typ, STG_HOST, rnk);
			
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
	
		err = 0;
	}
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		int16_t dat[] = {1};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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

cleanup:
	release_env(stk, stkhd);
	release_env((void **)loc, (void **)(loc + 1));
	return err;
}

int
ptr785(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	struct lex_vars {
		struct cell_func *has_nat_vals;
	} *lex;
	
	lex = (struct lex_vars *)self->fv;
	
	stkhd = &stk[0];
	err = 0;

	{
		struct cell_func *fn = lex->has_nat_vals;
		struct cell_array *arg = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
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
				int16_t dat[] = {0};
			
				err = mk_array(&arr, typ, STG_HOST, rnk);
			
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
	
		err = 0;
	}
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		int16_t dat[] = {1};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr786(struct cell_array **z,
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
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
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
				struct cell_array *dst;
			
				err = (fn->fptr)(&dst, NULL, arg, fn);
			
				if (err)
					goto cleanup;
			
				*stkhd++ = dst;
			}
			
			*z = *--stkhd;
			goto cleanup;
			
			err = -1;
			goto cleanup;
		}
	
		err = 0;
	}
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		int16_t dat[] = {0};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr787(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	struct lex_vars {
		struct cell_func *is_numeric;
	} *lex;
	
	lex = (struct lex_vars *)self->fv;
	
	stkhd = &stk[0];
	err = 0;

	{
		struct cell_func *fn = lex->is_numeric;
		struct cell_array *arg = alpha;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *x = *--stkhd;
	
		err = guard_check(x);
	
		release_array(x);
	
		if (err > 0)
			goto cleanup;
	
		if (!err) {
			{
				struct cell_func *fn = lex->is_numeric;
				struct cell_array *arg = omega;
				struct cell_array *dst;
			
				err = (fn->fptr)(&dst, NULL, arg, fn);
			
				if (err)
					goto cleanup;
			
				*stkhd++ = dst;
			}
			
			*z = *--stkhd;
			goto cleanup;
			
			err = -1;
			goto cleanup;
		}
	
		err = 0;
	}
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		int16_t dat[] = {0};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr788(struct cell_array **z,
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

	struct lex_vars {
		struct cell_func *both_numeric;
	} *lex;
	
	lex = (struct lex_vars *)deldel->fv;
	
	stkhd = &stk[0];
	err = 0;

	{
		struct cell_array *x = alpha;
		struct cell_func *fn = lex->both_numeric;
		struct cell_array *y = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
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
				struct cell_func *fn = alphaalpha;
				struct cell_array *y = omega;
				struct cell_array *dst;
			
				err = (fn->fptr)(&dst, x, y, fn);
			
				if (err)
					goto cleanup;
			
				*stkhd++ = dst;
			}
			
			*z = *--stkhd;
			goto cleanup;
			
			err = -1;
			goto cleanup;
		}
	
		err = 0;
	}
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		int16_t dat[] = {11};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr789(struct cell_array **z,
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
	} loc_frm, *loc;
	
	loc = &loc_frm;
	
	struct lex_vars {
		struct cell_func *both_simple;
		struct cell_func *chk_scl;
		struct cell_func *max_shp;
	} *lex;
	
	lex = (struct lex_vars *)deldel->fv;
	
	loc->s = NULL;
	stkhd = &stk[0];
	err = 0;

	{
		struct cell_array *x = alpha;
		struct cell_func *fn = lex->chk_scl;
		struct cell_array *y = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
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
	
		err = 0;
	}
	
	{
		struct cell_array *x = alpha;
		struct cell_func *fn = lex->max_shp;
		struct cell_array *y = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	loc->s = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_array *x = alpha;
		struct cell_func *fn = lex->both_simple;
		struct cell_array *y = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
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
				struct cell_func *fn = alphaalpha;
				struct cell_array *y = omega;
				struct cell_array *dst;
			
				err = (fn->fptr)(&dst, x, y, fn);
			
				if (err)
					goto cleanup;
			
				*stkhd++ = dst;
			}
			
			{
				struct cell_array *x = loc->s;
				struct cell_func *fn = cdf_prim.rho;
				struct cell_array *y = *--stkhd;
				struct cell_array *dst;
			
				err = (fn->fptr)(&dst, x, y, fn);
			
				release_array(y);
			
				if (err)
					goto cleanup;
			
				*stkhd++ = dst;
			}
			
			*z = *--stkhd;
			goto cleanup;
			
			err = -1;
			goto cleanup;
		}
	
		err = 0;
	}
	
	{
		struct cell_func *x = self;
		struct cell_func *op = cdf_prim.q_veach;
		struct cell_func *dst;
	
		err = apply_mop(&dst, op, x);
	
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *x = alpha;
		struct cell_func *fn = *--stkhd;
		struct cell_array *y = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_func(fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *x = loc->s;
		struct cell_func *fn = cdf_prim.rho;
		struct cell_array *y = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	release_env((void **)loc, (void **)(loc + 1));
	return err;
}

int
ptr790(struct cell_array **z,
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
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr791(struct cell_array **z,
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
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr792(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	struct lex_vars {
		struct cell_func *chk_valid_shape;
	} *lex;
	
	lex = (struct lex_vars *)self->fv;
	
	stkhd = &stk[0];
	err = 0;

	{
		struct cell_func *fn = lex->chk_valid_shape;
		struct cell_array *arg = alpha;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
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
	
		err = 0;
	}
	
	{
		struct cell_array *x = alpha;
		struct cell_func *fn = reshape_ibeam;
		struct cell_array *y = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr793(struct cell_array **z,
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
		int16_t dat[] = {16};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr794(struct cell_array **z,
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
		int16_t dat[] = {16};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr795(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	stkhd = &stk[0];
	err = 0;

	{
		struct cell_func *fn = cdf_prim.rho;
		struct cell_array *arg = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *fn = cdf_prim.dis;
		struct cell_array *arg = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr796(struct cell_array **z,
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
		int16_t dat[] = {16};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr797(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	struct lex_vars {
		struct cell_func *chk_valid_shape;
	} *lex;
	
	lex = (struct lex_vars *)self->fv;
	
	stkhd = &stk[0];
	err = 0;

	{
		struct cell_func *fn = lex->chk_valid_shape;
		struct cell_array *arg = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
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
	
		err = 0;
	}
	
	{
		struct cell_func *fn = cdf_prim.cat;
		struct cell_array *arg = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *fn = cdf_prim.nqv;
		struct cell_array *arg = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		int16_t dat[] = {0};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(x);
		release_array(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
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
				int16_t dat[] = {0};
			
				err = mk_array(&arr, typ, STG_HOST, rnk);
			
				if (err)
					goto cleanup;
			
				arr->shape[0] = 0;
			
				err = fill_array(arr, dat);
			
				if (err)
					goto cleanup;
			
				*stkhd++ = arr;
			}
			{
				struct cell_func *fn = cdf_prim.par;
				struct cell_array *arg = *--stkhd;
				struct cell_array *dst;
			
				err = (fn->fptr)(&dst, NULL, arg, fn);
			
				release_array(arg);
			
				if (err)
					goto cleanup;
			
				*stkhd++ = dst;
			}
			
			*z = *--stkhd;
			goto cleanup;
			
			err = -1;
			goto cleanup;
		}
	
		err = 0;
	}
	
	{
		struct cell_func *fn = cdf_prim.cat;
		struct cell_array *arg = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *fn = cdf_prim.nqv;
		struct cell_array *arg = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		int16_t dat[] = {1};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(x);
		release_array(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *x = *--stkhd;
	
		err = guard_check(x);
	
		release_array(x);
	
		if (err > 0)
			goto cleanup;
	
		if (!err) {
			{
				struct cell_func *fn = index_gen_vec;
				struct cell_array *arg = omega;
				struct cell_array *dst;
			
				err = (fn->fptr)(&dst, NULL, arg, fn);
			
				if (err)
					goto cleanup;
			
				*stkhd++ = dst;
			}
			
			*z = *--stkhd;
			goto cleanup;
			
			err = -1;
			goto cleanup;
		}
	
		err = 0;
	}
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		int16_t dat[] = {16};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr798(struct cell_array **z,
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
		int16_t dat[] = {16};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr799(struct cell_array **z,
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
		int16_t dat[] = {16};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr800(struct cell_array **z,
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
		int16_t dat[] = {16};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr801(struct cell_array **z,
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
		int16_t dat[] = {16};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr802(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	struct lex_vars {
		struct cell_func *squeeze;
	} *lex;
	
	lex = (struct lex_vars *)self->fv;
	
	stkhd = &stk[0];
	err = 0;

	{
		struct cell_func *fn = lex->squeeze;
		struct cell_array *arg = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *fn = cdf_prim.q_dr;
		struct cell_array *arg = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		int16_t dat[] = {1289};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(x);
		release_array(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
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
				struct cell_array *dst;
			
				err = (fn->fptr)(&dst, NULL, arg, fn);
			
				if (err)
					goto cleanup;
			
				*stkhd++ = dst;
			}
			
			*z = *--stkhd;
			goto cleanup;
			
			err = -1;
			goto cleanup;
		}
	
		err = 0;
	}
	
	*z = omega;
	retain_cell(omega);
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr803(struct cell_array **z,
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
		int16_t dat[] = {16};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr804(struct cell_array **z,
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
		int16_t dat[] = {16};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr805(struct cell_array **z,
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
		int16_t dat[] = {16};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr806(struct cell_array **z,
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
		int16_t dat[] = {16};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr807(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	stkhd = &stk[0];
	err = 0;

	{
		struct cell_func *fn = cdf_prim.nqv;
		struct cell_array *arg = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *x = *--stkhd;
		struct cell_func *fn = cdf_prim.sub;
		struct cell_array *y = alpha;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(x);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *fn = cdf_prim.iot;
		struct cell_array *arg = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *x = alpha;
		struct cell_func *fn = cdf_prim.add;
		struct cell_array *y = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *fn = cdf_prim.par;
		struct cell_array *arg = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *x = *--stkhd;
		struct cell_func *fn = cdf_prim.sqd;
		struct cell_array *y = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(x);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr808(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	stkhd = &stk[0];
	err = 0;

	{
		struct cell_func *fn = cdf_prim.nqv;
		struct cell_array *arg = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *fn = cdf_prim.iot;
		struct cell_array *arg = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		int16_t dat[] = {1};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
		if (err)
			goto cleanup;
	
	
		err = fill_array(arr, dat);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = arr;
	}
	{
		struct cell_array *x = *--stkhd;
		struct cell_func *fn = cdf_prim.add;
		struct cell_array *y = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(x);
		release_array(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *fn = cdf_prim.nqv;
		struct cell_array *arg = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *x = *--stkhd;
		struct cell_func *fn = cdf_prim.sub;
		struct cell_array *y = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(x);
		release_array(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *x = *--stkhd;
		struct cell_func *fn = cdf_prim.sqd;
		struct cell_array *y = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(x);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr809(struct cell_array **z,
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
		int16_t dat[] = {16};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr810(struct cell_array **z,
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
		int16_t dat[] = {16};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr811(struct cell_array **z,
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
	} loc_frm, *loc;
	
	loc = &loc_frm;
	
	struct lex_vars {
		struct cell_func *chk_scl;
		struct cell_func *max_shp;
	} *lex;
	
	lex = (struct lex_vars *)deldel->fv;
	
	loc->s = NULL;
	stkhd = &stk[0];
	err = 0;

	{
		struct cell_array *x = alpha;
		struct cell_func *fn = lex->chk_scl;
		struct cell_array *y = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
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
	
		err = 0;
	}
	
	{
		struct cell_array *x = alpha;
		struct cell_func *fn = lex->max_shp;
		struct cell_array *y = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	loc->s = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *x = alphaalpha;
		struct cell_func *op = cdf_prim.q_veach;
		struct cell_func *dst;
	
		err = apply_mop(&dst, op, x);
	
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *x = alpha;
		struct cell_func *fn = *--stkhd;
		struct cell_array *y = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_func(fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *x = loc->s;
		struct cell_func *fn = cdf_prim.rho;
		struct cell_array *y = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	release_env((void **)loc, (void **)(loc + 1));
	return err;
}

int
ptr812(struct cell_array **z,
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

	struct lex_vars {
		struct cell_func *map_dyadic;
	} *lex;
	
	lex = (struct lex_vars *)deldel->fv;
	
	stkhd = &stk[0];
	err = 0;

	{
		struct cell_func *x = alphaalpha;
		struct cell_func *op = lex->map_dyadic;
		struct cell_func *dst;
	
		err = apply_mop(&dst, op, x);
	
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *x = alpha;
		struct cell_func *fn = *--stkhd;
		struct cell_array *y = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_func(fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	return err;
}

int
ptr813(struct cell_array **z,
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
		struct cell_func *op;
		struct cell_array *s;
		struct cell_array *c;
		struct cell_array *zs;
		struct cell_array *z;
	} loc_frm, *loc;
	
	loc = &loc_frm;
	
	loc->op = NULL;
	loc->s = NULL;
	loc->c = NULL;
	loc->zs = NULL;
	loc->z = NULL;
	stkhd = &stk[0];
	err = 0;

	{
		struct cell_func *x = alphaalpha;
		struct cell_func *op = cdf_prim.map;
		struct cell_func *dst;
	
		err = apply_mop(&dst, op, x);
	
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	loc->op = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn = cdf_prim.rho;
		struct cell_array *arg = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *fn = cdf_prim.nqv;
		struct cell_array *arg = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		int16_t dat[] = {0};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(x);
		release_array(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *x = *--stkhd;
	
		err = guard_check(x);
	
		release_array(x);
	
		if (err > 0)
			goto cleanup;
	
		if (!err) {
			{
				struct cell_func *fn = cdf_prim.cat;
				struct cell_array *arg = omega;
				struct cell_array *dst;
			
				err = (fn->fptr)(&dst, NULL, arg, fn);
			
				if (err)
					goto cleanup;
			
				*stkhd++ = dst;
			}
			
			{
				struct cell_func *fn = self;
				struct cell_array *arg = *--stkhd;
				struct cell_array *dst;
			
				err = (fn->fptr)(&dst, NULL, arg, fn);
			
				release_array(arg);
			
				if (err)
					goto cleanup;
			
				*stkhd++ = dst;
			}
			
			*z = *--stkhd;
			goto cleanup;
			
			err = -1;
			goto cleanup;
		}
	
		err = 0;
	}
	
	{
		struct cell_func *fn = cdf_prim.rho;
		struct cell_array *arg = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	loc->s = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn = cdf_prim.dis;
		struct cell_array *arg = loc->s;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	loc->c = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		int16_t dat[] = {1};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
		if (err)
			goto cleanup;
	
	
		err = fill_array(arr, dat);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = arr;
	}
	{
		struct cell_array *x = *--stkhd;
		struct cell_func *fn = cdf_prim.drp;
		struct cell_array *y = loc->s;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(x);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	loc->zs = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn = cdf_prim.cat;
		struct cell_array *arg = loc->z;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *fn = cdf_prim.nqv;
		struct cell_array *arg = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		int16_t dat[] = {0};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(x);
		release_array(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
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
				int16_t dat[] = {0};
			
				err = mk_array(&arr, typ, STG_HOST, rnk);
			
				if (err)
					goto cleanup;
			
			
				err = fill_array(arr, dat);
			
				if (err)
					goto cleanup;
			
				*stkhd++ = arr;
			}
			{
				struct cell_array *x = *--stkhd;
				struct cell_func *fn = cdf_prim.rho;
				struct cell_array *y = omega;
				struct cell_array *dst;
			
				err = (fn->fptr)(&dst, x, y, fn);
			
				release_array(x);
			
				if (err)
					goto cleanup;
			
				*stkhd++ = dst;
			}
			
			{
				struct cell_func *fn = cdf_prim.dis;
				struct cell_array *arg = *--stkhd;
				struct cell_array *dst;
			
				err = (fn->fptr)(&dst, NULL, arg, fn);
			
				release_array(arg);
			
				if (err)
					goto cleanup;
			
				*stkhd++ = dst;
			}
			
			{
				struct cell_array *x = loc->zs;
				struct cell_func *fn = cdf_prim.rho;
				struct cell_array *y = *--stkhd;
				struct cell_array *dst;
			
				err = (fn->fptr)(&dst, x, y, fn);
			
				release_array(y);
			
				if (err)
					goto cleanup;
			
				*stkhd++ = dst;
			}
			
			*z = *--stkhd;
			goto cleanup;
			
			err = -1;
			goto cleanup;
		}
	
		err = 0;
	}
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		int16_t dat[] = {0};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *y = loc->c;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(x);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
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
				int16_t dat[] = {16};
			
				err = mk_array(&arr, typ, STG_HOST, rnk);
			
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
				struct cell_array *dst;
			
				err = (fn->fptr)(&dst, NULL, arg, fn);
			
				release_array(arg);
			
				if (err)
					goto cleanup;
			
				*stkhd++ = dst;
			}
			
			*z = *--stkhd;
			goto cleanup;
			
			err = -1;
			goto cleanup;
		}
	
		err = 0;
	}
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		int16_t dat[] = {1};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
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
		struct cell_array *y = loc->c;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(x);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *x = *--stkhd;
	
		err = guard_check(x);
	
		release_array(x);
	
		if (err > 0)
			goto cleanup;
	
		if (!err) {
			{
				struct cell_array *x = loc->zs;
				struct cell_func *fn = cdf_prim.rho;
				struct cell_array *y = omega;
				struct cell_array *dst;
			
				err = (fn->fptr)(&dst, x, y, fn);
			
				if (err)
					goto cleanup;
			
				*stkhd++ = dst;
			}
			
			*z = *--stkhd;
			goto cleanup;
			
			err = -1;
			goto cleanup;
		}
	
		err = 0;
	}
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		int16_t dat[] = {1};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
		if (err)
			goto cleanup;
	
	
		err = fill_array(arr, dat);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = arr;
	}
	{
		struct cell_array *x = loc->c;
		struct cell_func *fn = cdf_prim.sub;
		struct cell_array *y = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *x = *--stkhd;
		struct cell_func *fn = cdf_prim.sqd;
		struct cell_array *y = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(x);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	loc->z = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	
	{
		struct cell_func *fn = cdf_prim.par;
		struct cell_array *arg = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *fn;
	
		err = mk_func(&fn, ptr814, 2);
	
		if (err)
			goto cleanup;
	
		fn->fv[0] = retain_cell(loc->z);
		fn->fv[1] = retain_cell(loc->op);
	
		*stkhd++ = fn;
	}
	
	{
		struct cell_func *x = *--stkhd;
		struct cell_func *op = cdf_prim.map;
		struct cell_func *dst;
	
		err = apply_mop(&dst, op, x);
	
		release_func(x);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *arr;
	
		enum array_type typ = ARR_SINT;
		unsigned int rnk = 0;
		int16_t dat[] = {1};
	
		err = mk_array(&arr, typ, STG_HOST, rnk);
	
		if (err)
			goto cleanup;
	
	
		err = fill_array(arr, dat);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = arr;
	}
	{
		struct cell_array *x = loc->c;
		struct cell_func *fn = cdf_prim.sub;
		struct cell_array *y = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *fn = cdf_prim.iot;
		struct cell_array *arg = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_func *fn = cdf_prim.rot;
		struct cell_array *arg = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, NULL, arg, fn);
	
		release_array(arg);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *x = *--stkhd;
		struct cell_func *fn = *--stkhd;
		struct cell_array *y = *--stkhd;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(x);
		release_func(fn);
		release_array(y);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	*z = loc->z;
	retain_cell(loc->z);
	goto cleanup;
	
	err = -1;

cleanup:
	release_env(stk, stkhd);
	release_env((void **)loc, (void **)(loc + 1));
	return err;
}

int
ptr814(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	struct lex_vars {
		struct cell_array *z;
		struct cell_func *op;
	} *lex;
	
	lex = (struct lex_vars *)self->fv;
	
	stkhd = &stk[0];
	err = 0;

	{
		struct cell_array *x = alpha;
		struct cell_func *fn = cdf_prim.sqd;
		struct cell_array *y = omega;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array *x = *--stkhd;
		struct cell_func *fn = lex->op;
		struct cell_array *y = lex->z;
		struct cell_array *dst;
	
		err = (fn->fptr)(&dst, x, y, fn);
	
		release_array(x);
	
		if (err)
			goto cleanup;
	
		*stkhd++ = dst;
	}
	
	{
		struct cell_array_box *bx = lex->z;
		struct cell_func *fn = cdf_prim.rgt;
		struct cell_array *y = *--stkhd;
		struct cell_array *x = bx->value;
	
		err = (fn->fptr)(&bx->value, x, y, fn);
	
		if (err) {
			goto cleanup;
		}
	
		release_array(x);
	
		*stkhd++ = y;
	}
	
	*z = *--stkhd;
	goto cleanup;
	
	err = -1;

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
is_numeric(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.is_numeric;

	return self->fptr(z, l, r, self);
}

EXPORT int
is_numeric_dwa(void *z, void *l, void *r)
{
	return call_dwa(is_numeric, z, l, r);
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
has_nat_vals(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.has_nat_vals;

	return self->fptr(z, l, r, self);
}

EXPORT int
has_nat_vals_dwa(void *z, void *l, void *r)
{
	return call_dwa(has_nat_vals, z, l, r);
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
chk_valid_shape(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.chk_valid_shape;

	return self->fptr(z, l, r, self);
}

EXPORT int
chk_valid_shape_dwa(void *z, void *l, void *r)
{
	return call_dwa(chk_valid_shape, z, l, r);
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
both_numeric(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.both_numeric;

	return self->fptr(z, l, r, self);
}

EXPORT int
both_numeric_dwa(void *z, void *l, void *r)
{
	return call_dwa(both_numeric, z, l, r);
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
reshape(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.reshape;

	return self->fptr(z, l, r, self);
}

EXPORT int
reshape_dwa(void *z, void *l, void *r)
{
	return call_dwa(reshape, z, l, r);
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
index_gen(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.index_gen;

	return self->fptr(z, l, r, self);
}

EXPORT int
index_gen_dwa(void *z, void *l, void *r)
{
	return call_dwa(index_gen, z, l, r);
}

EXPORT int
index_of(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.index_of;

	return self->fptr(z, l, r, self);
}

EXPORT int
index_of_dwa(void *z, void *l, void *r)
{
	return call_dwa(index_of, z, l, r);
}

EXPORT int
iot(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.iot;

	return self->fptr(z, l, r, self);
}

EXPORT int
iot_dwa(void *z, void *l, void *r)
{
	return call_dwa(iot, z, l, r);
}

EXPORT int
dis(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.dis;

	return self->fptr(z, l, r, self);
}

EXPORT int
dis_dwa(void *z, void *l, void *r)
{
	return call_dwa(dis, z, l, r);
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
negate(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.negate;

	return self->fptr(z, l, r, self);
}

EXPORT int
negate_dwa(void *z, void *l, void *r)
{
	return call_dwa(negate, z, l, r);
}

EXPORT int
sub(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.sub;

	return self->fptr(z, l, r, self);
}

EXPORT int
sub_dwa(void *z, void *l, void *r)
{
	return call_dwa(sub, z, l, r);
}

EXPORT int
sign(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.sign;

	return self->fptr(z, l, r, self);
}

EXPORT int
sign_dwa(void *z, void *l, void *r)
{
	return call_dwa(sign, z, l, r);
}

EXPORT int
mul(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.mul;

	return self->fptr(z, l, r, self);
}

EXPORT int
mul_dwa(void *z, void *l, void *r)
{
	return call_dwa(mul, z, l, r);
}

EXPORT int
recip(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.recip;

	return self->fptr(z, l, r, self);
}

EXPORT int
recip_dwa(void *z, void *l, void *r)
{
	return call_dwa(recip, z, l, r);
}

EXPORT int
div(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.div;

	return self->fptr(z, l, r, self);
}

EXPORT int
div_dwa(void *z, void *l, void *r)
{
	return call_dwa(div, z, l, r);
}

EXPORT int
split(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.split;

	return self->fptr(z, l, r, self);
}

EXPORT int
split_dwa(void *z, void *l, void *r)
{
	return call_dwa(split, z, l, r);
}

EXPORT int
drop(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.drop;

	return self->fptr(z, l, r, self);
}

EXPORT int
drop_dwa(void *z, void *l, void *r)
{
	return call_dwa(drop, z, l, r);
}

EXPORT int
drp(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.drp;

	return self->fptr(z, l, r, self);
}

EXPORT int
drp_dwa(void *z, void *l, void *r)
{
	return call_dwa(drp, z, l, r);
}

EXPORT int
reverse_last(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.reverse_last;

	return self->fptr(z, l, r, self);
}

EXPORT int
reverse_last_dwa(void *z, void *l, void *r)
{
	return call_dwa(reverse_last, z, l, r);
}

EXPORT int
rotate_last(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.rotate_last;

	return self->fptr(z, l, r, self);
}

EXPORT int
rotate_last_dwa(void *z, void *l, void *r)
{
	return call_dwa(rotate_last, z, l, r);
}

EXPORT int
rot(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.rot;

	return self->fptr(z, l, r, self);
}

EXPORT int
rot_dwa(void *z, void *l, void *r)
{
	return call_dwa(rot, z, l, r);
}

EXPORT int
map_monadic(struct cell_array **z, struct cell_array *l, struct cell_array *r)
{
	struct cell_func *self;

	cdf_prim_init();

	self = cdf_prim.map_monadic;

	return self->fptr(z, l, r, self);
}

EXPORT int
map_monadic_dwa(void *z, void *l, void *r)
{
	return call_dwa(map_monadic, z, l, r);
}

