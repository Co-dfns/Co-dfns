:Namespace scan

S←':Namespace' 'Run←{+\⍵}' 'R2←{×\⍵}' 'R3←{{⍺+⍵}\⍵}' ':EndNamespace'

'1'('scan' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'2'('scan' S 'Run' #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'3'('scan' S 'Run' #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'4'('scan' S 'R3'  #.util.GEN∆T1 ⎕THIS) ⍬⍴3
'5'('scan' S 'R2'  #.util.GEN∆T1 ⎕THIS) ⍬
'6'('scan' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'7'('scan' S 'R3'  #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'8'('scan' S 'R3'  #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'9'('scan' S 'R3'  #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9

:EndNamespace

