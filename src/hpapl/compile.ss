(define-syntax def-prims
  (syntax-rules ()
    [(_ name pred? (p n) ...)
     (begin 
       (meta define (pred? stx)
         (and (memq (syntax->datum stx) '(p ...)) #t))
       (define-syntax name
         (syntax-rules (p ...)
           [(_ p) n] ...)))]))

(def-prims prim-fn-name prim-function? 
  (⍳ array-iota)
  (⍴ rho)
  (≡ equiv)
  (× times)
  (+ plus)
  (- subtract)
  (≤ less-than-equal)
  (! bang))

(def-prims prim-op-name prim-operator?
  (∥ parallel)
  (/ reduce)
  (¨ each))

(define-syntax def-aux-keywords
  (syntax-rules ()
    [(_ k ...)
     (begin
       (define-syntax (k x)
         (syntax-violation #f "invalid aux keyword" x))
       ...)]))

(def-aux-keywords ⍳ ⍵ ⍺ ⋄ ← ⍴ ≡ ¨ { } : × ≤ ! ⍬ ∥)

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

(meta define (data? stx)
  (or (and (identifier? stx)
           (or (free-identifier=? #'⍺ stx) 
               (free-identifier=? #'⍵ stx)
               (free-identifier=? #'⍬ stx)))
      (literal? stx)))

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
    [(_ (l . o) ⍺ rest ...) 
     (aplexp/optimize (l . o) (% l) rest ...)]
    [(_ (l r . o) ⍵ rest ...) 
     (aplexp/optimize (l r . o) (% r) rest ...)]
    [(_ args ⍬ rest ...) 
     (aplexp/optimize args (% empty-array) rest ...)]
    [(_ args fn op)
     (prim-operator? #'op)
     ((op-name op) (fn-name fn))]
    [(_ args fn op rest ...) 
     (prim-operator? #'op)
     (((op-name op) (fn-name fn)) (aplexp/optimize args rest ...))]
    [(_ args fn rest ...) 
     (prim-function? #'fn) 
     ((fn-name fn) (aplexp/optimize args rest ...))]
    [(_ args (% exp) fn oper rest ...) 
     (prim-operator? #'oper)
     (((op-name oper) (fn-name fn)) exp (aplexp/optimize args rest ...))]
    [(_ args (% exp) fn rest ...) 
     (prim-function? #'fn)
     ((fn-name fn) exp (aplexp/optimize args rest ...))]
    [(_ args (tk tks ...) rest ...) 
     (not (and (identifier? #'tk) (free-identifier=? #'tk #'%)))
     (aplexp/optimize args (% (aplexp/optimize args tk tks ...)) rest ...)]
    [(_ args id fn rest ...) 
     (and (variable? #'id) (prim-function? #'fn))
     ((fn-name fn) id (aplexp/optimize (p f o) rest ...))]
    [(_ args id op rest ...) 
     (and (variable? #'id) (prim-operator? #'op))
     (((op-name op) id) (aplexp/optimize args rest ...))]
    [(_ args id dat rest ...)
     (and (variable? #'id) (data? #'dat))
     (id (aplexp/optimize args dat rest ...))]
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
          [(rgt) (aplbody (bad rgt bad bad) () body ...)] 
          [(lft rgt) (aplbody (lft rgt bad bad) () body ...)] 
          [(lop rop lft rgt) (aplbody (lft rgt lop rop) () body ...)])]))

(define-syntax bad 
  (identifier-syntax (syntax-violation #f "unbound variable" #'bad)))

(define-syntax aplproc
  (syntax-rules (})
    [(_ args (bds ...) id (body ...) } rest ...)
     (aplbody args (bds ... (id (proc-body body ...))) rest ...)]
    [(_ args bds id (body ...) e rest ...)
     (aplproc args bds id (body ... e) rest ...)]))

(define-syntax aplbody
  (syntax-rules (% ⋄ ← { :)
    [(_ args bds id ← { rest ...) (variable? #'id)
     (aplproc args bds id () rest ...)]
    [(_ args bds id ← exp ...) (variable? #'id) 
     (aplbody args bds (← id) exp ...)]
    [(_ args (b ...) (← id exp ...) ⋄ rest ...)
     (aplbody args (b ... (id (aplexp/optimize args exp ...))) rest ...)]
    [(_ args (b ...) (← id exp ...))
     (letrec* (b ... [id (aplexp/optimize exp ...)]) (void))]
    [(_ args (b ...) (← id) fn op ⋄ rest ...)
     (prim-operator? #'op)
     (aplbody args (b ... [id (aplexp/optimize args fn op)]) rest ...)]
    [(_ args bds (← id exp ...) e rest ...)
     (aplbody args bds (← id exp ... e) rest ...)]
    [(_ args (b ...) (: (t ...) (c ...)) ⋄ rest ...)
     (letrec* (b ...)
       (aplif (aplexp/optimize args t ...)
              (aplbody args () c ...)
              (aplbody args () rest ...)))]
    [(_ args bds (: t (c ...)) e rest ...)
     (aplbody args bds (: t (c ... e)) rest ...)]
    [(_ args bds (% exp ...) : rest ...)
     (aplbody args bds (: (exp ...) ()) rest ...)]
    [(_ args (b ...) (% exp ...) ⋄ rest ...)
     (letrec* (b ...) (aplexp/optimize args exp ...))]
    [(_ args (b ...) (% exp ...))
     (letrec* (b ...) (aplexp/optimize args exp ...))]
    [(_ args bds (% exp ...) e rest ...)
     (aplbody args bds (% exp ... e) rest ...)]
    [(_ args bds ⋄ exp ...)
     (aplbody args bds exp ...)]
    [(_ args bds e exp ...)
     (aplbody args bds (% e) exp ...)]))

(define-syntax apl
  (syntax-rules ()
    [(_ exp ...) (aplbody (bad bad bad bad) () exp ...)]))
