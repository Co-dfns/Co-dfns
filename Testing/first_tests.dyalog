:Namespace first

S←':Namespace' 'Run←{⊃⍵}' ':EndNamespace'

'01'('first' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'02'('first' S 'Run' #.util.GEN∆T1 ⎕THIS) 0
'03'('first' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍳5
'04'('first' S 'Run' #.util.GEN∆T1 ⎕THIS) 2 3 4⍴1+⍳5

:EndNamespace

