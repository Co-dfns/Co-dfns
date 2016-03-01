:Namespace indexgen

S←':Namespace' 'Run←{⍳⍵}' ':EndNamespace'

(⍕¨⍳5)('indexgen' S 'Run' #.util.GEN∆T1 ⎕THIS)¨⍳5

:EndNamespace

