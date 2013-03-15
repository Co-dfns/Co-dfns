#include <stdlib.h>

#include "runtime.h"
#include "driver.h"

long v = 5;
Array a = {1, 0, NULL, &v};

Array *F(void);

int
run_test(void) 
{
	Array *res;

	res = F();

	return !array_equal(&a, res);
}
