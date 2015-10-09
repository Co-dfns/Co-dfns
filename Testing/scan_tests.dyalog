:Namespace scan

S←':Namespace' 'Run←{+\⍵}' 'R2←{×\⍵}' 'R3←{{⍺+⍵}\⍵}' ':EndNamespace'

'1'('scan' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍬⍴1
'2'('scan' S 'Run' #.GEN∆T1 ⎕THIS) #.I 5⍴⍳5
'3'('scan' S 'Run' #.GEN∆T1 ⎕THIS) #.I 3 3⍴⍳9
'4'('scan' S 'R3'  #.GEN∆T1 ⎕THIS) #.I ⍬⍴3
'5'('scan' S 'R2'  #.GEN∆T1 ⎕THIS) #.I ⍬
'6'('scan' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍬
'7'('scan' S 'R3'  #.GEN∆T1 ⎕THIS) #.I ⍬⍴1
'8'('scan' S 'R3'  #.GEN∆T1 ⎕THIS) #.I 5⍴⍳5
'9'('scan' S 'R3'  #.GEN∆T1 ⎕THIS) #.I 3 3⍴⍳9

:EndNamespace

