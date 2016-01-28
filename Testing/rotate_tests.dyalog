:Namespace rotate

S←':Namespace' 'Run←{⍺⌽⍵}' ':EndNamespace'

'01'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	⍬
'02'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	0
'03'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	(⍳5)
'04'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	(2 3 4⍴⍳5)

:EndNamespace

