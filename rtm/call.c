#include "internal.h"

DECLSPEC int
mk_simple_array(void ***stkhd, enum array_type typ, unsigned int rnk, 
	size_t *shp, void *dat)
{
	struct cell_array *arr;
	int err;
	
	arr = NULL;
	
	CHKFN(mk_array(&arr, typ, STG_HOST, rnk), fail);
	
	for (unsigned int i = 0; i < rnk; i++)
		arr->shape[i] = shp[i];
	
	CHKFN(fill_array(arr, dat), fail);
	
	*(*stkhd)++ = arr;

fail:
	if (err)
		release_array(arr);
	
	return err;
}

DECLSPEC int
apply_mop(struct cell_func **z, struct cell_moper *op, 
    func_mon fm, func_dya fd, void *l)
{
	struct cell_func *dst;
	int err;
	
	err = mk_func(&dst, fm, fd, 2);
	
	if (err)
		return err;
	
	dst->fv[0] = retain_cell(op);
	dst->fv[1] = retain_cell(l);
	
	*z = dst;
	
	return 0;
}

DECLSPEC int
apply_dop(struct cell_func **z, struct cell_doper *op, 
    func_mon fm, func_dya fd, void *l, void *r)
{
	struct cell_func *dst;
	int err;

	err = mk_func(&dst, fm, fd, 3);

	if (err)
		return err;

	dst->fv[0] = retain_cell(op);
	dst->fv[1] = retain_cell(l);
	dst->fv[2] = retain_cell(r);

	*z = dst;
	
	return 0;
}

DECLSPEC int
derive_func_opts(struct cell_func **dst, struct cell_func *aa, int fs)
{
	struct cell_func *fn;
	int err;
	
	CHK(mk_func(&fn, aa->fptr_mon, aa->fptr_dya, fs+1), done,
	    L"mk_func(&fn, aa->fm, aa->fd, fs+1)");
	
	fn->fv = aa->fv;
	fn->opts = &fn->fv_[1];
	fn->fv_[0] = retain_cell(aa);

	*dst = fn;
	
	err = 0;
	
done:
	return err;
}

DECLSPEC int
guard_check(struct cell_array *x)
{
	int err, val;
	
	if (array_count(x) != 1)
		CHK(5, fail, L"Non-singleton test expression.");
	
	CHKFN(squeeze_array(x), fail);
	
	if (x->type != ARR_BOOL)
		CHK(11, fail, L"Test expression is not Boolean.");

	CHKFN(get_scalar_int32(&val, x), fail);

	return val - 1;

fail:
	return err;
}

DECLSPEC void
release_env(void *start[], void *end[])
{
	for (void **cur = start; cur != end; cur++)
		release_cell(*cur);
}
