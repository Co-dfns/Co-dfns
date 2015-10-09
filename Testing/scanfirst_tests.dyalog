:Namespace scanfirst

S←':Namespace' 'Run←{+⍀⍵}' 'R2←{×⍀⍵}' 'R3←{{⍺+⍵}⍀⍵}' ':EndNamespace'

'1'('scanfirst' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍬⍴1
'2'('scanfirst' S 'Run' #.GEN∆T1 ⎕THIS) #.I 5⍴⍳5
'3'('scanfirst' S 'Run' #.GEN∆T1 ⎕THIS) #.I 3 3⍴⍳9
'4'('scanfirst' S 'R3'  #.GEN∆T1 ⎕THIS) #.I ⍬⍴3
'5'('scanfirst' S 'R2'  #.GEN∆T1 ⎕THIS) #.I ⍬
'6'('scanfirst' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍬
'7'('scanfirst' S 'R3'  #.GEN∆T1 ⎕THIS) #.I ⍬⍴1
'8'('scanfirst' S 'R3'  #.GEN∆T1 ⎕THIS) #.I 5⍴⍳5
'9'('scanfirst' S 'R3'  #.GEN∆T1 ⎕THIS) #.I 3 3⍴⍳9

:EndNamespace
