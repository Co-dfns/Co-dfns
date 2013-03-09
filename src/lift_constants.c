#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "pool.h"
#include "stack.h"
#include "ast.h"
#include "util.h"

#define INIT_POOL_SIZE 64

void fail_exit(char *msg, Pool *mp)
{
	fprintf(stderr, "lift_constants: %s\n", msg);
	pool_dispose(mp);
	exit(EXIT_FAILURE);
}

Function *lc_function(Pool *mp, Stack *s, Function *fn)
{
	char *u;
	Variable *v;
	Constant *c;
	Global *g;

	u = unique_name(mp, "gvar");
	v = new_variable(mp, u, strlen(u));
	c = copy_constant(mp, fn->body);
	g = new_global(mp, v, GLOBAL_CONST, c);
	push(s, g);

	fn = new_function(mp, FUNCTION_VAR, v);

	return fn;
}

Global *lc_global(Pool *mp, Stack *s, Global *g)
{
	Function *fn;
	Variable *v;

	fn = g->value;

	switch (fn->type) {
	case FUNCTION_VAR:
		g = copy_global(mp, g);
		break;
	case FUNCTION_LIT:
		fn = lc_function(mp, s, fn);
		v = copy_variable(mp, g->var);
		g = new_global(mp, v, GLOBAL_FUNC, fn);
		break;
	}

	return g;
}

void lift_constants(Module **astp, Pool **mpp)
{
	int i, c;
	Global *g, **gs;
	Module *om;
	Pool *mp;
	Stack *ngs;

	if ((mp = new_pool(POOL_SIZE(*mpp))) == NULL) 
		fail_exit("failed to create pool", *mpp);

	if ((ngs = new_stack(INIT_POOL_SIZE)) == NULL) 
		fail_exit("failed to create stack", *mpp);

	c = (*astp)->count;
	gs = (*astp)->globals;

	for (i = 0; i < c; i++) {
		g = *gs++;
		switch (g->type) {
		case GLOBAL_CONST:
			g = copy_global(mp, g);
			break;
		case GLOBAL_FUNC:
			g = lc_global(mp, ngs, g);
			break;
		}
		push(ngs, g);
	}

	pool_dispose(*mpp);
	c = STACK_COUNT(ngs);
	
	if ((om = new_module(mp, c)) == NULL)
		fail_exit("failed to create outgoing module", mp);

	gs = om->globals + c;

	for (i = 0; i < c; i++) 
		*(--gs) = pop(ngs);

	stack_dispose(ngs);
	*astp = om;
	*mpp = mp;
}
