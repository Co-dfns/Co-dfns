:Namespace first

S←':Namespace' 'Run←{⊃⍵}' ':EndNamespace'

'01'('first' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍬
'02'('first' S 'Run' #.GEN∆T1 ⎕THIS) #.I 0
'03'('first' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍳5
'04'('first' S 'Run' #.GEN∆T1 ⎕THIS) #.I 2 3 4⍴1+⍳5

:EndNamespace

