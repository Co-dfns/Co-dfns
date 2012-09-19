(define-record-type queue (fields head.tail condition mutex)
  (protocol
    (lambda (n)
      (lambda ()
        (n (cons '() '())
           (make-condition)
           (make-mutex))))))

(define (queue-empty? q) (null? (queue-head q)))
(define (queue-empty/lock? q)
  (with-mutex (queue-mutex q) (null? (queue-head q))))

(define (queue-tail q) (cdr (queue-head.tail q)))
(define (queue-head q) (car (queue-head.tail q)))

(define (set-queue-head! q v) (set-car! (queue-head.tail q) v))
(define (set-queue-tail! q v) (set-cdr! (queue-head.tail q) v))

(define (make-queue-entry v) (cons v '()))
(define (entry-value e) (car e))
(define (entry-next e) (cdr e))
(define (set-entry-next! e nxt) (set-cdr! e nxt))

#|
(define enqueue-count 0)
(define enqueue-time 0)
(define (average-enqueue-time) (inexact (/ enqueue-time enqueue-count)))

(define dequeue-count 0)
(define dequeue-time 0)
(define (average-dequeue-time) (inexact (/ dequeue-time dequeue-count)))

(define (enqueue! q v)
  (let ([start (real-time)])
    (with-mutex (queue-mutex q)
      (let ([e (make-queue-entry v)])
        (if (queue-empty? q)
            (begin (set-queue-head! q e) (set-queue-tail! q e))
            (begin (set-entry-next! (queue-tail q) e) (set-queue-tail! q e))))
      (condition-signal (queue-condition q)))
    (set! enqueue-time (+ enqueue-time (- (real-time) start)))
    (set! enqueue-count (+ enqueue-count 1))))

(define (dequeue q)
  (let ([start (real-time)])
    (with-mutex (queue-mutex q)
      (when (queue-empty? q) (condition-wait (queue-condition q) (queue-mutex q)))
      (let ([e (queue-head q)])
        (set-queue-head! q (entry-next e))
        (set! dequeue-time (+ dequeue-time (- (real-time) start)))
        (set! dequeue-count (+ dequeue-count 1))
        (entry-value e)))))
|#

(define (enqueue! q v)
  (with-mutex (queue-mutex q)
    (let ([e (make-queue-entry v)])
      (if (queue-empty? q)
          (begin (set-queue-head! q e) (set-queue-tail! q e))
          (begin (set-entry-next! (queue-tail q) e) (set-queue-tail! q e))))
    (condition-signal (queue-condition q))))

(define (dequeue q)
  (with-mutex (queue-mutex q)
    (when (queue-empty? q) (condition-wait (queue-condition q) (queue-mutex q)))
    (let ([e (queue-head q)])
      (when (eq? e (queue-tail q))
        (set-queue-tail! q '()))
      (set-queue-head! q (entry-next e))
      (entry-value e))))

(define work-queue (make-queue))

(define exit-continuation
  (make-thread-parameter
    (lambda args
      (error 'exit-continuation "no exit continuation defined"))))
(define global-continuation
  (make-parameter
    (lambda args
      (error 'global-continuation "no global continuation defined"))))

(define (release-thread) ((exit-continuation)))
(define (apl-return-result x) ((global-continuation) x))

(define (shepherd)
  (call-with-current-continuation
    (lambda (k)
      (let ([thk (dequeue work-queue)])
        (when thk
          (parameterize ([exit-continuation k])
            (with-exception-handler
              (lambda (c) (apl-return-result c) (k))
              thk))))))
  (shepherd))

(define (initialize-shepherds!)
  (for-each 
    (lambda (x) 
      (fork-thread 
        (lambda () 
          (thread-affinity-set! x)
          (shepherd))))
    (iota (shepherd-count)))
  (void))

(define (halt-shepherds!)
  (for-each (lambda (x) (enqueue! work-queue #f)) (iota (shepherd-count)))
  (void))

(define-record-type future 
  (fields (mutable value) (mutable waiters) mutex)
  (protocol
    (lambda (n)
      (lambda (thk)
        (let ([res (n #f '() (make-mutex))])
          (enqueue! work-queue
            (lambda ()
              (future-value-set! res (thk))
              (with-mutex (future-mutex res)
                (for-each (lambda (thk) (enqueue! work-queue thk))
                  (future-waiters res)))))
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
          (with-mutex (future-mutex ftr)
            (future-waiters-set! ftr 
              (cons (lambda () (k (future-value ftr)))
                    (future-waiters ftr))))
          (release-thread)))))

(define (scalar-defuture x)
  (cond
    [(future? x) (defuture (scalar-value (defuture x)))]
    [(array? x) (defuture (scalar-value x))]
    [else x]))

(define (scalar-vector-defuture v)
  (vector-map scalar-defuture v))

(define (defuture-vector v)
  (vector-map defuture v))

(define (defuture a)
  (if (future? a) (future->array a) a))

(define shepherd-count (make-parameter 8))

(define (apl-run thk)
  (let ([m (make-mutex)] [c (make-condition)] [res #f])
    (define (set-result x)
      (set! res x)
      (with-mutex m (condition-signal c)))
    (parameterize ([global-continuation set-result])
      (with-mutex m
        (enqueue! work-queue (lambda () (set-result (defuture (thk)))))
        (condition-wait c m)
        (if (condition? res)
            (raise res)
            res)))))

(define dummy (load-shared-object "libhpapl.so"))

(define $thread-affinity-set
  (foreign-procedure "thread_affinity_set" (int) scheme-object))

(define (thread-affinity-set! cpu)
  (let ([res ($thread-affinity-set cpu)])
    (case res
      [(OKAY) (void)]
      [else (error 'thread-affinity-set "~a" res)])))

