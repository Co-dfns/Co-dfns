(meta define (primitive? stx)
  (and (memq (syntax->datum stx) '(⍳ +)) #t))

(meta define (operator? stx)
  (and (memq (syntax->datum stx) '(/ ¨)) #t))

(meta define (literal? stx)
  (or (number? (syntax->datum stx))))

(define-syntax prim-name
  (syntax-rules (⍳ +)
    [(_ ⍳) iota]
    [(_ +) plus]))

(define-syntax op-name
  (syntax-rules (/ ¨)
    [(_ /) reduce]
    [(_ ¨) each]))

(define-syntax apllit
  (syntax-rules ()
    [(_ (v ...) x r ...) (literal? #'x)
     (apllit (v ... x) r ...)]
    [(_ (v) r ...)
     (aplexp (% (scalar v)) r ...)]
    [(_ (v ...) r ...)
     (aplexp (% (arrvec v ...)) r ...)]))

(define-syntax aplexp
  (syntax-rules (%)
    [(_ id) (identifier? #'id) id]
    [(_ (% exp)) exp]
    [(_ prim oper rest ...) (and (primitive? #'prim) (operator? #'oper))
     (((op-name oper) (prim-name prim)) (aplexp rest ...))]
    [(_ prim rest ...) (primitive? #'prim) 
     ((prim-name prim) (aplexp rest ...))]
    [(_ (% exp) prim oper rest ...) 
     (and (primitive? #'prim) (operator? #'oper))
     (((op-name oper) (prim-name prim)) exp (aplexp rest ...))]
    [(_ (% exp) prim rest ...) (primitive? #'prim)
     ((prim-name prim) exp (aplexp rest ...))]
    [(_ (tks ...) rest ...)
     (aplexp (% (aplexp tks ...)) rest ...)]
    [(_ id prim rest ...) (and (identifier? #'id) (primitive? #'prim))
     ((prim-name prim) id (aplexp rest ...))]
    [(_ lit r ...) (literal? #'lit)
     (apllit (lit) r ...)]))

(define-syntax apl
  (syntax-rules ()
    [(_ exp) (aplexp exp)]))
