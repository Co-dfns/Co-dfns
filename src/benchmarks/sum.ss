(library-group
  (include "hpapl.ss")
  (import (hpapl) (chezscheme))
  (initialize-shepherds!)
  (display (time (apl F ← { + / ⍳ ⍵ } ⋄ + / F ¨ ⍳ 50000)))
  (halt-shepherds!)
  (newline)
  (exit 0))
