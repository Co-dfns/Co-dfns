#!chezscheme
(library (hpapl)
  (export apl array->boolean / + ⍳ ⍵ ⍺ ⍴ ≡ ← ⋄ ¨ { } : × - ≤ ! ⍬)
  (import (chezscheme))

(include "runtime.ss")
(include "compile.ss")
(include "convert.ss")
(include "idioms.ss")

)
