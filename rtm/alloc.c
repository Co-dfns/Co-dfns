#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include "internal.h"

size_t malloc_count = 0;
size_t calloc_count = 0;
size_t realloc_count = 0;
size_t free_count = 0;

void *
cell_malloc(size_t size)
{
	malloc_count++;
	
	return malloc(size);
}

void *
cell_realloc(void *obj, size_t size)
{
	realloc_count++;
	
	return realloc(obj, size);
}

void *
cell_calloc(size_t nmemb, size_t size)
{
	calloc_count++;
	
	return calloc(nmemb, size);
}

void
cell_free(void *obj)
{
	free_count++;
	
	free(obj);
}

DECLSPEC void
print_memstats(void)
{
	printf("Memory Statistics:\n");
	printf("\tmalloc count: %zd\n", malloc_count);
	printf("\tcalloc count: %zd\n", calloc_count);
	printf("\trealloc count: %zd\n", realloc_count);
	printf("\tfree count: %zd\n", free_count);
}