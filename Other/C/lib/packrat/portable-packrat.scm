;; Packrat Parser Library
;;
;; Copyright (c) 2004, 2005 Tony Garnock-Jones <tonyg@kcbbs.gen.nz>
;; Copyright (c) 2005 LShift Ltd. <query@lshift.net>
;; 
;; Permission is hereby granted, free of charge, to any person
;; obtaining a copy of this software and associated documentation
;; files (the "Software"), to deal in the Software without
;; restriction, including without limitation the rights to use, copy,
;; modify, merge, publish, distribute, sublicense, and/or sell copies
;; of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:
;; 
;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.
;; 
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
;; BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
;; ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
;; CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

;; Requires: SRFI-1, SRFI-9, SRFI-6. See the documentation for more
;; details.

(define-record-type parse-result
  (make-parse-result successful? semantic-value next error)
  parse-result?
  (successful? parse-result-successful?)
  (semantic-value parse-result-semantic-value)
  (next parse-result-next) ;; #f, if eof or error; otherwise a parse-results
  (error parse-result-error)
  ;; ^^ #f if none, but usually a parse-error structure
  )

(define-record-type parse-results
  (make-parse-results position base next map)
  parse-results?
  (position parse-results-position) ;; a parse-position or #f if unknown
  (base parse-results-base) ;; a value, #f indicating 'none' or 'eof'
  (next parse-results-next* set-parse-results-next!)
  ;; ^^ a parse-results, or a nullary function delivering same, or #f for nothing next (eof)
  (map parse-results-map set-parse-results-map!)
  ;; ^^ an alist mapping a nonterminal to a parse-result
  )

(define-record-type parse-error
  (make-parse-error position expected messages)
  parse-error?
  (position parse-error-position) ;; a parse-position or #f if unknown
  (expected parse-error-expected) ;; set of things (lset)
  (messages parse-error-messages) ;; list of strings
  )

(define-record-type parse-position
  (make-parse-position file line column)
  parse-position?
  (file parse-position-file)
  (line parse-position-line)
  (column parse-position-column))

(define (top-parse-position filename)
  (make-parse-position filename 1 0))

