#!chezscheme
(library (hpapl)
  (export apl array->boolean / + ⍳ ⍵ ⍺ ⍴ ≡ ← ⋄ ¨ { } : × - ≤ ! ⍬ ∥
    initialize-shepherds! halt-shepherds! shepherd-count)
  (import (chezscheme))

(include "runtime.ss")
(include "compile.ss")
(include "convert.ss")
(include "idioms.ss")
(include "parallel.ss")

)
