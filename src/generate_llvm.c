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
	LLVMTypeRef p, pts[2];

	p = LLVMPointerType(constant_type(), 0);
	pts[0] = p;
	pts[1] = p;

	return LLVMFunctionType(p, pts, 2, 0);
}

LLVMValueRef
primitive_function(LLVMModuleRef m, enum primitive fn)
{
	LLVMTypeRef t;

	t = function_type();

	switch (fn) {
	case PRM_MINUS: return LLVMAddFunction(m, "codfns_minus", t);
	case PRM_PLUS: return LLVMAddFunction(m, "codfns_plus", t);
	case PRM_LT: return LLVMAddFunction(m, "codfns_lt", t);
	case PRM_LTE: return LLVMAddFunction(m, "codfns_lte", t);
	case PRM_EQ: return LLVMAddFunction(m, "codfns_eq", t);
	case PRM_GTE: return LLVMAddFunction(m, "codfns_gte", t);
	case PRM_GT: return LLVMAddFunction(m, "codfns_gt", t);
	case PRM_NEQ: return LLVMAddFunction(m, "codfns_neq", t);
	case PRM_AND: return LLVMAddFunction(m, "codfns_and", t);
	case PRM_OR: return LLVMAddFunction(m, "codfns_or", t);
	case PRM_TIMES: return LLVMAddFunction(m, "codfns_times", t);
	case PRM_DIV: return LLVMAddFunction(m, "codfns_div", t);
	case PRM_HOOK: return LLVMAddFunction(m, "codfns_hook", t);
	case PRM_MEM: return LLVMAddFunction(m, "codfns_mem", t);
	case PRM_RHO: return LLVMAddFunction(m, "codfns_rho", t);
	case PRM_NOT: return LLVMAddFunction(m, "codfns_not", t);
	case PRM_TAKE: return LLVMAddFunction(m, "codfns_take", t);
	case PRM_DROP: return LLVMAddFunction(m, "codfns_drop", t);
	case PRM_IOTA: return LLVMAddFunction(m, "codfns_iota", t);
	case PRM_CIRC: return LLVMAddFunction(m, "codfns_circ", t);
	case PRM_POW: return LLVMAddFunction(m, "codfns_pow", t);
	case PRM_CEIL: return LLVMAddFunction(m, "codfns_ceil", t);
	case PRM_FLOOR: return LLVMAddFunction(m, "codfns_floor", t);
	case PRM_DEL: return LLVMAddFunction(m, "codfns_del", t);
	case PRM_RGT: return LLVMAddFunction(m, "codfns_rgt", t);
	case PRM_LFT: return LLVMAddFunction(m, "codfns_lft", t);
	case PRM_ENCL: return LLVMAddFunction(m, "codfns_encl", t);
	case PRM_DIS: return LLVMAddFunction(m, "codfns_dis", t);
	case PRM_INTER: return LLVMAddFunction(m, "codfns_inter", t);
	case PRM_UNION: return LLVMAddFunction(m, "codfns_union", t);
	case PRM_ENC: return LLVMAddFunction(m, "codfns_enc", t);
	case PRM_DEC: return LLVMAddFunction(m, "codfns_dec", t);
	case PRM_ABS: return LLVMAddFunction(m, "codfns_abs", t);
	case PRM_EXPNF: return LLVMAddFunction(m, "codfns_expnf", t);
	case PRM_FILF: return LLVMAddFunction(m, "codfns_filf", t);
	case PRM_GRDD: return LLVMAddFunction(m, "codfns_grdd", t);
	case PRM_GRDU: return LLVMAddFunction(m, "codfns_grdu", t);
	case PRM_ROT: return LLVMAddFunction(m, "codfns_rot", t);
	case PRM_TRANS: return LLVMAddFunction(m, "codfns_trans", t);
	case PRM_ROTF: return LLVMAddFunction(m, "codfns_rotf", t);
	case PRM_LOG: return LLVMAddFunction(m, "codfns_log", t);
	case PRM_NAND: return LLVMAddFunction(m, "codfns_nand", t);
	case PRM_NOR: return LLVMAddFunction(m, "codfns_nor", t);
	case PRM_BANG: return LLVMAddFunction(m, "codfns_bang", t);
	case PRM_MDIV: return LLVMAddFunction(m, "codfns_mdiv", t);
	case PRM_FIND: return LLVMAddFunction(m, "codfns_find", t);
	case PRM_SQUAD: return LLVMAddFunction(m, "codfns_squad", t);
	case PRM_EQV: return LLVMAddFunction(m, "codfns_eqv", t);
	case PRM_NEQV: return LLVMAddFunction(m, "codfns_neqv", t);
	case PRM_CATF: return LLVMAddFunction(m, "codfns_catf", t);
	case PRM_FIL: return LLVMAddFunction(m, "codfns_fil", t);
	case PRM_EXPND: return LLVMAddFunction(m, "codfns_expnd", t);
	case PRM_CAT: return LLVMAddFunction(m, "codfns_cat", t);
	case PRM_HAT: return LLVMAddFunction(m, "codfns_hat", t);
	}
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

LLVMValueRef
gl_application(LLVMModuleRef m, LLVMBuilderRef bldr, Application *a)
{
	Expression *el, *er;
	char *lft, *rgt;
	enum primitive prm;
	LLVMValueRef args[2], fn, call;

	prm = a->fn;
	el = a->lft;
	er = a->rgt;
	
	lft = el == NULL ? NULL : ((Variable *) el->value)->name;
	rgt = ((Variable *) el->value)->name;

	if (lft == NULL) {
		args[0] = LLVMConstPointerNull(constant_type());
	} else {
		args[0] = LLVMGetNamedGlobal(m, lft);
	}

	args[1] = LLVMGetNamedGlobal(m, rgt);
	fn = primitive_function(m, prm);
	call = LLVMBuildCall(bldr, fn, args, 2, "");
	
	return call;
}

void
gl_expression(LLVMModuleRef m, LLVMBuilderRef bldr, Expression *e)
{
	char *vn;
	LLVMValueRef res;
	
	switch (e->type) {
	case EXPR_VAR:
		vn = ((Variable *) e->value)->name;
		res = LLVMGetNamedGlobal(m, vn);
		break;
	case EXPR_APP:
		res = gl_application(m, bldr, e->value);
		break;
	case EXPR_LIT:	
		fprintf(stderr, "EXPR_LIT in gl_function; this should never happen\n");
		exit(EXIT_FAILURE);
	}
	
	LLVMBuildRet(bldr, res);
}

void
gl_function(LLVMModuleRef m, LLVMValueRef lf, Function *fn)
{
	Expression *e;
	LLVMBasicBlockRef bb;
	LLVMBuilderRef bldr;
	
	bldr = LLVMCreateBuilder();
	bb = LLVMAppendBasicBlock(lf, "_");
	LLVMPositionBuilderAtEnd(bldr, bb);

	/* For now we assume that we have one variable expression */
	e = fn->stmts[0];
	gl_expression(m, bldr, e);

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

	pool_dispose(mp);
	pool_dispose(p);

	return vm;
}
