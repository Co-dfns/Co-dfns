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
		return NULL;
	}

	res = malloc(sizeof(Pool));

	if (res == NULL) {
		perror("new_pool");
		free(buf);
		return NULL;
	}

	res->start = buf;
	res->end = buf + s;
	res->cur = buf;
	
	return res;
}

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

	while (s > POOL_AVAIL(p)) {
		if (pool_resize(p, 1.5 * POOL_SIZE(p)))
			return NULL;
	}

	res = p->cur;
	p->cur = ((char *)p->cur) + s;

	return res;
}
