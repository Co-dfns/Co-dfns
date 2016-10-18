:Namespace scan

S1←':Namespace' 'Run←{+\⍵}' ':EndNamespace'
S2←':Namespace' 'Run←{×\⍵}' ':EndNamespace'
S3←':Namespace' 'Run←{{⍺+⍵}\⍵}' ':EndNamespace'

'01'('scan' S1 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'02'('scan' S1 'Run' #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'03'('scan' S1 'Run' #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'04'('scan' S3 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴3
'05'('scan' S2 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'06'('scan' S1 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'07'('scan' S3 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'08'('scan' S3 'Run' #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'09'('scan' S3 'Run' #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'10'('scan' S1 'Run' #.util.GEN∆T1 ⎕THIS) (2*18)⍴2 0 0 0 0

:EndNamespace

