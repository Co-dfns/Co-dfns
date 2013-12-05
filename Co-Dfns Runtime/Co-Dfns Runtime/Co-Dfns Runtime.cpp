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

CODFNSRUNTIME_API LLVMTypeRef Int16Type (void)
{
	return LLVMInt16Type();
}

CODFNSRUNTIME_API LLVMTypeRef Int64Type (void)
{
	return LLVMInt64Type();
}

CODFNSRUNTIME_API LLVMTypeRef Int32Type (void)
{
	return LLVMInt32Type();
}

CODFNSRUNTIME_API LLVMTypeRef Int4Type (void)
{
	return LLVMIntType(4);
}

CODFNSRUNTIME_API LLVMTypeRef StructType (LLVMTypeRef *ElementTypes, unsigned ElementCount, LLVMBool Packed)
{
	return LLVMStructType(ElementTypes, ElementCount, Packed);
}

CODFNSRUNTIME_API LLVMTypeRef FunctionType (LLVMTypeRef ReturnType, LLVMTypeRef *ParamTypes, unsigned ParamCount, LLVMBool IsVarArg)
{
	return LLVMFunctionType(ReturnType, ParamTypes, ParamCount, IsVarArg);
}

CODFNSRUNTIME_API LLVMValueRef ConstIntOfString (LLVMTypeRef IntTy, const char *Text, uint8_t Radix)
{
	return LLVMConstIntOfString(IntTy, Text, Radix);
}

CODFNSRUNTIME_API LLVMValueRef ConstArray (LLVMTypeRef ElementTy, LLVMValueRef *ConstantVals, unsigned Length)
{
	return LLVMConstArray(ElementTy, ConstantVals, Length);
}

CODFNSRUNTIME_API LLVMValueRef ConstInt (LLVMTypeRef IntTy, unsigned long long N, LLVMBool SignExtend)
{
	return LLVMConstInt(IntTy, N, SignExtend);
}

CODFNSRUNTIME_API LLVMValueRef AddGlobal (LLVMModuleRef M, LLVMTypeRef Ty, const char *Name)
{
	return LLVMAddGlobal(M, Ty, Name);
}

CODFNSRUNTIME_API void SetInitializer (LLVMValueRef GlobalVar, LLVMValueRef ConstantVal)
{
	return LLVMSetInitializer(GlobalVar, ConstantVal);
}

CODFNSRUNTIME_API LLVMValueRef AddFunction (LLVMModuleRef M, const char *Name, LLVMTypeRef FunctionTy)
{
	return LLVMAddFunction(M, Name, FunctionTy);
}

CODFNSRUNTIME_API LLVMValueRef GetNamedGlobal (LLVMModuleRef M, const char *Name)
{
	return LLVMGetNamedGlobal(M, Name);
}

CODFNSRUNTIME_API LLVMBasicBlockRef AppendBasicBlock (LLVMValueRef Fn, const char *Name)
{
	return LLVMAppendBasicBlock(Fn, Name);
}

CODFNSRUNTIME_API LLVMBuilderRef CreateBuilder (void)
{
	return LLVMCreateBuilder();
}

CODFNSRUNTIME_API void PositionBuilderAtEnd (LLVMBuilderRef Builder, LLVMBasicBlockRef Block)
{
	return LLVMPositionBuilderAtEnd(Builder, Block);
}

CODFNSRUNTIME_API LLVMValueRef BuildRet (LLVMBuilderRef bldr, LLVMValueRef V)
{
	return LLVMBuildRet(bldr, V);
}

CODFNSRUNTIME_API void DisposeBuilder (LLVMBuilderRef Builder)
{
	return LLVMDisposeBuilder(Builder);
}

CODFNSRUNTIME_API LLVMValueRef ConstStruct (LLVMValueRef *ConstantVals, unsigned Count, LLVMBool Packed)
{
	return LLVMConstStruct(ConstantVals, Count, Packed);
}

CODFNSRUNTIME_API LLVMTypeRef PointerType (LLVMTypeRef ElementType, unsigned AddressSpace)
{
	return LLVMPointerType(ElementType, AddressSpace);
}