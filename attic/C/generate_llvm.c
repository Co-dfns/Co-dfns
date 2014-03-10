#include <stdio.h>
#include <stdlib.h>

#include <llvm-c/Core.h>

#include "env.h"
#include "pool.h"
#include "ast.h"

#define INIT_POOL_SIZE 1024
#define INIT_ENV_SIZE 64

struct state {
	LLVMModuleRef module;
	LLVMBuilderRef builder;
	Pool *pool;
	Environment *env;
};

LLVMTypeRef 
long_type(void)
{
	return LLVMIntType(sizeof(long)*8);
}

LLVMTypeRef
int_type(void)
{
	return LLVMIntType(sizeof(int)*8);
}

LLVMTypeRef
constant_type(void)
{
	LLVMTypeRef t[4];

	t[0] = int_type();
	t[1] = int_type();
	t[2] = LLVMPointerType(long_type(), 0);
	t[3] = LLVMPointerType(long_type(), 0);
	
	return LLVMStructType(t, 4, 0);
}

LLVMTypeRef
function_type(void)
{
	LLVMTypeRef p, pts[3];

	pts[0] = LLVMPointerType(LLVMInt8Type(), 0);
	p = LLVMPointerType(constant_type(), 0);
	pts[1] = p;
	pts[2] = p;

	return LLVMFunctionType(p, pts, 3, 0);
}

LLVMValueRef
primitive_function(struct state *s, enum primitive fn)
{
	const char *nm;
	LLVMTypeRef t;
	LLVMValueRef v;

	t = function_type();

	switch (fn) {
	case PRM_MINUS: nm = "codfns_minus"; break;
	case PRM_PLUS: nm = "codfns_plus"; break;
	case PRM_LT: nm = "codfns_lt"; break;
	case PRM_LTE: nm = "codfns_lte"; break;
	case PRM_EQ: nm = "codfns_eq"; break;
	case PRM_GTE: nm = "codfns_gte"; break;
	case PRM_GT: nm = "codfns_gt"; break;
	case PRM_NEQ: nm = "codfns_neq"; break;
	case PRM_AND: nm = "codfns_and"; break;
	case PRM_OR: nm = "codfns_or"; break;
	case PRM_TIMES: nm = "codfns_times"; break;
	case PRM_DIV: nm = "codfns_div"; break;
	case PRM_HOOK: nm = "codfns_hook"; break;
	case PRM_MEM: nm = "codfns_mem"; break;
	case PRM_RHO: nm = "codfns_rho"; break;
	case PRM_NOT: nm = "codfns_not"; break;
	case PRM_TAKE: nm = "codfns_take"; break;
	case PRM_DROP: nm = "codfns_drop"; break;
	case PRM_IOTA: nm = "codfns_iota"; break;
	case PRM_CIRC: nm = "codfns_circ"; break;
	case PRM_POW: nm = "codfns_pow"; break;
	case PRM_CEIL: nm = "codfns_ceil"; break;
	case PRM_FLOOR: nm = "codfns_floor"; break;
	case PRM_DEL: nm = "codfns_del"; break;
	case PRM_RGT: nm = "codfns_rgt"; break;
	case PRM_LFT: nm = "codfns_lft"; break;
	case PRM_ENCL: nm = "codfns_encl"; break;
	case PRM_DIS: nm = "codfns_dis"; break;
	case PRM_INTER: nm = "codfns_inter"; break;
	case PRM_UNION: nm = "codfns_union"; break;
	case PRM_ENC: nm = "codfns_enc"; break;
	case PRM_DEC: nm = "codfns_dec"; break;
	case PRM_ABS: nm = "codfns_abs"; break;
	case PRM_EXPNF: nm = "codfns_expnf"; break;
	case PRM_FILF: nm = "codfns_filf"; break;
	case PRM_GRDD: nm = "codfns_grdd"; break;
	case PRM_GRDU: nm = "codfns_grdu"; break;
	case PRM_ROT: nm = "codfns_rot"; break;
	case PRM_TRANS: nm = "codfns_trans"; break;
	case PRM_ROTF: nm = "codfns_rotf"; break;
	case PRM_LOG: nm = "codfns_log"; break;
	case PRM_NAND: nm = "codfns_nand"; break;
	case PRM_NOR: nm = "codfns_nor"; break;
	case PRM_BANG: nm = "codfns_bang"; break;
	case PRM_MDIV: nm = "codfns_mdiv"; break;
	case PRM_FIND: nm = "codfns_find"; break;
	case PRM_SQUAD: nm = "codfns_squad"; break;
	case PRM_EQV: nm = "codfns_eqv"; break;
	case PRM_NEQV: nm = "codfns_neqv"; break;
	case PRM_CATF: nm = "codfns_catf"; break;
	case PRM_FIL: nm = "codfns_fil"; break;
	case PRM_EXPND: nm = "codfns_expnd"; break;
	case PRM_CAT: nm = "codfns_cat"; break;
	case PRM_HAT: nm = "codfns_hat"; break;
	}

	v = LLVMGetNamedFunction(s->module, nm);

	if (v == NULL)
		v = LLVMAddFunction(s->module, nm, t);

	return v;
}

