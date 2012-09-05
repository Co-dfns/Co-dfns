#! /usr/bin/env scheme-script
(import (chezscheme))

(include "srfi-64.sls")
(include "dmatch.ss")
(include "runtime.ss")
(include "compile.ss")

(import (srfi-64) (arcfide hpapl runtime))

(define env (environment '(chezscheme) '(arcfide hpapl runtime)))

(define-syntax compile/run
  (syntax-rules ()
    [(_ run prog) (eval `(let () ,(hpapl-compile 'prog) run) env)]))

(define (test-array-equal e v)
  (test-equal (array-shape e) (array-shape v))
  (test-equal (array-values e) (array-values v)))

(test-begin "HPAPL Tests")

(test-array-equal (make-scalar-array 5)
  (compile/run (main) (program (main) 5)))

(test-array-equal (make-vector-array '(5))
  (compile/run (main) (program (main) '(5))))

(test-array-equal (array-iota (make-scalar-array 5))
  (compile/run (main) (program (main) (⍳ 5))))

(test-end "HPAPL Tests")

(exit 0)
