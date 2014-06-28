#include <stdlib.h>
#include <error.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "codfns.h"
#include "scalar.h"

/* codfns_divide()
 *
 * Intended Function: Compute the APL ÷ function.
 */

#define reciprocal(nm, rt) \
int inline static \
nm(double *tgt, rt *rgt) \
{ \
	if (*rgt == 0) { \
		fprintf(stderr, "DOMAIN ERROR: Divide by zero\n"); \
		return 11; \
	} \
 \
	*tgt = 1.0 / *rgt; \
 \
	return 0; \
}

reciprocal(reciprocal_i, int64_t)
reciprocal(reciprocal_d, double)

#define divide(nm, lt, rt) \
int inline static \
nm(double *tgt, lt *lft, rt *rgt) \
{ \
	if (*rgt == 0) { \
		fprintf(stderr, "DOMAIN ERROR: Divide by zero\n"); \
		return 11; \
	} \
 \
	*tgt = (1.0 * *lft) / (1.0 * *rgt); \
 \
	return 0; \
}

divide(divide_ii, int64_t, int64_t)
divide(divide_id, int64_t, double)
divide(divide_di, double, int64_t)
divide(divide_dd, double, double)

int
codfns_divide(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	scalar_dispatch(
	    reciprocal_d, 3, double, double,
	    reciprocal_i, 3, double, int64_t,
	    divide_dd, 3, double, double, double,
	    divide_di, 3, double, double, int64_t,
	    divide_id, 3, double, int64_t, double,
	    divide_ii, 3, double, int64_t, int64_t)
}


