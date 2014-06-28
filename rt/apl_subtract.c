#include <stdlib.h>
#include <error.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "codfns.h"
#include "scalar.h"

/* codfns_subtract()
 *
 * Intended Function: Implement the primitive APL - function.
 */

#define negate(nm, zt, rt) \
int inline static \
nm(zt *tgt, rt *rgt) \
{ \
	*tgt = -1 * *rgt; \
	return 0; \
}

negate(negate_i, int64_t, int64_t)
negate(negate_d, double, double)

#define subtract(nm, zt, lt, rt) \
int inline static \
nm(zt *tgt, lt *lft, rt *rgt) \
{ \
	*tgt = *lft - *rgt; \
	return 0; \
}

subtract(subtract_ii, int64_t, int64_t, int64_t)
subtract(subtract_id, double, int64_t, double)
subtract(subtract_di, double, double, int64_t)
subtract(subtract_dd, double, double, double)

int
codfns_subtract(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	/*printf("subtract ");*/
	scalar_dispatch(
	    negate_d, 3, double, double,
	    negate_i, 2, int64_t, int64_t,
	    subtract_dd, 3, double, double, double,
	    subtract_di, 3, double, double, int64_t,
	    subtract_id, 3, double, int64_t, double,
	    subtract_ii, 2, int64_t, int64_t, int64_t)
}

