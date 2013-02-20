;;; -*- Mode: scheme -*-

;;;; Languages of the compiler
;;;; All of the intermediate representations in the compiler

;;; Copyright (c) 2013 Aaron W. Hsu <arcfide@sacrideo.us>
;;; 
;;; See LICENSING file for more information about the license
;;; associated with this document.

(define variable? symbol?)

(define-language lang/lift-constants
  (terminals
    (variable (var))
    (integer (int)))
  (Module (mod)
    (Module var global* ...))
  (Global (global)
    (Constant var int* ...)
    (Function var bb))
  (Basic-block (bb)
    (Block var stmt))
  (Statement (stmt)
    (Return int* ...)
    (Return var)))

(define-language lang/generate-llvm
  (extends lang/lift-constants)
  (entry Module)
  (Statement (stmt)
    (- (Return int* ...))))
