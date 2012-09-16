(meta define (prim-function? stx)
  (and (memq (syntax->datum stx) '(⍳ + ⍴ ≡)) #t))

(meta define (prim-operator? stx)
  (and (memq (syntax->datum stx) '(/ ¨)) #t))

(meta define (literal? stx)
  (or (number? (syntax->datum stx))))

(meta define (synmem? id stx)
  (syntax-case stx ()
    [(x rest ...) (free-identifier=? #'x id) #t]
    [() #f]
    [(x rest ...) (synmem? id #'(rest ...))]))

(meta define (function? id funs)
  (or (prim-function? id) (synmem? id funs)))

(meta define (operator? id oprs)
  (or (prim-operator? id) (synmem? id oprs)))

(meta define (variable? stx)
  (define (char-aplvar? x)
    (or (char-alphabetic? x) (char-numeric? x) (char=? x #\∆)))
  (let ([val (syntax->datum stx)])
    (and (symbol? val)
         (for-all char-aplvar? (string->list (symbol->string val))))))

(define ⍳)
(define ⍵)
(define ⍺)
(define ⋄)
(define ←)
(define ⍴)
(define ≡)
(define ¨)
(define {)
(define })
(define :)

(define-syntax prim-name
  (syntax-rules (⍳ + ⍴ ≡)
    [(_ ⍳) array-iota]
    [(_ +) plus]
    [(_ ⍴) rho]
    [(_ ≡) equiv]))

(define-syntax op-name
  (syntax-rules (/ ¨)
    [(_ /) reduce]
    [(_ ¨) each]))

(define-syntax apllit
  (syntax-rules ()
    [(_ args (v ...) x r ...) (literal? #'x)
     (apllit args (v ... x) r ...)]
    [(_ args (v) r ...)
     (aplexp/optimize args (% (make-scalar-array v)) r ...)]
    [(_ args (v ...) r ...)
     (aplexp/optimize args (% (make-vector-array '(v ...))) r ...)]))

(define-syntax aplexp
  (syntax-rules (% ⍬ ⍺ ⍵)
    [(_ args id) 
     (variable? #'id) 
     id]
    [(_ args (% exp)) 
     exp]
    [(_ (l . o) ⍺ rest ...) 
     (aplexp/optimize (l . o) (% l) rest ...)]
    [(_ (l r . o) ⍵ rest ...) 
     (aplexp/optimize (l r . o) (% r) rest ...)]
    [(_ args ⍬ rest ...) 
     (aplexp/optimize args (% empty-array) rest ...)] 
    [(_ args prim oper rest ...) 
     (and (function? #'prim #'()) (operator? #'oper #'()))
     (((op-name oper) (prim-name prim)) (aplexp/optimize args rest ...))]
    [(_ args prim rest ...) 
     (function? #'prim #'()) 
     ((prim-name prim) (aplexp/optimize args rest ...))]
    [(_ args (% exp) prim oper rest ...) 
     (and (function? #'prim #'()) (operator? #'oper #'()))
     (((op-name oper) (prim-name prim)) exp (aplexp/optimize args rest ...))]
    [(_ args (% exp) prim rest ...) 
     (function? #'prim #'())
     ((prim-name prim) exp (aplexp/optimize args rest ...))]
    [(_ args (tks ...) rest ...)
     (aplexp/optimize args (% (aplexp args tks ...)) rest ...)]
    [(_ args id prim rest ...) 
     (and (variable? #'id) (function? #'prim #'()))
     ((prim-name prim) id (aplexp/optimize args rest ...))]
    [(_ args id oper rest ...) 
     (and (variable? #'id) (operator? #'oper #'()))
     (((op-name oper) id) (aplexp/optimize args rest ...))]
    [(_ args lit r ...) (literal? #'lit)
     (apllit args (lit) r ...)]))

(define-syntax aplexp/optimize
  (syntax-rules (+ / ⍳ ¨)
    [(_ args + / ⍳ rest ...)
     (plus-reduce-iota (aplexp/optimize args rest ...))]
    [(_ args + / rest ...)
     (plus-reduce (aplexp/optimize args rest ...))]
    [(_ args id ¨ ⍳ rest ...) (variable? #'id)
     (each-iota id (aplexp/optimize args rest ...))]
    [(_ args rest ...) 
     (aplexp args rest ...)]))

(define-syntax (proc-body x)
  (syntax-case x ()
    [(_ body ...)
      #'(case-lambda 
          [(rgt) (aplbody (bad rgt bad bad) body ...)] 
          [(lft rgt) (aplbody (lft rgt bad bad) body ...)] 
          [(lop rop lft rgt) (aplbody (lft rgt lop rop) body ...)])]))

(define-syntax bad 
  (identifier-syntax (syntax-violation #f "unbound variable" #'bad)))

(define-syntax aplproc
  (syntax-rules (})
    [(_ args id (body ...) } rest ...)
     (letrec ([id (proc-body body ...)])
       (aplbody args rest ...))]
    [(_ args id (body ...) e rest ...)
     (aplproc args id (body ... e) rest ...)]))

(define-syntax aplbody
  (syntax-rules (% ⋄ ← { :)
    [(_ args id ← { rest ...) (variable? #'id)
     (aplproc args id () rest ...)]
    [(_ args id ← exp ...) (variable? #'id) 
     (aplbody args (← id) exp ...)]
    [(_ args (← id exp ...) ⋄ rest ...)
     (let ([id (aplexp/optimize args exp ...)])
       (aplbody args rest ...))]
    [(_ args (← id exp ...))
     (let ([id (aplexp/optimize exp ...)]) (void))]
    [(_ args (← id exp ...) e rest ...)
     (aplbody args (← id exp ... e) rest ...)]
    [(_ args (: (t ...) (c ...)) ⋄ rest ...)
     (aplif (aplexp/optimize args t ...)
            (aplbody args c ...)
            (aplbody args rest ...))]
    [(_ args (: t (c ...)) e rest ...)
     (aplbody args (: t (c ... e)) rest ...)]
    [(_ args (% exp ...) : rest ...)
     (aplbody args (: (exp ...) ()) rest ...)]
    [(_ args (% exp ...) ⋄ rest ...)
     (aplexp/optimize args exp ...)]
    [(_ args (% exp ...))
     (aplexp/optimize args exp ...)]
    [(_ args (% exp ...) e rest ...)
     (aplbody args (% exp ... e) rest ...)]
    [(_ args ⋄ exp ...)
     (aplbody args exp ...)]
    [(_ args e exp ...)
     (aplbody args (% e) exp ...)]))

(define-syntax apl
  (syntax-rules ()
    [(_ exp ...) (aplbody (bad bad bad bad) exp ...)]))
