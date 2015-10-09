:Namespace depth

S←':Namespace' 'Run←{≡⍵}' ':EndNamespace'

'01'('depth' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍬
'02'('depth' S 'Run' #.GEN∆T1 ⎕THIS) #.I 0
'03'('depth' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍳5
'04'('depth' S 'Run' #.GEN∆T1 ⎕THIS) #.I 2 3 4⍴⍳5

:EndNamespace

