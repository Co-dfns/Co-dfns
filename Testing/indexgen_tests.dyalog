:Namespace indexgen

S←':Namespace' 'Run←{⍳⍵}' ':EndNamespace'

(⍕¨⍳5)('indexgen' S 'Run' #.GEN∆T1 ⎕THIS)∘#.I¨⍳5

:EndNamespace

