(library-group
  (include "hpapl.ss")
  (import (hpapl) (chezscheme))
  (display (time (apl F ← { + / ⍳ ⍵ } ⋄ + / F ¨ ⍳ 50000)))
  (newline)
  (exit 0))
