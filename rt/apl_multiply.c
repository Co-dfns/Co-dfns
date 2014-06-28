#include <stdlib.h>
#include <error.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "codfns.h"
#include "scalar.h"

/* codfns_multiply()
 *
 * Intended Function: Compute the APL × function.
 */

#define direction(nm, rt) \
int inline static \
nm(int64_t *tgt, rt *rgt) \
{ \
	if (*rgt == 0) \
		*tgt = 0; \
	else if (*rgt < 0) \
		*tgt = -1; \
	else \
		*tgt = 1; \
 \
	return 0; \
}

direction(direction_i, int64_t)
direction(direction_d, double)

#define multiply(nm, zt, lt, rt) \
int inline static \
nm(zt *tgt, lt *lft, rt *rgt) \
{ \
	*tgt = *lft * *rgt; \
	return 0; \
}

multiply(multiply_ii, int64_t, int64_t, int64_t)
multiply(multiply_id, double, int64_t, double)
multiply(multiply_di, double, double, int64_t)
multiply(multiply_dd, double, double, double)

int
codfns_multiply(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	/*printf("multiply ");*/
	scalar_dispatch(
	    direction_d, 2, int64_t, double,
	    direction_i, 2, int64_t, int64_t,
	    multiply_dd, 3, double, double, double,
	    multiply_di, 3, double, double, int64_t,
	    multiply_id, 3, double, int64_t, double,
	    multiply_ii, 2, int64_t, int64_t, int64_t)
}


