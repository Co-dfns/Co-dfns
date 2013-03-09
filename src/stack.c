#include <stdio.h>
#include <stdlib.h>

#include "stack.h"

Stack *
new_stack_barrier(Stack *s)
{
	int i, c;
	void *t;
	Stack *n;

	c = STACK_COUNT(s);
	n = new_stack(c);

	for (i = 0; i < c; i++) {
		t = pop(s);
		if (t == NULL) return n;
		push(n, t);
	}

	return n;
}

Stack *
new_stack(int count)
{
	Stack *res;
	void **buf;

	buf = malloc(count * sizeof(void *));

	if (buf == NULL) {
		perror("new_stack");
		return NULL;
	}

	res = malloc(sizeof(Stack));

	if (res == NULL) {
		perror("new_stack");
		free(buf);
		return NULL;
	}

	res->start = buf;
	res->end = buf + count;
	res->cur = buf;

	return res;
}

void
stack_dispose(Stack *s)
{
	free(s->start);
	free(s);
}

int
stack_resize(Stack *s, int count)
{
	int o;
	void **buf;
	
	o = STACK_COUNT(s);
	buf = realloc(s->start, count * sizeof(void *));

	if (buf == NULL) {
		perror("stack_resize");
		return 1;
	}

	s->start = buf;
	s->end = buf + count;
	s->cur = buf + o;

	return 0;
}

int
push(Stack *s, void *e)
{
	if (!STACK_AVAIL(s)) {
		if (stack_resize(s, 1.5 * STACK_SIZE(s) + 1)) {
			perror("push");
			return 1;
		}
	}

	*(s->cur++) = e;
	return 0;
}

