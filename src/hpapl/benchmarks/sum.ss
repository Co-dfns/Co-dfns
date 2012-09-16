(library-group
  (include "hpapl.ss")
  (import (hpapl) (chezscheme))
  (time (apl F ← { + / ⍳ ⍵ } ⋄ + / F ¨ ⍳ 50000))
  (exit 0))