LLVMValueRef
gl_constant(struct state *s, Constant *v)
{
	int i, c;
	long *n;
	LLVMValueRef k, g, sh, *ln, *lni, r[4];
	LLVMTypeRef t, tsh, pt;

	c = v->count;
	n = v->elems;
	lni = ln = pool_alloc(s->pool, c * sizeof(LLVMValueRef));

	for (i = 0; i < c; i++)
		*lni++ = LLVMConstInt(long_type(), *n++, 0);

	t = LLVMArrayType(long_type(), c);
	pt = LLVMPointerType(long_type(), 0);
	g = LLVMAddGlobal(s->module, t, "");
	r[0] = LLVMConstInt(int_type(), c, 0);
	r[3] = LLVMConstPointerCast(g, pt);
	LLVMSetInitializer(g, LLVMConstArray(long_type(), ln, c));

	if (c == 1) {
		r[1] = LLVMConstInt(int_type(), 0, 0);
		r[2] = LLVMConstPointerNull(pt);
	} else {
		tsh = LLVMArrayType(long_type(), 1);
		sh = LLVMAddGlobal(s->module, tsh, "");
		k = LLVMConstInt(long_type(), c, 0);
		r[1] = LLVMConstInt(int_type(), 1, 0);
		r[2] = LLVMConstPointerCast(sh, pt);
		LLVMSetInitializer(sh, LLVMConstArray(long_type(), &k, 1));
	}

	return LLVMConstStruct(r, 4, 0);
}

LLVMValueRef gl_expression(struct state *, LLVMValueRef, Expression *);

LLVMValueRef
gl_application(struct state *s, LLVMValueRef lf, Application *a)
{
	LLVMValueRef args[3], fn, call;

	args[0] = LLVMGetParam(lf, 0);

	/* Process right argument first to match order of execution (side-effects) */
	args[2] = gl_expression(s, lf, a->rgt);

	if (a->lft == NULL) 
		args[1] = LLVMConstPointerNull(constant_type());
	else
		args[1] = gl_expression(s, lf, a->lft);

	fn = primitive_function(s, a->fn);
	call = LLVMBuildCall(s->builder, fn, args, 3, "");
	
	return call;
}

LLVMValueRef
gl_variable(struct state *s, Variable *var)
{
	enum env_type t;
	void *v;
	
	if (env_lookup(s->env, var->name, &t, &v))
		return v;
	else
		v = LLVMGetNamedGlobal(s->module, var->name);

	if (v == NULL) {
		fprintf(stderr, "Unknown variable %s\n", var->name);
		exit(EXIT_FAILURE);
	}

	return v;
}

LLVMValueRef
gl_expression(struct state *s, LLVMValueRef lf, Expression *e)
{
	const char *nm;
	LLVMValueRef res;
	
	switch (e->type) {
	case EXPR_VAR:
		res = gl_variable(s, e->value);
		break;
	case EXPR_APP:
		res = gl_application(s, lf, e->value);
		break;
	case EXPR_LIT:	
		fprintf(stderr, "EXPR_LIT in gl_function; this should never happen\n");
		exit(EXIT_FAILURE);
	}

	if (e->tgt != NULL) {
		nm = e->tgt->name;
		env_insert(s->env, nm, ENV_VALUE, res);
		LLVMSetValueName(res, nm); 
	}

	return res;
}

void
gl_function(struct state *s, LLVMValueRef lf, Function *fn)
{
	int i, c;
	Expression **e;
	LLVMBasicBlockRef bb;
	LLVMValueRef rv;
	
	bb = LLVMAppendBasicBlock(lf, "_");
	LLVMPositionBuilderAtEnd(s->builder, bb);
	env_insert_frame(s->env);
	c = fn->count;
	e = fn->stmts;

	for (i = 0; i < c; i++)
		rv = gl_expression(s, lf, *e++);

	env_clear_frame(s->env);
	LLVMBuildRet(s->builder, rv);
}

void
gl_global(struct state *s, Global *g)
{
	char *vn;
	LLVMValueRef v, gv;
	LLVMTypeRef t;

	vn = g->var->name;

	switch (g->type) {
	case GLOBAL_CONST:
		t = constant_type();
		v = gl_constant(s, g->value);
		gv = LLVMAddGlobal(s->module, t, vn);
		LLVMSetInitializer(gv, v);
		break;
	case GLOBAL_FUNC:
		t = function_type();
		gv = LLVMAddFunction(s->module, vn, t);
		gl_function(s, gv, g->value);
		break;
	}
}

LLVMModuleRef
generate_llvm(Module *m, Pool *mp)
{
	int i, c;
	Global **gs;
	struct state s;

	s.pool = new_pool(INIT_POOL_SIZE);
	s.module = LLVMModuleCreateWithName("Co-Dfns Module");
	s.builder = LLVMCreateBuilder();
	s.env = new_env(INIT_ENV_SIZE);
	c = m->count;
	gs = m->globals;
	
	for (i = 0; i < c; i++)
		gl_global(&s, *gs++);

	LLVMSetTarget(s.module, "x86_64-slackware-linux-gnu");

	pool_dispose(mp);
	pool_dispose(s.pool);
	env_dispose(s.env);
	LLVMDisposeBuilder(s.builder);

	return s.module;
}
