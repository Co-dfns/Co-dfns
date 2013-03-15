#include <stdlib.h>

#include "runtime.h"
#include "driver.h"

long v[4] = {1, 2, 3, 4};
long s[1] = {4};
Array a = {4, 1, s, v};

Array *F(void);

int
run_test(void)
{
	Array *res;

	res = F();

	return !array_equal(&a, res);
}
