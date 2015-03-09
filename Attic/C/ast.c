#include <stdio.h>
#include <string.h>

#include "pool.h"
#include "ast.h"

void
print_constant(FILE *fd, Constant *con)
{
	int i, c;
	long *n;

	c = con->count;
	n = con->elems;

	for (i = 0; i < c; i++)
		fprintf(fd, "%ld ", *n++);
}

void
print_variable(FILE *fd, Variable *var)
{
	fprintf(fd, "%s", var->name);
}

void
print_function(FILE *fd, Function *func)
{
	int i, c;
	Expression **es;

	fprintf(fd, "{\n");

	c = func->count;
	es = func->stmts;

	for (i = 0; i < c; i++) {
		print_expression(fd, *es++);
		fprintf(fd, "\n");
	}

	fprintf(fd, "\n}\n");

	return;
}

void 
print_expression(FILE *fd, Expression *exp) 
{
	if (exp->tgt != NULL) {
		print_variable(fd, exp->tgt);
		fprintf(fd, "←");
	}

	switch (exp->type) {
	case EXPR_LIT: 
		print_constant(fd, exp->value); 
		break;
	case EXPR_VAR: 
		print_variable(fd, exp->value); 
		break;
	case EXPR_APP:
		print_application(fd, exp->value);
		break;
	}
}

void
print_application(FILE *fd, Application *app)
{
	Expression *lft;

	lft = app->lft;

	if (lft != NULL) {
		switch (lft->type) {
		case EXPR_LIT:
			print_constant(fd, lft->value);
			break;
		case EXPR_VAR:
			print_variable(fd, lft->value);
			break;
		case EXPR_APP:
			fprintf(fd, "(");
			print_application(fd, lft->value);
			fprintf(fd, ")");
			break;
		}
	}
	
	fprintf(fd, " ");
	print_primitive(fd, app->fn);
	fprintf(fd, " ");
	print_expression(fd, app->rgt);
}

void
print_primitive(FILE *fd, enum primitive fn)
{
	const char *s;

	switch (fn) {
	case PRM_MINUS:
		s = "-"; break;
	case PRM_PLUS:
		s = "+"; break;
	case PRM_LT:
		s = "<"; break;
	case PRM_LTE:
		s = "≤"; break;
	case PRM_EQ:
		s = "="; break;
	case PRM_GTE:
		s = "≥"; break;
	case PRM_GT:
		s = ">"; break;
	case PRM_NEQ:
		s = "≠"; break;
	case PRM_AND:
		s = "∧"; break;
	case PRM_OR:
		s = "∨"; break;
	case PRM_TIMES:
		s = "×"; break;
	case PRM_DIV:
		s = "÷"; break;
	case PRM_HOOK:
		s = "?"; break;
	case PRM_MEM:
		s = "∊"; break;
	case PRM_RHO:
		s = "⍴"; break;
	case PRM_NOT:
		s = "~"; break;
	case PRM_TAKE:
		s = "↑"; break;
	case PRM_DROP:
		s = "↓"; break;
	case PRM_IOTA:
		s = "⍳"; break;
	case PRM_CIRC:
		s = "○"; break;
	case PRM_POW:
		s = "*"; break;
	case PRM_CEIL:
		s = "⌈"; break;
	case PRM_FLOOR:
		s = "⌊"; break;
	case PRM_DEL:
		s = "∇"; break;
	case PRM_RGT:
		s = "⊢"; break;
	case PRM_LFT:
		s = "⊣"; break;
	case PRM_ENCL:
		s = "⊂"; break;
	case PRM_DIS:
		s = "⊃"; break;
	case PRM_INTER:
		s = "∩"; break;
	case PRM_UNION:
		s = "∪"; break;
	case PRM_ENC:
		s = "⊤"; break;
	case PRM_DEC:
		s = "⊥"; break;
	case PRM_ABS:
		s = "|"; break;
	case PRM_EXPNF:
		s = "⍀"; break;
	case PRM_FILF:
		s = "⌿"; break;
	case PRM_GRDD:
		s = "⍒"; break;
	case PRM_GRDU:
		s = "⍋"; break;
	case PRM_ROT:
		s = "⌽"; break;
	case PRM_TRANS:
		s = "⍉"; break;
	case PRM_ROTF:
		s = "⊖"; break;
	case PRM_LOG:
		s = "⍟"; break;
	case PRM_NAND:
		s = "⍲"; break;
	case PRM_NOR:
		s = "⍱"; break;
	case PRM_BANG:
		s = "!"; break;
	case PRM_MDIV:
		s = "⌹"; break;
	case PRM_FIND:
		s = "⍸"; break;
	case PRM_SQUAD:
		s = "⌷"; break;
	case PRM_EQV:
		s = "≡"; break;
	case PRM_NEQV:
		s = "≢"; break;
	case PRM_CATF:
		s = "⍪"; break;
	case PRM_FIL:
		s = "/"; break;
	case PRM_EXPND:
		s = "\\"; break;
	case PRM_CAT:
		s = ","; break;
	case PRM_HAT:
		s = "^"; break;
	}

	fprintf(fd, "%s", s);
}

void
print_global(FILE *fd, Global *global)
{
	fprintf(fd, "%s←", global->var->name);

	switch (global->type) {
		case GLOBAL_CONST:
			print_constant(fd, global->value);
			break;
		case GLOBAL_FUNC:
			print_function(fd, global->value);
			break;
	}


	return;
}

