#include "codfns.h"

EXPORT int
DyalogGetInterpreterFunctions(void *p)
{
    return set_dwafns(p);
}

int ptr6(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);

int cdf_prim_flag = 0;

EXPORT struct cdf_prim_loc {
	int __count;
	wchar_t **__names;
	struct cell_func *rgt;
} cdf_prim;

wchar_t *cdf_prim_names[] = {L"rgt"};

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

	loc.__count = 1;
	loc.__names = cdf_prim_names;
	loc.rgt = NULL;

	err = 0;

	err = mk_func((struct cell_func **)stkhd++, ptr6, 0);
	if (err)
		goto cleanup;
	
	loc.rgt = *stkhd++ = retain_cell(*--stkhd);
	release_cell(*--stkhd);
	

	cdf_prim = loc;

cleanup:
	return err;
}

int
ptr6(struct cell_array **z,
    struct cell_array *alpha, struct cell_array *omega,
    struct cell_func *self)
{

	void *stk[128];
	void **stkhd;
	int err;

	stkhd = &stk[0];
	err = 0;

	*z = retain_cell(omega);
	goto cleanup;
	
cleanup:
	return err;
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

