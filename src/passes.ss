;;; -*- Mode: scheme -*-

;;;; Compiler passes
;;;; The passes to the compiler

;;; Copyright (c) 2013 Aaron W. Hsu <arcfide@sacrideo.us>
;;; 
;;; See LICENSING file for more information about the license
;;; associated with this document.

(define-pass lift-constants : lang/lift-constants (ir) -> lang/generate-llvm ()
  (definitions
    (define new-globals '()))
  (Module : Module (mod) -> Module ()
    [(Module ,var ,[global*] ...)
     `(Module ,var ,new-globals ... ,global* ...)])
  (Statement : Statement (stmt) -> Statement ()
    [(Return ,int* ...)
     (let ([var (gensym "literal")])
       (set! new-globals
         (cons
           (with-output-language (lang/generate-llvm Global)
             `(Constant ,var ,int* ...))
           new-globals))
       `(Return ,var))])
  (Module ir))

(define-pass generate-llvm : lang/generate-llvm (ir) -> * ()
  (definitions
    (define type/return (llvm-pointer-type (llvm-int-64-type) 0))
    (define type/function (llvm-function-type type/return 0 0 #f))
    (define globals '())
    (define (global-lookup var)
      (let ([res (assq var globals)])
        (unless res (errorf 'generate-llvm "unable to lookup global ~a" var))
        (cdr res)))
    (define (make-integer-constant n)
      (llvm-const-int (llvm-int-64-type) n #t))
    (define (make-vector-integer-constant ints)
      (define-ftype array (array 4294967296 (* llvm-value)))
      (let ([int-values (map make-integer-constant ints)])
        (let ([arr (make-ftype-pointer array
                     (foreign-alloc (* (length ints) (foreign-sizeof 'uptr))))])
          (for-each (lambda (n i) (ftype-set! array (i) arr n))
            int-values (iota (length ints)))
          (let ([res (llvm-const-vector
                       (make-ftype-pointer llvm-value-ref
                         (ftype-pointer-address arr))
                       (length ints))])
            (foreign-free (ftype-pointer-address arr))
            res)))))
  (Module : Module (ir) -> * ()
    [(Module ,var ,global* ...)
     (let ([mod (llvm-module-create-with-name var)])
       (llvm-set-data-layout mod "e")
       (for-each (lambda (global) (Global global mod)) global*)
       mod)])
  (Global : Global (global mod) -> * ()
    [(Constant ,var ,int* ...)
     (let* ([t (llvm-vector-type (llvm-int-64-type) (length int*))]
            [g (llvm-add-global mod t var)])
       (set! globals (cons `(,var . ,g) globals))
       (llvm-set-global-constant g #t)
       (llvm-set-initializer g (make-vector-integer-constant int*)))]
    [(Function ,var ,bb)
     (let ([fn (llvm-add-function mod var type/function)])
       (set! globals (cons `(,var . ,fn) globals))
       (Basic-block bb fn))])
  (Basic-block : Basic-block (bb fn) -> * ()
    [(Block ,var ,stmt)
     (let ([bldr (llvm-create-builder)]
           [blk (llvm-append-basic-block fn var)])
       (llvm-position-builder-at-end bldr blk)
       (let ([stmt (Statement stmt bldr)])
         (llvm-dispose-builder bldr)
         stmt))])
  (Statement : Statement (stmt bldr) -> * ()
    [(Return ,var)
     (llvm-build-ret bldr
       (llvm-build-pointer-cast bldr (global-lookup var) type/return ""))])
  (let ([res (Module ir)])
    (llvm-dump-module res)
    res))
