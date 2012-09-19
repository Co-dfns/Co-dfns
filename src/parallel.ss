(define work-queues '())
(define work-queue-lock (make-mutex))

(define (add-work-queue! wsq)
  (with-mutex work-queue-lock
    (set! work-queues (cons wsq work-queues))))

(define exit-continuation
  (make-thread-parameter
    (lambda args
      (error 'exit-continuation "no exit continuation defined"))))
(define global-continuation
  (make-parameter
    (lambda args
      (error 'global-continuation "no global continuation defined"))))

(define thread-queue (make-thread-parameter #f))

(define (release-thread) ((exit-continuation)))
(define (apl-return-result x) ((global-continuation) x))

(define (make-shepherd cpu wsq)
  (add-work-queue! wsq)
  (lambda ()
    (thread-affinity-set! cpu)
    (thread-queue wsq)
    (let loop ()
      (call-with-current-continuation
        (lambda (k)
          (parameterize ([exit-continuation k])
            (with-exception-handler
              (lambda (c) (apl-return-result c) (k))
              (get-work wsq)))))
      (loop))))

(define (initialize-shepherds!)
  (for-each 
    (lambda (cpu) (fork-thread (make-shepherd cpu (make-ws-queue)))) 
    (iota (shepherd-count))))

(define-record-type future 
  (fields (mutable value) (mutable waiters) mutex)
  (protocol
    (lambda (n)
      (lambda (thk)
          (let ([res (n #f '() (make-mutex))])
            (enqueue! 
              (lambda ()
                (future-value-set! res (thk))
                (with-mutex (future-mutex res)
                  (for-each (lambda (thk) (enqueue! thk))
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
      (set! res (defuture x))
      (with-mutex m (condition-signal c)))
    (parameterize ([global-continuation set-result] 
                   [thread-queue (car work-queues)])
      (with-mutex m
        (enqueue! (lambda () (set-result (thk))))
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

