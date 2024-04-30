#include "internal.h"

DECLSPEC int
mk_nested_array(void ***stkhd, size_t count)
{
	struct cell_array *arr, **dat;
	int err;
	
	arr = NULL;
	
	CHKFN(mk_array(&arr, ARR_NESTED, STG_HOST, 1), fail);
	
	arr->shape[0] = count;
	
	CHKFN(alloc_array(arr), fail);
	
	dat = arr->values;
	
	for (size_t i = 0; i < count; i++)
		dat[i] = *--*stkhd;
	
	CHKFN(squeeze_array(arr), fail);
	
	*(*stkhd)++ = arr;
	
fail:
	if (err)
		release_array(arr);
	
	return err;
}

DECLSPEC int
var_ref(void ***stkhd, void *ref)
{
	if (!ref)
		return 6;
	
	*(*stkhd)++ = retain_cell(ref);
	
	return 0;
}

DECLSPEC void
bind_value(void ***stkhd, void **val)
{
	release_cell(*val);
	*val = retain_cell((*stkhd)[-1]);
}

DECLSPEC int
mk_closure_func(void ***stkhd, func_mon fm, func_dya fd, unsigned int fc, void **fvs)
{
	struct cell_func *func;
	int err;
	
	CHKFN(mk_func(&func, fm, fd, fc), fail);
	
	for (unsigned int i = 0; i < fc; i++)
		func->fv[i] = fvs[i];
	
	*(*stkhd)++ = func;

fail:
	return err;
}

DECLSPEC int
mk_closure_moper(void ***stkhd, 
    func_mon fam, func_dya fad, func_mon ffm, func_dya ffd,
    unsigned int fc, void **fvs)
{
	struct cell_moper *mopr;
	int err;
	
	CHKFN(mk_moper(&mopr, fam, fad, ffm, ffd, fc), fail);
	
	for (unsigned int i = 0; i < fc; i++)
		mopr->fv[i] = fvs[i];
	
	*(*stkhd)++ = mopr;
fail:
	return err;
}

DECLSPEC int
mk_closure_doper(void ***stkhd,
    func_mon faam, func_dya faad, func_mon fafm, func_dya fafd,
    func_mon ffam, func_dya ffad, func_mon fffm, func_dya fffd,
    unsigned int fc, void **fvs)
{
	struct cell_doper *dopr;
	int err;
	
	CHKFN(mk_doper(&dopr, 
	    faam, faad, fafm, fafd, ffam, ffad, fffm, fffd, fc), 
	    fail);
	    
	for (unsigned int i = 0; i < fc; i++)
		dopr->fv[i] = fvs[i];
	
	*(*stkhd)++ = dopr;

fail:
	return err;
}

DECLSPEC int
apply_niladic(void ***stkhd, struct cell_func *fn)
{
	struct cell_array *dst;
	int err;

	CHKIG((fn->fptr_mon)(&dst, NULL, fn), fail);
	
	*(*stkhd)++ = dst;
	
fail:
	return err;
}

DECLSPEC int
apply_monadic(void ***stkhd)
{
	struct cell_func *fn;
	struct cell_array *y, *dst;
	int err;
	
	fn = (*stkhd)[-1];
	y = (*stkhd)[-2];
	
	CHKIG((fn->fptr_mon)(&dst, y, fn), fail);
	
	release_func(fn);
	release_array(y);
	
	*stkhd -= 2;
	*(*stkhd)++ = dst;
	
fail:
	return err;
}

DECLSPEC int
apply_dyadic(void ***stkhd)
{
	struct cell_array *x, *y, *dst;
	struct cell_func *fn;
	int err;
	
	x = (*stkhd)[-1];
	fn = (*stkhd)[-2];
	y = (*stkhd)[-3];
	
	CHKIG((fn->fptr_dya)(&dst, x, y, fn), fail);
	
	release_array(x);
	release_func(fn);
	release_array(y);
	
	*stkhd -= 3;
	*(*stkhd)++ = dst;
	
fail:
	return err;
}

DECLSPEC int
apply_assign(void ***stkhd, struct cell_array **bx)
{
	struct cell_array *x, *y, *orig;
	struct cell_func *fn;
	int err;
	
	x = (*stkhd)[-1];
	fn = (*stkhd)[-2];
	y = (*stkhd)[-3];
	orig = *bx;
	
	CHKIG((fn->fptr_dya)(bx, x, y, fn), fail);
	
	release_array(orig);
	release_array(x);
	release_func(fn);
	
	*stkhd -= 2;
	
fail:
	return err;
}

DECLSPEC int
apply_mop(struct cell_func **z, struct cell_moper *op, 
    func_mon fm, func_dya fd, void *x)
{
	struct cell_derf *dst;
	int err;
	
	CHKIG(mk_derf(&dst, fm, fd, 2), fail);
	
	dst->fv[0] = retain_cell(op);
	dst->fv[1] = retain_cell(x);
	
	*z = (struct cell_func *)dst;
	
fail:
	return err;
}

