 {Z}←FFI∆INIT;P;Core;ExEng;X86Info;X86CodeGen;X86Desc;R
 Z←⍬
 Core←LLVMCore
 ExEng←LLVMExecutionEngine
 X86Info←LLVMX86Info
 X86CodeGen←LLVMX86CodeGen
 X86Desc←LLVMX86Desc
 R←CoDfnsRuntime
 P←'LLVM'

⍝ LLVMTypeRef LLVMTypeOf (LLVMValueRef Val)
 'TypeOf'⎕NA'P ',Core,'|',P,'TypeOf P'

⍝ LLVMTypeRef LLVMInt8Type (void)
 'Int8Type'⎕NA'P ',Core,'|',P,'Int8Type'

⍝ LLVMTypeRef  LLVMInt16Type (void)
 'Int16Type'⎕NA'P ',Core,'|',P,'Int16Type'

⍝ LLVMTypeRef  LLVMInt32Type (void)
 'Int32Type'⎕NA'P ',Core,'|',P,'Int32Type'

⍝ LLVMTypeRef  LLVMInt64Type (void)
 'Int64Type'⎕NA'P ',Core,'|',P,'Int64Type'

⍝ LLVMTypeRef LLVMDoubleType(void)
 'DoubleType'⎕NA'P ',Core,'|',P,'DoubleType'

⍝ LLVMTypeRef LLVMVoidType(void)
 'VoidType'⎕NA'P ',Core,'|',P,'VoidType'

⍝ LLVMTypeRef
⍝ LLVMFunctionType (LLVMTypeRef ReturnType,
⍝    LLVMTypeRef *ParamTypes, unsigned ParamCount, LLVMBool IsVarArg)
 'FunctionType'⎕NA'P ',Core,'|',P,'FunctionType P <P[] U I'

⍝ LLVMTypeRef
⍝ LLVMStructType (LLVMTypeRef *ElementTypes, unsigned ElementCount, LLVMBool Packed)
 'StructType'⎕NA'P ',Core,'|',P,'StructType <P[] U I'

⍝ void
⍝ LLVMStructSetBody (LLVMTypeRef StructTy,
⍝     LLVMTypeRef *ElementTypes, unsigned ElementCount, LLVMBool Packed)
 'StructSetBody'⎕NA Core,'|',P,'StructSetBody P <P[] U I'

⍝ LLVMPointerType (LLVMTypeRef ElementType, unsigned AddressSpace)
 'PointerType'⎕NA'P ',Core,'|',P,'PointerType P U'

⍝ LLVMTypeRef     LLVMArrayType (LLVMTypeRef ElementType, unsigned ElementCount)
 'ArrayType'⎕NA'P ',Core,'|',P,'ArrayType P U'

⍝ LLVMTypeRef     LLVMStructCreateNamed (LLVMContextRef C, const char *Name)
 'StructCreateNamed'⎕NA'P ',Core,'|',P,'StructCreateNamed P <0C[]'

⍝ LLVMValueRef     LLVMConstReal (LLVMTypeRef RealTy, double N)
 'ConstReal'⎕NA'P ',Core,'|',P,'ConstReal P F'

⍝ LLVMValueRef  LLVMConstInt (LLVMTypeRef IntTy, unsigned long long N, LLVMBool SignExtend)
 'ConstInt'⎕NA'P ',Core,'|',P,'ConstInt P I8 I'

⍝ LLVMValueRef  LLVMConstIntOfString (LLVMTypeRef IntTy, const char *Text, uint8_t Radix)
 'ConstIntOfString'⎕NA'P ',Core,'|',P,'ConstIntOfString P <0C[] U8'

⍝ LLVMValueRef
⍝ LLVMConstArray (LLVMTypeRef ElementTy, LLVMValueRef *ConstantVals, unsigned Length)
 'ConstArray'⎕NA'P ',Core,'|',P,'ConstArray P <P[] U'

⍝ LLVMValueRef     LLVMConstPointerNull (LLVMTypeRef Ty)
 'ConstPointerNull'⎕NA'P ',Core,'|',P,'ConstPointerNull P'

