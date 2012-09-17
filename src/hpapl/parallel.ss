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

(define queue (make-queue))

(define (shepherd)
  (let ([thk (dequeue! queue)])
    (and thk (thk) (shepherd))))

(define (initialize-shepherds! count)
  (for-each (lambda (x) (fork-thread shepherd)) (iota count))
  (void))

(define (halt-shepherds! count)
  (for-each (lambda (x) (enqueue! queue #f)) (iota count))
  (void))

(define-record-type future (fields (mutable value) condition mutex)
  (protocol
    (lambda (n)
      (lambda (thk)
        (let ([c (make-condition)])
          (let ([res (n #f c (make-mutex))])
            (define (run)
              (future-value-set! res (thk))
              (condition-broadcast c))
            (enqueue! queue run)
            res))))))

(define-syntax spawn
  (syntax-rules ()
    [(_ exp) (make-future (lambda () exp))]))

(define (parallel f)
  (case-lambda
    [(a) (spawn (f a))]
    [(a b) (spawn (f a b))]))

(define (future->array ftr)
  (unless (future-value ftr)
    (with-mutex (future-mutex ftr)
      (condition-wait (future-condition ftr) (future-mutex ftr))))
  (future-value ftr))

