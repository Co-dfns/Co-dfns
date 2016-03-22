:Namespace indexgen

S←':Namespace' 'Run←{⍳⍵}' ':EndNamespace'

(⍕¨⍳5)('indexgen' S 'Run' #.util.GEN∆T1 ⎕THIS)¨⍳5
'5'('indexgen' S 'Run' #.util.GEN∆T1 ⎕THIS)⊃83 11⎕DR 1
'6'('indexgen' S 'Run' #.util.GEN∆T1 ⎕THIS)⊃83 11⎕DR 0

:EndNamespace

