#include <stdlib.h>
#include <error.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "codfns.h"
#include "scalar.h"

/* codfns_magnitude()
 *
 * Intended Function: Compute the APL | function.
 */

#define magnitude(nm, zt, rt) \
int inline static \
nm(zt *tgt, rt *rgt) \
{ \
	if (*rgt < 0) { \
		*tgt = -1 * *rgt; \
	} else { \
		*tgt = *rgt; \
	} \
 \
	return 0; \
}

magnitude(magnitude_i, int64_t, int64_t)
magnitude(magnitude_d, double, double)

int inline static
residue_ii(int64_t *tgt, int64_t *lft, int64_t *rgt)
{
	*tgt = *lft % *rgt;
	return 0;
}

#define residue(nm, zt, lt, rt) \
int inline static \
nm(zt *tgt, lt *lft, rt *rgt) \
{ \
	double res; \
\
	res = *rgt / *lft; \
	res = floor(res); \
	*tgt = *rgt - res * *lft; \
	return 0; \
}

residue(residue_id, double, int64_t, double)
residue(residue_di, double, double, int64_t)
residue(residue_dd, double, double, double)

int
codfns_residue(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	scalar_dispatch(
	    magnitude_d, 3, double, double,
	    magnitude_i, 2, int64_t, int64_t,
	    residue_dd, 3, double, double, double,
	    residue_di, 3, double, double, int64_t,
	    residue_id, 3, double, int64_t, double,
	    residue_ii, 2, int64_t, int64_t, int64_t)
}


