(define-record-type queue (fields head.tail condition mutex)
  (protocol
    (lambda (n)
      (lambda ()
        (n (cons '() '())
           (make-condition)
           (make-mutex))))))

(define (queue-empty? q) (null? (queue-head q)))

(define (queue-tail q) (cdr (queue-head.tail q)))
(define (queue-head q) (car (queue-head.tail q)))

(define (set-queue-head! q v) (set-car! (queue-head.tail q) v))
(define (set-queue-tail! q v) (set-cdr! (queue-head.tail q) v))

(define (make-queue-entry v) (cons v '()))
(define (entry-value e) (car e))
(define (entry-next e) (cdr e))
(define (set-entry-next! e nxt) (set-cdr! e nxt))

(define (enqueue! q v)
  (with-mutex (queue-mutex q)
    (let ([e (make-queue-entry v)])
      (if (queue-empty? q)
          (begin (set-queue-head! q e) (set-queue-tail! q e))
          (begin (set-entry-next! (queue-tail q) e) (set-queue-tail! q e))))
    (condition-signal (queue-condition q))))

(define (dequeue! q)
  (with-mutex (queue-mutex q)
    (when (queue-empty? q) (condition-wait (queue-condition q) (queue-mutex q)))
    (let ([e (queue-head q)])
      (set-queue-head! q (entry-next e))
      (entry-value e))))

(define work-queue (make-queue))

(define exit-continuation
  (make-thread-parameter #f))

(define (release-thread) ((exit-continuation)))

(define (shepherd)
  (let ([thk (dequeue! work-queue)])
    (when thk
      (call-with-current-continuation
        (lambda (k)
          (parameterize ([exit-continuation k])
            (thk))))
      (shepherd))))

(define (initialize-shepherds!)
  (for-each (lambda (x) (fork-thread shepherd)) (iota (shepherd-count)))
  (void))

(define (halt-shepherds!)
  (for-each (lambda (x) (enqueue! work-queue #f)) (iota (shepherd-count)))
  (void))

(define-record-type future (fields (mutable value))
  (protocol
    (lambda (n)
      (lambda (thk)
        (let ([res (n #f)])
          (enqueue! work-queue 
            (lambda () (future-value-set! res (thk))))
          res)))))

(define-syntax spawn
  (syntax-rules ()
    [(_ exp) (make-future (lambda () exp))]))

(define (parallel f)
  (case-lambda 
    [(a) (spawn (f a))]
    [(a b) (spawn (f a b))]))

(define (future->array ftr)
  (if (future-value ftr)
      (future-value ftr)
      (call-with-current-continuation
        (lambda (k)
          (enqueue! work-queue
            (rec retry
              (lambda ()
                (if (future-value ftr)
                    (k (future-value ftr))
                    (enqueue! work-queue retry)))))
          (release-thread)))))

(define (defuture a)
  (if (future? a) (future->array a) a))

(define shepherd-count (make-parameter 8))

(define (apl-run thk)
  (let ([m (make-mutex)] [c (make-condition)] [res #f])
    (with-mutex m
      (enqueue! work-queue
        (lambda ()
          (set! res (thk))
          (with-mutex m (condition-signal c))))
      (condition-wait c m)
      res)))
