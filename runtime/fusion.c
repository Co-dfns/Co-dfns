#include <stdlib.h>
#include <error.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include "codfns.h"
#include "scalar.h"

int
codfns_cursor(struct codfns_array *res, struct codfns_array *rgt)
{
	res->rank = ((0 == rgt->rank) ? 0 : 1);
	res->elements = rgt->elements;
	
	return 0;
}

int
codfns_bump_int(struct codfns_array *res, struct codfns_array *rgt)
{
	res->elements = ((int64_t *)rgt->elements) + rgt->rank;
	
	return 0;
}

int
codfns_bump_double(struct codfns_array *res, struct codfns_array *rgt)
{
	res->elements = ((double *)rgt->elements) + rgt->rank;

	return 0;
}
