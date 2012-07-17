#include <stdio.h>

#include "runtime.h"

int
main(int argc, char *argv[])
{
	unsigned short rank;
	size_t size;
	
	decl(a);
	alloc(a, 3, 8);
	
	return 0;
}
