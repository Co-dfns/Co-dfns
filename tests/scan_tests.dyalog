:Namespace scan

S←':Namespace' 'Run←{+\⍵}' 'R2←{×\⍵}' 'R3←{{⍺+⍵}\⍵}' ':EndNamespace'

'01'('scan' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'02'('scan' S 'Run' #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'03'('scan' S 'Run' #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'04'('scan' S 'R3'  #.util.GEN∆T1 ⎕THIS) ⍬⍴3
'05'('scan' S 'R2'  #.util.GEN∆T1 ⎕THIS) ⍬
'06'('scan' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'07'('scan' S 'R3'  #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'08'('scan' S 'R3'  #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'09'('scan' S 'R3'  #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'10'('scan' S 'Run' #.util.GEN∆T1 ⎕THIS) (2*18)⍴2 0 0 0 0

:EndNamespace