⍝ LLVMValueRef  LLVMAddGlobal (LLVMModuleRef M, LLVMTypeRef Ty, const char *Name)
 'AddGlobal'⎕NA'P ',Core,'|',P,'AddGlobal P P <0C[]'

⍝ void  LLVMSetInitializer (LLVMValueRef GlobalVar, LLVMValueRef ConstantVal)
 'SetInitializer'⎕NA'',Core,'|',P,'SetInitializer P P'

⍝ LLVMValueRef  LLVMAddFunction (LLVMModuleRef M, const char *Name, LLVMTypeRef FunctionTy)
 'AddFunction'⎕NA'P ',Core,'|',P,'AddFunction P <0C[] P'

⍝ LLVMValueRef  LLVMGetNamedGlobal (LLVMModuleRef M, const char *Name)
 'GetNamedGlobal'⎕NA'P ',Core,'|',P,'GetNamedGlobal P <0C[]'

⍝ LLVMValueRef     LLVMGetNamedFunction (LLVMModuleRef M, const char *Name)
 'GetNamedFunction'⎕NA'P ',Core,'|',P,'GetNamedFunction P <0C[]'

⍝ LLVMBasicBlockRef  LLVMAppendBasicBlock (LLVMValueRef Fn, const char *Name)
 'AppendBasicBlock'⎕NA'P ',Core,'|',P,'AppendBasicBlock P <0C[]'

⍝ LLVMBuilderRef  LLVMCreateBuilder (void)
 'CreateBuilder'⎕NA'P ',Core,'|',P,'CreateBuilder'

⍝ void  LLVMPositionBuilderAtEnd (LLVMBuilderRef Builder, LLVMBasicBlockRef Block)
 'PositionBuilderAtEnd'⎕NA'P ',Core,'|',P,'PositionBuilderAtEnd P P'

⍝ LLVMValueRef  LLVMBuildRet (LLVMBuilderRef, LLVMValueRef V)
 'BuildRet'⎕NA'P ',Core,'|',P,'BuildRet P P'

⍝ LLVMValueRef     LLVMBuildRetVoid (LLVMBuilderRef)
 'BuildRetVoid'⎕NA'P ',Core,'|',P,'BuildRetVoid P'

⍝ LLVMValueRef
⍝ LLVMBuildCondBr (LLVMBuilderRef, LLVMValueRef If, LLVMBasicBlockRef Then,
⍝     LLVMBasicBlockRef Else)
 'BuildCondBr'⎕NA'P ',Core,'|',P,'BuildCondBr P P P P'

⍝ LLVMValueRef
⍝ LLVMBuildCall (LLVMBuilderRef, LLVMValueRef Fn,
⍝     LLVMValueRef *Args, unsigned NumArgs, const char *Name)
 'BuildCall'⎕NA'P ',Core,'|',P,'BuildCall P P <P[] U <0C'

⍝ void  LLVMDisposeBuilder (LLVMBuilderRef Builder)
 'DisposeBuilder'⎕NA'P ',Core,'|',P,'DisposeBuilder P'

⍝ LLVMValueRef
⍝ LLVMConstStruct (LLVMValueRef *ConstantVals, unsigned Count, LLVMBool Packed)
 'ConstStruct'⎕NA'P ',Core,'|',P,'ConstStruct <P[] U I'

⍝ LLVMValueRef     LLVMBuildAlloca (LLVMBuilderRef, LLVMTypeRef Ty, const char *Name)
 'BuildAlloca'⎕NA'P ',Core,'|',P,'BuildAlloca P P <0C'

⍝ LLVMValueRef     LLVMBuildLoad (LLVMBuilderRef, LLVMValueRef PointerVal, const char *Name)
 'BuildLoad'⎕NA'P ',Core,'|',P,'BuildLoad P P <0C'

⍝ LLVMValueRef     LLVMBuildStore (LLVMBuilderRef, LLVMValueRef Val, LLVMValueRef Ptr)
 'BuildStore'⎕NA'P ',Core,'|',P,'BuildStore P P P'

