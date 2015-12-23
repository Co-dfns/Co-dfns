:Namespace drop

S←':Namespace' 'Run←{⍺↓⍵}' 'R2←{(1⌷⍺)↓⍵}' ':EndNamespace'

'01'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)1	(5 5⍴⍳5)
'02'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)3	(⍳10)
'03'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)(5 7)	(⍳35)

:EndNamespace
