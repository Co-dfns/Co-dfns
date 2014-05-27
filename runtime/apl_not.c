#include <stdlib.h>
#include <error.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "codfns.h"
#include "scalar.h"

/* codfns_not()
 *
 * Intended Function: Compute the APL ~ function, both monadic and dyadic.
 */

int
codfns_not(struct codfns_array *ret, struct codfns_array *lft, struct codfns_array *rgt)
{
  int i, k;
  int64_t *res_elems;
  uint32_t *shp;

  /* We return the negation array for the RHS */
  if (lft == NULL) {
    ret->size = rgt->size;
    ret->rank = rgt->rank;
    k = rgt->rank;

    res_elems = realloc(ret->elements, ret->size);
    shp = scalar(rgt) ? NULL : realloc(ret->shape, rgt->rank);
    memcpy(shp, rgt->shape, ret->rank);
    memcpy(res_elems, rgt->elements, rgt->size);

    for (i = 0; i < k; i++)
        res_elems[i] = !res_elems[i];

    ret->elements = res_elems;
    ret->shape = shp;

    return 0;
  }
  return 1;
}

