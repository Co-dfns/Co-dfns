#include <stdio.h>
#include <stdlib.h>

#include <llvm-c/Core.h>

#include "pool.h"
#include "ast.h"

#define INIT_POOL_SIZE 1024

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
primitive_function(LLVMModuleRef m, enum primitive fn)
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

	v = LLVMGetNamedFunction(m, nm);

	if (v == NULL)
		v = LLVMAddFunction(m, nm, t);

	return v;
}

LLVMValueRef
gl_constant(Pool *p, LLVMModuleRef m, Constant *v)
{
	int i, c;
	long *n;
	LLVMValueRef k, g, s, *ln, *lni, r[4];
	LLVMTypeRef t, ts, pt;

	c = v->count;
	n = v->elems;
	lni = ln = pool_alloc(p, c * sizeof(LLVMValueRef));

	for (i = 0; i < c; i++)
		*lni++ = LLVMConstInt(long_type(), *n++, 0);

	t = LLVMArrayType(long_type(), c);
	pt = LLVMPointerType(long_type(), 0);
	g = LLVMAddGlobal(m, t, "");
	r[0] = LLVMConstInt(int_type(), c, 0);
	r[3] = LLVMConstPointerCast(g, pt);
	LLVMSetInitializer(g, LLVMConstArray(long_type(), ln, c));

	if (c == 1) {
		r[1] = LLVMConstInt(int_type(), 0, 0);
		r[2] = LLVMConstPointerNull(pt);
	} else {
		ts = LLVMArrayType(long_type(), 1);
		s = LLVMAddGlobal(m, ts, "");
		k = LLVMConstInt(long_type(), c, 0);
		r[1] = LLVMConstInt(int_type(), 1, 0);
		r[2] = LLVMConstPointerCast(s, pt);
		LLVMSetInitializer(s, LLVMConstArray(long_type(), &k, 1));
	}

	return LLVMConstStruct(r, 4, 0);
}

LLVMValueRef gl_expression(LLVMModuleRef, LLVMBuilderRef, LLVMValueRef, Expression *);

LLVMValueRef
gl_application(LLVMModuleRef m, LLVMBuilderRef bldr, LLVMValueRef lf, Application *a)
{
	LLVMValueRef args[3], fn, call;
	
	args[0] = LLVMGetParam(lf, 0);

	if (a->lft == NULL) 
		args[1] = LLVMConstPointerNull(constant_type());
	else
		args[1] = gl_expression(m, bldr, lf, a->lft);

	args[2] = gl_expression(m, bldr, lf, a->rgt);

	fn = primitive_function(m, a->fn);
	call = LLVMBuildCall(bldr, fn, args, 3, "");
	
	return call;
}

LLVMValueRef
gl_expression(LLVMModuleRef m, LLVMBuilderRef bldr, LLVMValueRef lf, Expression *e)
{
	char *vn;
	LLVMValueRef res;
	
	switch (e->type) {
	case EXPR_VAR:
		vn = ((Variable *) e->value)->name;
		res = LLVMGetNamedGlobal(m, vn);
		break;
	case EXPR_APP:
		res = gl_application(m, bldr, lf, e->value);
		break;
	case EXPR_LIT:	
		fprintf(stderr, "EXPR_LIT in gl_function; this should never happen\n");
		exit(EXIT_FAILURE);
	}
	
	return res;
}

void
gl_function(LLVMModuleRef m, LLVMValueRef lf, Function *fn)
{
	Expression *e;
	LLVMBasicBlockRef bb;
	LLVMBuilderRef bldr;
	LLVMValueRef rv;
	
	bldr = LLVMCreateBuilder();
	bb = LLVMAppendBasicBlock(lf, "_");
	LLVMPositionBuilderAtEnd(bldr, bb);

	/* For now we assume that we have one variable expression */
	e = fn->stmts[0];
	rv = gl_expression(m, bldr, lf, e);

	LLVMBuildRet(bldr, rv);
	LLVMDisposeBuilder(bldr);
}

void
gl_global(Pool *p, LLVMModuleRef m, Global *g)
{
	char *vn;
	LLVMValueRef v, gv;
	LLVMTypeRef t;

	vn = g->var->name;

	switch (g->type) {
	case GLOBAL_CONST:
		t = constant_type();
		v = gl_constant(p, m, g->value);
		gv = LLVMAddGlobal(m, t, vn);
		LLVMSetInitializer(gv, v);
		break;
	case GLOBAL_FUNC:
		t = function_type();
		gv = LLVMAddFunction(m, vn, t);
		gl_function(m, gv, g->value);
		break;
	}
}

LLVMModuleRef
generate_llvm(Module *m, Pool *mp)
{
	int i, c;
	Global **gs;
	LLVMModuleRef vm;
	Pool *p;

	p = new_pool(INIT_POOL_SIZE);
	vm = LLVMModuleCreateWithName("Co-Dfns Module");
	c = m->count;
	gs = m->globals;
	
	for (i = 0; i < c; i++)
		gl_global(p, vm, *gs++);

	LLVMSetTarget(vm, "x86_64-slackware-linux-gnu");

	pool_dispose(mp);
	pool_dispose(p);

	return vm;
}
