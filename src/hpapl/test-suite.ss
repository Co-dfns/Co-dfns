(define (->string x) (with-output-to-string (lambda () (write x))))

(define-syntax test-apl
  (syntax-rules ()
    [(_ tks ...) 
     (test-eq #t
       (array->boolean
         (test-read-eval-string (->string '(apl tks ...)))))]
    [(_ name tks ...) (string? (syntax->datum #'name))
     (test-eq name #t
       (array->boolean
         (test-read-eval-string (->string '(apl tks ...)))))]))

(test-apl 0 ≡ ⍴ ⍴ 5)
(test-apl 1 ≡ ⍴ ⍴ 0 1 2)
(test-apl 2 ≡ 1 1 ⍴ 0)
(test-apl 1 ≡ ⍴ ⍴ ⍴ 5)
(test-apl 1 ≡ ⍴ ⍴ ⍴ 0 1 2)


