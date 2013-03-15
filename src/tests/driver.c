#include <stdio.h>
#include <stdlib.h>

#include "runtime.h"

int run_test(void);

int
main(int argc, char *argv[])
{
	const char *name;

	name = argv[0];

	if (run_test()) {
		fprintf(stderr, "Failed %s.\n", name);
		return EXIT_FAILURE;
	} 

	return EXIT_SUCCESS;
}

int 
array_equal(Array *a, Array *b)
{
	int i, c;
	long *av, *bv;

	if (a->size != b->size) return 0;
	if (a->rank != b->rank) return 0;
	
	c = a->rank;
	av = a->shape;
	bv = b->shape;
	for (i = 0; i < c; i++)
		if (*av++ != *bv++)
			return 0;

	c = a->size;
	av = a->elems;
	bv = b->elems;
	for (i = 0; i < c; i++)
		if (*av++ != *bv++)
			return 0;

	return 1;
}
