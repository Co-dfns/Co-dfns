#!/usr/bin/env scheme-script
(import (chezscheme))

(define na 1400)
(define nonzer 7)
(define shift 10.0)
(define niter 15)
(define rcond 0.0)

(include "cg.ss")

(solve)
