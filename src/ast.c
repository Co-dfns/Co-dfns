#include <stdio.h>
#include <string.h>

#include "pool.h"
#include "ast.h"

void
print_constant(Constant *con)
{
	int i, c;
	long *n;

	c = con->count;
	n = con->elems;

	for (i = 0; i < c; i++)
		printf("%ld ", *n++);
}

void
print_variable(Variable *var)
{
	printf("%s", var->name);
}

void
print_function(Function *func)
{
        printf("{\n");

	switch (func->type) {
		case FUNCTION_VAR:
			print_variable(func->body);
			break;
		case FUNCTION_LIT:
			print_constant(func->body);
			break;
	}

        printf("\n}\n");

        return;
}

void
print_global(Global *global)
{
        printf("%s←", global->var->name);

	switch (global->type) {
		case GLOBAL_CONST:
			print_constant(global->value);
			break;
		case GLOBAL_FUNC:
			print_function(global->value);
			break;
	}


        return;
}

void
print_module(Module *module)
{
        int i;

        for (i=0; i < module->count; i++) {
                print_global(module->globals[i]);
                printf("\n");
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
	
	if ((buf = pool_alloc(p, s)) == NULL) {
		fprintf(stderr, "new_module: failed to create node");
		return NULL;
	}
	
	res = (Module *) (buf + count);
	res->count = count;
	res->globals = buf;

	return res;
}

Global *
new_global(Pool *p, Variable *v, enum global_type t, void *val)
{
	Global *res;

	res = NEW_NODE(p, Global, 0);

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

	if ((buf = pool_alloc(p, s)) == NULL) {
		fprintf(stderr, "new_constant: failed to create node");
		return NULL;
	}

	res = (Constant *) (buf + count);
	res->count = count;
	res->elems = buf;

	return res;
}

Function *
new_function(Pool *p, enum function_type t, void *body)
{
	Function *res;

	res = NEW_NODE(p, Function, 0);

	res->type = t;
	res->body = body;
	
	return res;
}

Variable *
new_variable(Pool *p, char *n, int l)
{
	char *str;
	Variable *res;

	res = NEW_NODE(p, Variable, 0);
	str = NEW_NODE(p, char, l);

	strncpy(str, n, l);
	res->name = str;

	return res;
}

Integer *
new_int(Pool *p, long v)
{
	Integer *res;

	res = NEW_NODE(p, Integer, 0);

	res->value = v;

	return res;
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
copy_function(Pool *p, Function *fn)
{
	enum function_type t;
	void *body;

	t = fn->type;

	switch (t) {
		case FUNCTION_LIT:
			body = copy_constant(p, fn->body);
			break;
		case FUNCTION_VAR:
			body = copy_variable(p, fn->body);
			break;
	}

	return new_function(p, t, body);
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

