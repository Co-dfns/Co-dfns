:Namespace rotfirst

S←':Namespace' 'Run←{⍺⊖⍵}' ':EndNamespace'
R←':Namespace' 'Run←{7⊖⍵}' ':EndNamespace'
T←':Namespace' 'Run←{¯1⊖⍵}' ':EndNamespace'

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
'11'('rotfirst' R 'Run' #.util.GEN∆T1 ⎕THIS)		(17⍴⍳17)
'12'('rotfirst' T 'Run' #.util.GEN∆T1 ⎕THIS)		(2 3 4⍴⍳5)
'13'('rotfirst' T 'Run' #.util.GEN∆T1 ⎕THIS)		(⍳5)
'14'('rotfirst' T 'Run' #.util.GEN∆T1 ⎕THIS)		0
'15'('rotfirst' T 'Run' #.util.GEN∆T1 ⎕THIS)		(17⍴0 1 1 0 0 1 1 1 1 0 0)
'16'('rotfirst' T 'Run' #.util.GEN∆T1 ⎕THIS)		(0 1 1 0 0 1 1)
'17'('rotfirst' T 'Run' #.util.GEN∆T1 ⎕THIS)		(2 3 4⍴0 1 1 0 0 1 1 1 1 0 0)
'18'('rotfirst' R 'Run' #.util.GEN∆T1 ⎕THIS)		(17⍴0 1 1 0 0 1 1 1 1 0 0)
'19'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	(32 32⍴0 1 1 0 0 1 1 1 1 0 0)
'20'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	(64 20⍴0 1 1 0 0 1 1 1 1 0 0)
'21'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	(?15 15⍴2)
'22'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	(?80 80⍴2)
'23'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	(?800 800⍴2)
'24'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	(?90 90⍴2)
'25'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	(?8100⍴2)
'26'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	(?8133⍴2)
'27'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	2	(32 32⍴0 1 1 0 0 1 1 1 1 0 0)
'28'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	2	(64 20⍴0 1 1 0 0 1 1 1 1 0 0)
'29'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	2	(?15 15⍴2)
'30'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	2	(?80 80⍴2)
'31'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	2	(?30 30⍴2)
'32'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	2	(?800 800⍴2)
'33'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	2	(?90 90⍴2)
'34'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	2	(?8100⍴2)
'35'('rotfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)	2	(?8133⍴2)


:EndNamespace

