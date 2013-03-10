#include <llvm-c/Core.h>

#include "pool.h"
#include "ast.h"

LLVMTypeRef 
constant_type(void)
{
	return LLVMInt64Type();
}

LLVMTypeRef
function_type(void)
{
	LLVMTypeRef rt;

	rt = LLVMInt64Type();
	return LLVMFunctionType(rt, NULL, 0, 0);
}

LLVMValueRef
gl_constant(Constant *v)
{
	long *n;

	n = v->elems;

	return LLVMConstInt(constant_type(), *n, 0);
}

void
gl_global(LLVMModuleRef m, Global *g)
{
	char *vn;
	LLVMValueRef v, gv;
	LLVMTypeRef t;

	vn = g->var->name;

	switch (g->type) {
	case GLOBAL_CONST:
		t = constant_type();
		v = gl_constant(g->value);
		gv = LLVMAddGlobal(m, t, vn);
		LLVMSetInitializer(gv, v);
		break;
	default:
		break;
	}
}

LLVMModuleRef
generate_llvm(Module *m, Pool *mp)
{
	int i, c;
	Global **gs;
	LLVMModuleRef vm;

	vm = LLVMModuleCreateWithName("Co-Dfns Module");
	c = m->count;
	gs = m->globals;
	
	for (i = 0; i < c; i++)
		gl_global(vm, *gs++);

	pool_dispose(mp);

	return vm;
}
