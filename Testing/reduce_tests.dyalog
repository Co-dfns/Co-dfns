:Namespace reduce

S←':Namespace' 'Run←{+/⍵}' 'R2←{×/⍵}' 'R3←{{⍺+⍵}/⍵}' ':EndNamespace'

'1'('reduce' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'2'('reduce' S 'Run' #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'3'('reduce' S 'Run' #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'4'('reduce' S 'R2'  #.util.GEN∆T1 ⎕THIS) ⍬⍴3
'5'('reduce' S 'R2'  #.util.GEN∆T1 ⎕THIS) ⍬
'6'('reduce' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'7'('reduce' S 'R3'  #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'8'('reduce' S 'R3'  #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'9'('reduce' S 'R3'  #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9

:EndNamespace

