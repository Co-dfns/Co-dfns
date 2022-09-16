#include "codfns.h"

EXPORT int
DyalogGetInterpreterFunctions(void *p)
{
    return set_dwafns(p);
}


int cdf_prim_flag = 0;

struct cdf_prim_loc {
	int __count;
	wchar_t **__names;
} cdf_prim;

wchar_t **cdf_prim_names = NULL;

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

	loc.__count = 0;
	loc.__names = cdf_prim_names;

	err = 0;


	cdf_prim = loc;

cleanup:
	return err;
}

