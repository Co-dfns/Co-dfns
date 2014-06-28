#include <stdlib.h>
#include <error.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "codfns.h"
#include "scalar.h"

/* codfns_greater()
 *
 * Intended Function: Compute the APL > function.
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

#define great(nm, lt, rt) \
int inline static \
nm(int64_t *tgt, lt *lft, rt *rgt) \
{ \
	*tgt = (*lft > *rgt); \
	return 0; \
}

great(great_dd, double, double)
great(great_di, double, int64_t)
great(great_id, int64_t, double)
great(great_ii, int64_t, int64_t)

int
codfns_greater(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	if (lft == NULL) {
		fprintf(stderr, "SYNTAX ERROR");
		return 2;
	}

	scalar_dispatch(
	    identity_d, 3, double, double,
	    identity_i, 2, int64_t, int64_t,
	    great_dd, 2, int64_t, double, double,
	    great_di, 2, int64_t, double, int64_t,
	    great_id, 2, int64_t, int64_t, double,
	    great_ii, 2, int64_t, int64_t, int64_t)
}


