#include <stdlib.h>
#include <error.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "codfns.h"
#include "scalar.h"

/* codfns_power()
 *
 * Intended Function: Compute the APL * function.
 */

#define expapl(nm, zt, rt) \
int inline static \
nm(zt *tgt, rt *rgt) \
{ \
	*tgt = exp(*rgt); \
	return 0; \
}

expapl(exp_i, int64_t, int64_t)
expapl(exp_d, double, double)

#define powapl(nm, zt, lt, rt) \
int inline static \
nm(zt *tgt, lt *lft, rt *rgt) \
{ \
	*tgt = pow(*lft, *rgt); \
	return 0; \
}

powapl(pow_dd, double, double, double)
powapl(pow_di, double, double, int64_t)
powapl(pow_id, double, int64_t, double)
powapl(pow_ii, int64_t, int64_t, int64_t)

int
codfns_power(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	scalar_dispatch(
	    exp_d, 3, double, double,
	    exp_i, 2, int64_t, int64_t,
	    pow_dd, 3, double, double, double,
	    pow_di, 3, double, double, int64_t,
	    pow_id, 3, double, int64_t, double,
	    pow_ii, 2, int64_t, int64_t, int64_t)
}


