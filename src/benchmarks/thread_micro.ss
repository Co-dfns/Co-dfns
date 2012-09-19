(library-group
  (include "hpapl.ss")
  (import (hpapl) (chezscheme))
  (shepherd-count 8)
  (initialize-shepherds!)
  (display 
    (time 
      (apl
        branch ← { ⍵ ≡ 0 : 1 ⋄ F ← branch ∥ ⋄ X ← F ¨ 8 ⍴ ⍵ - 1 ⋄ 1} ⋄
        branch 7)))
  (newline)
  (let ([grabbed (get-grabbed)])
    (display (length grabbed)) (newline)
    (display (is-unique? grabbed)) (newline))
  (exit 0))
