#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define YYPARSE parse_codfns
#define YY_CTX_LOCAL
#define INIT_STACK_SIZE 64

#define YY_INPUT(buf, result, max_size) \
{ \
	int yyc = fgetc(ctx->ifile); \
	result = (EOF == yyc) ? 0 : (*(buf) = yyc, 1); \
}

#define YY_CTX_MEMBERS Stack * stack; Pool *pool; FILE *ifile;

#include "pool.h"
#include "stack.h"
#include "ast.h"

void
parse_variable(Pool *p, Stack *s, char *n, int l)
{
	Variable *var;

	var = new_variable(p, n, l);
	push(s, var);
}

void
parse_global(Pool *p, Stack *s, enum global_type t)
{
	Variable *var;
	void *value;
	Global *g;

	value = pop(s);
	var = pop(s);
	g = new_global(p, var, t, value);

	push(s, g);
}

void
parse_module(Pool *p, Stack *s)
{
	int i, c; 
	Module *mod;

	c = STACK_COUNT(s);
	mod = new_module(p, c);
	mod->count = c;

	for (i = 0; i < c; i++) {
		mod->globals[i] = pop(s);
	}

	push(s, mod);
}

void
parse_intarray(Pool *p, Stack *os)
{
	int i, c;
	long *x;
	Integer *n;
	Constant *a;
	Stack *s;

	s = new_stack_barrier(os);
	c = STACK_COUNT(s);
	a = new_constant(p, c);
	x = a->elems;

	for (i = 0; i < c; i++) {
		n = pop(s);
		*x++ = n->value;
	}

	a->count = c;
	push(os, a);
	stack_dispose(s);
}

void
parse_barrier(Pool *p, Stack *s)
{
	push(s, NULL);
}

void
parse_int(Pool *p, Stack *s, char *ns, int l)
{
	long v;
	Integer *n;
	char b[64];

	strncpy(b, ns, l);
	v = strtol(b, NULL, 10);
	n = new_int(p, v);
	push(s, n);
}

void
parse_function(Pool *p, Stack *s)
{
	Function *fn;
	Expression **es, *e;
	void *val;

	val = pop(s);
	e = new_expression(p, EXPR_LIT, NULL, val);
	es = pool_alloc(p, sizeof(Expression *));
	*es = e;
	fn = new_function(p, es, 1);

	push(s, fn);
}

#include "grammar.c"

Module *
parse_file(Pool* p, char *fnam)
{
	yycontext ctx;
	Module *res;
	FILE *fil;

	if ((fil = fopen(fnam, "r")) == NULL) {
		perror("parse_file");
		return NULL;
	}
	
	memset(&ctx, 0, sizeof(yycontext));
	ctx.pool = p;
	ctx.ifile = fil;

	if ((ctx.stack = new_stack(INIT_STACK_SIZE)) == NULL) {
		fprintf(stderr, "parse_file: failed to allocate stack");
		return NULL;
	}

	while (parse_codfns(&ctx));

	if (STACK_COUNT(ctx.stack) == 0) {
		stack_dispose(ctx.stack);
		return NULL;
	}

	res = pop(ctx.stack);
	stack_dispose(ctx.stack);
	return res;
}
