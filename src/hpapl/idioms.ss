(define (plus-reduce-iota x)
  (if (scalar-array? x)
      (let ([x (scalar-value x)])
        (unless (and (integer? x) (nonnegative? x))
          (error #f "DOMAIN ERROR"))
        (do ([i 0 (fx+ i 1)] [r 0 (fx+ r i)])
            [(= i x) (make-scalar-array r)]))
      ((reduce plus) (array-iota x))))

(define (each-iota f x)
  (if (scalar-array? x)
      (let ([x (scalar-value x)])
        (unless (and (integer? x) (nonnegative? x))
          (error #f "DOMAIN ERROR"))
        (if (zero? x)
            (f empty-array)
            (let ([res (make-vector x)])
              (do ([i 0 (+ i 1)])
                  [(= i x) (make-vector-array res)]
                (vector-set! res i (f (make-scalar-array i)))))))
      ((each f) x)))

(define (plus-reduce a)
  (define (last-axis a)
    (let ([v (array-shape a)])
      (fxvector-ref v (fx- (fxvector-length v) 1))))
  (define (drop-last-axis a)
    (let ([v (array-shape a)])
      (fxvector-subvector v 0 (fx- (fxvector-length v) 1))))
  (define s (last-axis a))
  (define (values-reduce v)
    (define (inner get set! len make)
      (let ([nv (make (div len s))])
        (define (vector-reduce s e)
          (set! nv s (get v (fx- e 1)))
          (let loop ([i (fx- e 2)])
            (unless (fx= i s)
              (set! nv s (+ (get v i) (get nv s)))
              (loop (fx- i 1)))))
        (let loop ([i 0])
          (if (fx= i len)
              nv
              (begin (vector-reduce i (fx+ i s))
                     (loop (fx+ i s)))))))
    (cond
     [(vector? v) 
      (inner vector-ref vector-set! (vector-length v) make-vector)]
     [(fxvector? v)
      (inner fxvector-ref fxvector-set! (fxvector-length v) make-fxvector)]
     [else (error 'reduce "domain error")]))  
  (lambda (a)
    (cond
     [(scalar-array? a) a]
     [(empty-array? a) (make-scalar-array 0)]
     [(fx= 1 (last-axis a)) (make-array (drop-last-axis a) (array-values a))]
     [else (make-array (drop-last-axis a) (values-reduce (array-values a)))])))

