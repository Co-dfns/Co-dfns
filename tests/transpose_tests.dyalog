:Namespace transpose

S←':Namespace' 'Run←{⍉⍵}' ':EndNamespace'

'01'('transpose' S 'Run' #.util.GEN∆T1 ⎕THIS) 5 5⍴⍳25
'02'('transpose' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'03'('transpose' S 'Run' #.util.GEN∆T1 ⎕THIS) 5
'04'('transpose' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍳5
'05'('transpose' S 'Run' #.util.GEN∆T1 ⎕THIS) 2 3 4 1⍴⍳24
'06'('transpose' S 'Run' #.util.GEN∆T1 ⎕THIS) ÷5 5⍴1+⍳25
'07'('transpose' S 'Run' #.util.GEN∆T1 ⎕THIS) ÷2 3 4 1⍴1+⍳24
'08'('transpose' S 'Run' #.util.GEN∆T1 ⎕THIS) 5 5⍴0 1 1
'09'('transpose' S 'Run' #.util.GEN∆T1 ⎕THIS) 2 3 4 1⍴0 1 1

:EndNamespace
