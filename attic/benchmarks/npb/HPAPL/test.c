#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>

int
main(int argc, char *argv[])
{
	int64_t x,y,z;
	uint64_t t, u, v;
	uint64_t m;
	
	m = 1;
	m = (m<<46)-1;
	x = 1; t = 1;
	x = y = (x<<62)+0xFFFF;
	t = u = (t<<62)+0xFFFF;
	
	printf("%ld\n", x);
	printf("%lu\n", t);
	
	z = x*y;
	v = t*u;
	
	printf("%ld\n", m & z);
	printf("%lu\n", m & v);
	return 0;
}
