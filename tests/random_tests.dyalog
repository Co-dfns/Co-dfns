:Namespace random

S←':Namespace' 'Run←{?⍺⍴⍵}' ':EndNamespace'

'01'('random' S 'Run' #.util.GEN∆T2 ⎕THIS)	13	4
'02'('random' S 'Run' #.util.GEN∆T2 ⎕THIS)	0	14
'03'('random' S 'Run' #.util.GEN∆T2 ⎕THIS)	19	0
'04'('random' S 'Run' #.util.GEN∆T2 ⎕THIS)	0	0
'05'('random' S 'Run' #.util.GEN∆T2 ⎕THIS)	12345	67890

:EndNamespace