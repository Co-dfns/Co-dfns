;;; -*- Mode: scheme -*-

;;;; Main Compiler Interface
;;;; Encapsulates and controls the execution of compiler passes

;;; Copyright (c) 2013 Aaron W. Hsu <arcfide@sacrideo.us>
;;; 
;;; See LICENSING file for more information about the license
;;; associated with this document.

(define-record-type execution-unit
  (fields engine pointer)
  (protocol
    (lambda (n)
      (lambda (mod)
        (n (make-execution-engine mod) mod)))))

(define (co-dfns-compile-file fname)
  (co-dfns-compile (list->ast (parse-file fname))))

(define (co-dfns-compile-string str)
  (co-dfns-compile (list->ast (parse-string str))))

(define (co-dfns-compile code)
  (make-execution-unit (run-passes code)))

(define (co-dfns-apply mod fn . args)
  (apply (get-function mod fn) args))

(define list->ast parse-generate-llvm)

(define (run-passes code)
  (generate-llvm code))

(define (get-function mod name)
  (let ([eng (execution-unit-engine mod)]
        [fn-cell (make-pointer llvm-value-ref)])
    (let ([res (llvm-find-function eng name fn-cell)])
      (when res
        (errorf 'get-function "failed to find ~a" name))
      (let ([fn (ftype-ref llvm-value-ref () fn-cell)])
        (foreign-free (ftype-pointer-address fn-cell))
        (lambda ()
          (let ([val (llvm-run-function eng fn 0 0)])
            (llvm-generic-value-to-int val #t)))))))

(define (make-execution-engine mod)
  (let ([err-cell (foreign-alloc (foreign-sizeof 'uptr))]
        [eng-cell (make-pointer llvm-execution-engine-ref)])
    (let ([res (llvm-create-execution-engine-for-module eng-cell mod err-cell)])
      (let ([err-str (foreign-ref 'uptr err-cell 0)]
            [eng (ftype-ref llvm-execution-engine-ref () eng-cell)])
        (foreign-free err-cell)
        (foreign-free (ftype-pointer-address eng-cell))
        (when res
          (let ([msg (foreign-string->scheme-string err-str)])
            (llvm-dispose-message err-str)
            (errorf 'co-dfns-compile
              "failed to create execution engine (~a)" msg)))
        eng))))
