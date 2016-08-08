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
'10'('reducefirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) ?15⍴2
'11'('reducefirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) ?128⍴2
'12'('reducefirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) ?100⍴2
'13'('reducefirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) ?3 3⍴2
'14'('reducefirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) ?10 10⍴2
'15'('reducefirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) ?32 32⍴2

:EndNamespace

