;;; -*- Mode: scheme -*-

;;;; Packrat Library
;;;; Encapsulates the portable packrate code

;;; Copyright (c) 2013 Aaron W. Hsu <arcfide@sacrideo.us>
;;; 
;;; See LICENSING file for more information about the license
;;; associated with this document.

(library (packrat)
  (export
    parse-result?
    parse-result-successful?
    parse-result-semantic-value
    parse-result-next
    parse-result-error

    parse-results?
    parse-results-position
    parse-results-base
    parse-results-next

    parse-error?
    parse-error-position
    parse-error-expected
    parse-error-messages
    parse-error->list

    make-parse-position
    parse-position?
    parse-position-file
    parse-position-line
    parse-position-column

    top-parse-position
    update-parse-position
    parse-position->string

    ;;empty-results
    ;;make-results

    make-error-expected
    make-error-message
    make-result
    parse-error->parse-result
    make-expected-result
    make-message-result

    prepend-base
    prepend-semantic-value

    base-generator->results
    results->result

    parse-position>?
    parse-error-empty?
    merge-parse-errors
    merge-result-errors

    parse-results-token-kind
    parse-results-token-value

    packrat-check-base
    packrat-check
    packrat-or
    packrat-unless

    packrat-parser
    packrat-lambda
    packrat-lambda*
    packrat-parse
    try-packrat-parse-pattern

    packrat-port-results
    packrat-string-results
    packrat-list-results

    <- @ ! / quote)
  (import (except (chezscheme) define-record-type open-input-string)
    (only (srfi srfi-1) lset-union append-map fold)
    (srfi srfi-9) (srfi srfi-6))

  (define-syntax (<- x)
    (syntax-violation #f "misplaced aux keyword" x))

  (define-syntax (@ x)
    (syntax-violation #f "misplaced aux keyword" x))

  (define-syntax (! x)
    (syntax-violation #f "misplaced aux keyword" x))
  
  (include "packrat/portable-packrat.scm"))


