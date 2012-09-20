(library-group
  (include "hpapl.ss")
  (import (hpapl) (chezscheme))
  (shepherd-count 4)
  (initialize-shepherds!)
  (display 
    (time 
      (apl
        branch ← { ⍵ ≡ 0 : 1 ⋄ F ← branch ∥ ⋄ X ← F ¨ 8 ⍴ ⍵ - 1 ⋄ 1} ⋄
        branch 7)))
  (newline)
  (exit 0))
