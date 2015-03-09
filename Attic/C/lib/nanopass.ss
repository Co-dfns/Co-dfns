;;; Copyright (c) 2000-2013 Dipanwita Sarkar, Andrew W. Keep, R. Kent Dybvig, Oscar Waddell
;;; See the accompanying file Copyright for detatils

(library-group
  (include "nanopass/implementation-helpers.ss")
  (include "nanopass/helpers.ss")
  (include "nanopass/nano-syntax-dispatch.ss")
  (include "nanopass/syntaxconvert.ss")
  (include "nanopass/records.ss")
  (include "nanopass/unparser.ss")
  (include "nanopass/meta-syntax-dispatch.ss")
  (include "nanopass/meta-parser.ss")
  (include "nanopass/parser.ss")
  (include "nanopass/language.ss")
  (include "nanopass/pass.ss")
  (include "nanopass/language-node-counter.ss")
  (library (nanopass)
    (export define-language define-parser trace-define-parser trace-define-pass
      echo-define-pass define-pass with-output-language nanopass-case
      language->s-expression extends entry terminals nongenerative-id
      define-nanopass-record-types diff-languages define-language-node-counter)
    (import
      (nanopass language)
      (nanopass parser)
      (nanopass language-node-counter)
      (nanopass pass)
      (nanopass helpers)
      (nanopass records))))
