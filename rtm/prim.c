#include "codfns.h"

EXPORT int
DyalogGetInterpreterFunctions(void *p)
{
    return set_dwafns(p);
}

int prim(struct cell_array **,
    struct cell_array *, struct cell_array *,
    struct cell_func *);

int prim_flag = 0;

struct prim_loc {
	int __count;
	wchar_t **__names;
	
} prim_env;

wchar_t **prim_names = NULL;

EXPORT int
prim_init(void)
{
	struct prim_loc loc;
	void *stk[128];
	void **stkhd;
	int err;

	if (prim_flag)
		return 0;

	stkhd = &stk[0];
	prim_flag = 1;
	cdf_init();

	loc.__count = 0;
	loc.__names = prim_names;

	err = 0;


	prim_env = loc;

cleanup:
	return err;
}

