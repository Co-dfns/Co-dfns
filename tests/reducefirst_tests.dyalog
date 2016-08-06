:Namespace reducefirst

S1←':Namespace' 'Run←{+⌿⍵}' ':EndNamespace'
S2←':Namespace' 'Run←{×⌿⍵}' ':EndNamespace'
S3←':Namespace' 'Run←{{⍺+⍵}⌿⍵}' ':EndNamespace'

'01'('reducefirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'02'('reducefirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'03'('reducefirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'04'('reducefirst' S2 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴3
'05'('reducefirst' S2 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'06'('reducefirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'07'('reducefirst' S3 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'08'('reducefirst' S3 'Run' #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'09'('reducefirst' S3 'Run' #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'10'('reducefirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) ?3 3⍴2

:EndNamespace

