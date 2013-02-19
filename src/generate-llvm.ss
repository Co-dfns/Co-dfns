;;; -*- Mode: scheme -*-

;;;; LLVM Code Generator
;;;; Connect the Nanopass compiler to the LLVM compiler

;;; Copyright (c) 2013 Aaron W. Hsu <arcfide@sacrideo.us>
;;; 
;;; See LICENSING file for more information about the license
;;; associated with this document.

(define variable? symbol?)

(define-language lang/generate-llvm
  (terminals
    (variable (var))
    (number (num))
    (vector (vec))
    (string (name str)))
  (Module (mod)
    (Module name global* ...))
  (Global (global)
    (Constant var str)
    (Function var bb))
  (Basic-block (bb)
    (Block var stmt))
  (Statement (stmt)
    (Return num)))

(define-pass generate-llvm : lang/generate-llvm (ir) -> * ()
  (definitions
    (define type/function
      (llvm-function-type (llvm-int64-type) 0 0 #f))
    
    )
  (Module : Module (ir) -> * ()
    [(Module ,name ,global* ...)
     (let ([mod (llvm-module-create-with-name name)])
       (for-each (lambda (global) (Global global mod)) global*)
       mod)])
  (Global : Global (global mod) -> * ()
    [(Constant ,var ,str)
     (let ([g (llvm-add-global mod
                (llvm-array-type (llvm-int-8-type) (1+ (string-length str)))
                var)])
       (llvm-set-global-constant g #t)
       (llvm-set-initializer g (llvm-const-string str (string-length str) #f)))]
    [(Function ,var ,bb)
     (let ([fn (llvm-add-function mod var type/function)])
       (Basic-block bb fn))])
  (Basic-block : Basic-block (bb fn) -> * ()
    [(Block ,var ,stmt)
     (let ([bldr (llvm-create-builder)]
           [blk (llvm-append-basic-block fn var)])
       (llvm-position-builder-at-end bldr blk)
       (Statement stmt bldr))])
  (Statement : Statement (stmt bldr) -> * ()
    [(Return ,num)
     (llvm-build-ret bldr (llvm-const-int (llvm-int64-type) num #f))])
  (Module ir))

(define-parser parse-generate-llvm lang/generate-llvm)