:Namespace reducefirst

S←':Namespace' 'Run←{+⌿⍵}' 'R2←{×⌿⍵}' 'R3←{{⍺+⍵}⌿⍵}' ':EndNamespace'

'1'('reducefirst' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'2'('reducefirst' S 'Run' #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'3'('reducefirst' S 'Run' #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'4'('reducefirst' S 'R2'  #.util.GEN∆T1 ⎕THIS) ⍬⍴3
'5'('reducefirst' S 'R2'  #.util.GEN∆T1 ⎕THIS) ⍬
'6'('reducefirst' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'7'('reducefirst' S 'R3'  #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'8'('reducefirst' S 'R3'  #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'9'('reducefirst' S 'R3'  #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9

:EndNamespace

