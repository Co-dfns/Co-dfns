#include <stdlib.h>
#include <string.h>

#include "internal.h"

DECLSPEC int
mk_func(struct cell_func **k, func_ptr fn, unsigned int fs)
{
        size_t sz;
        struct cell_func *ptr;

        sz = sizeof(struct cell_func) + fs * sizeof(void *);
        ptr = malloc(sz);

        if (ptr == NULL)
                return 1;

        ptr->ctyp = CELL_FUNC;
        ptr->refc = 1;
        ptr->fptr = fn;
        ptr->fs = fs;

        *k = ptr;

        return 0;
}

DECLSPEC void
release_func(struct cell_func *k)
{
        if (k == NULL)
                return;
	
	if (!k->refc)
		return;

        k->refc--;

        if (k->refc)
                return;

        for (unsigned int i = 0; i < k->fs; i++)
                release_cell(k->fv[i]);
        
        free(k);
}

DECLSPEC int
apply_mop(struct cell_func **z, struct cell_func *op, void *l)
{
	struct cell_func *dst;
	int err;
	
	err = mk_func(&dst, op->fptr, 2);
	
	if (err)
		return err;
	
	dst->fv[0] = retain_cell(op);
	dst->fv[1] = retain_cell(l);
	
	*z = dst;
	
	return 0;
}

DECLSPEC int
apply_dop(struct cell_func **z, struct cell_func *op, void *l, void *r)
{
	struct cell_func *dst;
	int err;

	err = mk_func(&dst, op->fptr, 3);

	if (err)
		return err;

	dst->fv[0] = retain_cell(op);
        dst->fv[1] = retain_cell(l);
        dst->fv[2] = retain_cell(r);

	*z = dst;
	
	return 0;
}

DECLSPEC int
guard_check(struct cell_array *x)
{
	int err, val;
	
	if (array_count(x) != 1)
		return 5;
	
	if (err = squeeze_array(x))
		return err;
	
	if (x->type != ARR_BOOL)
		return 11;
	
	if (err = get_scalar_int(&val, x))
		return err;
	
	return val - 1;
}

DECLSPEC void
release_env(void *start[], void *end[])
{
	for (void **cur = start; cur != end; cur++)
		release_cell(*cur);
}
