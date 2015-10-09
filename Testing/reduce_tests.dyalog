:Namespace reduce

S←':Namespace' 'Run←{+/⍵}' 'R2←{×/⍵}' 'R3←{{⍺+⍵}/⍵}' ':EndNamespace'

'1'('reduce' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍬⍴1
'2'('reduce' S 'Run' #.GEN∆T1 ⎕THIS) #.I 5⍴⍳5
'3'('reduce' S 'Run' #.GEN∆T1 ⎕THIS) #.I 3 3⍴⍳9
'4'('reduce' S 'R2'  #.GEN∆T1 ⎕THIS) #.I ⍬⍴3
'5'('reduce' S 'R2'  #.GEN∆T1 ⎕THIS) #.I ⍬
'6'('reduce' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍬
'7'('reduce' S 'R3'  #.GEN∆T1 ⎕THIS) #.I ⍬⍴1
'8'('reduce' S 'R3'  #.GEN∆T1 ⎕THIS) #.I 5⍴⍳5
'9'('reduce' S 'R3'  #.GEN∆T1 ⎕THIS) #.I 3 3⍴⍳9

:EndNamespace

