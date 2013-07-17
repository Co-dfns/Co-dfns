;;; Copyright (c) 2000-2013 Dipanwita Sarkar, Andrew W. Keep, R. Kent Dybvig, Oscar Waddell
;;; See the accompanying file Copyright for detatils

(library (random-util)
  (export map-values vector-map-values)
  (import (rnrs))

  (define map-values
    (lambda (f ls . more)
      (define (return-values vals vals*)
        (if (null? vals*)
            (apply values (map list vals))
            (apply values (map cons vals vals*))))
      (if (null? more)
          (let map1 ([ls ls])
            (if (null? ls)
                (values)
                (let-values ([vals (f (car ls))] [vals* (map1 (cdr ls))])
                  (return-values vals vals*))))
          (let map-more ([ls ls] [more more])
            (if (null? ls)
                (values)
                (let-values ([vals (apply f (car ls) (map car more))]
                             [vals* (map-more (cdr ls) (map cdr more))])
                  (return-values vals vals*)))))))
  
  (define vector-map-values
    (lambda (f v . more)
      (let ([len (vector-length v)])
        (define (update-values! vals* vals i)
          (let ([vals* (if (null? vals*) 
                           (map (lambda (x) (make-vector len)) vals)
                           vals*)])
            (for-each (lambda (nv val) (vector-set! nv i val)) vals* vals)
            vals*))
        (if (null? more)
            (let map1 ([i len] [vals* '()])
              (if (= i 0)
                  (apply values vals*)
                  (let ([i (- i 1)])
                    (let-values ([vals (f (vector-ref v i))])
                      (map1 i (update-values! vals* vals i))))))
            (let map-more ([i len] [vals* '()])
              (if (= i 0)
                  (apply values vals*)
                  (let ([i (- i 1)])
                    (let-values ([vals (apply f (vector-ref v i) 
                                              (map (lambda (v)
                                                     (vector-ref v i))
                                                   more))])
                     (map-more i (update-values! vals* vals i)))))))))))




