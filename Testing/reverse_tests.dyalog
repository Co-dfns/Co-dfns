:Namespace reverse

S←':Namespace' 'Run←{⌽⍵}' ':EndNamespace'

'01'('reverse' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍬
'02'('reverse' S 'Run' #.GEN∆T1 ⎕THIS) #.I 0
'03'('reverse' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍳5
'04'('reverse' S 'Run' #.GEN∆T1 ⎕THIS) #.I 2 3 4⍴⍳5

:EndNamespace

