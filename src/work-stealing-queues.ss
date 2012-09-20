(define ws-queue/empty (cons 'empty '()))
(define ws-queue/abort (cons 'abort '()))

(define ws-queue/initial-log-size 6)

(define-record-type ws-queue
  (fields
    lock
    (mutable top)
    (mutable tub)
    (mutable bottom)
    (mutable active-vector))
  (protocol
    (lambda (n)
      (lambda ()
        (let ([lock (make-ftype-pointer ftype-lock
                      (foreign-alloc (ftype-sizeof ftype-lock)))])
          (initialize-lock lock)
          (n lock 0 0 0 (make-circular-vector ws-queue/initial-log-size)))))))

(define (destroy-queue! wsq)
  (foreign-free (ftype-pointer-address (ws-queue-lock wsq))))

(define (ws-queue-cas-top wsq old new)
  (and (acquire-lock (ws-queue-lock wsq))
       (let ([res (and (= (ws-queue-top wsq) old) 
                       (ws-queue-top-set! wsq new) 
                       #t)])
         (release-lock (ws-queue-lock wsq))
         res)))

(define (ws-queue-push-bottom! wsq v)
  (define (grow/maybe b t cv)
    (let ([n (fx1- (circular-vector-length cv))])
      (if (fx>= (fx- b t) n)
          (let ([rt (ws-queue-top wsq)])
            (ws-queue-tub-set! wsq rt)
            (if (fx>= (fx- b rt) n)
                (let ([nv (circular-vector-grow cv b rt)])
                  (ws-queue-active-vector-set! wsq nv)
                  nv)
                cv))
          cv)))
  (let ([b (ws-queue-bottom wsq)] [t (ws-queue-tub wsq)])
    (let ([cv (grow/maybe b t (ws-queue-active-vector wsq))])
      (circular-vector-set! cv b v)
      (ws-queue-bottom-set! wsq (fx1+ b)))))

(define (ws-queue-steal wsq)
  (let ([b (ws-queue-bottom wsq)] [t (ws-queue-top wsq)])
    (if (fx<= (fx- b t) 0)
        ws-queue/empty
        (let ([v (circular-vector-ref (ws-queue-active-vector wsq) t)])
          (if (ws-queue-cas-top wsq t (fx1+ t))
              v
              ws-queue/abort)))))

(define (ws-queue-pop-bottom wsq)
  (let ([b (fx1- (ws-queue-bottom wsq))] [t (ws-queue-top wsq)])
    (ws-queue-bottom-set! wsq b)
    (let ([size (fx- b t)])
      (if (fx< size 0)
          (begin
            (ws-queue-bottom-set! wsq t)
            ws-queue/empty)
          (let ([v (circular-vector-ref (ws-queue-active-vector wsq) b)])
            (cond 
              [(fx> size 0) v]
              [(not (ws-queue-cas-top wsq t (fx1+ t))) ws-queue/empty]
              [else 
                (ws-queue-bottom-set! wsq (fx1+ t)) 
                v]))))))

(define (enqueue! thk)
  (let ([queue (thread-queue)])
    (unless queue
      (error 'enqueue! "calling enqueue! from outside a thread"))
    (ws-queue-push-bottom! queue thk)))

(define (try-steal)
  (let loop ([lst work-queues])
    (if (null? lst) 
        ws-queue/empty
        (let ([res (ws-queue-steal (car lst))])
          (cond
            [(eq? res ws-queue/empty) (loop (cdr lst))]
            [(eq? res ws-queue/abort) (loop lst)]
            [else res])))))

(define (steal-from-queues)
  (let loop ([slp 1000])
    (let ([res (try-steal)])
      (if (eq? ws-queue/empty res)
          (begin (sleep (make-time 'time-duration slp 0)) (loop slp))
          res))))

(define (get-work/try wsq)
  (let ([thk (ws-queue-pop-bottom wsq)])
    (if (eq? thk ws-queue/empty)
        (try-steal)
        thk)))

(define (get-work)
  (let ([wsq (thread-queue)])
    (let ([thk (ws-queue-pop-bottom wsq)])
      (if (eq? thk ws-queue/empty)
          (steal-from-queues)
          thk))))

