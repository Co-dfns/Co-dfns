;;; -*- Mode: scheme -*-

;;;; Main Co-Dfns Interface and Top-level Module
;;;; Encapsulates all of the co-dfns code into a compiled object

;;; Copyright (c) 2013 Aaron W. Hsu <arcfide@sacrideo.us>
;;; 
;;; See LICENSING file for more information about the license
;;; associated with this document.

(source-directories (list "." "lib" "lib/srfi"))

(include "lib/nanopass.ss")

(include "lib/srfi/srfi-1.sls")
(include "lib/srfi/srfi-6.sls")
(include "lib/srfi/srfi-9.sls")
(include "lib/packrat.ss")

(import (nanopass))
(import (packrat))

(include "parser.ss")
(include "ffi-libs.ss")
(include "llvm-ffi.ss")
(include "generate-llvm.ss")
(include "compile.ss")