;;; Copyright (c) 2000-2013 Dipanwita Sarkar, Andrew W. Keep, R. Kent Dybvig, Oscar Waddell
;;; See the accompanying file Copyright for detatils

(library (nanopass unparser)
  (export make-unparser)
  (import (rnrs) 
          (nanopass helpers)
          (nanopass records)
          (nanopass syntaxconvert)) 
  
  (define make-unparser
    (lambda (desc)
      (let* ([lang-name (language-record desc)]
             [ntspecs (language-ntspecs desc)]
             [tspecs (language-tspecs desc)])
        (with-syntax ([(proc-name ...) (map ntspec-unparse-name ntspecs)]
                      [(ntspec? ...) (map ntspec-pred ntspecs)]
                      [(tspec? ...) (map tspec-pred tspecs)])
          (with-syntax ([(proc ...)
                         (map (lambda (ntspec procname)
                                (make-unparse-proc tspecs ntspecs ntspec 
                                                   procname lang-name))
                              ntspecs #'(proc-name ...))])
            #`(rec f (case-lambda
                       [(ir) (f ir #f)]
                       [(ir raw?)
                        (define proc-name proc) ...
                        (cond
                          [(ntspec? ir) (proc-name ir)] ...
                          ; TODO: should be calling the prettify function on these potentially
                          [(tspec? ir) ir] ...
                          [else (error '#,lang-name
                                  "unrecognized language record"
                                  ir)])])))))))
  
  (define make-unparse-proc
    (lambda (tspecs ntspecs ntspec procname lang-name)
      ;; handles alts of the form: LambdaExpr where LambdaExpr is another
      ;; non-terminal specifier with no surrounding markers.
      (define make-nonterm-clause
        (lambda (alt)
          (let ([ntspec (nonterminal-alt-ntspec alt)])
            (let ([nonterm-proc (ntspec-unparse-name ntspec)]
                  [nonterm-pred? (ntspec-all-pred ntspec)])
              (list #`((#,nonterm-pred? ir) (#,nonterm-proc ir)))))))
      
      ;; handles alts of the form: x, c where x and c are meta-variables
      ;; that refer to terminals, and have no surrounding marker.
      (define-who make-term-clause ;; only atom alt cases
        (lambda (alt)
          (let ([tspec (meta-name->tspec (alt-syn alt) tspecs)])
            (unless tspec (error who "expected to find matching tspec" alt))
            (let ([h (tspec-handler tspec)])
              (with-syntax ([term-pred? (tspec-pred tspec)])
                #`((term-pred? ir)
                    #,(if h
                          #`(if raw? ir (#,h ir))
                          #'ir)))))))


      (define make-pair-clause
        (lambda (alt)
          (define meta-var?
            (let ([names (syntax->datum (pair-alt-field-names alt))])
              (lambda (m)
                (and (identifier? m) (memq (syntax->datum m) names) #t))))

          (define lookup-meta-info
            (let ([meta-map (map list
                              (pair-alt-field-names alt)
                              (pair-alt-field-levels alt)
                              (pair-alt-field-maybes alt)
                              (pair-alt-accessors alt))])
              (lambda (name)
                (apply values
                  (or (assp (lambda (x) (bound-identifier=? x name)) meta-map)
                      (syntax-error name
                        "unable to find match for ~s in ~s"
                        (syntax->datum name)
                        (syntax->datum (pair-alt-field-names alt))))))))

          (define unparse-field
            (lambda (m) 
              (let-values ([(m level maybe? accr) (lookup-meta-info m)])
                (cond
                  [(meta-name->tspec m tspecs) =>
                   (lambda (spec)
                     (if (tspec-handler spec)
                         #`(if raw?
                               (#,accr ir)
                               #,(with-syntax ([proc-name (tspec-handler spec)]
                                               [field #`(#,accr ir)])
                                   (let f ([level level] [x #'field])
                                     (if (= level 0)
                                         (if maybe? #`(and #,x (proc-name #,x)) #`(proc-name #,x))
                                         #`(map (lambda (x)
                                                  #,(f (- level 1) #'x))
                                                #,x)))))
                         #`(#,accr ir)))]
                  [(meta-name->ntspec m ntspecs) =>
                   (lambda (spec)
                     (with-syntax ([proc-name (ntspec-unparse-name spec)]
                                   [field #`(#,accr ir)])
                       (let f ([level level] [x #'field])
                         (if (= level 0)
                             (if maybe? #`(and #,x (proc-name #,x)) #`(proc-name #,x))
                             #`(map (lambda (x) #,(f (- level 1) #'x))
                                    #,x)))))]
                  [else (error 'parse-field "unrecognized meta variable ~s"
                               m)]))))

          (define-syntax syntax-lambda
            (lambda (x)
              (syntax-case x ()
                [(_ (pat ...) b b* ...)
                 (with-syntax ([(x ...) (generate-temporaries #'(pat ...))])
                   #'(lambda (x ...)
                       (with-syntax ((pat x) ...)
                         b b* ...)))])))

          (define-syntax with-temp
            (syntax-rules ()
              [(_ v b b* ...)
               (with-syntax ([(v) (generate-temporaries '(x))])
                 b b* ...)]))

          (define destruct
            (lambda (x)
              (syntax-case x ()
                [var
                 (meta-var? #'var)
                 (with-temp t
                   (values #'t (list #'t) (list (unparse-field #'var))))]
                [(maybe var)
                 (and (eq? (datum maybe) 'maybe) (meta-var? #'var))
                 (with-temp t
                   (values #'t (list #'t) (list (unparse-field #'var))))]
                [(var dots)
                 (and (meta-var? #'var) (ellipsis? #'dots))
                 (with-temp t
                   (values #'t (list #'t) (list (unparse-field #'var))))]
                [(var dots . rest)
                 (and (meta-var? #'var) (ellipsis? #'dots))
                 (with-values (destruct #'rest)
                   (syntax-lambda (rest-builder rest-vars rest-exps)
                     (with-syntax ([tail-exp (if (null? #'rest-vars)
                                                 #''rest
                                                 #'rest-builder)])
                       (with-temp t
                         (values #'(append t tail-exp)
                                 (cons #'t #'rest-vars)
                                 (cons (unparse-field #'var) #'rest-exps))))))]
                [(exp dots . rest)
                 (ellipsis? #'dots)
                 (with-values (destruct #'exp)
                   (syntax-lambda (exp-builder (exp-var ...) (exp-exp ...))
                     (with-values (destruct #'rest)
                       (syntax-lambda (rest-builder rest-vars rest-exps)
                         (with-syntax ([tail-exp (if (null? #'rest-vars)
                                                     #''rest
                                                     #'rest-builder)])
                           (values #'(let f ([exp-var exp-var] ...)
                                       (if (and (pair? exp-var) ...)
                                           (cons
                                             (let ([exp-var (car exp-var)] ...)
                                               exp-builder)
                                             (f (cdr exp-var) ...))
                                           tail-exp))
                                   (append #'(exp-var ...) #'rest-vars)
                                   (append #'(exp-exp ...) #'rest-exps)))))))]
                [(a . d)
                 (with-values (destruct #'a)
                   (syntax-lambda (a-builder a-vars a-exps)
                     (with-values (destruct #'d)
                       (syntax-lambda (d-builder d-vars d-exps)
                         (with-syntax ([a (if (null? #'a-vars)
                                              #''a
                                              #'a-builder)]
                                       [d (if (null? #'d-vars)
                                              #''d
                                              #'d-builder)])
                           (values #'(cons a d)
                                   (append #'a-vars #'d-vars)
                                   (append #'a-exps #'d-exps)))))))]
                [other (values #'other '() '())])))
          (with-syntax ([pred? (pair-alt-pred alt)])
            #`((pred? ir) 
               #,(with-values (destruct (alt-syn alt))
                   (syntax-lambda (builder (x ...) (exp ...))
                     (let ([pretty (alt-pretty alt)])
                       (if pretty
                           (with-values (destruct pretty)
                             (syntax-lambda (pbuilder (px ...) (pexp ...))
                               #'(if raw?
                                     (let ((x exp) ...) builder)
                                     (let ((px pexp) ...) pbuilder))))
                           #'(let ((x exp) ...) builder)))))))))

      ;; When one nonterminalA alternative is another nonterminalB, we
      ;; expand all the alternatives of nonterminalB with the alternatives
      ;; of nonterminalA However, nonterminalA and nonterminalB cannot
      ;; (both) have an implicit case, by design.
      (partition-syn (ntspec-alts ntspec)
        ([term-alt* terminal-alt?] [nonterm-alt* nonterminal-alt?] [pair-alt* otherwise])
        (partition-syn nonterm-alt*
          ([nonterm-imp-alt* (lambda (alt)
                               (has-implicit-alt?
                                 (nonterminal-alt-ntspec alt)))]
           [nonterm-nonimp-alt* otherwise])
          #`(lambda (ir)
              (cond
                #,@(map make-term-clause term-alt*)
                #,@(map make-pair-clause pair-alt*)
                ;; note: the following two can potentially be combined
                #,@(apply append (map make-nonterm-clause nonterm-nonimp-alt*))
                #,@(apply append (map make-nonterm-clause nonterm-imp-alt*))
                [else (error '#,procname "invalid record" ir)])))))))
