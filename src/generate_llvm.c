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
	LLVMTypeRef t[2];

	t[0] = int_type();
	t[1] = LLVMPointerType(long_type(), 0);
	
	return LLVMStructType(t, 2, 0);
}

LLVMTypeRef
function_type(void)
{
	LLVMTypeRef p;

	p = LLVMPointerType(constant_type(), 0);

	return LLVMFunctionType(p, NULL, 0, 0);
}

LLVMValueRef
gl_constant(Pool *p, LLVMModuleRef m, Constant *v)
{
	int i, c;
	long *n;
	LLVMValueRef g, *ln, *lni, r[2];
	LLVMTypeRef t;

	c = v->count;
	n = v->elems;
	lni = ln = pool_alloc(p, c * sizeof(LLVMValueRef));

	for (i = 0; i < c; i++)
		*lni++ = LLVMConstInt(long_type(), *n++, 0);

	t = LLVMArrayType(long_type(), c);
	g = LLVMAddGlobal(m, t, "");
	r[0] = LLVMConstInt(int_type(), c, 0);
	r[1] = LLVMConstPointerCast(g, LLVMPointerType(long_type(), 0));
	LLVMSetInitializer(g, LLVMConstArray(long_type(), ln, c));

	return LLVMConstStruct(r, 2, 0);
}

void
gl_function(LLVMModuleRef m, LLVMValueRef lf, Function *fn)
{
	char *vn;
	LLVMBasicBlockRef bb;
	LLVMBuilderRef bldr;
	LLVMValueRef g;
	
	bldr = LLVMCreateBuilder();
	bb = LLVMAppendBasicBlock(lf, "_");
	vn = ((Variable *) fn->body)->name;
	g = LLVMGetNamedGlobal(m, vn);
	
	LLVMPositionBuilderAtEnd(bldr, bb);
	LLVMBuildRet(bldr, g);
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
