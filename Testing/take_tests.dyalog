:Namespace take

S1←':Namespace' 'Run←{⍺↑⍵}'  ':EndNamespace'
S2←':Namespace' 'Run←{(1⌷⍺)↑⍵}' ':EndNamespace'

'01'('take' S1 'Run' #.util.GEN∆T2 ⎕THIS)5	(⍳35)
'02'('take' S2 'Run' #.util.GEN∆T2 ⎕THIS)(7 5)	(⍳12)

:EndNamespace
