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

#define YY_CTX_MEMBERS Stack *stack; Pool *pool; FILE *ifile;

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

	v = strtol(ns, NULL, 10);
	n = new_int(p, v);
	push(s, n);
}

void
parse_function(Pool *p, Stack *os)
{
	int i, c;
	Stack *s;
	Function *fn;
	Expression **es;

	s = new_stack_barrier(os);
	c = STACK_COUNT(s);
	es = pool_alloc(p, c * sizeof(Expression *));
	fn = new_function(p, es, c);

	for (i = 0; i < c; i++)
		*es++ = pop(s);

	push(os, fn);
	stack_dispose(s);
}

void
parse_expression(Pool *p, Stack *s, enum expr_type t)
{
	Expression *e;
	void *val;
	
	val = pop(s);
	e = new_expression(p, t, NULL, val);

	push(s, e);
}

void
parse_application(Pool *p, Stack *s)
{
	Primitive *prm;
	Expression *lft, *rgt;
	Application *app;

	rgt = pop(s);
	prm = pop(s);
	lft = pop(s);
	app = new_application(p, prm->value, lft, rgt);
	
	push(s, app);
}

void
parse_primitive(Pool *p, Stack *s, char *txt, int len)
{
	enum primitive fn;
	Primitive *prm;

	if (!strncmp(txt, "-", len)) fn = PRM_MINUS;
	else if (!strncmp(txt, "+", len)) fn = PRM_PLUS;
	else if (!strncmp(txt, "<", len)) fn = PRM_LT;
	else if (!strncmp(txt, "≤", len)) fn = PRM_LTE;
	else if (!strncmp(txt, "=", len)) fn = PRM_EQ;
	else if (!strncmp(txt, "≥", len)) fn = PRM_GTE;
	else if (!strncmp(txt, ">", len)) fn = PRM_GT;
	else if (!strncmp(txt, "≠", len)) fn = PRM_NEQ;
	else if (!strncmp(txt, "∧", len)) fn = PRM_AND;
	else if (!strncmp(txt, "∨", len)) fn = PRM_OR;
	else if (!strncmp(txt, "×", len)) fn = PRM_TIMES;
	else if (!strncmp(txt, "÷", len)) fn = PRM_DIV;
	else if (!strncmp(txt, "?", len)) fn = PRM_HOOK;
	else if (!strncmp(txt, "∊", len)) fn = PRM_MEM;
	else if (!strncmp(txt, "⍴", len)) fn = PRM_RHO;
	else if (!strncmp(txt, "~", len)) fn = PRM_NOT;
	else if (!strncmp(txt, "↑", len)) fn = PRM_TAKE;
	else if (!strncmp(txt, "↓", len)) fn = PRM_DROP;
	else if (!strncmp(txt, "⍳", len)) fn = PRM_IOTA;
	else if (!strncmp(txt, "○", len)) fn = PRM_CIRC;
	else if (!strncmp(txt, "*", len)) fn = PRM_POW;
	else if (!strncmp(txt, "⌈", len)) fn = PRM_CEIL;
	else if (!strncmp(txt, "⌊", len)) fn = PRM_FLOOR;
	else if (!strncmp(txt, "∇", len)) fn = PRM_DEL;
	else if (!strncmp(txt, "⊢", len)) fn = PRM_RGT;
	else if (!strncmp(txt, "⊣", len)) fn = PRM_LFT;
	else if (!strncmp(txt, "⊂", len)) fn = PRM_ENCL;
	else if (!strncmp(txt, "⊃", len)) fn = PRM_DIS;
	else if (!strncmp(txt, "∩", len)) fn = PRM_INTER;
	else if (!strncmp(txt, "∪", len)) fn = PRM_UNION;
	else if (!strncmp(txt, "⊤", len)) fn = PRM_ENC;
	else if (!strncmp(txt, "⊥", len)) fn = PRM_DEC;
	else if (!strncmp(txt, "|", len)) fn = PRM_ABS;
	else if (!strncmp(txt, "⍀", len)) fn = PRM_EXPNF;
	else if (!strncmp(txt, "⌿", len)) fn = PRM_FILF;
	else if (!strncmp(txt, "⍒", len)) fn = PRM_GRDD;
	else if (!strncmp(txt, "⍋", len)) fn = PRM_GRDU;
	else if (!strncmp(txt, "⌽", len)) fn = PRM_ROT;
	else if (!strncmp(txt, "⍉", len)) fn = PRM_TRANS;
	else if (!strncmp(txt, "⊖", len)) fn = PRM_ROTF;
	else if (!strncmp(txt, "⍟", len)) fn = PRM_LOG;
	else if (!strncmp(txt, "⍲", len)) fn = PRM_NAND;
	else if (!strncmp(txt, "⍱", len)) fn = PRM_NOR;
	else if (!strncmp(txt, "!", len)) fn = PRM_BANG;
	else if (!strncmp(txt, "⌹", len)) fn = PRM_MDIV;
	else if (!strncmp(txt, "⍸", len)) fn = PRM_FIND;
	else if (!strncmp(txt, "⌷", len)) fn = PRM_SQUAD;
	else if (!strncmp(txt, "≡", len)) fn = PRM_EQV;
	else if (!strncmp(txt, "≢", len)) fn = PRM_NEQV;
	else if (!strncmp(txt, "⍪", len)) fn = PRM_CATF;
	else if (!strncmp(txt, "/", len)) fn = PRM_FIL;
	else if (!strncmp(txt, "\\", len)) fn = PRM_EXPND;
	else if (!strncmp(txt, ",", len)) fn = PRM_CAT;
	else if (!strncmp(txt, "^", len)) fn = PRM_HAT;
	else {
		fprintf(stderr, "unknown primitive %s\n", txt);
		stack_dispose(s);
		pool_dispose(p);
		exit(EXIT_FAILURE);
	}

	prm = new_primitive(p, fn);
	push(s, prm);
}

void
parse_assignment(Pool *p, Stack *s)
{
	Expression *e;
	Variable *v;

	e = pop(s);
	v = pop(s);

	e->tgt = v;

	push(s, e);
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
	ctx.stack = new_stack(INIT_STACK_SIZE);

	while (parse_codfns(&ctx));

	if (STACK_COUNT(ctx.stack) == 0) {
		stack_dispose(ctx.stack);
		return NULL;
	}

	res = pop(ctx.stack);
	stack_dispose(ctx.stack);
	return res;
}
