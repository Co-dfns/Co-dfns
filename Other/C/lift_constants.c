#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "pool.h"
#include "stack.h"
#include "ast.h"
#include "util.h"

#define INIT_POOL_SIZE 64

void 
fail_exit(const char *msg, Pool *mp)
{
	fprintf(stderr, "lift_constants: %s\n", msg);
	pool_dispose(mp);
	exit(EXIT_FAILURE);
}

Variable *
lift(Pool *mp, Stack *s, Constant *a)
{
	Variable *v;
	Constant *c;
	Global *g;
	
	v = unique_variable(mp, "gvar");
	c = copy_constant(mp, a);
	g = new_global(mp, v, GLOBAL_CONST, c);
	push(s, g);

	return v;
}

Application *lc_application(Pool *, Stack *, Application *);

Expression *
lc_expression(Pool *mp, Stack *s, Expression *oe)
{
	Expression *e;
	Variable *v, *tgt;
	Application *app;

	switch (oe->type) {
	case EXPR_VAR:
		e = copy_expression(mp, oe);
		break;
	case EXPR_LIT:
		v = lift(mp, s, oe->value);
		tgt = oe->tgt == NULL ? NULL : copy_variable(mp, oe->tgt);
		e = new_expression(mp, EXPR_VAR, tgt, v);
		break;
	case EXPR_APP:
		app = lc_application(mp, s, oe->value);
		tgt = oe->tgt == NULL? NULL : copy_variable(mp, oe->tgt);
		e = new_expression(mp, EXPR_APP, tgt, app);
		break;
	}

	return e;
}

Application *
lc_application(Pool *mp, Stack *s, Application *oa)
{
	Application *app;
	enum primitive fn;
	Expression *lft, *rgt;

	lft = oa->lft == NULL ? NULL : lc_expression(mp, s, oa->lft);
	rgt = lc_expression(mp, s, oa->rgt);
	fn = oa->fn;
	app = new_application(mp, fn, lft, rgt);

	return app;
}

Function *
lc_function(Pool *mp, Stack *s, Function *ofn)
{
	int i, c;
	Expression **es, **esi, **oes;

	c = ofn->count;
	oes = ofn->stmts;
	esi = es = pool_alloc(mp, c * sizeof(Expression *));

	for (i = 0; i < c; i++)
		*esi++ = lc_expression(mp, s, *oes++);

	return new_function(mp, es, c);
}

Global *
lc_global(Pool *mp, Stack *s, Global *g)
{
	Function *fn;
	Variable *v;

	fn = lc_function(mp, s, g->value);
	v = copy_variable(mp, g->var);
	return new_global(mp, v, GLOBAL_FUNC, fn);
}

void 
lift_constants(Module **astp, Pool **mpp)
{
	int i, c;
	Global *g, **gs;
	Module *om;
	Pool *mp;
	Stack *ngs;

	mp = new_pool(POOL_SIZE(*mpp));
	ngs = new_stack(INIT_POOL_SIZE);
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
	om = new_module(mp, c);
	gs = om->globals + c;

	for (i = 0; i < c; i++) 
		*(--gs) = pop(ngs);

	stack_dispose(ngs);
	*astp = om;
	*mpp = mp;
}
