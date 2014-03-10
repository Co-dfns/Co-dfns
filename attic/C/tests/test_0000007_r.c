#include <stdio.h>
#include <stdlib.h>

#include "pool.h"
#include "runtime.h"
#include "driver.h"

long v[4] = {14, 18, 22, 26};
long s[1] = {4};
Array a = {4, 1, s, v};

Array *F(Pool *, Array *, Array *);

int
run_test(void) 
{
	Array *res;
	Pool *p;

	p = new_pool(256);
	res = F(p, NULL, NULL);

	return !array_equal(&a, res);
}
