;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Chez Scheme port of SRFI-64
;;; Version: 1.0
;;; 
;;; Copyright (c) 2011 Aaron W. Hsu <arcfide@sacrideo.us>
;;; 
;;; Permission to use, copy, modify, and distribute this software for
;;; any purpose with or without fee is hereby granted, provided that the
;;; above copyright notice and this permission notice appear in all
;;; copies.
;;; 
;;; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
;;; WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
;;; WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
;;; AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
;;; DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA
;;; OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
;;; TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
;;; PERFORMANCE OF THIS SOFTWARE.

;; Copyright (c) 2005, 2006 Per Bothner
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

(library (srfi-64)
  (export test-begin test-group
	  test-end test-assert test-eqv test-eq test-equal
	  test-approximate test-assert test-error test-apply test-with-runner
	  test-match-nth test-match-all test-match-any test-match-name
	  test-skip test-expect-fail test-read-eval-string
	  test-runner-group-path test-group-with-cleanup
	  test-result-ref test-result-set! test-result-clear test-result-remove
	  test-result-kind test-passed?
	  test-log-to-file
	  ; Misc test-runner functions
	  test-runner? test-runner-reset test-runner-null
	  test-runner-simple test-runner-current test-runner-factory test-runner-get
	  test-runner-create test-runner-test-name
	  ;; test-runner field setter and getter functions - see %test-record-define:
	  test-runner-pass-count test-runner-pass-count!
	  test-runner-fail-count test-runner-fail-count!
	  test-runner-xpass-count test-runner-xpass-count!
	  test-runner-xfail-count test-runner-xfail-count!
	  test-runner-skip-count test-runner-skip-count!
	  test-runner-group-stack test-runner-group-stack!
	  test-runner-on-test-begin test-runner-on-test-begin!
	  test-runner-on-test-end test-runner-on-test-end!
	  test-runner-on-group-begin test-runner-on-group-begin!
	  test-runner-on-group-end test-runner-on-group-end!
	  test-runner-on-final test-runner-on-final!
	  test-runner-on-bad-count test-runner-on-bad-count!
	  test-runner-on-bad-end-name test-runner-on-bad-end-name!
	  test-result-alist test-result-alist!
	  test-runner-aux-value test-runner-aux-value!
	  ;; default/simple call-back functions, used in default test-runner,
	  ;; but can be called to construct more complex ones.
	  test-on-group-begin-simple test-on-group-end-simple
	  test-on-bad-count-simple test-on-bad-end-name-simple
	  test-on-final-simple test-on-test-end-simple
	  test-on-final-simple)
  (import (chezscheme))

(define-record-type (<test-runner> %test-runner-alloc test-runner?)
  (protocol
   (lambda (n)
     (lambda ()
       (apply n (make-list 22 #f)))))
  (fields

   ;; Cumulate count of all tests that have passed and were expected to.
   (mutable pass-count      test-runner-pass-count      test-runner-pass-count!)
   (mutable fail-count      test-runner-fail-count      test-runner-fail-count!)
   (mutable xpass-count     test-runner-xpass-count     test-runner-xpass-count!)
   (mutable xfail-count     test-runner-xfail-count     test-runner-xfail-count!)
   (mutable skip-count      test-runner-skip-count      test-runner-skip-count!)
   (mutable skip-list       %test-runner-skip-list      %test-runner-skip-list!)
   (mutable fail-list       %test-runner-fail-list      %test-runner-fail-list!)

   ;; Normally #t, except when in a test-apply.
   (mutable run-list        %test-runner-run-list       %test-runner-run-list!)
   (mutable skip-save       %test-runner-skip-save      %test-runner-skip-save!)
   (mutable fail-save       %test-runner-fail-save      %test-runner-fail-save!)
   (mutable group-stack     test-runner-group-stack     test-runner-group-stack!)
   (mutable on-test-begin   test-runner-on-test-begin   test-runner-on-test-begin!)
   (mutable on-test-end     test-runner-on-test-end     test-runner-on-test-end!)

   ;; Call-back when entering a group. Takes (runner suite-name count).
   (mutable on-group-begin  test-runner-on-group-begin  test-runner-on-group-begin!)

   ;; Call-back when leaving a group.
   (mutable on-group-end    test-runner-on-group-end    test-runner-on-group-end!)

   ;; Call-back when leaving the outermost group.
   (mutable on-final        test-runner-on-final        test-runner-on-final!)

   ;; Call-back when expected number of tests was wrong.
   (mutable on-bad-count    test-runner-on-bad-count    test-runner-on-bad-count!)

   ;; Call-back when name in test=end doesn't match test-begin.
   (mutable on-bad-end-name test-runner-on-bad-end-name test-runner-on-bad-end-name!)

   ;; Cumulate count of all tests that have been done.
   (mutable total-count     %test-runner-total-count    %test-runner-total-count!)

   ;; Stack (list) of (count-at-start . expected-count):
   (mutable count-list      %test-runner-count-list     %test-runner-count-list!)
   (mutable result-alist    test-result-alist           test-result-alist!)

   ;; Field can be used by test-runner for any purpose.
   ;; test-runner-simple uses it for a log file.
   (mutable aux-value       test-runner-aux-value       test-runner-aux-value!)))

(define (test-runner-reset runner)
  (test-runner-pass-count!   runner 0)
  (test-runner-fail-count!   runner 0)
  (test-runner-xpass-count!  runner 0)
  (test-runner-xfail-count!  runner 0)
  (test-runner-skip-count!   runner 0)
  (%test-runner-total-count! runner 0)
  (%test-runner-count-list!  runner '())
  (%test-runner-run-list!    runner #t)
  (%test-runner-skip-list!   runner '())
  (%test-runner-fail-list!   runner '())
  (%test-runner-skip-save!   runner '())
  (%test-runner-fail-save!   runner '())
  (test-runner-group-stack!  runner '()))

(define (test-runner-group-path runner)
  (reverse (test-runner-group-stack runner)))

(define (%test-null-callback runner) #f)

(define (test-runner-null)
  (let ((runner (%test-runner-alloc)))
    (test-runner-reset runner)
    (test-runner-on-group-begin! runner (lambda (runner name count) #f))
    (test-runner-on-group-end! runner %test-null-callback)
    (test-runner-on-final! runner %test-null-callback)
    (test-runner-on-test-begin! runner %test-null-callback)
    (test-runner-on-test-end! runner %test-null-callback)
    (test-runner-on-bad-count! runner (lambda (runner count expected) #f))
    (test-runner-on-bad-end-name! runner (lambda (runner begin end) #f))
    runner))

;; Not part of the specification.  FIXME
;; Controls whether a log file is generated.
(define test-log-to-file 
  (make-parameter #t 
    (lambda (x)
      (unless (boolean? x)
	(error 'test-log-to-file "boolean expected" x))
      x)))

(define (test-runner-simple)
  (let ([runner (%test-runner-alloc)])
    (test-runner-reset            runner)
    (test-runner-on-group-begin!  runner test-on-group-begin-simple)
    (test-runner-on-group-end!    runner test-on-group-end-simple)
    (test-runner-on-final!        runner test-on-final-simple)
    (test-runner-on-test-begin!   runner test-on-test-begin-simple)
    (test-runner-on-test-end!     runner test-on-test-end-simple)
    (test-runner-on-bad-count!    runner test-on-bad-count-simple)
    (test-runner-on-bad-end-name! runner test-on-bad-end-name-simple)
    runner))

(define test-runner-current (make-parameter #f))
(define test-runner-factory (make-parameter test-runner-simple))

;; A safer wrapper to test-runner-current.
(define (test-runner-get)
  (let ([r (test-runner-current)])
    (when (not r)
      (error 'test-runner-get "test-runner not initialized - test-begin missing?"))
    r))

(define (%test-specificier-matches spec runner)
  (spec runner))

(define (test-runner-create)
  ((test-runner-factory)))

(define (%test-any-specifier-matches list runner)
  (let ([result #f])
    (let loop ([l list])
      (cond [(null? l) result]
	    [else
	     (when (%test-specificier-matches (car l) runner)
	       (set! result #t))
	     (loop (cdr l))]))))

;; Returns #f, #t, or 'xfail.
(define (%test-should-execute runner)
  (let ([run (%test-runner-run-list runner)])
    (cond [(or
	    (not (or (eqv? run #t)
		     (%test-any-specifier-matches run runner)))
	    (%test-any-specifier-matches
	     (%test-runner-skip-list runner)
	     runner))
	    (test-result-set! runner 'result-kind 'skip)
	    #f]
	  [(%test-any-specifier-matches
	    (%test-runner-fail-list runner)
	    runner)
	   (test-result-set! runner 'result-kind 'xfail)
	   'xfail]
	  [else #t])))

(define (%test-begin suite-name count)
  (unless (test-runner-current)
    (test-runner-current (test-runner-create)))
  (let ([runner (test-runner-current)])
    ((test-runner-on-group-begin runner) runner suite-name count)
    (%test-runner-skip-save! runner 
			     (cons (%test-runner-skip-list runner)
				   (%test-runner-skip-save runner)))
    (%test-runner-fail-save! runner 
			     (cons (%test-runner-fail-list runner)
				   (%test-runner-fail-save runner)))
    (%test-runner-count-list! runner 
			      (cons (cons (%test-runner-total-count runner)
					  count)
				    (%test-runner-count-list runner)))
    (test-runner-group-stack! runner 
			      (cons suite-name
				    (test-runner-group-stack runner)))))
(define-syntax test-begin
  (syntax-rules ()
    [(test-begin suite-name) (%test-begin suite-name #f)]
    [(test-begin suite-name count) (%test-begin suite-name count)]))

(define (test-on-group-begin-simple runner suite-name count)
  (if (null? (test-runner-group-stack runner))
      (begin
	(printf "%%%% Starting test ~a" suite-name)
	(if (test-log-to-file)
	    (let* ([log-file-name
		    (if (string? test-log-to-file) test-log-to-file
			(string-append suite-name ".log"))]
		   [log-file (open-file-output-port log-file-name 
						    (file-options no-fail) 
						    (buffer-mode block)
						    (native-transcoder))])
	      (display "%%%% Starting test " log-file)
	      (display suite-name log-file)
	      (newline log-file)
	      (test-runner-aux-value! runner log-file)
	      (display "  (Writing full log to \"")
	      (display log-file-name)
	      (display "\")")))
	(newline)))
  (let ((log (test-runner-aux-value runner)))
    (if (output-port? log)
	(begin
	  (display "Group begin: " log)
	  (display suite-name log)
	  (newline log))))
  #f)

(define (test-on-group-end-simple runner)
  (let ((log (test-runner-aux-value runner)))
    (if (output-port? log)
	(begin
	  (display "Group end: " log)
	  (display (car (test-runner-group-stack runner)) log)
	  (newline log))))
  #f)

(define (%test-on-bad-count-write runner count expected-count port)
  (display "*** Total number of tests was " port)
  (display count port)
  (display " but should be " port)
  (display expected-count port)
  (display ". ***" port)
  (newline port)
  (display "*** Discrepancy indicates testsuite error or exceptions. ***" port)
  (newline port))

(define (test-on-bad-count-simple runner count expected-count)
  (%test-on-bad-count-write runner count expected-count (current-output-port))
  (let ((log (test-runner-aux-value runner)))
    (if (output-port? log)
	(%test-on-bad-count-write runner count expected-count log))))

(define (test-on-bad-end-name-simple runner begin-name end-name)
  (let ((msg (string-append (%test-format-line runner) "test-end " begin-name
			    " does not match test-begin " end-name)))
    (error #f msg)))

(define (%test-final-report1 value label port)
  (if (> value 0)
      (begin
	(display label port)
	(display value port)
	(newline port))))

(define (%test-final-report-simple runner port)
  (%test-final-report1 (test-runner-pass-count runner)
		      "# of expected passes      " port)
  (%test-final-report1 (test-runner-xfail-count runner)
		      "# of expected failures    " port)
  (%test-final-report1 (test-runner-xpass-count runner)
		      "# of unexpected successes " port)
  (%test-final-report1 (test-runner-fail-count runner)
		      "# of unexpected failures  " port)
  (%test-final-report1 (test-runner-skip-count runner)
		      "# of skipped tests        " port))

(define (test-on-final-simple runner)
  (%test-final-report-simple runner (current-output-port))
  (let ((log (test-runner-aux-value runner)))
    (if (output-port? log)
	(%test-final-report-simple runner log))))

(define (%test-format-line runner)
   (let* ((line-info (test-result-alist runner))
	  (source-file (assq 'source-file line-info))
	  (source-line (assq 'source-line line-info))
	  (file (if source-file (cdr source-file) "")))
     (if source-line
	 (string-append file ":"
			(number->string (cdr source-line)) ": ")
	 "")))

(define (%test-end suite-name line-info)
  (let* ((r (test-runner-get))
	 (groups (test-runner-group-stack r))
	 (line (%test-format-line r)))
    (test-result-alist! r line-info)
    (when (null? groups)
      (let ((msg (string-append line "test-end not in a group")))
	(error #f msg)))
    (if (and suite-name (not (equal? suite-name (car groups))))
	((test-runner-on-bad-end-name r) r suite-name (car groups)))
    (let* ((count-list (%test-runner-count-list r))
	   (expected-count (cdar count-list))
	   (saved-count (caar count-list))
	   (group-count (- (%test-runner-total-count r) saved-count)))
      (if (and expected-count
	       (not (= expected-count group-count)))
	  ((test-runner-on-bad-count r) r group-count expected-count))
      ((test-runner-on-group-end r) r)
      (test-runner-group-stack! r (cdr (test-runner-group-stack r)))
      (%test-runner-skip-list! r (car (%test-runner-skip-save r)))
      (%test-runner-skip-save! r (cdr (%test-runner-skip-save r)))
      (%test-runner-fail-list! r (car (%test-runner-fail-save r)))
      (%test-runner-fail-save! r (cdr (%test-runner-fail-save r)))
      (%test-runner-count-list! r (cdr count-list))
      (if (null? (test-runner-group-stack r))
	  ((test-runner-on-final r) r)))))

(define-syntax test-group
  (syntax-rules ()
    ((test-group suite-name . body)
     (let ((r (test-runner-current)))
       ;; Ideally should also set line-number, if available.
       (test-result-alist! r (list (cons 'test-name suite-name)))
       (if (%test-should-execute r)
	   (dynamic-wind
	       (lambda () (test-begin suite-name))
	       (lambda () . body)
	       (lambda () (test-end  suite-name))))))))

(define-syntax test-group-with-cleanup
  (syntax-rules ()
    ((test-group-with-cleanup suite-name form cleanup-form)
     (test-group suite-name
		    (dynamic-wind
			(lambda () #f)
			(lambda () form)
			(lambda () cleanup-form))))
    ((test-group-with-cleanup suite-name cleanup-form)
     (test-group-with-cleanup suite-name #f cleanup-form))
    ((test-group-with-cleanup suite-name form1 form2 form3 . rest)
     (test-group-with-cleanup suite-name (begin form1 form2) form3 . rest))))

(define (test-on-test-begin-simple runner)
 (let ((log (test-runner-aux-value runner)))
    (if (output-port? log)
	(let* ((results (test-result-alist runner))
	       (source-file (assq 'source-file results))
	       (source-line (assq 'source-line results))
	       (source-form (assq 'source-form results))
	       (test-name (assq 'test-name results)))
	  (display "Test begin:" log)
	  (newline log)
	  (if test-name (%test-write-result1 test-name log))
	  (if source-file (%test-write-result1 source-file log))
	  (if source-line (%test-write-result1 source-line log))
	  (if source-file (%test-write-result1 source-form log))))))

(define-syntax test-result-ref
  (syntax-rules ()
    ((test-result-ref runner pname)
     (test-result-ref runner pname #f))
    ((test-result-ref runner pname default)
     (let ((p (assq pname (test-result-alist runner))))
       (if p (cdr p) default)))))

(define (test-on-test-end-simple runner)
  (let ((log (test-runner-aux-value runner))
	(kind (test-result-ref runner 'result-kind)))
    (if (memq kind '(fail xpass))
	(let* ((results (test-result-alist runner))
	       (source-file (assq 'source-file results))
	       (source-line (assq 'source-line results))
	       (test-name (assq 'test-name results)))
	  (if (or source-file source-line)
	      (begin
		(if source-file (display (cdr source-file)))
		(display ":")
		(if source-line (display (cdr source-line)))
		(display ": ")))
	  (display (if (eq? kind 'xpass) "XPASS" "FAIL"))
	  (if test-name
	      (begin
		(display " ")
		(display (cdr test-name))))
	  (newline)))
    (if (output-port? log)
	(begin
	  (display "Test end:" log)
	  (newline log)
	  (let loop ((list (test-result-alist runner)))
	    (if (pair? list)
		(let ((pair (car list)))
		  ;; Write out properties not written out by on-test-begin.
		  (if (not (memq (car pair)
				 '(test-name source-file source-line source-form)))
		      (%test-write-result1 pair log))
		  (loop (cdr list)))))))))

(define (%test-write-result1 pair port)
  (display "  " port)
  (display (car pair) port)
  (display ": " port)
  (write (cdr pair) port)
  (newline port))

(define (test-result-set! runner pname value)
  (let* ((alist (test-result-alist runner))
	 (p (assq pname alist)))
    (if p
	(set-cdr! p value)
	(test-result-alist! runner (cons (cons pname value) alist)))))

(define (test-result-clear runner)
  (test-result-alist! runner '()))

(define (test-result-remove runner pname)
  (let* ((alist (test-result-alist runner))
	 (p (assq pname alist)))
    (if p
	(test-result-alist! runner
				   (let loop ((r alist))
				     (if (eq? r p) (cdr r)
					 (cons (car r) (loop (cdr r)))))))))

(define (test-result-kind . rest)
  (let ((runner (if (pair? rest) (car rest) (test-runner-current))))
    (test-result-ref runner 'result-kind)))

(define (test-passed? . rest)
  (let ((runner (if (pair? rest) (car rest) (test-runner-get))))
    (memq (test-result-ref runner 'result-kind) '(pass xpass))))

(define (%test-report-result)
  (let* ((r (test-runner-get))
	 (result-kind (test-result-kind r)))
    (case result-kind
      ((pass)
       (test-runner-pass-count! r (+ 1 (test-runner-pass-count r))))
      ((fail)
       (test-runner-fail-count!	r (+ 1 (test-runner-fail-count r))))
      ((xpass)
       (test-runner-xpass-count! r (+ 1 (test-runner-xpass-count r))))
      ((xfail)
       (test-runner-xfail-count! r (+ 1 (test-runner-xfail-count r))))
      (else
       (test-runner-skip-count! r (+ 1 (test-runner-skip-count r)))))
    (%test-runner-total-count! r (+ 1 (%test-runner-total-count r)))
    ((test-runner-on-test-end r) r)))

(define-syntax %test-evaluate-with-catch
  (syntax-rules ()
    [(_ test-expr)
     (guard 
      (c 
       [else 
	(test-result-set! (test-runner-current) 'actual-error c) 
	#f])
      test-expr)]))

(meta define (%test-source-line2 x)
  (let ([annot (syntax->annotation x)])
    (cons (cons #'source-form x)
	  (if annot
	      (list 
	       (cons #'source-file
		     (source-file-descriptor-path
		      (source-object-sfd
		       (annotation-source annot)))))
	      '()))))

(define (%test-on-test-begin r)
  (%test-should-execute r)
  ((test-runner-on-test-begin r) r)
  (not (eq? 'skip (test-result-ref r 'result-kind))))

(define (%test-on-test-end r result)
    (test-result-set! r 'result-kind
		      (if (eq? (test-result-ref r 'result-kind) 'xfail)
			  (if result 'xpass 'xfail)
			  (if result 'pass 'fail))))

(define (test-runner-test-name runner)
  (test-result-ref runner 'test-name ""))

(define-syntax %test-comp2body
  (syntax-rules ()
		((%test-comp2body r comp expected expr)
		 (let ()
		   (if (%test-on-test-begin r)
		       (let ((exp expected))
			 (test-result-set! r 'expected-value exp)
			 (let ((res (%test-evaluate-with-catch expr)))
			   (test-result-set! r 'actual-value res)
			   (%test-on-test-end r (comp exp res)))))
		   (%test-report-result)))))

(define (%test-approximimate= error)
  (lambda (value expected)
    (and (>= value (- expected error))
         (<= value (+ expected error)))))

(define-syntax %test-comp1body
  (syntax-rules ()
    ((%test-comp1body r expr)
     (let ()
       (if (%test-on-test-begin r)
	   (let ()
	     (let ((res (%test-evaluate-with-catch expr)))
	       (test-result-set! r 'actual-value res)
	       (%test-on-test-end r res))))
       (%test-report-result)))))

(define-syntax (test-end x)
  (let ([line (%test-source-line2 x)])
    (syntax-case x ()
      [(_ suite-name)
       #`(%test-end suite-name '#,line)]
      [(_) 
       #`(%test-end #f '#,line)])))
(define-syntax (test-assert x)
  (let ([line (%test-source-line2 x)])
    (syntax-case x ()
      [(_ tname expr)
       #`(let ([r (test-runner-get)] [name tname])
	   (test-result-alist! r (cons (cons 'test-name tname) '#,line))
	   (%test-comp1body r expr))]
      [(_ expr)
       #`(let ([r (test-runner-get)])
	   (test-result-alist! r '#,line)
	   (%test-comp1body r expr))])))
(meta define (%test-comp2 comp x)
  (let ([line (%test-source-line2 x)])
    (syntax-case x ()
      [(_ tname expected expr)
       #`(let ([r (test-runner-get)] [name tname])
	   (test-result-alist! r (cons (cons 'test-name tname) '#,line))
	   (%test-comp2body r #,comp expected expr))]
      [(_ expected expr)
       #`(let ([r (test-runner-get)])
	   (test-result-alist! r '#,line)
	   (%test-comp2body r #,comp expected expr))])))
(define-syntax (test-eqv x) (%test-comp2 #'eqv? x))
(define-syntax (test-eq x) (%test-comp2 #'eq? x))
(define-syntax (test-equal x) (%test-comp2 #'equal? x))
(define-syntax (test-approximate x)
  (let ([line (%test-source-line2 x)]) 
    (syntax-case x ()
      [(_ tname expected expr error)
       #`(let ([r (test-runner-get)] [name tname])
	   (test-result-alist! r (cons (cons 'test-name tname) '#,line))
	   (%test-comp2body r (%test-approximimate= error) expected expr))]
      [(_ expected expr error)
       #`(let ([r (test-runner-get)])
	   (test-result-alist! r '#,line)
	   (%test-comp2body r (%test-approximimate= error) expected expr))])))

(define-syntax %test-error
  (syntax-rules ()
    [(_ r etype expr)
     (when (%test-on-test-begin r)
       (let ([et etype])
	 (test-result-set! r 'expected-error et)
	 (%test-on-test-end r
	   (guard (c
		    [(and (condition? c) (equal? (record-rtd c) et))
		     (test-result-set! r 'actual-error c)
		     #t]
		    [(equal? c et)
		     (test-result-set! r 'actual-error c)
		     #t]
		    [(eq? #t et)
		     (test-result-set! r 'actual-error c)
		     #t]
		    [else 
		     (test-result-set! r 'actual-error c)
		     #f])
	     (test-result-set! r 'actual-value expr)
	     #f))
	 (%test-report-result)))]))

(define-syntax (test-error x)
  (let ([line (%test-source-line2 x)])
    (syntax-case x ()
      [(_ tname etype expr)
       #`(let ([r (test-runner-get)] [name tname])
	   (test-result-alist! r (cons (cons 'test-name tname) '#,line))
	   (%test-error r etype expr))]
      [(_ etype expr)
       #`(let ([r (test-runner-get)])
	   (test-result-alist! r '#,line)
	   (%test-error r etype expr))]
      [(_ expr)
       #`(let ([r (test-runner-get)])
	   (test-result-alist! r '#,line)
	   (%test-error r #t expr))])))

(define (test-apply first . rest)
  (if (test-runner? first)
      (test-with-runner first (apply test-apply rest))
      (let ((r (test-runner-current)))
	(if r
	    (let ((run-list (%test-runner-run-list r)))
	      (cond ((null? rest)
		     (%test-runner-run-list! r (reverse! run-list))
		     (first)) ;; actually apply procedure thunk
		    (else
		     (%test-runner-run-list!
		      r
		      (if (eq? run-list #t) (list first) (cons first run-list)))
		     (apply test-apply rest)
		     (%test-runner-run-list! r run-list))))
	    (let ((r (test-runner-create)))
	      (test-with-runner r (apply test-apply first rest))
	      ((test-runner-on-final r) r))))))

(define-syntax test-with-runner
  (syntax-rules ()
    ((test-with-runner runner form ...)
     (let ((saved-runner (test-runner-current)))
       (dynamic-wind
           (lambda () (test-runner-current runner))
           (lambda () form ...)
           (lambda () (test-runner-current saved-runner)))))))

;;; Predicates

(define (%test-match-nth n count)
  (let ((i 0))
    (lambda (runner)
      (set! i (+ i 1))
      (and (>= i n) (< i (+ n count))))))

(define-syntax test-match-nth
  (syntax-rules ()
    ((test-match-nth n)
     (test-match-nth n 1))
    ((test-match-nth n count)
     (%test-match-nth n count))))

(define (%test-match-all . pred-list)
  (lambda (runner)
    (let ((result #t))
      (let loop ((l pred-list))
	(if (null? l)
	    result
	    (begin
	      (if (not ((car l) runner))
		  (set! result #f))
	      (loop (cdr l))))))))
  
(define-syntax test-match-all
  (syntax-rules ()
    ((test-match-all pred ...)
     (%test-match-all (%test-as-specifier pred) ...))))

(define (%test-match-any . pred-list)
  (lambda (runner)
    (let ((result #f))
      (let loop ((l pred-list))
	(if (null? l)
	    result
	    (begin
	      (if ((car l) runner)
		  (set! result #t))
	      (loop (cdr l))))))))
  
(define-syntax test-match-any
  (syntax-rules ()
    ((test-match-any pred ...)
     (%test-match-any (%test-as-specifier pred) ...))))

;; Coerce to a predicate function:
(define (%test-as-specifier specifier)
  (cond ((procedure? specifier) specifier)
	((integer? specifier) (test-match-nth 1 specifier))
	((string? specifier) (test-match-name specifier))
	(else
	 (error #f "not a valid test specifier"))))

(define-syntax test-skip
  (syntax-rules ()
    ((test-skip pred ...)
     (let ((runner (test-runner-get)))
       (%test-runner-skip-list! runner
				  (cons (test-match-all (%test-as-specifier pred)  ...)
					(%test-runner-skip-list runner)))))))

(define-syntax test-expect-fail
  (syntax-rules ()
    ((test-expect-fail pred ...)
     (let ((runner (test-runner-get)))
       (%test-runner-fail-list! runner
				  (cons (test-match-all (%test-as-specifier pred)  ...)
					(%test-runner-fail-list runner)))))))

(define (test-match-name name)
  (lambda (runner)
    (equal? name (test-runner-test-name runner))))

(define test-read-eval-string
  (case-lambda
    [(x) (%test-read-eval-string x (interaction-environment))]
    [(x e) (%test-read-eval-string x e)]))
    
(define (%test-read-eval-string string env)
  (let* ([port (open-input-string string)]
	 [form (read port)])
    (if (eof-object? (read-char port))
	(eval form env)
	(error #f "(not at EOF)"))))

)
