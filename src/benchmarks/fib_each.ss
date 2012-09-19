(library-group
  (include "hpapl.ss")
  (import (hpapl) (chezscheme))
  (shepherd-count 8)
  (initialize-shepherds!)
  (display 
    (time 
      (apl
        fib ← { ⍵ ≤ 1 : 1 ⋄ (fib ⍵ - 1) + fib ⍵ - 2 } ⋄
        pfib ← fib ∥ ⋄ 
        pfib ¨ 8 ⍴ 35)))
  (newline)
  (halt-shepherds!)
  (exit 0))
