#include <stdlib.h>
#include <error.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "codfns.h"
#include "scalar.h"


/* codfns_ridx[fi]()
 * 
 * Intended Function: Given a guaranteed scalar right argument, a left argument 
 * whose size must admit the index given by the scalar right integer argument, 
 * extract the element indexed by the right argument of the ravel of the left.
 * That is, compute the following:
 * 
 *   res←(,lft)[rgt]
 * 
 * where ⟨((⍴res)≡⍬)∧(⍴rgt)≡⍬⟩.
 *
 * There are float and integer variants for the obvious reasons.
 */

int
codfns_ridxf(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	if (lft->rank == 0) {
		*((double *)res->elements) = *((double *)lft->elements);
	} else {
		int64_t *ip = rgt->elements;
		double *elm = lft->elements;
		double *rese = res->elements;
		*rese = elm[*ip];
	}

	return 0;
}

int
codfns_ridxi(struct codfns_array *res,
    struct codfns_array *lft, struct codfns_array *rgt)
{
	if (lft->rank == 0) {
		*((int64_t *)res->elements) = *((int64_t *)lft->elements);
	} else {
		int64_t *ip = rgt->elements;
		int64_t *elm = lft->elements;
		int64_t *rese = res->elements;
		*rese = elm[*ip];
	}

	return 0;
}

