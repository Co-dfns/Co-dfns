#include <stdlib.h>
#include <string.h>

#include "internal.h"

DECLSPEC int
mk_func(struct cell_func **k, func_mon fm, func_dya fd, unsigned int fs)
{
        size_t sz;
        struct cell_func *ptr;

        sz = sizeof(struct cell_func) + fs * sizeof(void *);
        ptr = malloc(sz);

        if (ptr == NULL)
                return 1;

        ptr->ctyp = CELL_FUNC;
        ptr->refc = 1;
        ptr->fptr_mon = fm;
        ptr->fptr_dya = fd;
        ptr->fs = fs;

        *k = ptr;

        return 0;
}

DECLSPEC int
mk_moper(struct cell_moper **k, 
    func_mon fam, func_dya fad, func_mon ffm, func_dya ffd,
    unsigned int fs)
{
        size_t sz;
        struct cell_moper *ptr;

        sz = sizeof(struct cell_moper) + fs * sizeof(void *);
        ptr = malloc(sz);

        if (ptr == NULL)
                return 1;

        ptr->ctyp = CELL_MOPER;
        ptr->refc = 1;
        ptr->fptr_am = fam;
        ptr->fptr_ad = fad;
        ptr->fptr_fm = ffm;
        ptr->fptr_fd = ffd;
        ptr->fs = fs;

        *k = ptr;

        return 0;
}

DECLSPEC int
mk_doper(struct cell_doper **k, 
    func_mon faam, func_dya faad, func_mon fafm, func_dya fafd,
    func_mon ffam, func_dya ffad, func_mon fffm, func_dya fffd,
    unsigned int fs)
{
        size_t sz;
        struct cell_doper *ptr;

        sz = sizeof(struct cell_doper) + fs * sizeof(void *);
        ptr = malloc(sz);

        if (ptr == NULL)
                return 1;

        ptr->ctyp = CELL_DOPER;
        ptr->refc = 1;
        ptr->fptr_aam = faam;
        ptr->fptr_aad = faad;
        ptr->fptr_afm = fafm;
        ptr->fptr_afd = fafd;
        ptr->fptr_fam = ffam;
        ptr->fptr_fad = ffad;
        ptr->fptr_ffm = fffm;
        ptr->fptr_ffd = fffd;
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

DECLSPEC void
release_moper(struct cell_moper *k)
{
	release_func((struct cell_func *)k);
}

DECLSPEC void
release_doper(struct cell_doper *k)
{
	release_func((struct cell_func *)k);
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
