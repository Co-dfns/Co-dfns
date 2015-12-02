:Namespace reverse

S←':Namespace' 'Run←{⌽⍵}' ':EndNamespace'

'01'('reverse' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'02'('reverse' S 'Run' #.util.GEN∆T1 ⎕THIS) 0
'03'('reverse' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍳5
'04'('reverse' S 'Run' #.util.GEN∆T1 ⎕THIS) 2 3 4⍴⍳5

:EndNamespace

