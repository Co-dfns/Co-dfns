(module (solve)

;; Define a proper vector abstraction
(define (make-flvector n)
  (make-bytevector (fx* 8 n)))
(define (flvector-ref v i)
  (bytevector-ieee-double-native-ref v (fx* 8 i)))
(define (flvector-set! v i x)
  (bytevector-ieee-double-native-set! v (fx* 8 i) x))
(define (flvector-fill! v n)
  (do ([i 0 (fx+ 8 i)]) [(fx>= i (bytevector-length v))]
    (bytevector-ieee-double-native-set! v i n)))

;; Generally used globals
(define firstrow 0)
(define lastrow na)
(define firstcol 0)
(define lastcol na)
(define tran 314159265.0)
(define amult 1220703125.0)
(define nz (fx* na (fx+ nonzer 1) (fx+ nonzer 1)))
(define n na)

;; Randlc Section
(define d2m46 (flexpt 0.5 46.0))
(define i246m1 (flexpt 2.0 46.0))
(define (randlc)
  (let ([lx (flmod (fl* tran amult) i246m1)])
    (set! tran lx)
    (fl* d2m46 lx)))
    
;; Initial Zeta value
(define zeta-init (randlc))

(define (print-header)
  (printf "it\t∥R∥\t\t\t\tZeta~n"))
(define (print-iteration it rnorm zeta)
  (printf "~a\t~a\t\t~a~n" it rnorm zeta))

(define last-first+1 (fx+ 0 (fx- lastcol firstcol)))
(define lastr-firstr+1 (fx+ 0 (fx- lastrow firstrow)))

(define (solve)
  (define x (make-flvector (fx+ na 1)))
  (define (x-ref i) (flvector-ref x i))
  (define (x-set! i v) (flvector-set! x i v))
  (define q (make-flvector last-first+1))
  (define z (make-flvector last-first+1))
  (define (z-ref i) (flvector-ref z i))
  (define r (make-flvector last-first+1))
  (define p (make-flvector last-first+1))
  (define (compute-norms)
    (let loop ([j 0] [nt1 0.0] [nt2 0.0])
      (if (fx= j last-first+1)
          (values nt1 (fl/ 1.0 (flsqrt nt2)))
          (loop (fx+ j 1)
            (fl+ nt1 (fl* (x-ref j) (z-ref j)))
            (fl+ nt2 (fl* (z-ref j) (z-ref j)))))))
  (define (main-loop a colidx rowstr)
    (let loop ([it 0] [zeta 0.0])
      (when (fx< it niter)
        (let ([rnorm (conj-grad colidx rowstr x z a p q r)])
          (let-values ([(norm1 norm2) (compute-norms)])
            (let ([zeta (fl+ shift (fl/ 1.0 norm1))])
              (print-iteration it rnorm zeta)
              (do ([j 0 (fx+ j 1)]) [(fx= j last-first+1)]
                (x-set! j (fl* norm2 (z-ref j))))
              (loop (fx+ it 1) zeta)))))))
  (let-values ([(a colidx rowstr) (time (makea))])
    (define (rowstr-ref i) (fxvector-ref rowstr i))
    (define (colidx-ref i) (fxvector-ref colidx i))
    (define (colidx-set! i v) (fxvector-set! colidx i v))
    (define (a-ref i) (flvector-ref a i))
    (do ([j 0 (fx+ j 1)]) [(fx= j (fx- lastrow firstrow))]
      (do ([k (rowstr-ref j) (fx+ k 1)]) [(fx= k (fx- (rowstr-ref (fx+ j 1)) 1))]
        (colidx-set! k (fx- (colidx-ref k) firstcol))))
    (for-each (lambda (x) (flvector-fill! x 0.0))
      (list q z r p))
    (flvector-fill! x 1.0)
    (print-header)
    (collect (collect-maximum-generation))
    (time (main-loop a colidx rowstr)))
  (void))
  
(define (conj-grad colidx rowstr x z a p q r)
  (define cgitmax 25)
  (define (r-ref i) (flvector-ref r i))
  (define (x-ref i) (flvector-ref x i))
  (define (z-ref i) (flvector-ref z i))
  (define (a-ref i) (flvector-ref a i))
  (define (p-ref i) (flvector-ref p i))
  (define (q-ref i) (flvector-ref q i))
  (define (r-set! i v) (flvector-set! r i v))
  (define (x-set! i v) (flvector-set! x i v))
  (define (z-set! i v) (flvector-set! z i v))
  (define (a-set! i v) (flvector-set! a i v))
  (define (p-set! i v) (flvector-set! p i v))
  (define (q-set! i v) (flvector-set! q i v))
  (define (colidx-ref i) (fxvector-ref colidx i))
  (define (rowstr-ref i) (fxvector-ref rowstr i))
  (define (get-rho)
    (do ([j 0 (fx+ j 1)]
         [rho 0.0 (fl+ rho (fl* (r-ref j) (r-ref j)))]) 
        [(fx= j 10) rho]))
  (do ([j 0 (fx+ j 1)]) [(fx= j n)]
    (q-set! j 0.0) (z-set! j 0.0)
    (r-set! j (x-ref j)) (p-set! j (r-ref j)))
  (let loop ([cgit 0] [rho (get-rho)])
    (define (compute-alpha)
      (do ([j 0 (fx+ j 1)]
           [d 0.0 (fl+ d (fl* (p-ref j) (q-ref j)))])
          [(fx= j last-first+1)
           (fl/ rho d)]))
    (when (fx< cgit cgitmax)
      (do ([j 0 (fx+ j 1)]) [(fx= j last-first+1)]
        (do ([k (rowstr-ref j) (fx+ k 1)]
             [sum 0.0 (fl+ sum (fl* (a-ref k) (p-ref (colidx-ref k))))]) 
            [(fx= k (rowstr-ref (fx+ j 1)))
             (q-set! j sum)]))
      (let ([alpha (compute-alpha)] [rho0 rho])
        (do ([j 0 (fx+ j 1)]) [(fx= j last-first+1)]
          (z-set! j (fl+ (z-ref j) (fl* alpha (p-ref j))))
          (r-set! j (fl- (r-ref j) (fl* alpha (q-ref j)))))
        (let* ([rho (get-rho)]
               [beta (fl/ rho rho0)])
          (do ([j 0 (fx+ j 1)]) [(fx= j last-first+1)]
            (p-set! j (fl+ (r-ref j) (fl* beta (p-ref j)))))
          (loop (fx+ cgit 1) rho)))))
  (do ([j 0 (fx+ j 1)]) [(fx= j lastr-firstr+1)]
    (do ([k (rowstr-ref j) (fx+ k 1)]
         [d 0.0 (fl+ d (fl* (a-ref k) (z-ref (colidx-ref k))))]) 
        [(fx= k (rowstr-ref (fx+ j 1)))
         (r-set! j d)]))
  (do ([j 0 (fx+ j 1)]
       [sum 0.0 (fl+ sum (fl- (x-ref j) (r-ref j)))]) 
      [(fx= j last-first+1) (flsqrt sum)]))

;; Makea Section
(define (makea)
  ;; Setup the initial values and do the initial allocation all at once.
  (define colidx (make-fxvector nz))
  (define rowstr (make-fxvector (fx+ n 1)))
  (define iv (make-fxvector n))
  (define arow (make-fxvector n))
  (define acol (make-fxvector (fx* (fx+ nonzer 1) n)))
  (define aelt (make-flvector (fx* (fx+ nonzer 1) n)))
  (define a (make-flvector nz))
  (define (getidx c r) (fx+ (fx* r (fx+ nonzer 1)) c))
  (define ivc (make-fxvector (fx+ nonzer 1)))
  (define vc (make-flvector (fx+ nonzer 1)))
  (define (arow-set! i v) (fxvector-set! arow i v))
  (define (acol-set! i j v) (fxvector-set! acol (getidx i j) v))
  (define (aelt-set! i j v) (flvector-set! aelt (getidx i j) v))
  (define (ivc-ref i) (fxvector-ref ivc i))
  (define (vc-ref i) (flvector-ref vc i))
  (define nn1
    (let loop ([nn1 2])
      (if (fx< nn1 n)
          (loop (fx* 2 nn1))
          (inexact nn1))))
  ;; Generate nonzero positions and save for the use in sparse.
  (do ([iouter 0 (fx+ iouter 1)]) [(fx= iouter n)]
    (let ([nzv (sprnvc+vecset n nonzer nn1 vc ivc iouter)])
      (arow-set! iouter nzv)
      (do ([ivelt 0 (fx+ ivelt 1)]) [(fx= ivelt nzv)]
        (acol-set! ivelt iouter (ivc-ref ivelt))
        (aelt-set! ivelt iouter (vc-ref ivelt)))))
  ;; ... make the sparse matrix from list of elements with duplicates
  ;;     (iv is used as workspace)
  (sparse a colidx rowstr arow acol aelt))

(define (sparse a colidx rowstr arow acol aelt)
  (define (getidx c r) (fx+ (fx* r (fx+ nonzer 1)) c))
  (define nzloc (make-fxvector n 0))
  (define (nzloc-set! i v) (fxvector-set! nzloc i v))
  (define (nzloc-ref i) (fxvector-ref nzloc i))
  (define (arow-ref i) (fxvector-ref arow i))
  (define (acol-ref i j) (fxvector-ref acol (getidx i j)))
  (define (aelt-ref i j) (flvector-ref aelt (getidx i j)))
  (define (a-set! i v) (flvector-set! a i v))
  (define (a-ref i) (flvector-ref a i))
  (define (rowstr-ref i) (fxvector-ref rowstr i))
  (define (rowstr-set! i v) (fxvector-set! rowstr i v))
  (define (colidx-ref i) (fxvector-ref colidx i))
  (define (colidx-set! i v) (fxvector-set! colidx i v))
  (define nrows (fx- lastrow firstrow))
  ;; Count the number of triples in each row
  (fxvector-fill! rowstr 0)
  (do ([i 0 (fx+ i 1)]) [(fx= i n)]
    (do ([nza 0 (fx+ nza 1)]) [(fx= nza (arow-ref i))]
      (let ([j (fx+ 1 (acol-ref nza i))])
        (rowstr-set! j (fx+ (rowstr-ref j) (arow-ref i))))))
  (do ([j 1 (fx+ j 1)]) [(fx= j (fx+ nrows 1))]
    (rowstr-set! j (fx+ (rowstr-ref j) (rowstr-ref (fx- j 1)))))
  ;; ... rowstr(j) now is the location of the first nonzero
  ;;     of row j of a
  (let ([nza (rowstr-ref nrows)])
    (when (fx> nza nz)
      (error #f "Space for matrix elements exceeded in sparse" nza nz)))
  ;; ... preload data pages
  (fxvector-fill! nzloc 0)
  (flvector-fill! a 0.0)
  (fxvector-fill! colidx -1)
  ;; ... generate actual values by summing duplicates
  (let ([ratio (flexpt rcond (fl/ 1.0 (inexact n)))])
    (do ([i 0 (fx+ i 1)] [size 1.0 (fl* size ratio)]) [(fx= i n)]
      (do ([nza 0 (fx+ nza 1)]) [(fx= nza (arow-ref i))]
        (let ([j (acol-ref nza i)] [scale (fl* size (aelt-ref nza i))])
          (do ([nzrow 0 (fx+ nzrow 1)]) [(fx= nzrow (arow-ref i))]
            (let ([jcol (acol-ref nzrow i)]
                  [va (fl* scale (aelt-ref nzrow i))])
              (let ([va (if (and (fx= jcol j) (fx= j i))
                             (fl- (fl+ va rcond) shift)
                             va)])
                (define (ak+va k) (a-set! k (fl+ va (a-ref k))))
                (let loop ([k (rowstr-ref j)])
                  (cond
                    [(fx= k (rowstr-ref (fx+ j 1)))
                     (error #f "Internal error in sparse" i)]
                    [(fx< jcol (colidx-ref k))
                     (do ([kk (fx- (rowstr-ref (fx+ j 1)) 2) (fx- kk 1)])
                         [(fx< kk k)]
                       (when (fx<= 0 (colidx-ref kk))
                         (a-set! (fx+ kk 1) (a-ref kk))
                         (colidx-set! (fx+ kk 1) (colidx-ref kk))))
                     (colidx-set! k jcol)
                     (a-set! k va)]
                    [(fx= -1 (fxvector-ref colidx k))
                     (colidx-set! k jcol)
                     (ak+va k)]
                    [(fx= jcol (fxvector-ref colidx k))
                     (nzloc-set! j (fx+ 1 (nzloc-ref j)))
                     (ak+va k)]
                    [else (loop (fx+ k 1))])))))))))
  ;; ... remove empty entries and generate final results
  (do ([j 1 (fx+ j 1)]) [(fx= j nrows)]
    (nzloc-set! j (fx+ (nzloc-ref j) (nzloc-ref (fx- j 1)))))
  (do ([j 0 (fx+ j 1)]) [(fx= j nrows)]
    (let ([j1 (if (fx= j 0) 0 (fx- (rowstr-ref j) (nzloc-ref (fx- j 1))))]
          [j2 (fx- (rowstr-ref (fx+ j 1)) (nzloc-ref j))])
      (do ([k j1 (fx+ k 1)] [nza (rowstr-ref j) (fx+ nza 1)]) 
           [(fx= k j2)]
        (a-set! k (a-ref nza))
        (colidx-set! k (colidx-ref nza)))))
  (do ([j 1 (fx+ j 1)]) [(fx= j (fx+ nrows 1))]
    (rowstr-set! j (fx- (rowstr-ref j) (nzloc-ref (fx- j 1)))))
  (printf "Final nonzero count in sparse: ~d~n"
          (fx- (rowstr-ref nrows) 1))
  (values a colidx rowstr))

(define (sprnvc+vecset n nz nn1 v iv i)
  (define (icnvrt x) (flonum->fixnum (fltruncate (fl* x nn1))))
  (define (elt+loc)
    (let* ([elt (randlc)] [loc (randlc)])
      (values elt (icnvrt loc))))
  ;; Generate the sparse vector (v, iv)
  (let loop ([nzv 0])
	(define (in-iv? i)
      (let loop ([ii 0])
		(cond
			[(fx= ii nzv) #f]
			[(fx= i (fxvector-ref iv ii))]
			[else (loop (fx+ ii 1))])))
    (when (fx< nzv nz)
      (let-values ([(vecelt i) (elt+loc)])
        (cond 
          [(or (fx>= i n) (in-iv? i)) (loop nzv)]
          [else
           (flvector-set! v nzv vecelt)
           (fxvector-set! iv nzv i)
           (loop (fx+ nzv 1))]))))
  ;; Set the ith element of the sparse vector to 0.5
  (let loop ([k 0])
    (cond
      [(fx= k nz)
       (fxvector-set! iv nz i)
       (flvector-set! v nz 0.5)
       (fx+ nz 1)]
      [(fx= i (fxvector-ref iv k))
       (flvector-set! v k 0.5)
       nz]
      [else (loop (fx+ k 1))])))

)
