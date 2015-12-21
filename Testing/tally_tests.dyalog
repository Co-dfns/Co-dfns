:Namespace tally

S←':Namespace' 'Run←{≢⍵}' ':EndNamespace'

'01'('tally' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'02'('tally' S 'Run' #.util.GEN∆T1 ⎕THIS) 0
'03'('tally' S 'Run' #.util.GEN∆T1 ⎕THIS) ,0
'04'('tally' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍳5
'05'('tally' S 'Run' #.util.GEN∆T1 ⎕THIS) 2 3 4⍴⍳5

:EndNamespace

