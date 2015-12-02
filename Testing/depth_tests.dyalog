:Namespace depth

S←':Namespace' 'Run←{≡⍵}' ':EndNamespace'

'01'('depth' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'02'('depth' S 'Run' #.util.GEN∆T1 ⎕THIS) 0
'03'('depth' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍳5
'04'('depth' S 'Run' #.util.GEN∆T1 ⎕THIS) 2 3 4⍴⍳5

:EndNamespace

