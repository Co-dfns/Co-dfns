#!/usr/bin/env scheme-script
(import (chezscheme))

(define (compute n)
  (let loop ([i 0] [sum 0])
    (if (fx= i n) sum (loop (fx1+ i) (fx+ sum i)))))

(define (main)
  (let* ([res (iota 100000)]
         [res (map compute res)])
    (printf "~s~n" (car (reverse res)))))

(main)
(exit 0)
