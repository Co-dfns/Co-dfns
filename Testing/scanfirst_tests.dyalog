:Namespace scanfirst

S←':Namespace' 'Run←{+⍀⍵}' 'R2←{×⍀⍵}' 'R3←{{⍺+⍵}⍀⍵}' ':EndNamespace'

'1'('scanfirst' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'2'('scanfirst' S 'Run' #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'3'('scanfirst' S 'Run' #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'4'('scanfirst' S 'R3'  #.util.GEN∆T1 ⎕THIS) ⍬⍴3
'5'('scanfirst' S 'R2'  #.util.GEN∆T1 ⎕THIS) ⍬
'6'('scanfirst' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'7'('scanfirst' S 'R3'  #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'8'('scanfirst' S 'R3'  #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'9'('scanfirst' S 'R3'  #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9

:EndNamespace
