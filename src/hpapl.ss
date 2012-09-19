#!chezscheme
(library (hpapl)
  (export apl array->boolean / + ⍳ ⍵ ⍺ ⍴ ≡ ← ⋄ ¨ { } : × - ≤ ! ⍬ ∥
    initialize-shepherds! #;halt-shepherds! 
    shepherd-count get-grabbed is-unique?)
  (import (chezscheme))

(include "runtime.ss")
(include "compile.ss")
(include "convert.ss")
(include "idioms.ss")
(include "parallel.ss")
(include "circular-vectors.ss")
(include "work-stealing-queues.ss")
;(include "lock-queues.ss")

)
