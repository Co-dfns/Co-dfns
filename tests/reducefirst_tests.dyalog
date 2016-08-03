:Namespace reducefirst

S←':Namespace' 'Run←{+⌿⍵}' 'R2←{×⌿⍵}' 'R3←{{⍺+⍵}⌿⍵}' ':EndNamespace'

'01'('reducefirst' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'02'('reducefirst' S 'Run' #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'03'('reducefirst' S 'Run' #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'04'('reducefirst' S 'R2'  #.util.GEN∆T1 ⎕THIS) ⍬⍴3
'05'('reducefirst' S 'R2'  #.util.GEN∆T1 ⎕THIS) ⍬
'06'('reducefirst' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'07'('reducefirst' S 'R3'  #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'08'('reducefirst' S 'R3'  #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'09'('reducefirst' S 'R3'  #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'10'('reducefirst' S 'Run' #.util.GEN∆T1 ⎕THIS) ?3 3⍴2

:EndNamespace

