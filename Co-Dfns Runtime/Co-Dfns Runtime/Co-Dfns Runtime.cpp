// Co-Dfns Runtime.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"
#include "Co-Dfns Runtime.h"
#include "llvm-c/Core.h"


// This is an example of an exported variable
CODFNSRUNTIME_API int nCoDfnsRuntime=0;

// This is an example of an exported function.
CODFNSRUNTIME_API int fnCoDfnsRuntime(void)
{
	return 42;
}

CODFNSRUNTIME_API LLVMModuleRef ModuleCreateWithName(const char *ModuleID) 
{
	return LLVMModuleCreateWithName(ModuleID);
}

CODFNSRUNTIME_API LLVMBool PrintModuleToFile (LLVMModuleRef M, const char *Filename, char **ErrorMessage)
{
	return LLVMPrintModuleToFile(M, Filename, ErrorMessage);
}

CODFNSRUNTIME_API void DisposeMessage (char *Message)
{
	LLVMDisposeMessage (Message);
}