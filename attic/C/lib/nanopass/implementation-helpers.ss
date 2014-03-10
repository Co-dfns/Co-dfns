;;; Copyright (c) 2000-2013 Dipanwita Sarkar, Andrew W. Keep, R. Kent Dybvig, Oscar Waddell
;;; See the accompanying file Copyright for detatils

(library (nanopass implementation-helpers)
  (export format make-compile-time-value pretty-print trace-define-syntax
          trace-define trace-lambda trace-let printf time gensym
          statistics sstats-difference sstats-cpu sstats-real sstats-bytes
          sstats-gc-count sstats-gc-cpu sstats-gc-real sstats-gc-bytes
          make-sstats sstats? sstats-print display-statistics inspect module
          define-property warningf
          indirect-export syntax->annotation
          annotation-source source-object-bfp source-object-sfd source-file-descriptor-path
          scheme-version= scheme-version< scheme-version> scheme-version>= scheme-version<=
          with-scheme-version gensym? errorf with-output-to-string with-input-from-string $primitive
          list-head)
  (import (chezscheme))

  (define-syntax define-scheme-version-relop
    (lambda (x)
      (syntax-case x ()
        [(_ name relop strict-inequality?)
          #`(define name
              (lambda (ls)
                (let-values ([(a1 b1 c1) (scheme-version-number)]
                             [(a2 b2 c2)
                              (cond
                                [(fx= (length ls) 1) (values (car ls) 0 0)]
                                [(fx= (length ls) 2) (values (car ls) (cadr ls) 0)]
                                [(fx= (length ls) 3) (values (car ls) (cadr ls) (caddr ls))])])
                  #,(if (datum strict-inequality?)
                        #'(or (relop a1 a2)
                              (and (fx= a1 a2)
                                   (or (relop b1 b2)
                                       (and (fx= b1 b2)
                                            (relop c1 c2)))))
                        #'(and (relop a1 a2) (relop b1 b2) (relop c1 c2))))))])))

  (define-scheme-version-relop scheme-version= fx= #f)
  (define-scheme-version-relop scheme-version< fx< #t)
  (define-scheme-version-relop scheme-version> fx> #t)
  (define-scheme-version-relop scheme-version<= fx<= #f)
  (define-scheme-version-relop scheme-version>= fx>= #f)

  (define-syntax with-scheme-version
    (lambda (x)
      (define-scheme-version-relop scheme-version= fx= #f)
      (define-scheme-version-relop scheme-version< fx< #t)
      (define-scheme-version-relop scheme-version> fx> #t)
      (define-scheme-version-relop scheme-version<= fx<= #f)
      (define-scheme-version-relop scheme-version>= fx>= #f)
      (define finish
        (lambda (pat* e** elsee*)
          (if (null? pat*)
              #`(begin #,@elsee*)
              (or (and (syntax-case (car pat*) (< <= = >= >)
                         [(< v ...) (scheme-version< (datum (v ...)))]
                         [(<= v ...) (scheme-version<= (datum (v ...)))]
                         [(= v ...) (scheme-version= (datum (v ...)))]
                         [(>= v ...) (scheme-version>= (datum (v ...)))]
                         [(> v ...) (scheme-version> (datum (v ...)))]
                         [else #f])
                       #`(begin #,@(car e**)))
                  (finish (cdr pat*) (cdr e**) elsee*)))))
      (syntax-case x (else)
        [(_ [pat e1 e2 ...] ... [else ee1 ee2 ...])
         (finish #'(pat ...) #'((e1 e2 ...) ...) #'(ee1 ee2 ...))]
        [(_ [pat e1 e2 ...] ...)
         (finish #'(pat ...) #'((e1 e2 ...) ...) #'())])))
      

  (with-scheme-version
    [(< 8 3 1)
     (define syntax->annotation (lambda (x) #f))
     (define annotation-source (lambda (x) (errorf 'annotation-source "unsupported before version 8.4")))
     (define source-object-bfp (lambda (x) (errorf 'source-object-bfp "unsupported before version 8.4")))
     (define source-object-sfd (lambda (x) (errorf 'source-object-sfd "unsupported before version 8.4")))
     (define source-file-descriptor-path (lambda (x) (errorf 'source-file-descriptor-path "unsupported before version 8.4")))])
  (with-scheme-version
    [(< 8 1) (define-syntax indirect-export (syntax-rules () [(_ id indirect-id ...) (define t (if #f #f))]))]))
