#include "codfns.h"

EXPORT int
DyalogGetInterpreterFunctions(void *p)
{
	return set_dwafns(p);
}

int
fn0(struct array **z, struct array *l, struct array *r, void *fv[]);

int
fn6(struct array **z, struct array *l, struct array *r, void *fv[]);

struct closure *rgt;

EXPORT int
rgt_dwa(struct localp *zp, struct localp *lp, struct localp *rp)
{
	struct array *z, *l, *r;
	int err;

	l = NULL;
	r = NULL;

	fn0(NULL, NULL, NULL, NULL);

	err = 0;

	if (lp)
		err = dwa2array(&l, lp->pocket);

	if (err)
		dwa_error(err);;

	if (rp)
		dwa2array(&r, rp->pocket);

	if (err) {
		release_array(l);
		dwa_error(err);
	}

	err = (rgt->fn)(&z, l, r, rgt->fv);

	release_array(l);
	release_array(r);

	if (err)
		dwa_error(err);

	err = array2dwa(NULL, z, zp);
	release_array(z);

	if (err)
		dwa_error(err);

	return 0;
}


int init0 = 0;

EXPORT int
init(void)
{
	return fn0(NULL, NULL, NULL, NULL);
}

int
fn0(struct array **z, struct array *l, struct array *r, void *fv[])
{
	void	*stk[128];
	void	**stkhd;

	if (init0)
		return 0;

	stkhd = &stk[0];
	init0 = 1;
	cdf_init();

	mk_closure((struct closure **)stkhd++, fn6, 0);
	rgt = retain_cell(stkhd[-1]);
	release_cell(*--stkhd);
	
	return 0;
}

int
fn6(struct array **z, struct array *l, struct array *r, void *fv[])
{
	void	*stk[128];
	void	**stkhd;

	stkhd = &stk[0];

	*stkhd++ = retain_cell(r);
	*z = *--stkhd;
	goto cleanup;
	
	*z = NULL;

cleanup:
	return 0;
}

