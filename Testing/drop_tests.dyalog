:Namespace drop

S←':Namespace' 'Run←{⍺↓⍵}' 'R2←{(1⌷⍺)↓⍵}' ':EndNamespace'

⍝[c]'01'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	1	(5 5⍴⍳5)
⍝[c]'02'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	3	(⍳10)
⍝[c]'03'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(5 7)	(⍳35)
'04'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	1	(0 1 0 1 0 0 1 1 1 1 0 0 0)

:EndNamespace
