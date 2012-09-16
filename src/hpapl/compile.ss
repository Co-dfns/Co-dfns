(meta define prim-fns '(⍳ ⍴ ≡ ¨ × + - ≤))

(meta define (prim-function? stx)
  (and (memq (syntax->datum stx) prim-fns) #t))

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
  (and (identifier? id)
       (or (prim-function? id) (synmem? id funs))))

(meta define (operator? id oprs)
  (and (identifier? id)
       (or (prim-operator? id) (synmem? id oprs))))

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
(define ×)
(define ≤)

(define-syntax prim-fn-name
  (syntax-rules (⍳ + ⍴ ≡ × - ≤)
    [(_ ⍳) array-iota]
    [(_ +) plus]
    [(_ ⍴) rho]
    [(_ ≡) equiv]
    [(_ ×) times]
    [(_ -) subtract]
    [(_ ≤) less-than-equal]))

(define-syntax prim-op-name
  (syntax-rules (/ ¨)
    [(_ /) reduce]
    [(_ ¨) each]))

(define-syntax fn-name
  (syntax-rules ()
    [(_ id) (prim-function? #'id) (prim-fn-name id)]
    [(_ id) id]))

(define-syntax op-name
  (syntax-rules ()
    [(_ id) (prim-operator? #'id) (prim-op-name id)]
    [(_ id) id]))

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
    [(_ ((l . o) . rst) ⍺ rest ...) 
     (aplexp/optimize ((l . o) . rst) (% l) rest ...)]
    [(_ ((l r . o) . rst) ⍵ rest ...) 
     (aplexp/optimize ((l r . o) . rst) (% r) rest ...)]
    [(_ args ⍬ rest ...) 
     (aplexp/optimize args (% empty-array) rest ...)] 
    [(_ (p f o) fn op rest ...) 
     (and (function? #'fn #'f) (operator? #'op #'o))
     (((op-name op) (fn-name fn)) (aplexp/optimize (p f o) rest ...))]
    [(_ (p f o) fn rest ...) 
     (function? #'fn #'f) 
     ((fn-name fn) (aplexp/optimize (p f o) rest ...))]
    [(_ (p f o) (% exp) fn oper rest ...) 
     (and (function? #'fn #'f) (operator? #'oper #'o))
     (((op-name oper) (fn-name fn)) exp (aplexp/optimize (p f o) rest ...))]
    [(_ (p f o) (% exp) fn rest ...) 
     (function? #'fn #'f)
     ((fn-name fn) exp (aplexp/optimize (p f o) rest ...))]
    [(_ args (tk tks ...) rest ...) 
     (not (and (identifier? #'tk) (free-identifier=? #'tk #'%)))
     (aplexp/optimize args (% (aplexp args tk tks ...)) rest ...)]
    [(_ (p f o) id fn rest ...) 
     (and (variable? #'id) (function? #'fn #'f))
     ((fn-name fn) id (aplexp/optimize (p f o) rest ...))]
    [(_ (p f o) id op rest ...) 
     (and (variable? #'id) (operator? #'op #'o))
     (((op-name op) id) (aplexp/optimize (p f o) rest ...))]
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
    [(_ (p f o) body ...)
      #'(case-lambda 
          [(rgt) (aplbody ((bad rgt bad bad) f o) body ...)] 
          [(lft rgt) (aplbody ((lft rgt bad bad) f o) body ...)] 
          [(lop rop lft rgt) (aplbody ((lft rgt lop rop) f o) body ...)])]))

(define-syntax bad 
  (identifier-syntax (syntax-violation #f "unbound variable" #'bad)))

(define-syntax aplproc
  (syntax-rules (})
    [(_ (p (f ...) o) id (body ...) } rest ...)
     (letrec ([id (proc-body (p (id f ...) o) body ...)])
       (aplbody (p (id f ...) o) rest ...))]
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
    [(_ exp ...) (aplbody ((bad bad bad bad) () ()) exp ...)]))
