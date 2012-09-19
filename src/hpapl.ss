#!chezscheme
(library (hpapl)
  (export apl array->boolean / + ⍳ ⍵ ⍺ ⍴ ≡ ← ⋄ ¨ { } : × - ≤ ! ⍬ ∥
    initialize-shepherds! shepherd-count)
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