⍝ LLVMBasicBlockRef     LLVMGetInsertBlock (LLVMBuilderRef Builder)
 'GetInsertBlock'⎕NA'P ',Core,'|',P,'GetInsertBlock P'

⍝ LLVMValueRef     LLVMGetLastInstruction (LLVMBasicBlockRef BB)
 'GetLastInstruction'⎕NA'P ',Core,'|',P,'GetLastInstruction P'

⍝ LLVMBasicBlockRef     LLVMGetPreviousBasicBlock (LLVMBasicBlockRef BB)
 'GetPreviousBasicBlock'⎕NA'P ',Core,'|',P,'GetPreviousBasicBlock P'

⍝ LLVMValueRef
⍝ LLVMBuildStructGEP (LLVMBuilderRef B, LLVMValueRef Pointer, unsigned Idx, const char *Name)
 'BuildStructGEP'⎕NA'P ',Core,'|',P,'BuildStructGEP P P U <0C'

⍝ LLVMValueRef
⍝ LLVMBuildGEP (LLVMBuilderRef B, LLVMValueRef Pointer, LLVMValueRef *Indices,
⍝     unsigned NumIndices, const char *Name)
 'BuildGEP'⎕NA'P ',Core,'|',P,'BuildGEP P P <P[] U <0C'

⍝ LLVMValueRef
⍝ LLVMBuildBitCast (LLVMBuilderRef, LLVMValueRef Val, LLVMTypeRef DestTy, const char *Name)
 'BuildBitCast'⎕NA'P ',Core,'|',P,'BuildBitCast P P P <0C'

⍝ LLVMValueRef
⍝ LLVMBuildICmp (LLVMBuilderRef, LLVMIntPredicate Op, LLVMValueRef LHS,
⍝     LLVMValueRef RHS, const char *Name)
 'BuildICmp'⎕NA'P ',Core,'|',P,'BuildICmp P U P P <0C'

⍝ LLVMValueRef
⍝ LLVMBuildArrayAlloca (LLVMBuilderRef,
⍝     LLVMTypeRef Ty, LLVMValueRef Val, const char *Name)
 'BuildArrayAlloca'⎕NA'P ',Core,'|',P,'BuildArrayAlloca P P P <0C'

⍝ LLVMValueRef     LLVMGetParam (LLVMValueRef Fn, unsigned Index)
 'GetParam'⎕NA'P ',Core,'|',P,'GetParam P U'

⍝ unsigned     LLVMCountParams (LLVMValueRef Fn)
 'CountParams'⎕NA'U ',Core,'|',P,'CountParams P'

⍝ LLVMBool
⍝ LLVMPrintModuleToFile (LLVMModuleRef M, const char *Filename, char **ErrorMessage)
 'PrintModuleToFile'⎕NA'I4 ',Core,'|',P,'PrintModuleToFile P <0C >P'

⍝ void LLVMDisposeMessage (char *Message)
 'DisposeMessage'⎕NA Core,'|',P,'DisposeMessage P'

⍝ LLVMContextRef     LLVMGetGlobalContext (void)
 'GetGlobalContext'⎕NA'P ',Core,'|',P,'GetGlobalContext'

⍝ LLVMModuleRef LLVMModuleCreateWithName (const char *ModuleID)
 'ModuleCreateWithName'⎕NA'P ',Core,'|',P,'ModuleCreateWithName <0C'

⍝ LLVMValueRef
⍝ LLVMAddAlias (LLVMModuleRef M, LLVMTypeRef Ty, LLVMValueRef Aliasee, const char *Name)
 'AddAlias'⎕NA'P ',Core,'|',P,'AddAlias P P P <0C'

⍝ LLVMBool
⍝ LLVMCreateJITCompilerForModule (LLVMExecutionEngineRef *OutJIT,
⍝     LLVMModuleRef M, unsigned OptLevel, char **OutError)
 'CreateJITCompilerForModule'⎕NA'I ',ExEng,'|',P,'CreateJITCompilerForModule >P P U >P'

⍝ LLVMGenericValueRef
⍝ LLVMRunFunction (LLVMExecutionEngineRef EE,
⍝     LLVMValueRef F, unsigned NumArgs, LLVMGenericValueRef *Args)
 'RunFunction'⎕NA'P ',ExEng,'|',P,'RunFunction P P U <P[]'

