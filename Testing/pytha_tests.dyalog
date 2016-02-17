:Namespace pytha

S←':Namespace' 'Run←{((⍺*2)+⍵*2)*÷2}' ':EndNamespace'

'01'('pytha' S 'Run' #.util.GEN∆T2 ⎕THIS)	3	4
'02'('pytha' S 'Run' #.util.GEN∆T2 ⎕THIS)	13	14
'03'('pytha' S 'Run' #.util.GEN∆T2 ⎕THIS)	(3 14)	(4 13)
'04'('pytha' S 'Run' #.util.GEN∆T2 ⎕THIS)	(⍳5)	(⍳5)

:EndNamespace

