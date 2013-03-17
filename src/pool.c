#include <stdio.h>
#include <stdlib.h>

#include "pool.h"

Pool *
new_pool(size_t s)
{
	char *buf;
	Pool *res;

	buf = malloc(s);

	if (buf == NULL) {
		perror("new_pool");
		exit(EXIT_FAILURE);
	}

	res = malloc(sizeof(Pool));

	if (res == NULL) {
		perror("new_pool");
		free(buf);
		exit(EXIT_FAILURE);
	}

	res->start = buf;
	res->end = buf + s;
	res->cur = buf;
	
	return res;
}

/* This is not used right now because Pools cannot be resized. */
int
pool_resize(Pool *p, size_t s)
{
	char *buf;
	size_t o;

	buf = p->start;
	o = POOL_USED(p);
	buf = realloc(buf, s);

	if (buf == NULL) {
		perror("pool_resize");
		return 1;
	}

	p->start = buf;
	p->end = buf + s;
	p->cur = buf + o;

	return 0;
}

void
pool_dispose(Pool *p)
{
	free(p->start);
	free(p);
}

void *
pool_alloc(Pool *p, size_t s)
{
	void *res;

	if (s > POOL_AVAIL(p)) {
		fprintf(stderr, "No more memory in pool\n");
		exit(EXIT_FAILURE);
	}

	res = p->cur;
	p->cur = ((char *)p->cur) + s;

	return res;
}
