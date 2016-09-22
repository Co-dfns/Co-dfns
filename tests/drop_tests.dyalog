:Namespace drop

S←':Namespace' 'Run←{⍺↓⍵}' 'R2←{(1⌷⍺)↓⍵}' ':EndNamespace'

'01'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	1	(5 5⍴⍳5)
'02'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	3	(⍳10)
'03'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(5 7)	(⍳35)
'04'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	1	(0 1 0 1 0 0 1 1 1 1 0 0 0)
'05'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	1	(0 1 0 1 0 0)
'06'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	1	⍬
'07'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	1	(3 10⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
'08'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	5	(5 5⍴⍳5)
'09'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	6	(5 5⍴⍳5)
'10'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	(5 5⍴⍳5)
'11'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯5	(5 5⍴⍳5)
'12'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯20	(5 5⍴⍳5)
'13'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯20	(⍳10)
'14'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯3	(⍳10)
'15'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	⍬



:EndNamespace
