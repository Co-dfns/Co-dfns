;;; Copyright (c) 2000-2013 Andrew W. Keep
;;; See the accompanying file Copyright for detatils

(library (nanopass language-node-counter)
  (export define-language-node-counter)
  (import (rnrs) (nanopass records) (only (chezscheme) trace-define-syntax))

  (define-syntax define-language-node-counter
    (lambda (x)
      (define build-counter-proc
        (lambda (proc-name l)
          (lambda (ntspec)
            (let loop ([alt* (ntspec-alts ntspec)] [term* '()] [nonterm* '()] [pair* '()])
              (if (null? alt*)
                  #`(lambda (x)
                      (cond
                        #,@term*
                        #,@pair*
                        #,@nonterm*
                        [else (error '#,proc-name "unrecognized term" x)]))
                  (let ([alt (car alt*)] [alt* (cdr alt*)])
                    (cond
                      [(terminal-alt? alt)
                       (loop alt*
                         (cons #`[(#,(tspec-pred (terminal-alt-tspec alt)) x) 1] term*)
                         nonterm* pair*)]
                      [(nonterminal-alt? alt)
                       (let ([ntspec (nonterminal-alt-ntspec alt)])
                         (loop alt* term* 
                           (cons #`[(#,(ntspec-all-pred ntspec) x)
                                    (#,(ntspec-unparse-name ntspec) x)]
                             nonterm*)
                           pair*))]
                      [(pair-alt? alt)
                       (let inner-loop ([fld* (pair-alt-field-names alt)]
                                        [lvl* (pair-alt-field-levels alt)]
                                        [maybe?* (pair-alt-field-maybes alt)]
                                        [acc* (pair-alt-accessors alt)]
                                        [rec* '()])
                         (if (null? fld*)
                             (loop alt* term* nonterm*
                               (cons #`[(#,(pair-alt-pred alt) x) (+ 1 #,@rec*)] pair*))
                             (inner-loop (cdr fld*) (cdr lvl*) (cdr maybe?*) (cdr acc*)
                               (cons 
                                 (let ([fld (car fld*)] [maybe? (car maybe?*)] [acc (car acc*)])
                                   (let ([spec (find-spec fld l)])
                                     (if (ntspec? spec)
                                         #`(let ([x (#,acc x)])
                                             #,(let loop ([lvl (car lvl*)] [outer-most? #t])
                                                 (if (fx=? lvl 0)
                                                     (if maybe?
                                                         (if outer-most?
                                                             #`(if x (#,(ntspec-unparse-name spec) x) 0)
                                                             #`(+ a (if x (#,(ntspec-unparse-name spec) x) 0)))
                                                         (if outer-most?
                                                             #`(#,(ntspec-unparse-name spec) x)
                                                             #`(+ a (#,(ntspec-unparse-name spec) x))))
                                                     (if outer-most?
                                                         #`(fold-left
                                                             (lambda (a x) #,(loop (- lvl 1) #f))
                                                             0 x)
                                                         #`(fold-left
                                                             (lambda (a x) #,(loop (- lvl 1) #f))
                                                             a x)))))
                                         0)))
                                 rec*))))]
                      [else (syntax-violation 'define-language-node-counter
                              "unrecognized alt ~s" alt)])))))))
      (syntax-case x ()
        [(_ name lang)
         (and (identifier? #'name) (identifier? #'lang))
         (lambda (r)
           (let ([l (r #'lang)])
             (unless l (syntax-violation 'define-language-node-counter "Unknown language" x #'lang))
             (let ([ntspecs (language-ntspecs l)] [tspecs (language-tspecs l)])
               (with-syntax ([(ntspec? ...) (map ntspec-pred ntspecs)]
                             [(proc-name ...) (map ntspec-unparse-name ntspecs)] ; reuse these names internally
                             [(tspec? ...) (map tspec-pred tspecs)]
                             [(proc ...) (map (build-counter-proc #'name l) ntspecs)])
                 #'(define name
                     (lambda (x)
                       (define proc-name proc) ...
                       (cond
                         [(ntspec? x) (proc-name x)] ...
                         [(tspec? x) 1] ...
                         [else (error 'name "unrecognized language record" x)])))))))]))))
