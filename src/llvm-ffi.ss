;;; -*- Mode: scheme -*-

;;;; Scheme bindings for LLVM

;;; Copyright (c) 2013 Aaron W. Hsu <arcfide@sacrideo.us>
;;; 
;;; See LICENSING file for more information about the license
;;; associated with this document.

(define-ftype llvm-module (struct))
(define-ftype llvm-type (struct))
(define-ftype llvm-value (struct))
(define-ftype llvm-builder (struct))
(define-ftype llvm-basic-block (struct))
(define-ftype llvm-execution-engine (struct))
(define-ftype llvm-generic-value (struct))

(define-ftype llvm-execution-engine-ref (* llvm-execution-engine))
(define-ftype llvm-generic-value-ref (* llvm-generic-value))
(define-ftype llvm-value-ref (* llvm-value))

(define-syntax make-pointer
  (syntax-rules ()
    [(_ type)
     (make-ftype-pointer type (foreign-alloc (ftype-sizeof type)))]))

(define foreign-string->scheme-string
  (let ([$memcpy (foreign-procedure "memcpy" (uptr uptr int) string)])
    (lambda (str-ptr) ($memcpy str-ptr 0 0))))

(define (llvm-module-create-with-name name)
  ((foreign-procedure "LLVMModuleCreateWithName" (string) (* llvm-module))
   (symbol->string name)))

(define llvm-dispose-module
  (foreign-procedure "LLVMDisposeModule" ((* llvm-module)) void))

(define llvm-dump-module
  (foreign-procedure "LLVMDumpModule" ((* llvm-module)) void))

(define llvm-int-8-type
  (foreign-procedure "LLVMInt8Type" () (* llvm-type)))

(define llvm-array-type
  (foreign-procedure "LLVMArrayType" ((* llvm-type) int) (* llvm-type)))

(define (llvm-add-global m t v)
  ((foreign-procedure "LLVMAddGlobal"
     ((* llvm-module) (* llvm-type) string)
     (* llvm-value))
   m t (symbol->string v)))

(define llvm-set-global-constant
  (foreign-procedure "LLVMSetGlobalConstant" ((* llvm-value) boolean) void))

(define llvm-set-initializer
  (foreign-procedure "LLVMSetInitializer" ((* llvm-value) (* llvm-value)) void))

(define llvm-const-string
  (foreign-procedure "LLVMConstString" (string int boolean) (* llvm-value)))

(define llvm-int64-type
  (foreign-procedure "LLVMInt64Type" () (* llvm-type)))

(define (llvm-add-function m v t)
  ((foreign-procedure "LLVMAddFunction" ((* llvm-module) string (* llvm-type))
     (* llvm-value))
   m (symbol->string v) t))

(define llvm-create-builder
  (foreign-procedure "LLVMCreateBuilder" () (* llvm-builder)))

(define (llvm-append-basic-block fn var)
  ((foreign-procedure "LLVMAppendBasicBlock" ((* llvm-value) string) (* llvm-basic-block))
   fn (symbol->string var)))

(define llvm-position-builder-at-end
  (foreign-procedure "LLVMPositionBuilderAtEnd" ((* llvm-builder) (* llvm-basic-block))
    void))

(define llvm-build-ret
  (foreign-procedure "LLVMBuildRet" ((* llvm-builder) (* llvm-value)) (* llvm-value)))

(define llvm-const-int
  (foreign-procedure "LLVMConstInt" ((* llvm-type) unsigned-long-long boolean)
    (* llvm-value)))

(define llvm-function-type
  (foreign-procedure "LLVMFunctionType" ((* llvm-type) uptr int boolean) (* llvm-type)))

(define llvm-create-execution-engine-for-module
  (foreign-procedure "LLVMCreateExecutionEngineForModule"
    ((* llvm-execution-engine-ref) (* llvm-module) uptr)
    boolean))

(define llvm-dispose-message
  (foreign-procedure "LLVMDisposeMessage" (uptr) void))

(define llvm-find-function
  (foreign-procedure "LLVMFindFunction"
    ((* llvm-execution-engine) string (* llvm-value-ref))
    boolean))

(define llvm-run-function
  (foreign-procedure "LLVMRunFunction"
    ((* llvm-execution-engine) (* llvm-value) unsigned-int uptr)
    (* llvm-generic-value)))

(define llvm-generic-value-to-int
  (foreign-procedure "LLVMGenericValueToInt" ((* llvm-generic-value) boolean)
    unsigned-long-long))

(define llvm-generic-value-to-pointer
  (foreign-procedure "LLVMGenericValueToPointer" ((* llvm-generic-value))
    void*))

(define llvm-dispose-generic-value
  (foreign-procedure "LLVMDisposeGenericValue" ((* llvm-generic-value)) void))

(define llvm-dispose-module
  (foreign-procedure "LLVMDisposeModule" ((* llvm-module)) void))

(define llvm-dispose-execution-engine
  (foreign-procedure "LLVMDisposeExecutionEngine"
    ((* llvm-execution-engine))
    void))

(define llvm-dispose-builder
  (foreign-procedure "LLVMDisposeBuilder"
    ((* llvm-builder))
    void))

(define llvm-const-vector
  (foreign-procedure "LLVMConstVector"
    ((* llvm-value-ref) unsigned-int)
    (* llvm-value)))

(define llvm-const-array
  (foreign-procedure "LLVMConstArray"
    ((* llvm-type) (* llvm-value-ref) unsigned)
    (* llvm-value)))

(define llvm-int-64-type
  (foreign-procedure "LLVMInt64Type" () (* llvm-type)))

(define llvm-vector-type
  (foreign-procedure "LLVMVectorType" ((* llvm-type) unsigned) (* llvm-type)))

(define llvm-array-type
  (foreign-procedure "LLVMArrayType" ((* llvm-type) unsigned) (* llvm-type)))

(define llvm-pointer-type
  (foreign-procedure "LLVMPointerType" ((* llvm-type) unsigned) (* llvm-type)))

(define llvm-build-pointer-cast
  (foreign-procedure "LLVMBuildPointerCast"
    ((* llvm-builder) (* llvm-value) (* llvm-type) string)
    (* llvm-value)))

(define llvm-get-pointer-to-global
  (foreign-procedure "LLVMGetPointerToGlobal"
    ((* llvm-execution-engine) (* llvm-value))
    void*))

(define llvm-get-named-global
  (foreign-procedure "LLVMGetNamedGlobal"
    ((* llvm-module) string)
    (* llvm-value)))

(define llvm-get-data-layout
  (foreign-procedure "LLVMGetDataLayout" ((* llvm-module)) string))

(define llvm-set-data-layout
  (foreign-procedure "LLVMSetDataLayout" ((* llvm-module) string) void))