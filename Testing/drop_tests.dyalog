:Namespace drop

S←':Namespace' 'Run←{⍺↓⍵}' ':EndNamespace'

'01'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)1	(5 5⍴⍳5)
'02'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)3	(⍳10)

:EndNamespace
