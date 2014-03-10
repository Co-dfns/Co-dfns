#include <stdlib.h>

#include "pool.h"
#include "runtime.h"
#include "driver.h"

long v = 5;
Array a = {1, 0, NULL, &v};

Array *F(Pool *, Array *, Array *);

int
run_test(void) 
{
	Array *res;

	res = F(NULL, NULL, NULL);

	return !array_equal(&a, res);
}
