#include <stdio.h>
#include <string.h>

#include "pool.h"
#include "ast.h"

unsigned short var_counter = 0;

#define COUNTER_MAX 65536
#define COUNTER_DIGITS 5

Variable *
unique_variable(Pool *mp, const char *prefix)
{
	char *b;
	size_t l;
	Variable *v;

	l = strlen(prefix);
	v = NEW_NODE(mp, Variable);
	b = pool_alloc(mp, l + COUNTER_DIGITS + 1);
	v->name = b;
	strcpy(b, prefix);
	b += l;
	sprintf(b, "%hd", var_counter);
	var_counter = (var_counter +1) % COUNTER_MAX;

	return v;
}

