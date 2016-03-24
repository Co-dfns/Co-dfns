:Namespace reverse

S←':Namespace' 'Run←{⌽⍵}' ':EndNamespace'
S2←':Namespace' 'Run←{⌽⌽⌽⍵}' ':EndNamespace'

'01'('reverse' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'02'('reverse' S 'Run' #.util.GEN∆T1 ⎕THIS) 0
'03'('reverse' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍳5
'04'('reverse' S 'Run' #.util.GEN∆T1 ⎕THIS) 2 3 4⍴⍳5
'05'('reverse' S 'Run' #.util.GEN∆T1 ⎕THIS) (0 1 1 0 0 1 1 1 1 0 0)
'06'('reverse' S 'Run' #.util.GEN∆T1 ⎕THIS) (0 1 1 0 0 1 1)
'07'('reverse' S 'Run' #.util.GEN∆T1 ⎕THIS) (2 3 4⍴0 1 1 0 0 1 1 1 1 0 0)
'08'('reverse' S2 'Run' #.util.GEN∆T1 ⎕THIS) (2 3 4⍴0 1 1 0 0 1 1 1 1 0 0)
'09'('reverse' S2 'Run' #.util.GEN∆T1 ⎕THIS) 2 3 4⍴⍳5

:EndNamespace

