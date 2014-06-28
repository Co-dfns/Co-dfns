#include <stdlib.h>
#include <error.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "codfns.h"
#include "scalar.h"

/* codfns_max()
 *
 * Intended Function: Compute the APL ⌈ function.
 */

#define ceilapl(nm, zt, rt) \
int inline static \
nm(zt *tgt, rt *rgt) \
{ \
	*tgt = ceil(*rgt); \
	return 0; \
}

ceilapl(ceiling_d, double, double)
ceilapl(ceiling_i, int64_t, int64_t)

#define maxapl(nm, zt, lt, rt) \
int inline static \
nm(zt *tgt, lt *lft, rt *rgt) \
{ \
	*tgt = (*lft >= *rgt ? *lft : *rgt); \
	return 0; \
}

maxapl(max_dd, double, double, double)
maxapl(max_di, double, double, int64_t)
maxapl(max_id, double, int64_t, double)
maxapl(max_ii, int64_t, int64_t, int64_t)

int
codfns_max(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	scalar_dispatch(
	    ceiling_d, 3, double, double,
	    ceiling_i, 2, int64_t, int64_t,
	    max_dd, 3, double, double, double,
	    max_di, 3, double, double, int64_t,
	    max_id, 3, double, int64_t, double,
	    max_ii, 2, int64_t, int64_t, int64_t)
}


