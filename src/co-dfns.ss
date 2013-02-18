;;; -*- Mode: scheme -*-

;;;; Main Co-Dfns Interface and Top-level Module
;;;; Encapsulates all of the co-dfns code into a compiled object

;;; Copyright (c) 2013 Aaron W. Hsu <arcfide@sacrideo.us>
;;; 
;;; See LICENSING file for more information about the license
;;; associated with this document.

(source-directories (append (source-directories) (list "lib")))

(include "lib/nanopass.ss")

(import (nanopass))

(include "ffi-libs.ss")
(include "llvm-ffi.ss")
(include "generate-llvm.ss")
(include "compile.ss")