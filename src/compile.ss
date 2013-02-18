;;; -*- Mode: scheme -*-

;;;; Main Compiler Interface
;;;; Encapsulates and controls the execution of compiler passes

;;; Copyright (c) 2013 Aaron W. Hsu <arcfide@sacrideo.us>
;;; 
;;; See LICENSING file for more information about the license
;;; associated with this document.

(define (co-dfns-compile code name)
  (let ([mod (generate-llvm (parse-generate-llvm code))]
        [err-cell (foreign-alloc (foreign-sizeof 'uptr))]
        [fn-cell (make-pointer llvm-value-ref)]
        [eng-cell (make-pointer llvm-execution-engine-ref)])
    (let ([res (llvm-create-execution-engine-for-module eng-cell mod err-cell)])
      (let ([err-str (foreign-ref 'uptr err-cell 0)]
            [eng (ftype-ref llvm-execution-engine-ref () eng-cell)])
        (foreign-free err-cell)
        (foreign-free (ftype-pointer-address eng-cell))
        (if res
            (let ([msg (foreign-string->scheme-string err-str)])
              (llvm-dispose-message err-str)
              (errorf 'co-dfns-compile
                "failed to create execution engine (~a)" msg))
            (llvm-dispose-message err-str))
        (let ([res (llvm-find-function eng name fn-cell)])
          (when res
            (errorf 'co-dfns-compile "failed to find ~a" name))
          (let ([fn (ftype-ref llvm-value-ref () fn-cell)])
            (foreign-free (ftype-pointer-address fn-cell))
            (lambda ()
              (let ([val (llvm-run-function eng fn 0 0)])
                (llvm-generic-value-to-int val #t)))))))))
