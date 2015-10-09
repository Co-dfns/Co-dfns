:Namespace identity

S←':Namespace' 'Run←{⊢⍵}' ':EndNamespace'

'01'('identity' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍬
'02'('identity' S 'Run' #.GEN∆T1 ⎕THIS) #.I 0
'03'('identity' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍳5
'04'('identity' S 'Run' #.GEN∆T1 ⎕THIS) #.I 2 3 4⍴⍳5

:EndNamespace

