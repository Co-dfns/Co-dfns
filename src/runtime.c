#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "pool.h"
#include "runtime.h"

Array *
array_copy(Pool *p, Array *a)
{
	Array *res;

	res = NEW_NODE(p, Array);
	res->size = a->size;
	res->rank = a->rank;
	res->shape = pool_alloc(p, res->rank * sizeof(long));
	res->elems = pool_alloc(p, res->size * sizeof(long));
	memcpy(res->shape, a->shape, res->rank);
	memcpy(res->elems, a->elems, res->size);
	
	return res;
}

int
same_shape(Array *a, Array *b)
{
	int i, c;
	long *av, *bv;

	if (a->rank != b->rank) return 0;

	c = a->rank;
	av = a->shape;
	bv = b->shape;

	for (i = 0; i < c; i++)
		if (*av++ != *bv++)
			return 0;

	return 1;
}

#define SCALAR(a) ((a)->rank == 0)

Array *
codfns_plus(Pool *p, Array *lft, Array *rgt)
{
	int i, c;
	Array *res;
	long s, *tv, *lv, *rv;

	if (lft == NULL) return array_copy(p, rgt);

	res = NEW_NODE(p, Array);

	if (same_shape(lft, rgt)) {
		c = res->size = lft->size;
		res->rank = lft->rank;
		res->shape = pool_alloc(p, lft->rank * sizeof(long));
		memcpy(res->shape, lft->shape, res->rank);
		lv = lft->elems;
		rv = rgt->elems;
		tv = res->elems = pool_alloc(p, c * sizeof(long));
		for (i = 0; i < c; i++) *tv++ = *lv++ + *rv++;
	} else if (SCALAR(lft)) {
		c = res->size = rgt->size;
		res->rank = rgt->rank;
		res->shape = pool_alloc(p, rgt->rank * sizeof(long));
		memcpy(res->shape, rgt->shape, res->rank);
		s = *lft->elems;
		rv = rgt->elems;
		tv = res->elems = pool_alloc(p, c * sizeof(long));
		for (i = 0; i < c; i++) *tv++ = s + *rv++;
	} else if (SCALAR(rgt)) {
		c = res->size = lft->size;
		res->rank = lft->rank;
		res->shape = pool_alloc(p, lft->rank * sizeof(long));
		memcpy(res->shape, lft->shape, res->rank);
		s = *rgt->elems;
		lv = lft->elems;
		tv = res->elems = pool_alloc(p, c * sizeof(long));
		for (i = 0; i < c; i++) *tv++ = *lv++ + s;
	}

	return res;
}
