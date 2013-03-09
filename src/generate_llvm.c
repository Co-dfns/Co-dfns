#include <llvm-c/Core.h>

#include "pool.h"
#include "ast.h"

LLVMModuleRef
generate_llvm(Module *m, Pool *mp)
{
	LLVMModuleRef vm;

	pool_dispose(mp);

	vm = LLVMModuleCreateWithName("Sample Module");

	return vm;
}
