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

(define (enqueue! v)
  (let ([q (thread-queue)])
    (with-mutex (queue-mutex q)
      (let ([e (make-queue-entry v)])
        (if (queue-empty? q)
            (begin (set-queue-head! q e) (set-queue-tail! q e))
            (begin (set-entry-next! (queue-tail q) e) (set-queue-tail! q e))))
      (condition-signal (queue-condition q)))))

(define (dequeue)
  (let ([q (thread-queue)])
    (with-mutex (queue-mutex q)
      (when (queue-empty? q) 
        (condition-wait (queue-condition q) (queue-mutex q)))
      (let ([e (queue-head q)])
        (when (eq? e (queue-tail q))
          (set-queue-tail! q '()))
        (set-queue-head! q (entry-next e))
        (entry-value e)))))

(define work-queue (make-queue))

(define (make-ws-queue) work-queue)

(define (get-work wsq) (dequeue))
