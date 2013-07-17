;;; Copyright (c) 2000-2013 Dipanwita Sarkar, Andrew W. Keep, R. Kent Dybvig, Oscar Waddell
;;; See the accompanying file Copyright for detatils

(library (nanopass parser)
  (export define-parser trace-define-parser)
  (import (rnrs)
          (nanopass helpers)
          (nanopass records)
          (nanopass syntaxconvert)
          (nanopass nano-syntax-dispatch)
          (only (chezscheme) trace-define trace-lambda))

  (define-syntax define-parser
    (syntax-rules ()
      [(_ . rest) (x-define-parser . rest)]))

  (define-syntax trace-define-parser
    (syntax-rules ()
      [(_ . rest) (x-define-parser trace . rest)]))

  (define-syntax x-define-parser
    (lambda (x)
      (define make-parse-proc
        (lambda (desc tspecs ntspecs ntspec lang-name)
          (define parse-field
            (lambda (m level maybe?)
              (cond
                [(meta-name->tspec m tspecs) m]
                [(meta-name->ntspec m ntspecs) =>
                  (lambda (spec)
                    (with-syntax ([proc-name (ntspec-parse-name spec)])
                      (let f ([level level] [x m])
                        (if (= level 0)
                            (if maybe? #`(and #,x (proc-name #,x #t))  #`(proc-name #,x #t))
                            #`(map (lambda (x) #,(f (- level 1) #'x)) #,x)))))]
                [else (syntax-violation 'parser "unrecognized meta variable"
                        (language-name desc) m)]))) 

          (define-who make-term-clause
            (lambda (alt)
              (with-syntax ([term-pred?
                              (cond
                                [(meta-name->tspec (alt-syn alt) tspecs) =>
                                  (lambda (tspec) (tspec-pred tspec))]
                                [else (error who "expected to find matching tspec" alt)])])
                #'[(term-pred? s-exp) s-exp])))

          (define make-nonterm-clause
            (lambda (alt)
              (let ([spec (meta-name->ntspec (alt-syn alt) ntspecs)])
                (unless spec
                  (syntax-violation 'parser "unrecognized meta variable"
                    (language-name desc) (alt-syn alt)))
                (with-syntax ([proc-name (ntspec-parse-name spec)])
                  #`(proc-name s-exp #f)))))

          (define make-pair-clause
            (lambda (alt)
              (let ([field-pats (pair-alt-pattern alt)])
                (with-syntax ([maker (pair-alt-checking-maker alt)]
                               [(field-var ...) (pair-alt-field-names alt)])
                  (with-syntax ([(parsed-field ...)
                                  (map parse-field #'(field-var ...)
                                    (pair-alt-field-levels alt)
                                    (pair-alt-field-maybes alt))]
                                 [(msg ...) (map (lambda (x) #f) #'(field-var ...))])
                    #`(#,(if (pair-alt-implicit? alt)
                             #`(nano-syntax-dispatch
                                 s-exp '#,(datum->syntax #'lang-name field-pats))
                             #`(and (eq? '#,(car (alt-syn alt)) (car s-exp))
                                    (nano-syntax-dispatch 
                                      (cdr s-exp) 
                                      '#,(datum->syntax #'lang-name field-pats))))
                        => (lambda (ls)
                             (apply
                               (lambda (field-var ...)
                                 (let ([field-var parsed-field] ...)
                                   (maker who field-var ... msg ...))) ls))))))))

          (partition-syn (ntspec-alts ntspec)
            ([term-alt* terminal-alt?]
             [nonterm-alt* nonterminal-alt?]
             [pair-imp-alt* pair-alt-implicit?]
             [pair-alt* otherwise])
            (partition-syn nonterm-alt*
              ([nonterm-imp-alt* (lambda (alt) (has-implicit-alt?  (nonterminal-alt-ntspec alt)))]
                [nonterm-nonimp-alt* otherwise])
              #`(lambda (s-exp error?)
                  (or #,@(map make-nonterm-clause nonterm-nonimp-alt*)
                      (if (pair? s-exp)
                          (cond
                            #,@(map make-pair-clause pair-alt*)
                            #,@(map make-pair-clause pair-imp-alt*)
                            [else #f])
                          (cond
                            #,@(map make-term-clause term-alt*)
                            [else #f]))
                      #,@(map make-nonterm-clause nonterm-imp-alt*)
                      (and error? (error who
                                    (format "invalid syntax ~s" 
                                      s-exp)))))))))

      (define make-parser
        (lambda (parser-name lang trace?)
          (lambda (r)
            (let ([desc (guard (c [else #f]) (r lang))])
              (unless desc
                (error (if trace? 'trace-define-syntax 'define-syntax)
                  "invalid language identifier" lang))
              (let* ([ntname (language-entry-ntspec desc)]
                     [lang-name (language-record desc)]
                     [ntspecs (language-ntspecs desc)]
                     [tspecs (language-tspecs desc)])
                (with-syntax ([(entry-name parse-name ...)
                                (map ntspec-parse-name ntspecs)]
                              [(entry-proc parse-proc ...)
                                (map (lambda (ntspec)
                                       (make-parse-proc desc tspecs ntspecs ntspec lang-name))
                                  ntspecs)])
                  (with-syntax ([entry-proc-name 
                                  (if ntname
                                      (construct-id lang-name "parse-" ntname)
                                      #'entry-name)]
                                [parser-name parser-name])
                    (with-syntax ([(lam-exp ...) (if trace? #'(trace-lambda parser-name) #'(lambda))]
                                  [def (if trace? #'trace-define #'define)])
                      #'(define-who parser-name
                          (lam-exp ... (s-exp)
                            (def entry-name entry-proc)
                            (def parse-name parse-proc)
                            ...
                            (entry-proc-name s-exp #t)))))))))))
      (syntax-case x (trace)
        [(_ parser-name lang)
         (and (identifier? #'parser-name) (identifier? #'lang))
         (make-parser #'parser-name #'lang #f)]
        [(_ trace parser-name lang)
         (and (identifier? #'parser-name) (identifier? #'lang))
         (make-parser #'parser-name #'lang #t)]))))