(define (update-parse-position pos ch)
  (if (not pos)
      #f
      (let ((file (parse-position-file pos))
	    (line (parse-position-line pos))
	    (column (parse-position-column pos)))
	(case ch
	 ((#\return) (make-parse-position file line 0))
	 ((#\newline) (make-parse-position file (+ line 1) 0))
	 ((#\tab) (make-parse-position file line (* (quotient (+ column 8) 8) 8)))
	 (else (make-parse-position file line (+ column 1)))))))

(define (parse-position->string pos)
  (if (not pos)
      "<??>"
      (string-append (parse-position-file pos) ":"
		     (number->string (parse-position-line pos)) ":"
		     (number->string (parse-position-column pos)))))

(define (empty-results pos)
  (make-parse-results pos #f #f '()))

(define (make-results pos base next-generator)
  (make-parse-results pos base next-generator '()))

(define (make-error-expected pos str)
  (make-parse-error pos (list str) '()))

(define (make-error-message pos msg)
  (make-parse-error pos '() (list msg)))

(define (make-result semantic-value next)
  (make-parse-result #t semantic-value next #f))

(define (parse-error->parse-result err)
  (make-parse-result #f #f #f err))

(define (make-expected-result pos str)
  (parse-error->parse-result (make-error-expected pos str)))

(define (make-message-result pos msg)
  (parse-error->parse-result (make-error-message pos msg)))

(define (prepend-base pos base next)
  (make-parse-results pos base next '()))

(define (prepend-semantic-value pos key result next)
  (make-parse-results pos #f #f
		      (list (cons key (make-result result next)))))

(define (base-generator->results generator)
  ;; Note: applies first next-generator, to get first result
  (define (results-generator)
    (let-values (((pos base) (generator)))
      (if (not base)
	  (empty-results pos)
	  (make-results pos base results-generator))))
  (results-generator))

(define (parse-results-next results)
  (let ((next (parse-results-next* results)))
    (if (procedure? next)
	(let ((next-value (next)))
	  (set-parse-results-next! results next-value)
	  next-value)
	next)))

(define (results->result results key fn)
  (let ((results-map (parse-results-map results)))
    (cond
     ((assv key results-map) =>
      (lambda (entry)
	;;(write `(cache-hit ,key ,(parse-position->string (parse-results-position results))))(newline)
	(if (not (cdr entry))
	    (error "Recursive parse rule" key)
	    (cdr entry))))
     (else (let ((cell (cons key #f)))
	     ;;(write `(cache-miss ,key ,(parse-position->string (parse-results-position results))))(newline)
	     (set-parse-results-map! results (cons cell results-map))
	     (let ((result (fn)))
	       (set-cdr! cell result)
	       result))))))

(define (parse-position>? a b)
  (cond
   ((not a) #f)
   ((not b) #t)
   (else (let ((la (parse-position-line a)) (lb (parse-position-line b)))
	   (or (> la lb)
	       (and (= la lb)
		    (> (parse-position-column a) (parse-position-column b))))))))

(define (parse-error-empty? e)
  (and (null? (parse-error-expected e))
       (null? (parse-error-messages e))))

(define (merge-parse-errors e1 e2)
  (cond
   ((not e1) e2)
   ((not e2) e1)
   (else
    (let ((p1 (parse-error-position e1))
	  (p2 (parse-error-position e2)))
      (cond
       ((or (parse-position>? p1 p2) (parse-error-empty? e2)) e1)
       ((or (parse-position>? p2 p1) (parse-error-empty? e1)) e2)
       (else (make-parse-error p1
			       (lset-union equal?
					   (parse-error-expected e1)
					   (parse-error-expected e2))
			       (lset-union equal?
					   (parse-error-messages e1)
					   (parse-error-messages e2)))))))))

(define (parse-error->list e)
  (and e (list (parse-position->string (parse-error-position e))
	       (parse-error-expected e)
	       (parse-error-messages e))))

(define (merge-result-errors result errs)
  (make-parse-result (parse-result-successful? result)
		     (parse-result-semantic-value result)
		     (parse-result-next result)
		     (merge-parse-errors (parse-result-error result) errs)))

;---------------------------------------------------------------------------

(define (parse-results-token-kind results)
  (let ((base (parse-results-base results)))
    (and base (car base))))

(define (parse-results-token-value results)
  (let ((base (parse-results-base results)))
    (and base (cdr base))))

(define (packrat-check-base token-kind k)
  (lambda (results)
    (let ((base (parse-results-base results)))
      (if (eqv? (and base (car base)) token-kind)
	  ((k (and base (cdr base))) (parse-results-next results))
	  (make-expected-result (parse-results-position results)
				(if (not token-kind)
				    "end-of-file"
				    token-kind))))))

(define (packrat-check parser k)
  (lambda (results)
    (let ((result (parser results)))
      (if (parse-result-successful? result)
	  (merge-result-errors ((k (parse-result-semantic-value result))
				(parse-result-next result))
			       (parse-result-error result))
	  result))))

(define (packrat-or p1 p2)
  (lambda (results)
    (let ((result (p1 results)))
      (if (parse-result-successful? result)
	  result
	  (merge-result-errors (p2 results)
			       (parse-result-error result))))))

(define (packrat-unless explanation p1 p2)
  (lambda (results)
    (let ((result (p1 results)))
      (if (parse-result-successful? result)
	  (make-message-result (parse-results-position results)
			       explanation)
	  (p2 results)))))

;---------------------------------------------------------------------------

(define (object->external-representation o)
  (let ((s (open-output-string)))
    (write o s)
    (get-output-string s)))

(define-syntax packrat-parser
  (syntax-rules (<- quote ! @ /)
    ((_ start (nonterminal (alternative body0 body ...) ...) ...)
     (let ()
       (define nonterminal
	 (lambda (results)
	   (results->result results 'nonterminal
			    (lambda ()
			      ((packrat-parser #f "alts" nonterminal
					       ((begin body0 body ...) alternative) ...)
			       results)))))
       ...
       start))

    ((_ #f "alts" nt (body alternative))
     (packrat-parser #f "alt" nt body alternative))

    ((_ #f "alts" nt (body alternative) rest0 rest ...)
     (packrat-or (packrat-parser #f "alt" nt body alternative)
		 (packrat-parser #f "alts" nt rest0 rest ...)))

    ((_ #f "alt" nt body ())
     (lambda (results) (make-result body results)))

    ((_ #f "alt" nt body ((! fails ...) rest ...))
     (packrat-unless (string-append "Nonterminal " (symbol->string 'nt)
				    " expected to fail "
				    (object->external-representation '(fails ...)))
		     (packrat-parser #f "alt" nt #t (fails ...))
		     (packrat-parser #f "alt" nt body (rest ...))))

    ((_ #f "alt" nt body ((/ alternative ...) rest ...))
     (packrat-check (packrat-parser #f "alts" nt (#t alternative) ...)
		    (lambda (result) (packrat-parser #f "alt" nt body (rest ...)))))

    ((_ #f "alt" nt body (var <- 'val rest ...))
     (packrat-check-base 'val
			 (lambda (var)
			   (packrat-parser #f "alt" nt body (rest ...)))))

    ((_ #f "alt" nt body (var <- @ rest ...))
     (lambda (results)
       (let ((var (parse-results-position results)))
	 ((packrat-parser #f "alt" nt body (rest ...)) results))))

    ((_ #f "alt" nt body (var <- val rest ...))
     (packrat-check val
		    (lambda (var)
		      (packrat-parser #f "alt" nt body (rest ...)))))

    ((_ #f "alt" nt body ('val rest ...))
     (packrat-check-base 'val
			 (lambda (dummy)
			   (packrat-parser #f "alt" nt body (rest ...)))))

    ((_ #f "alt" nt body (val rest ...))
     (packrat-check val
		    (lambda (dummy)
		      (packrat-parser #f "alt" nt body (rest ...)))))))

(define-record-type packrat-parse-pattern
  (make-packrat-parse-pattern binding-names parser-proc)
  packrat-parse-pattern?
  (binding-names packrat-parse-pattern-binding-names)
  (parser-proc packrat-parse-pattern-parser-proc))

(define (try-packrat-parse-pattern pat bindings results ks kf)
  ((packrat-parse-pattern-parser-proc pat) bindings results ks kf))

(define-syntax packrat-lambda
  (syntax-rules ()
    ((_ (binding ...) body ...)
     (packrat-lambda* succeed fail (binding ...)
		      (let ((value (begin body ...)))
			(succeed value))))))

(define-syntax packrat-lambda*
  (syntax-rules ()
    ((_ succeed fail (binding ...) body ...)
     (make-packrat-parse-pattern
      '()
      (lambda (bindings results ks kf)
	(let ((succeed (lambda (value)
			 (ks bindings (make-result value results))))
	      (fail (lambda (error-maker . args)
		      (kf (apply error-maker (parse-results-position results) args))))
	      (binding (cond ((assq 'binding bindings) => cdr)
			     (else (error "Missing binding" 'binding))))
	      ...)
	  body ...))))))

(define (packrat-parse table)
  (define (make-nsv-result results)
    (make-result 'no-semantic-value results))

  (define (merge-success-with-errors err ks)
    (lambda (bindings result)
      (ks bindings (merge-result-errors result err))))

  (define (merge-failure-with-errors err kf)
    (lambda (err1)
      (kf (merge-parse-errors err1 err))))

  (define (all-binding-names parse-patterns)
    (append-map packrat-parse-pattern-binding-names parse-patterns))

  (define (parse-alternatives alts0)
    (cond
     ((null? alts0) (make-packrat-parse-pattern
		     '()
		     (lambda (bindings results ks kf) (kf #f))))
     ((null? (cdr alts0)) (parse-simple (car alts0)))
     (else
      (let ((alts (map parse-simple alts0)))
	(make-packrat-parse-pattern
	 (all-binding-names alts) ;; should be a union rather than a product, technically
	 (lambda (bindings results ks kf)
	   (let try ((err #f)
		     (alts alts))
	     (if (null? alts)
		 (kf err)
		 (try-packrat-parse-pattern
		  (car alts) bindings results
		  (merge-success-with-errors err ks)
		  (lambda (err1) (try (merge-parse-errors err1 err)
				      (cdr alts))))))))))))

  (define (extract-sequence seq)
    (cond
     ((null? seq) '())
     ((null? (cdr seq)) (cons (parse-simple (car seq)) '()))
     ((eq? (cadr seq) '+) (cons (parse-repetition (car seq) 1 #f) (extract-sequence (cddr seq))))
     ((eq? (cadr seq) '*) (cons (parse-repetition (car seq) 0 #f) (extract-sequence (cddr seq))))
     ((eq? (cadr seq) '?) (cons (parse-repetition (car seq) 0 1) (extract-sequence (cddr seq))))
     ((eq? (cadr seq) '<-) (if (null? (cddr seq))
			       (error "Bad binding form" seq)
			       (cons (parse-binding (car seq)
						    (parse-simple (caddr seq)))
				     (extract-sequence (cdddr seq)))))
     (else (cons (parse-simple (car seq)) (extract-sequence (cdr seq))))))

  (define (parse-sequence seq)
    (let ((parsers (extract-sequence seq)))
      (make-packrat-parse-pattern
       (all-binding-names parsers)
       (lambda (bindings results ks kf)
	 (let continue ((bindings bindings)
			(results results)
			(err #f)
			(parsers parsers))
	   (cond
	    ((null? parsers) (ks bindings (merge-result-errors (make-nsv-result results) err)))
	    ((null? (cdr parsers))
	     (try-packrat-parse-pattern
	      (car parsers) bindings results
	      (merge-success-with-errors err ks)
	      (merge-failure-with-errors err kf)))
	    (else
	     (try-packrat-parse-pattern
	      (car parsers) bindings results
	      (lambda (new-bindings result)
		(continue new-bindings
			  (parse-result-next result)
			  (merge-parse-errors err (parse-result-error result))
			  (cdr parsers)))
	      (merge-failure-with-errors err kf)))))))))

  (define (parse-literal-string str)
    (let ((len (string-length str)))
      (make-packrat-parse-pattern
       '()
       (lambda (bindings starting-results ks kf)
	 (let loop ((pos 0)
		    (results starting-results))
	   (if (= pos len)
	       (ks bindings (make-result str results))
	       (let ((v (parse-results-token-value results)))
		 (if (and (char? v)
			  (char=? v (string-ref str pos)))
		     (loop (+ pos 1) (parse-results-next results))
		     (kf (make-error-expected (parse-results-position starting-results)
					      str))))))))))

  (define (parse-char-set* predicate expected)
    (make-packrat-parse-pattern
     '()
     (lambda (bindings results ks kf)
       (let ((v (parse-results-token-value results)))
	 (if (and (char? v) (predicate v))
	     (ks bindings (make-result v (parse-results-next results)))
	     (kf (make-error-expected (parse-results-position results) expected)))))))

  (define (parse-char-set set-spec optional-arg)
    (cond
     ((string? set-spec)
      (let ((chars (string->list set-spec)))
	(parse-char-set* (lambda (ch) (memv ch chars)) (or optional-arg `(one-of ,set-spec)))))
     ((procedure? set-spec)
      (parse-char-set* set-spec (or optional-arg `(char-predicate ,set-spec))))
     (else (error "Bad char set specification" set-spec))))

  (define (parse-simple simple)
    (cond
     ((string? simple) (parse-literal-string simple))
     ((eq? simple '@) (make-packrat-parse-pattern
		       '()
		       (lambda (bindings results ks kf)
			 (ks bindings (make-result (parse-results-position results) results)))))
     ((symbol? simple) (parse-goal simple))
     ((packrat-parse-pattern? simple) simple) ;; extension point
     ((pair? simple) (case (car simple)
		       ((/) (parse-alternatives (cdr simple)))
		       ((&) (parse-follow (cdr simple)))
		       ((!) (parse-no-follow (cdr simple)))
		       ((quote) (parse-base-token (cadr simple)))
		       ((/:) (parse-char-set (cadr simple) (and (pair? (cddr simple))
								(caddr simple))))
		       (else (parse-sequence simple))))
     ((or (char? simple)
	  (not simple))
      (parse-base-token simple))
     ((null? simple)
      (parse-sequence simple))
     (else (error "Bad syntax pattern" simple))))

  (define (parse-follow seq)
    (let ((parser (parse-sequence seq)))
      (make-packrat-parse-pattern
       (packrat-parse-pattern-binding-names parser)
       (lambda (bindings results ks kf)
	 (try-packrat-parse-pattern
	  parser bindings results
	  (lambda (bindings result)
	    (ks bindings
		(merge-result-errors (make-result (parse-result-semantic-value result)
						  results)
				     (parse-result-error result))))
	  kf)))))

  (define (explain-no-follow results seq)
    (make-error-message (parse-results-position results)
			(string-append "Failed no-follow rule: "
				       (object->external-representation seq))))

  (define (parse-no-follow seq)
    (let ((parser (parse-sequence seq)))
      (make-packrat-parse-pattern
       '()
       (lambda (bindings results ks kf)
	 (try-packrat-parse-pattern
	  parser bindings results
	  (lambda (bindings result) (kf (explain-no-follow results seq)))
	  (lambda (err) (ks bindings (make-nsv-result results))))))))

  (define (parse-base-token token)
    (make-packrat-parse-pattern
     '()
     (lambda (bindings results ks kf)
       (let ((base (parse-results-base results)))
	 (if (eqv? (and base (car base)) token)
	     (ks bindings (make-result (and base (cdr base)) (parse-results-next results)))
	     (kf (make-error-expected (parse-results-position results)
				      (if (not token) "end-of-file" token))))))))

  (define (rotate-bindings binding-names child-bindings)
    (let ((seed (fold (lambda (bindings seed)
			(map (lambda (name val)
			       (cond
				((assq name bindings) =>
				 (lambda (entry)
				   (cons (cdr entry) val)))
				(else val)))
			     binding-names
			     seed))
		      (map (lambda (name) '()) binding-names)
		      child-bindings)))
      (map cons binding-names seed)))

  (define (explain-too-many results counter maxrep simple)
    (lambda (bindings result)
      (make-message-result (parse-results-position results)
			   (string-append "Expected maximum "
					  (number->string maxrep)
					  " repetition(s) of rule "
					  (object->external-representation simple)
					  ", but saw at least "
					  (number->string counter)))))

  (define (prepare-bindings binding-names nested-bindings results err0)
    (lambda (err)
      (merge-result-errors (make-result (rotate-bindings binding-names nested-bindings) results)
			   (merge-parse-errors err err0))))

  (define (parse-repetition simple minrep maxrep)
    (let* ((parser (parse-simple simple))
	   (repeated-names (packrat-parse-pattern-binding-names parser))
	   (repetition-id (gensym)))

      (define (repeat counter err0 nested-bindings results)
	(define (consume-one failure-k)
	  (try-packrat-parse-pattern
	   parser '() results
	   (lambda (bindings result)
	     (repeat (+ counter 1)
		     (merge-parse-errors (parse-result-error result) err0)
		     (cons bindings nested-bindings)
		     (parse-result-next result)))
	   failure-k))
	;;(begin (write `(repeat ,simple ,counter ,nested-bindings))(newline))
	(cond
	 ((< counter minrep)
	  (consume-one (lambda (err1) (parse-error->parse-result (merge-parse-errors err1 err0)))))
	 ((or (not maxrep) (< counter maxrep))
	  (consume-one (prepare-bindings repeated-names nested-bindings results err0)))
	 (else
	  (try-packrat-parse-pattern
	   parser '() results
	   (explain-too-many results counter maxrep simple)
	   (prepare-bindings repeated-names nested-bindings results err0)))))

      (make-packrat-parse-pattern
       repeated-names
       (lambda (bindings results ks kf)
	 (results->result/k bindings results repetition-id
			    (lambda ()
			      (repeat 0 #f '() results))
			    (lambda (bindings result)
			      (let ((rotated-nested-bindings (parse-result-semantic-value result)))
				(ks (append rotated-nested-bindings bindings)
				    result)))
			    kf)))))

  (define (parse-binding name parser)
    (make-packrat-parse-pattern
     (list name)
     (lambda (bindings results ks kf)
       (try-packrat-parse-pattern
	parser bindings results
	(lambda (bindings result)
	  (ks (cons (cons name (parse-result-semantic-value result)) bindings)
	      result))
	kf))))

  (define (results->result/k bindings results goal filler ks kf)
;     (begin (write `(goal ,goal ,(parse-position->string (parse-results-position results))))(newline))
    (let ((result (results->result results goal filler)))
;       (begin (write `(goal ,goal ,(parse-position->string (parse-results-position results))
; 			   =>
; 			   ,(parse-result-successful? result)
; 			   ,(parse-result-semantic-value result)
; 			   ,(parse-error->list (parse-result-error result))))
; 	     (newline))
      (if (parse-result-successful? result)
	  (ks bindings result)
	  (kf (parse-result-error result)))))

  (define parse-goal
    (let ((compiled-table (delay (map (lambda (entry)
					(if (not (= (length entry) 2))
					    (error "Ill-formed rule entry" entry))
					(cons (car entry) (parse-simple (cadr entry))))
				      table))))
      (lambda (goal)
	(if (not (assq goal table))
	    (error "Unknown rule name" goal))
	(make-packrat-parse-pattern
	 '()
	 (lambda (bindings results ks kf)
	   (let ((rule (cond
			((assq goal (force compiled-table)) => cdr)
			(else (error "Unknown rule name" goal)))))
	     (results->result/k bindings results goal
				(lambda ()
				  (try-packrat-parse-pattern
				   rule '() results
				   (lambda (bindings1 result) result)
				   parse-error->parse-result))
				ks kf)))))))

  parse-goal)

(define (packrat-port-results filename p)
  (base-generator->results
   (let ((ateof #f)
         (pos (top-parse-position filename)))
     (lambda ()
       (if ateof
           (values pos #f)
           (let ((x (read-char p)))
             (if (eof-object? x)
                 (begin
                   (set! ateof #t)
                   (values pos #f))
                 (let ((old-pos pos))
                   (set! pos (update-parse-position pos x))
                   (values old-pos (cons x x))))))))))

(define (packrat-string-results filename s)
  (base-generator->results
   (let ((idx 0)
         (len (string-length s))
         (pos (top-parse-position filename)))
     (lambda ()
       (if (= idx len)
           (values pos #f)
           (let ((x (string-ref s idx))
                 (old-pos pos))
             (set! pos (update-parse-position pos x))
             (set! idx (+ idx 1))
             (values old-pos (cons x x))))))))

(define (packrat-list-results tokens)
  (base-generator->results
   (let ((stream tokens))
     (lambda ()
       (if (null? stream)
	   (values #f #f)
	   (let ((base-token (car stream)))
	     (set! stream (cdr stream))
	     (values #f base-token)))))))

'(define (x)
  (sc-expand
   '(packrat-parser expr
		    (expr ((a <- mulexp '+ b <- mulexp)
			   (+ a b))
			  ((a <- mulexp) a))
		    (mulexp ((a <- simple '* b <- simple)
			     (* a b))
			    ((a <- simple) a))
		    (simple ((a <- 'num) a)
			    (('oparen a <- expr 'cparen) a)))))

'(let ((p ((packrat-parse `((expr (/ (a <- mulexp '+ b <- mulexp ,(packrat-lambda (a b) (+ a b)))
				     mulexp))
			    (mulexp (/ (a <- simple '* b <- simple ,(packrat-lambda (a b) (* a b)))
				       simple))
			    (simple (/ 'num
				       ('oparen a <- expr 'cparen ,(packrat-lambda (a) a))))))
	   'expr)))
   (try-packrat-parse-pattern
    p '()
    (packrat-list-results '((oparen) (num . 1) (+) (num . 2) (cparen) (*) (num . 3)))
    (lambda (bindings result) (values bindings (parse-result-semantic-value result)))
    (lambda (err)
      (list 'parse-error
	    (parse-position->string (parse-error-position err))
	    (parse-error-expected err)
	    (parse-error-messages err)))))

'(define expr-parse
   (let ((p ((packrat-parse `((toplevel (e <- expr #f ,(packrat-lambda (e) e)))
			      (expr (/ (a <- mulexp "+"ws b <- expr
					  ,(packrat-lambda (a b) (+ a b)))
				       mulexp))
			      (mulexp (/ (a <- simple "*"ws b <- mulexp
					    ,(packrat-lambda (a b) (* a b)))
					 simple))
			      (simple (/ num
					 ("("ws a <- expr ")"ws
					  ,(packrat-lambda (a) a))))
			      (num ((d <- digit)+ ws
				    ,(packrat-lambda (d) (string->number (list->string d)))))
			      (ws (#\space *))
			      (digit (/: "0123456789"))))
	     'toplevel)))
     (lambda (str)
       (try-packrat-parse-pattern
	p '()
	(packrat-string-results "<str>" str)
	(lambda (bindings result) (values bindings (parse-result-semantic-value result)))
	(lambda (err)
	  (list 'parse-error
		(parse-position->string (parse-error-position err))
		(parse-error-expected err)
		(parse-error-messages err)))))))
