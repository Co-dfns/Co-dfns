:Namespace tally

S←':Namespace' 'Run←{≢⍵}' ':EndNamespace'

'01'('table' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍬
'02'('table' S 'Run' #.GEN∆T1 ⎕THIS) #.I 0
'03'('table' S 'Run' #.GEN∆T1 ⎕THIS) #.I ,0
'04'('table' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍳5
'05'('table' S 'Run' #.GEN∆T1 ⎕THIS) #.I 2 3 4⍴⍳5

:EndNamespace

