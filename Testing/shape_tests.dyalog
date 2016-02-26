:Namespace shape

S←':Namespace' 'Run←{⍴⍵}' ':EndNamespace'

'1'('shape' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴0
'2'('shape' S 'Run' #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'3'('shape' S 'Run' #.util.GEN∆T1 ⎕THIS) 2 2⍴⍳4
'4'('shape' S 'Run' #.util.GEN∆T1 ⎕THIS) 2 5⍴0 1

:EndNamespace

