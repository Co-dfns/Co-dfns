:Namespace rotfirst

S←':Namespace' 'Run←{⍺⊖⍵}' ':EndNamespace'

'01'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	⍬
'02'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	0
'03'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	(⍳5)
'04'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	(2 3 4⍴⍳5)
'05'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	(17⍴0 1 1 0 0 1 1 1 1 0 0)
'06'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	(0 1 1 0 0 1 1)
'07'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	(2 3 4⍴0 1 1 0 0 1 1 1 1 0 0)
'08'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	1	(0 1 1 0 0 1 1)
'09'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	7	(17⍴0 1 1 0 0 1 1 1 1 0 0)
'10'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	7	(17⍴⍳17)


:EndNamespace

