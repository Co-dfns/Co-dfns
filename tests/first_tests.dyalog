:Namespace first

S←':Namespace' 'Run←{⊃⍵}' ':EndNamespace'

'01'('first' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'02'('first' S 'Run' #.util.GEN∆T1 ⎕THIS) 0
'03'('first' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍳5
'04'('first' S 'Run' #.util.GEN∆T1 ⎕THIS) 2 3 4⍴1+⍳5
'05'('first' S 'Run' #.util.GEN∆T1 ⎕THIS) 0 1 1 1 0
'06'('first' S 'Run' #.util.GEN∆T1 ⎕THIS) 1 0 1 1 0

:EndNamespace

