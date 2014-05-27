#include <stdlib.h>
#include <error.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "codfns.h"
#include "scalar.h"

/* codfns_add()
 *
 * Intended Function: Compute the + APL primitive, both monadic and dyadic
 * cases.
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

#define add(nm, zt, lt, rt) \
int inline static \
nm(zt *tgt, lt *lft, rt *rgt) \
{ \
	*tgt = *lft + *rgt; \
	return 0; \
}

add(add_ii, int64_t, int64_t, int64_t)
add(add_id, double, int64_t, double)
add(add_di, double, double, int64_t)
add(add_dd, double, double, double)

int
codfns_add(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	scalar_dispatch(
	    identity_d, 3, double, double,
	    identity_i, 2, int64_t, int64_t,
	    add_dd, 3, double, double, double,
	    add_di, 3, double, double, int64_t,
	    add_id, 3, double, int64_t, double,
	    add_ii, 2, int64_t, int64_t, int64_t)
}

