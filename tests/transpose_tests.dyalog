:Namespace transpose

S1←':Namespace' 'Run←{⍉⍵}' ':EndNamespace'
S2←':Namespace' 'Run←{⍺⍉⍵}' ':EndNamespace'

'01'('transpose' S1 'Run' #.util.GEN∆T1 ⎕THIS) 5 5⍴⍳25
'02'('transpose' S1 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'03'('transpose' S1 'Run' #.util.GEN∆T1 ⎕THIS) 5
'04'('transpose' S1 'Run' #.util.GEN∆T1 ⎕THIS) ⍳5
'05'('transpose' S1 'Run' #.util.GEN∆T1 ⎕THIS) 2 3 4 1⍴⍳24
'06'('transpose' S1 'Run' #.util.GEN∆T1 ⎕THIS) ÷5 5⍴1+⍳25
'07'('transpose' S1 'Run' #.util.GEN∆T1 ⎕THIS) ÷2 3 4 1⍴1+⍳24
'08'('transpose' S1 'Run' #.util.GEN∆T1 ⎕THIS) 5 5⍴0 1 1
'09'('transpose' S1 'Run' #.util.GEN∆T1 ⎕THIS) 2 3 4 1⍴0 1 1
'10'('transpose' S2 'Run' #.util.GEN∆T2 ⎕THIS) (1 0)(5 5⍴⍳25)
'11'('transpose' S2 'Run' #.util.GEN∆T2 ⎕THIS) (0)(⍬)
'12'('transpose' S2 'Run' #.util.GEN∆T2 ⎕THIS) (⍬)(5)
'13'('transpose' S2 'Run' #.util.GEN∆T2 ⎕THIS) (0)(⍳5)
'14'('transpose' S2 'Run' #.util.GEN∆T2 ⎕THIS) (3 2 0 1)(2 3 4 1⍴⍳24)
'15'('transpose' S2 'Run' #.util.GEN∆T2 ⎕THIS) (0 1)(÷5 7⍴1+⍳25)
'16'('transpose' S2 'Run' #.util.GEN∆T2 ⎕THIS) (2 3 1 0)(÷2 3 4 1⍴1+⍳24)
'17'('transpose' S2 'Run' #.util.GEN∆T2 ⎕THIS) (1 0)(7 5⍴0 1 1)
'18'('transpose' S2 'Run' #.util.GEN∆T2 ⎕THIS) (0 1 2 3)(2 3 4 1⍴0 1 1)

:EndNamespace
