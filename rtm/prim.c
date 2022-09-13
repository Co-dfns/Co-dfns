#include "codfns.h"

EXPORT int
DyalogGetInterpreterFunctions(void *p)
{
    return set_dwafns(p);
}

int prim_flag = 0;

struct prim_loc {
	int __count;
	wchar_t **__names;
} prim_env;

EXPORT int
prim_init(void)
{
	void *stk[128];
	void **stkhd;

	struct prim_loc loc;

	if (prim_flag)
		return 0;

	stkhd = &stk[0];
	prim_flag = 1;
	cdf_init();

	loc.__count = 0;
	loc.__names = NULL;

	prim_env = loc;

	return 0;
}
