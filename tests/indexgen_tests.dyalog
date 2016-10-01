:Namespace indexgen

S←':Namespace' 'Run←{⍳⍵}' ':EndNamespace'
F←{⊃((⎕DR ⍵)645)⎕DR ⍵}

(⍕¨⍳5)('indexgen' S 'Run' #.util.GEN∆T1 ⎕THIS)¨⍳5
'5'('indexgen' S 'Run' #.util.GEN∆T1 ⎕THIS)⊃83 11⎕DR 1
'6'('indexgen' S 'Run' #.util.GEN∆T1 ⎕THIS)⊃83 11⎕DR 0
'7'('indexgen' S 'Run' #.util.GEN∆T1 ⎕THIS)F 7

:EndNamespace

