;;; Copyright (c) 2000-2013 Dipanwita Sarkar, Andrew W. Keep, R. Kent Dybvig, Oscar Waddell
;;; See the accompanying file Copyright for detatils

(library (nanopass syntax-handler)
  (export pattern-convert)
  (import (rnrs))

  (define-record-type pattern-instr (fields))

  (define-record-type literal-instr (parent pattern-instr) (fields literal))
  (define-record-type meta-instr (parent pattern-instr)
                      (fields name type number))
  (define-record-type subpat-instr (parent pattern-instr)
                      (fields subpat number))

  (define (ellipsis? x) (eq? (syntax->datum x) '...))

  (define (strip-extras x)
    (define (extra? x)
      (or (char=? #\0 x)
          (char=? #\1 x)
          (char=? #\2 x)
          (char=? #\3 x)
          (char=? #\4 x)
          (char=? #\5 x)
          (char=? #\6 x)
          (char=? #\7 x)
          (char=? #\8 x)
          (char=? #\9 x)
          (char=? #\* x)))
    (define (helper ls)
      (let f ([rls (reverse ls)])
        (cond
          [(null? rls) (error 'strip-extras "only found extras!" ls)]
          [(not (extra? (car rls))) (reverse rls)]
          [else (f (cdr rls))])))
    (string->symbol 
      (list->string
        (helper
          (string->list 
            (symbol->string 
              (syntax->datum x)))))))

  (define pattern-convert
    (lambda (pattern metavars)
      (define (meta? x) (assq (strip-extras x) metavars))
      (define (strict-union l1 l2)
        (if (null? l1) 
            l2 
            (strict-union (cdr l1) (strict-set-cons (car l1) l2))))
      (define (strict-set-cons x ls)
        (if (memp (lambda (y) (free-identifier=? x y)) ls)
            (error 'pattern-convert "repeated pattern var" x)
            (cons x ls)))
      (let f ([p pattern] [c '()] [v* '()])
        (syntax-case p ()
          [() (values (reverse c) (reverse v*))]
          [((subpat ...) dots rest ...)
           (ellipsis? #'dots)
           (let-values ([(sc sv*) (f #'(subpat ...) '() '())])
             (f #'(rest ...) (cons (make-subpat-instr sc -1) c)
                (strict-union sv* v*)))]
          [((subpat ...) rest ...)
           (let-values ([(sc sv*) (f #'(subpat ...) '() '())])
             (f #'(rest ...) (cons (make-subpat-instr sc 1) c)
                (strict-union sv* v*)))]
          [(meta dots rest ...)
           (and (meta? #'meta) (ellipsis? #'dots))
           (f #'(rest ...) 
              (cons (make-meta-instr #'meta (cdr (meta? #'meta)) -1) c)
              (strict-set-cons #'meta v*))]
          [(meta rest ...)
           (meta? #'meta) 
           (f #'(rest ...) 
              (cons (make-meta-instr #'meta (cdr (meta? #'meta)) -1) c)
              (strict-set-cons #'meta v*))]
          [(literal rest ...)
           (f #'(rest ...) (cons (make-literal-instr #'literal) c) v*)]))))
  
  (define pattern->matcher
    (lambda (pat*)
      (define pattern->match
        (lambda (pat*)
          (cond 
            [(null? pat*) '(null? to-match)]
            [(literal-instr? (car pat*))
             '(if (pair? to-match)
                  (let ([x (car to-match)] [to-match (cdr to-match)])
                    (if (eq? x ,(literal-instr-literal (car pat*)))
                        ,(pattern->match (cdr pat*))
                        #f))
                  #f)]
            [(subpattern-instr? (car pat*))

      `(lambda (to-match)
         (if (list? to-match)
             ,(pattern->match pat*)
             #f))))
  )
  