#define DEF_APPLY_MOP(pfx) 								\
DECLSPEC int										\
apply_mop_##pfx(void ***stkhd)								\
{											\
	struct cell_func *dst;								\
	struct cell_moper *op;								\
	struct cell_void *x;								\
	int err;									\
											\
	x = (*stkhd)[-1];								\
	op = (*stkhd)[-2];								\
											\
	CHKIG(apply_mop(&dst, op, op->fptr_##pfx##m, op->fptr_##pfx##d, x), fail);	\
											\
	release_cell(x);								\
	release_moper(op);								\
											\
	*stkhd -= 2;									\
	*(*stkhd)++ = dst;								\
											\
fail:											\
	return err;									\
}

DEF_APPLY_MOP(a)
DEF_APPLY_MOP(f)

DECLSPEC int
apply_dop(struct cell_func **z, struct cell_doper *op, 
    func_mon fm, func_dya fd, void *l, void *r)
{
	struct cell_derf *dst;
	int err;
	
	CHKIG(mk_derf(&dst, fm, fd, 3), fail);

	dst->fv[0] = retain_cell(op);
	dst->fv[1] = retain_cell(l);
	dst->fv[2] = retain_cell(r);

	*z = (struct cell_func *)dst;
	
fail:	
	return err;
}

#define DEF_APPLY_DOP(rt, lt) 									\
DECLSPEC int											\
apply_dop_##rt##lt(void ***stkhd)								\
{												\
	struct cell_func *dst;									\
	struct cell_doper *op;									\
	struct cell_void *x, *y;								\
	int err;										\
												\
	x = (*stkhd)[-1];									\
	op = (*stkhd)[-2];									\
	y = (*stkhd)[-3];									\
												\
	CHKIG(apply_dop(&dst, op, op->fptr_##rt##lt##m, op->fptr_##rt##lt##d, x, y), fail);	\
												\
	release_cell(x);									\
	release_doper(op);									\
	release_cell(y);									\
												\
	*stkhd -= 3;										\
	*(*stkhd)++ = dst;									\
												\
fail:												\
	return err;										\
}

DEF_APPLY_DOP(a, a)
DEF_APPLY_DOP(a, f)
DEF_APPLY_DOP(f, a)
DEF_APPLY_DOP(f, f)

DECLSPEC int
apply_variant(void ***stkhd)
{
	struct cell_func *aa;
	struct cell_derf *dst;
	struct cell_array *axis;
	int err;
	
	aa = (*stkhd)[-1];
	axis = (*stkhd)[-2];
	
	CHKIG(mk_derf(&dst, aa->fptr_mon, aa->fptr_dya, 2), fail);
	
	dst->fv = aa->fv;
	dst->opts = &dst->fv_[1];
	dst->fv_[0] = retain_cell(aa);
	dst->opts[0] = axis;
	
	release_func(aa);
	
	*stkhd -= 2;
	*(*stkhd)++ = dst;
	
fail:
	return err;
}

DECLSPEC int
guard_check(void ***stkhd)
{
	struct cell_array *x;
	int err, val;
	
	x = *--*stkhd;
	
	if (NUM_1 == x) {
		err = 0;
		goto done;
	}
	
	if (NUM_0 == x) {
		err = -1;
		goto done;
	}
	
	if (array_count(x) != 1)
		CHK(5, done, "Non-singleton test expression.");
	
	CHKFN(squeeze_array(x), done);
	
	if (x->type != ARR_BOOL)
		CHK(11, done, "Test expression is not Boolean.");

	CHKFN(get_scalar_int32(&val, x, 0), done);

	err = val - 1;

done:
	release_array(x);
	
	return err;
}

DECLSPEC void
release_env(void *start[], void *end[])
{
	for (void **cur = start; cur != end; cur++)
		release_cell(*cur);
}

DECLSPEC int
strand_assign_push(void ***stkhd, int count)
{
	int cdf_pick(struct cell_array **, struct cell_array *, struct cell_array *);
	struct cell_array *arr, *idx;
	int32_t *idxv;
	int err;
	
	err = 0;
	arr = *--*stkhd;
	
	if (!arr->rank) {
		for (size_t i = 0; i < count; i++)
			*(*stkhd)++ = retain_cell(arr);
		
		goto done;
	}

	CHKFN(mk_array_int32(&idx, 0), done);
	idxv = idx->values;
	
	for (int i = count - 1; i >= 0; i--) {
		*idxv = i;
		
		CHKFN(cdf_pick((struct cell_array **)(*stkhd)++, idx, arr), done);
	}
	
	CHKFN(release_array(idx), done);
	CHKFN(release_array(arr), done);
	
done:	
	return err;
}