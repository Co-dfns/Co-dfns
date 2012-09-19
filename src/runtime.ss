(define (hpapl-version) '(1 0))
(define (hpapl-version-string)
  "HPAPL Runtime Version (1.0)\nCopyright (c) 2012 Aaron W. Hsu")

(define-record-type array (fields shape values))

(define (make-scalar-array x) 
  (if (fixnum? x)
      (make-array '#vfx() (fxvector x))
      (make-array '#vfx() (vector x))))

(define (make-vector-array v) 
  (cond
   [(vector? v) (make-array (fxvector (vector-length v)) v)]
   [(fxvector? v) (make-array (fxvector (fxvector-length v)) v)]
   [(list? v) 
    (make-array (fxvector (length v))
		(if (for-all fixnum? v) 
		    (list->fxvector v)
		    (list->vector v)))]
   [else (error 'make-vector-array "domain error" v)]))

(define (rank a) (fxvector-length (array-shape a)))

(define (empty-array? a) (fxvector-exists fxzero? (array-shape a)))
(define (scalar-array? a) (fxzero? (rank a)))
(define (vector-array? a) (fx= 1 (rank a))) 
(define (matrix-array? a) (fx= 2 (rank a)))

(define (scalar-value a)
  (let ([v (array-values a)])
    (cond
     [(fxvector? v) (fxvector-ref v 0)]
     [(vector? v) (vector-ref v 0)])))

(define (array-scalar-value a)
  (make-scalar-array (scalar-value a)))

(define empty-array (make-vector-array '#()))

(define (fxvector-map-monadic f v)
  (let* ([vl (fxvector-length v)]
	 [nv (make-fxvector (fxvector-length v))])
    (let loop ([i 0])
      (if (fx= i vl)
	  nv
	  (begin
	   (fxvector-set! nv i (f (fxvector-ref v i)))
	   (loop (fx+ i 1)))))))

(define (fxvector-map-dyadic f a b)
  (let* ([vl (fxvector-length a)]
	 [nv (make-fxvector (fxvector-length a))])
    (let loop ([i 0])
      (if (fx= i vl)
	  nv
	  (begin
	   (fxvector-set! nv i (f (fxvector-ref a i) (fxvector-ref b i)))
	   (loop (fx+ i 1)))))))

(define fxvector-map
  (case-lambda
   [(f a) (fxvector-map-monadic f a)]
   [(f a b) (fxvector-map-dyadic f a b)]))

(define (fxvector->vector v)
  (let* ([len (fxvector-length v)]
	 [nv (make-vector len)])
    (let loop ([i 0])
      (unless (fx= i len)
	(vector-set! nv i (fxvector-ref v i))
	(loop (fx+ i 1))))
    nv))

(define (vector-forall pred? v)
  (let ([len (vector-length v)])
    (let loop ([i 0])
      (cond
       [(fx= i len) #t]
       [(pred? (vector-ref v i)) (loop (fx+ i 1))]
       [else #f]))))

(define (fxvector-forall pred? v)
  (let ([len (fxvector-length v)])
    (let loop ([i 0])
      (cond
       [(fx= i len) #t]
       [(pred? (fxvector-ref v i)) (loop (fx+ i 1))]
       [else #f]))))

(define (fxvector-exists pred? v)
  (let ([len (fxvector-length v)])
    (let loop ([i 0])
      (cond
       [(fx= i len) #f]
       [(pred? (fxvector-ref v i)) #t]
       [else (loop (fx+ i 1))]))))

(define (fxvector-subvector v s e)
  (let* ([len (- e s)]
	 [nv (make-fxvector len)])
    (let loop ([i 0])
      (unless (fx= i len)
	(fxvector-set! nv i (fxvector-ref v i))))
    nv))

(define (fxvector-product v)
  (let ([len (fxvector-length v)])
    (do ([i 0 (fx+ i 1)] [r 1 (fx* r (fxvector-ref v i))])
        [(= i len) r])))

(define (vector->fxvector v)
  (let ([len (vector-length v)])
    (let ([fv (make-fxvector len)])
      (do ([i 0 (fx+ i 1)])
          [(fx= i len) fv]
        (fxvector-set! fv i (vector-ref v i))))))

(define values-map
  (let ()
    (define (iterate n get)
      (let ([nv (make-vector n)])
        (do ([i 0 (fx+ i 1)])
            [(fx= i n) (convert nv)]
          (vector-set! nv i (get i)))))
    (define (convert v) v)
    (case-lambda
      [(f a)
       (cond
         [(vector? a)
          (iterate (vector-length a) (lambda (i) (f (vector-ref a i))))]
         [(fxvector? a)
          (iterate (fxvector-length a) (lambda (i) (f (fxvector-ref a i))))]
         [else (error #f "unknown value type" a)])]
      [(f a b)
       (cond
         [(vector? a)
          (cond
            [(vector? b)
             (iterate (vector-length a)
               (lambda (i) (f (vector-ref a i) (vector-ref b i))))]
            [(fxvector? b)
             (iterate (vector-length a)
               (lambda (i) (f (vector-ref a i) (fxvector-ref b i))))]
            [else (error #f "unknown value type" b)])]
         [(fxvector? a)
          (cond
            [(vector? b)
             (iterate (fxvector-length a)
               (lambda (i) (f (fxvector-ref a i) (vector-ref b i))))]
            [(fxvector? a)
             (iterate (fxvector-length a)
               (lambda (i) (f (fxvector-ref a i) (fxvector-ref b i))))]
            [else (error #f "unknown value type" b)])]
         [else (error #f "unknown value type" a)])])))

(define-syntax scalar-function
  (syntax-rules ()
    [(_ monf dyaf)
     (case-lambda
       [(a)
        (let ([a (defuture a)])
          (make-array (array-shape a) (values-map monf (array-values a))))]
       [(a b)
        (let ([a (defuture a)] [b (defuture b)])
          (cond
            [(equal? (array-shape a) (array-shape b))
             (make-array (array-shape a)
               (values-map dyaf (array-values a) (array-values b)))]
            [(scalar-array? a)
             (make-array (array-shape b)
               (values-map (let ([x (scalar-value a)])
                             (lambda (y) (dyaf x y)))
                 (array-values b)))]
            [(scalar-array? b)
             (make-array (array-shape a)
               (values-map (let ([x (scalar-value b)])
                             (lambda (y) (dyaf y x)))
                 (array-values a)))]
            [else (error #f "LENGTH ERROR")]))])]))
     
(define plus (scalar-function + +))
(define subtract (scalar-function - -))
(define times (scalar-function * *))
(define less-than-equal 
  (scalar-function
    (lambda (x) (error '≤ "Requires left argument"))
    (lambda (x y) (if (<= x y) 1 0))))

(define (fact n)
  (if (zero? n)
      1
      (* n (fact (- n 1)))))

(define nonce (lambda args (error #f "NONCE ERROR")))

(define bang (scalar-function fact nonce))

(define (shape a)
  (make-array (fxvector (rank a)) (array-shape a)))

(define (values-length v)
  (cond
    [(vector? v) (vector-length v)]
    [(fxvector? v) (fxvector-length v)]
    [else (error 'values-length "invalid values type" v)]))

(define (values-extend v len)
  (define (extend vget vset! vlen vmk)
    (let ([nv (vmk len)] [vl (vlen v)])
      (do ([i 0 (fx+ i 1)])
          [(fx= i len) nv]
        (vset! nv i (vget v (fxmod i vl))))))
  (cond
    [(vector? v) 
     (extend vector-ref vector-set! vector-length make-vector)]
    [(fxvector? v) 
     (extend fxvector-ref fxvector-set! fxvector-length make-fxvector)]
    [else (error 'values-extend "invalid values type" v)]))

(define (reshape s a)
  (make-array (array-values s)
    (let ([sp (fxvector-product (array-values s))])
      (if (= sp (values-length (array-values a)))
          (array-values a)
          (values-extend (array-values a) sp)))))

(define rho
  (case-lambda
    [(a) (shape a)]
    [(a b) (reshape a b)]))

(define (scalar-iota n)
  (let ([v (make-fxvector n)])
    (let loop ([i 0])
      (if (fx= i n)
	  v
	  (begin
	   (fxvector-set! v i i)
	   (loop (fx+ i 1)))))))

(define (vector-iota v)
  (error 'vector-iota "nonce error"))

(define (scalar-proc-monadic f)
  (lambda (s)
    (scalar-value (f (make-scalar-array s)))))

(define (scalar-proc-dyadic f)
  (lambda (a b)
    (scalar-value (f (make-scalar-array a) (make-scalar-array b)))))

(define (array-iota a)
  (cond
   [(scalar-array? a) (make-vector-array (scalar-iota (scalar-value a)))]
   [(vector-array? a) 
    #;(vector-iota (array-values a))
    (error 'array-iota "nonce error")]
   [else (error 'array-iota "domain error" a)]))

(define (each f)
  (define sf
    (case-lambda
      [(a) (f (make-scalar-array a))]
      [(a b) (f (make-scalar-array a) (make-scalar-array b))]))
  (case-lambda
    [(a)
     (let ([a (defuture a)])
       (make-array (array-shape a) 
         (scalar-vector-defuture (values-map sf (array-values a)))))]
    [(a b)
     (let ([a (defuture a)] [b (defuture b)])
       (cond
         [(equal? (array-shape a) (array-shape b))
          (make-array (array-shape a)
            (scalar-vector-defuture 
              (values-map sf (array-values a) (array-values b))))]
         [(scalar-array? a)
          (make-array (array-shape b)
            (scalar-vector-defuture
              (values-map (let ([x (scalar-value a)])
                            (lambda (y) (sf x y)))
                (array-values b))))]
         [(scalar-array? b)
          (make-array (array-shape a)
            (scalar-vector-defuture
              (values-map (let ([x (scalar-value b)])
                            (lambda (y) (sf y x)))
                (array-values a))))]
         [else (error #f "LENGTH ERROR")]))]))

(define (reduce f)
  (define (last-axis a)
    (let ([v (array-shape a)])
      (fxvector-ref v (fx- (fxvector-length v) 1))))
  (define (drop-last-axis a)
    (let ([v (array-shape a)])
      (fxvector-subvector v 0 (fx- (fxvector-length v) 1))))
  (lambda (a)
    (cond
     [(scalar-array? a) a]
     [(empty-array? a) (make-scalar-array 0)]
     [(fx= 1 (last-axis a)) (make-array (drop-last-axis a) (array-values a))]
     [else
      (make-array (drop-last-axis a)
		  (values-reduce f (array-values a) (last-axis a)))])))

(define (values-reduce f v s)
  (define sf (scalar-proc-dyadic f))
  (define (reduce get set! len make)
    (let ([nv (make (div len s))])
      (define (vector-reduce s e)
	(set! nv s (get v (fx- e 1)))
	(let loop ([i (fx- e 2)])
	  (unless (fx= i s)
	    (set! nv s (sf (get v i) (get nv s)))
	    (loop (fx- i 1)))))
      (let loop ([i 0])
	(if (fx= i len)
	    nv
	    (begin (vector-reduce i (fx+ i s))
		   (loop (fx+ i s)))))))
  (cond
   [(vector? v) 
    (reduce vector-ref vector-set! (vector-length v) make-vector)]
   [(fxvector? v)
    (reduce fxvector-ref fxvector-set! (fxvector-length v) make-fxvector)]
   [else (error 'reduce "domain error")]))

(define (array-equal a b)
  (define (same?)
    (and (equal? (array-shape a) (array-shape b))
      (let ([av (array-values a)] [bv (array-values b)])
        (vector-forall (lambda (x) x)
          (vector-map equal?
            (if (fxvector? av) (fxvector->vector av) av)
            (if (fxvector? bv) (fxvector->vector bv) bv))))))
  (make-scalar-array (if (same?) 1 0)))

(define equiv
  (case-lambda
    [(a b) (let ([a (defuture a)] [b (defuture b)]) (array-equal a b))]))

(define (boolean-array? a)
  (and (scalar-array? a)
       (or (= 0 (scalar-value a))
           (= 1 (scalar-value a)))))

(define-syntax aplif
  (syntax-rules ()
    [(_ be c a)
     (let ([res be])
       (if (boolean-array? res)
           (if (zero? (scalar-value res))
               a
               c)
           (error #f "DOMAIN ERROR")))]))

