#include "h.cuh"


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
		int64_t *ip = (int64_t*)rgt->elements;
		double *elm = (double*)lft->elements;
		double *rese = (double*)res->elements;
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
		int64_t *ip = (int64_t*)rgt->elements;
		int64_t *elm = (int64_t*)lft->elements;
		int64_t *rese = (int64_t*)res->elements;
		*rese = elm[*ip];
	}

	return 0;
}

/* codfns_sverify()
 *
 */

int
codfns_sverify(struct codfns_array *res, 
    struct codfns_array *lft, struct codfns_array *rgt)
{
	struct codfns_array *pat;

	if (same_shape(lft, rgt)) pat = lft;
	else if (scalar(lft)) pat = rgt;
	else if (scalar(rgt)) pat = lft;
	else return 5;
	
	if (copy_shape(res, pat)) return 99;
	res->size = pat->size;

	return 0;
}

