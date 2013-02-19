;;; -*- Mode: scheme -*-

;;;; Whole Compiler Test Suite
;;;; Test the entire compiler from start to finish on a number of programs

;;; Copyright (c) 2013 Aaron W. Hsu <arcfide@sacrideo.us>
;;; 
;;; See LICENSING file for more information about the license
;;; associated with this document.

(import (srfi srfi-64))

(test-begin "Co-Dfns Compiler Test Suite")

(let* ([prog "F←{5}"]
      [exec (co-dfns-compile-string prog)])
  (test-eqv 5 (co-dfns-apply exec "F")))

(test-end "Co-Dfns Compiler Test Suite")
