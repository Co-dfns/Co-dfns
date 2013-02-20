;;; -*- Mode: scheme -*-

;;;; Co-Dfns parser

;;; Copyright (c) 2013 Aaron W. Hsu <arcfide@sacrideo.us>
;;; 
;;; See LICENSING file for more information about the license
;;; associated with this document.

(define (parse-file ifile)
  (call-with-input-file ifile
    (lambda (iport) (parse-port 'parse-file ifile iport))))

(define (parse-string str)
  (with-input-from-string str
    (lambda () (parse-port 'parse-string str (current-input-port)))))

(define (parse-port name src iport)
  (let ([next-token (make-generator
                      (if (eq? 'parse-file name) src "string")
                      iport)])
    (let ([res (parser (base-generator->results next-token))])
      (unless (parse-result-successful? res)
        (error name "failed to parse" src))
      (parse-result-semantic-value res))))

(define (make-generator fname iport)
  (let ([pos (top-parse-position fname)])
    (lambda ()
      (let ([c (get-char iport)])
        (if (eof-object? c)
            (values pos #f)
            (let ([old-pos pos])
              (set! pos (update-parse-position pos c))
              (values old-pos (cons (char-kind c) c))))))))

(define (char-kind c)
  (cond
    [(char-alphabetic? c) 'alpha]
    [(char-numeric? c)    'numeric]
    [(char-whitespace? c) 'white]
    [(char=? #\∆ c)       'alpha]
    [(char=? #\¯ c)       'neg]
    [(char=? #\← c)       'gets]
    [(dya-prim? c)        'dya-prim]
    [(prim? c)            'prim]
    [(char=? #\( c)       'lparen]
    [(char=? #\) c)       'rparen]
    [(char=? #\{ c)       'lbrace]
    [(char=? #\} c)       'rbrace]
    [(char=? #\[ c)       'lbrack]
    [(char=? #\] c)       'rbrack]
    [else 'other]))

(define (prim? c) #f)
(define (dya-prim? c) #f)

(define parser
  (packrat-parser
    (begin Module)
    (Module
      [(glob <- Global) `(Module _ ,glob)])
    (Global
      [(var <- Variable 'gets fun <- Function) `(Function ,var ,fun)])
    (Function
      [('lbrace val <- Value 'rbrace) `(Block _ (Return ,val))])
    (Value
      [(val <- Variable) `(Variable ,val)]
      [(val <- Integers) `(Integers ,@val)])
    (Variable
      [(val <- Characters) (string->symbol (list->string val))])
    (Integers
      [(val <- Integer White rest <- Integers) (cons val rest)]
      [(val <- Integer) (list val)])
    (Integer
      [(val <- Digits) (string->number (list->string val))]
      [('neg val <- Digits) (string->number (list->string (cons #\- val)))])
    (Characters
      [(val <- 'alpha rest <- Characters) (cons val rest)]
      [(val <- 'alpha) (list val)])
    (Digits
      [(val <- 'numeric rest <- Digits) (cons val rest)]
      [(val <- 'numeric) (list val)])
    (White
      [('white White) (void)]
      [('white) (void)])))