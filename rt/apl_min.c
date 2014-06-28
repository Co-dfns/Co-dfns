#include <stdlib.h>
#include <error.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "codfns.h"
#include "scalar.h"

/* codfns_min()
 *
 * Intended Function: Compute the APL ⌊ function.
 */

#define floorapl(nm, zt, rt) \
int inline static \
nm(zt *tgt, rt *rgt) \
{ \
	*tgt = floor(*rgt); \
	return 0; \
}

floorapl(floor_d, double, double)
floorapl(floor_i, int64_t, int64_t)

#define minapl(nm, zt, lt, rt) \
int inline static \
nm(zt *tgt, lt *lft, rt *rgt) \
{ \
	*tgt = (*lft <= *rgt ? *lft : *rgt); \
	return 0; \
}

minapl(min_dd, double, double, double)
minapl(min_di, double, double, int64_t)
minapl(min_id, double, int64_t, double)
minapl(min_ii, int64_t, int64_t, int64_t)

int
codfns_min(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	scalar_dispatch(
	    floor_d, 3, double, double,
	    floor_i, 2, int64_t, int64_t,
	    min_dd, 3, double, double, double,
	    min_di, 3, double, double, int64_t,
	    min_id, 3, double, int64_t, double,
	    min_ii, 2, int64_t, int64_t, int64_t)
}


