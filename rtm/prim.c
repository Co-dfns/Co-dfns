#include "codfns.h"

EXPORT int
DyalogGetInterpreterFunctions(void *p)
{
    return set_dwafns(p);
}

int
fn0(struct array **z, struct array *l, struct array *r, void *fv[]);


int init0 = 0;

EXPORT int
init(void)
{
 return fn0(NULL, NULL, NULL, NULL);
}

int
fn0(struct array **z, 
    struct array *l, struct array *r, void *fv[])
{
       void    *stk[128];
       void    **stkhd;

       if (init0)
               return 0;

       stkhd = &stk[0];
       init0 = 1;
       cdf_init();

       return 0;
}

