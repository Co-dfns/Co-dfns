:Namespace take

S1←':Namespace' 'Run←{⍺↑⍵}'  ':EndNamespace'
S2←':Namespace' 'Run←{(1⌷⍺)↑⍵}' ':EndNamespace'

'01'('take' S1 'Run' #.util.GEN∆T2 ⎕THIS)5	(⍳35)
'02'('take' S2 'Run' #.util.GEN∆T2 ⎕THIS)(7 5)	(⍳12)
'03'('take' S1 'Run' #.util.GEN∆T2 ⎕THIS)(¯5)	(⍳12)
'04'('take' S1 'Run' #.util.GEN∆T2 ⎕THIS)(0)	(⍳12)
'05'('take' S1 'Run' #.util.GEN∆T2 ⎕THIS)(1)	(12)
'06'('take' S1 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)	(12)
'07'('take' S1 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)	(⍳12)
'08'('take' S1 'Run' #.util.GEN∆T2 ⎕THIS)(2)	(5 5⍴⍳25)
'09'('take' S1 'Run' #.util.GEN∆T2 ⎕THIS)(2 2)	(5 5⍴⍳25)
'10'('take' S1 'Run' #.util.GEN∆T2 ⎕THIS)(¯2 2)	(5 5⍴⍳25)
'11'('take' S1 'Run' #.util.GEN∆T2 ⎕THIS)(¯2 ¯3)	(5 5⍴⍳25)
'12'('take' S1 'Run' #.util.GEN∆T2 ⎕THIS)(¯2)	(5 5⍴⍳25)
'13'('take' S1 'Run' #.util.GEN∆T2 ⎕THIS)(¯2 2)	(5 5 3⍴⍳75)
'14'('take' S1 'Run' #.util.GEN∆T2 ⎕THIS)(25)	(⍳12)

:EndNamespace