⍝ void * LLVMGenericValueToPointer (LLVMGenericValueRef GenVal)
 'GenericValueToPointer'⎕NA'P ',ExEng,'|',P,'GenericValueToPointer P'

⍝ void * LLVMGenericValueToPointer (LLVMGenericValueRef GenVal)
 'GenericValueToInt'⎕NA'I ',ExEng,'|',P,'GenericValueToInt P I'

⍝ void LLVMDisposeGenericValue (LLVMGenericValueRef GenVal)
 'DisposeGenericValue'⎕NA ExEng,'|',P,'DisposeGenericValue P'

⍝ LLVMBool
⍝ LLVMFindFunction (LLVMExecutionEngineRef EE, const char *Name, LLVMValueRef *OutFn)
 'FindFunction'⎕NA'I ',ExEng,'|',P,'FindFunction P <0C >P'

⍝ void     LLVMSetTarget (LLVMModuleRef M, const char *Triple)
 'SetTarget'⎕NA Core,'|',P,'SetTarget P <0C'

⍝ #define     LLVM_TARGET(TargetName)   void LLVMInitialize##TargetName##TargetInfo(void);
⍝ #define     LLVM_TARGET(TargetName)   void LLVMInitialize##TargetName##Target(void);
⍝ #define     LLVM_TARGET(TargetName)   void LLVMInitialize##TargetName##TargetMC(void);
 ('Initialize',Target,'TargetInfo')⎕NA X86Info,'|',P,'Initialize',Target,'TargetInfo'
 ('Initialize',Target,'Target')⎕NA X86CodeGen,'|',P,'Initialize',Target,'Target'
 ('Initialize',Target,'TargetMC')⎕NA X86Desc,'|',P,'Initialize',Target,'TargetMC'

⍝ void     LLVMDumpModule (LLVMModuleRef M)
 'DumpModule'⎕NA Core,'|',P,'DumpModule P'

⍝ void LLVMDumpType (LLVMValueRef Val)
 'DumpType'⎕NA Core,'|',P,'DumpType P'

⍝ uint8_t ffi_get_type (struct codfns_array *)
 'ffi_get_type'⎕NA'U1 ',R,'|ffi_get_type P'

⍝ void ffi_get_data_int (int64_t *res, struct codfns_array *)
 'ffi_get_data_int'⎕NA R,'|ffi_get_data_int >I8[] P'

⍝ void ffi_get_data_float (double *res, struct codfns_array *)
 'ffi_get_data_float'⎕NA R,'|ffi_get_data_float >F8[] P'

⍝ void ffi_get_shape (uint32_t *res, struct codfns_array *)
 'ffi_get_shape'⎕NA R,'|ffi_get_shape >U4[] P'

⍝ uint64_t ffi_get_size (struct codfns_array *)
 'ffi_get_size'⎕NA'U8 ',R,'|ffi_get_size P'

⍝ uint16_t ffi_get_rank (struct codfns_array *)
 'ffi_get_rank'⎕NA'U2 ',R,'|ffi_get_rank P'

⍝ int ffi_make_array(struct codfns_array **, uint16_t, uint64_t, uint32_t *, int64_t *)
 'ffi_make_array_int'⎕NA'I ',R,'|ffi_make_array_int >P U2 U8 <U4[] <I8[]'
 'ffi_make_array_double'⎕NA'I ',R,'|ffi_make_array_double >P U2 U8 <U4[] <F8[]'

⍝ void array_free(struct codfns_array *)
 'array_free'⎕NA R,'|array_free P'

⍝ void *memcpy(void *dst, void *src, size_t size)
 'cstring'⎕NA'libc.so.6|memcpy >C[] P P'

⍝ size_t strlen(char *str)
 'strlen'⎕NA'P libc.so.6|strlen P'

⍝ void free(void *)
 'free'⎕NA'libc.so.6|free P'

⍝ Generate an Array value for everyone to use
 ArrayTypeV←GenArrayType ⍬

