#include <stdlib.h>
#include <error.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "codfns.h"
#include "scalar.h"

/* codfns_log()
 *
 * Intended Function: Compute the APL ⍟ function.
 */

#define logapl(nm, rt) \
int inline static \
nm(double *tgt, rt *rgt) \
{ \
	*tgt = log(*rgt); \
	return 0; \
}

logapl(log_i, int64_t)
logapl(log_d, double)

#define logbn(nm, lt, rt) \
int inline static \
nm(double *tgt, lt *lft, rt *rgt) \
{ \
	*tgt = log(*rgt) / log(*lft); \
	return 0; \
}

logbn(logbn_dd, double, double)
logbn(logbn_di, double, int64_t)
logbn(logbn_id, int64_t, double)
logbn(logbn_ii, int64_t, int64_t)

int
codfns_log(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	scalar_dispatch(
	    log_d, 3, double, double,
	    log_i, 3, double, int64_t,
	    logbn_dd, 3, double, double, double,
	    logbn_di, 3, double, double, int64_t,
	    logbn_id, 3, double, int64_t, double,
	    logbn_ii, 3, double, int64_t, int64_t)
}


