#include <stdlib.h>
#include <error.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "codfns.h"
#include "scalar.h"

/* codfns_not_equal()
 *
 * Intended Function: Compute the APL ≠ function.
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

#define notequal(nm, lt, rt) \
int inline static \
nm(int64_t *tgt, lt *lft, rt *rgt) \
{ \
	*tgt = (*lft != *rgt); \
	return 0; \
}

notequal(notequal_dd, double, double)
notequal(notequal_di, double, int64_t)
notequal(notequal_id, int64_t, double)
notequal(notequal_ii, int64_t, int64_t)

int
codfns_not_equal(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)  /* Add OCT argument */
{
	if (lft == NULL) {
		fprintf(stderr, "SYNTAX ERROR");
		return 2;
	}


	scalar_dispatch(
	    identity_d, 3, double, double,
	    identity_i, 2, int64_t, int64_t,
	    notequal_dd, 2, int64_t, double, double,
	    notequal_di, 2, int64_t, double, int64_t,
	    notequal_id, 2, int64_t, int64_t, double,
	    notequal_ii, 2, int64_t, int64_t, int64_t)
}



