#include <stdlib.h>

#include "pool.h"
#include "runtime.h"
#include "driver.h"

long v[4] = {1, 2, 3, 4};
long s[1] = {4};
Array a = {4, 1, s, v};

Array *F(Pool *, Array *, Array *);

int
run_test(void)
{
	Array *res;

	res = F(NULL, NULL, NULL);

	return !array_equal(&a, res);
}
