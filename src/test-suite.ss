;;; -*- Mode: scheme -*-

;;;; Whole Compiler Test Suite
;;;; Test the entire compiler from start to finish on a number of programs

;;; Copyright (c) 2013 Aaron W. Hsu <arcfide@sacrideo.us>
;;; 
;;; See LICENSING file for more information about the license
;;; associated with this document.

(import (srfi srfi-64))

(printf "~n~n")

(define (run-compiler-tests tests)
  (for-each
    (lambda (test)
      (let ([function (car test)]
            [expected (cadr test)]
            [program  (caddr test)])
        (test-eqv expected
          (let* ([exec (co-dfns-compile-string program)]
                 [res (co-dfns-apply exec function)])
            (dispose-execution-unit exec)
            res))))
    tests))

(test-begin "Co-Dfns Compiler Test Suite")

(run-compiler-tests
  '(("F" 5 "F←{5}")
    ("F" 120 "F←{120}")))

(test-end "Co-Dfns Compiler Test Suite")

(printf "~n")