void
print_module(FILE *fd, Module *module)
{
	int i;

	for (i=0; i < module->count; i++) {
		print_global(fd, module->globals[i]);
		fprintf(fd, "\n");
	}

	return;
}

Module *
new_module(Pool *p, int count)
{
	size_t s;
	Module *res;
	Global **buf;

	s = sizeof(Module) + count * sizeof(Global *);
	buf = pool_alloc(p, s);
	res = (Module *) (buf + count);
	res->count = count;
	res->globals = buf;

	return res;
}

Global *
new_global(Pool *p, Variable *v, enum global_type t, void *val)
{
	Global *res;

	res = NEW_NODE(p, Global);

	res->var = v;
	res->type = t;
	res->value = val;

	return res;
}

Constant *
new_constant(Pool *p, int count)
{
	size_t s;
	Constant *res;
	long *buf;

	s = sizeof(Constant) + count * sizeof(long);
	buf = pool_alloc(p, s);
	res = (Constant *) (buf + count);
	res->count = count;
	res->elems = buf;

	return res;
}

Function *
new_function(Pool *p, Expression **es, int c)
{
	Function *res;

	res = NEW_NODE(p, Function);

	res->count = c;
	res->stmts = es;
	
	return res;
}

Expression *
new_expression(Pool *p, enum expr_type t, Variable *nam, void *val) 
{
	Expression *exp;

	exp = NEW_NODE(p, Expression);

	exp->type = t;
	exp->tgt = nam;
	exp->value = val;

	return exp;
}

Application *
new_application(Pool *p, enum primitive fn, Expression *lft, Expression *rgt)
{
	Application *app;

	app = NEW_NODE(p, Application);

	app->fn = fn;
	app->lft = lft;
	app->rgt = rgt;

	return app;
}

Variable *
new_variable(Pool *p, char *n, int l)
{
	char *str;
	Variable *res;

	res = NEW_NODE(p, Variable);
	str = pool_alloc(p, sizeof(char) * (l + 1));

	strncpy(str, n, l);
	res->name = str;

	return res;
}

Integer *
new_int(Pool *p, long v)
{
	Integer *res;

	res = NEW_NODE(p, Integer);

	res->value = v;

	return res;
}

Primitive *
new_primitive(Pool *p, enum primitive fn)
{
	Primitive *prm;

	prm = NEW_NODE(p, Primitive);
	prm->value = fn;

	return prm;
}

Module *
copy_module(Pool *p, Module *m)
{
	int i, c;
	Module *res;
	Global **tgs, **sgs;

	c = m->count;
	res = new_module(p, c);
	tgs = res->globals;
	sgs = m->globals;
	res->count = c;

	for (i = 0; i < c; i++) 
		*tgs++ = *sgs++;

	return res;
}

Global *
copy_global(Pool *p, Global *g)
{
	Variable *v;
	enum global_type t;
	void *val;

	v = copy_variable(p, g->var);
	t = g->type;
	switch (t) {
		case GLOBAL_FUNC:
			val = copy_function(p, g->value);
			break;
		case GLOBAL_CONST:
			val = copy_constant(p, g->value);
			break;
	}

	return new_global(p, v, t, val);
}

Constant *
copy_constant(Pool *p, Constant *cnst)
{
	int i, c;
	Constant *res;
	long *tns, *sns;

	c = cnst->count;
	res = new_constant(p, c);
	res->count = c;
	tns = res->elems;
	sns = cnst->elems;

	for (i = 0; i < c; i++)
		*tns++ = *sns++;

	return res;
}

Function *
copy_function(Pool *p, Function *ofn)
{
	int i, c;
	Expression **es, **esi, **stmts;
	Function *fn;
	
	c = ofn->count;
	stmts = ofn->stmts;
	esi = es = pool_alloc(p, c * sizeof(Expression *));
	
	for (i = 0; i < c; i++)
		*esi++ = copy_expression(p, *stmts++);

	fn = NEW_NODE(p, Function);

	fn->count = c;
	fn->stmts = es;
	
	return fn;
}

Expression *
copy_expression(Pool *p, Expression *oe)
{
	Expression *exp;

	exp = NEW_NODE(p, Expression);

	exp->type = oe->type;
	exp->tgt = oe->tgt == NULL ? NULL : copy_variable(p, oe->tgt);
	
	switch (exp->type) {
	case EXPR_LIT:
		exp->value = copy_constant(p, oe->value);
		break;
	case EXPR_VAR:
		exp->value = copy_variable(p, oe->value);
		break;
	case EXPR_APP:
		exp->value = copy_application(p, oe->value);
		break;
	}

	return exp;
}

Application *
copy_application(Pool *p, Application *oa)
{
	Application *app;

	app = NEW_NODE(p, Application);

	app->fn = oa->fn;
	app->lft = oa->lft == NULL ? NULL : copy_expression(p, oa->lft);
	app->rgt = copy_expression(p, oa->rgt);

	return app;
}

Variable *
copy_variable(Pool *p, Variable *var)
{
	return new_variable(p, var->name, strlen(var->name));
}

Integer *
copy_int(Pool *p, Integer *n)
{
	return new_int(p, n->value);
}

Primitive *
copy_primitive(Pool *p, Primitive *prm)
{
	return new_primitive(p, prm->value);
}
