#include <stdio.h>
#include <stdlib.h>

int
compute(int rgt) {
	int i, sum;
	
	sum = 0;
	
	for (i = 0; i < rgt; i++) {
		sum += i;
	}
	
	return sum;
}

int
main(int argc, char *argv[])
{
	int count, i;
	int *res;
	
	count = 100000;
	res = calloc(sizeof(int), 100000);
	
	for (i = 0; i < count; i++) res[i] = compute(i);
	
	printf("%d\n", res[count -1]);
}
