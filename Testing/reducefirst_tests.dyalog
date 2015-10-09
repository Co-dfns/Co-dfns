:Namespace reducefirst

S←':Namespace' 'Run←{+⌿⍵}' 'R2←{×⌿⍵}' 'R3←{{⍺+⍵}⌿⍵}' ':EndNamespace'

'1'('reducefirst' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍬⍴1
'2'('reducefirst' S 'Run' #.GEN∆T1 ⎕THIS) #.I 5⍴⍳5
'3'('reducefirst' S 'Run' #.GEN∆T1 ⎕THIS) #.I 3 3⍴⍳9
'4'('reducefirst' S 'R2'  #.GEN∆T1 ⎕THIS) #.I ⍬⍴3
'5'('reducefirst' S 'R2'  #.GEN∆T1 ⎕THIS) #.I ⍬
'6'('reducefirst' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍬
'7'('reducefirst' S 'R3'  #.GEN∆T1 ⎕THIS) #.I ⍬⍴1
'8'('reducefirst' S 'R3'  #.GEN∆T1 ⎕THIS) #.I 5⍴⍳5
'9'('reducefirst' S 'R3'  #.GEN∆T1 ⎕THIS) #.I 3 3⍴⍳9

:EndNamespace

