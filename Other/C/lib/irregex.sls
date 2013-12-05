;;; -*- Mode: scheme -*-

;;;; IrRegex Library
;;;; Wrapper around the R6RS version of the IrRegex library

;;; Copyright (c) 2013 Aaron W. Hsu <arcfide@sacrideo.us>
;;; 
;;; See LICENSING file for more information about the license
;;; associated with this document.

(library (irregex)
  (export
    irregex string->irregex sre->irregex
    string->sre maybe-string->sre
    irregex? irregex-match-data?
    irregex-new-matches irregex-reset-matches!
    irregex-search irregex-search/matches irregex-match
    irregex-search/chunked irregex-match/chunked make-irregex-chunker
    irregex-match-substring irregex-match-subchunk
    irregex-match-start-chunk irregex-match-start-index
    irregex-match-end-chunk irregex-match-end-index
    irregex-match-num-submatches irregex-match-names
    irregex-match-valid-index?
    irregex-fold irregex-replace irregex-replace/all
    irregex-dfa irregex-dfa/search ; irregex-dfa/extract
    irregex-nfa irregex-flags irregex-lengths irregex-names
    irregex-num-submatches irregex-extract irregex-split)
  (import
    (rename
      (chezscheme)
      (error r6rs:error)))

  (define (error msg . irritants)
    (apply r6rs:error 'irregex msg irritants))

  (include "irregex/irregex.scm"))