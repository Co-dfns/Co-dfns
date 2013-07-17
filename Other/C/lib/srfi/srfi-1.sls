#!r6rs
;; Copyright 2010 Derick Eddington.  My MIT-style license is in the file named
;; LICENSE from the original collection this file is distributed with.

(library (srfi srfi-1)
  (export
    ;;; Exported:
    xcons #;tree-copy make-list list-tabulate list-copy
    proper-list? circular-list? dotted-list? not-pair? null-list? list=
    circular-list length+
    iota
    first second third fourth fifth sixth seventh eighth ninth tenth
    car+cdr
    take       drop
    take-right drop-right
    take!      drop-right!
    split-at   split-at!
    last last-pair
    zip unzip1 unzip2 unzip3 unzip4 unzip5
    count
    append! append-reverse append-reverse! concatenate concatenate!
    unfold       fold       pair-fold       reduce
    unfold-right            pair-fold-right reduce-right
    append-map append-map! map! pair-for-each filter-map map-in-order
    filter! partition! remove!
    find-tail any every list-index
    take-while drop-while take-while!
    span break span! break!
    delete delete!
    alist-cons alist-copy
    delete-duplicates delete-duplicates!
    alist-delete alist-delete!
    reverse!
    lset<= lset= lset-adjoin
    lset-union  lset-intersection  lset-difference  lset-xor
    lset-diff+intersection
    lset-union! lset-intersection! lset-difference! lset-xor!
    lset-diff+intersection!
    ;; re-exported:
    append assq assv caaaar caaadr caaar caadar caaddr
    caadr caar cadaar cadadr cadar caddar cadddr caddr cadr
    car cdaaar cdaadr cdaar cdadar cdaddr cdadr cdar cddaar
    cddadr cddar cdddar cddddr cdddr cddr cdr cons cons*
    length list list-ref memq memv null? pair?
    reverse set-car! set-cdr!
    ;; different than R6RS:
    assoc filter find fold-right for-each map member partition remove)
  (import
    (except (chezscheme)
      make-list cons* list-copy iota last-pair append! fold-right map
      for-each filter partition remove remove! member assoc find
      break reverse!))

  (define-syntax :optional
    (syntax-rules ()
      ((_ args default)
       (let ((a args))
         (if (pair? a) (car a) default)))))

  (define-syntax let-optionals
    (syntax-rules ()
      ((_ _ () . body)
       (let () . body))
      ((_ args ((id default) . more) . body)
       (let ((a args))
         (let ((id (:optional a default)))
           (let-optionals (if (pair? a) (cdr a) '()) more . body))))))

  (define-syntax check-arg
    (syntax-rules ()
      [(_ pred val caller)
       (let ([t val])
         (unless (pred t)
           (errorf "bad argument ~s in ~a" val 'caller))
         t)]))

  (define-syntax receive
    (syntax-rules ()
      [(_ fmls prod body ...)
       (let-values ([fmls prod]) body ...)]))

  (include "srfi-1-reference.scm")

)
