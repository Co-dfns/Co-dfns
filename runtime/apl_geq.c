#include <stdlib.h>
#include <error.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "codfns.h"
#include "scalar.h"

/* codfns_greater_or_equal()
 *
 * Intended Function: Compute the APL ≥ function.
 */

#define identity(nm, tgtt, rgtt) \
int inline static \
nm(tgtt *tgt, rgtt *rgt) \
{ \
	*tgt = *rgt; \
	return 0; \
}

identity(identity_i, int64_t, int64_t)
identity(identity_d, double, double)

#define greateq(nm, lt, rt) \
int inline static \
nm(int64_t *tgt, lt *lft, rt *rgt) \
{ \
	*tgt = (*lft >= *rgt); \
	return 0; \
}

greateq(greateq_dd, double, double)
greateq(greateq_di, double, int64_t)
greateq(greateq_id, int64_t, double)
greateq(greateq_ii, int64_t, int64_t)

int
codfns_greater_or_equal(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	if (lft == NULL) {
		fprintf(stderr, "SYNTAX ERROR");
		return 2;
	}

	scalar_dispatch(
	    identity_d, 3, double, double,
	    identity_i, 2, int64_t, int64_t,
	    greateq_dd, 2, int64_t, double, double,
	    greateq_di, 2, int64_t, double, int64_t,
	    greateq_id, 2, int64_t, int64_t, double,
	    greateq_ii, 2, int64_t, int64_t, int64_t)
}


