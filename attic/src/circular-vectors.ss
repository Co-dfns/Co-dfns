(define-record-type circular-vector
  (fields log-size segment)
  (protocol
    (lambda (n)
      (lambda (lsize)
        (n lsize (make-vector (fxarithmetic-shift-left 1 lsize)))))))

(define (circular-vector-length cv)
  (fxarithmetic-shift-left 1 (circular-vector-log-size cv)))

(define (circular-vector-ref cv i)
  (vector-ref 
    (circular-vector-segment cv)
    (fxmod i (circular-vector-length cv))))

(define (circular-vector-set! cv i v)
  (vector-set!
    (circular-vector-segment cv)
    (fxmod i (circular-vector-length cv))
    v))

(define (circular-vector-grow cv b t)
  (let ([nv (make-circular-vector (fx1+ (circular-vector-length cv)))])
    (do ([i t (fx1+ i)])
        [(fx< i b) nv]
      (circular-vector-set! nv i (circular-vector-ref cv i)))))


