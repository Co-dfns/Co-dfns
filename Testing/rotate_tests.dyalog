:Namespace rotate

S←':Namespace' 'Run←{⍺⌽⍵}' ':EndNamespace'

'01'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	⍬
'02'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	0
'03'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	(⍳5)
'04'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	(2 3 4⍴⍳5)
'05'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	(17⍴0 1 1 0 0 1 1 1 1 0 0)
'06'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	(0 1 1 0 0 1 1)
'07'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	(2 3 4⍴0 1 1 0 0 1 1 1 1 0 0)
'08'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS)	1	(0 1 1 0 0 1 1)
'09'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS)	7	(17⍴0 1 1 0 0 1 1 1 1 0 0)
'10'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS)	7	(17⍴⍳17)


:EndNamespace

