:Namespace identity

S←':Namespace' 'Run←{⊢⍵}' ':EndNamespace'

'01'('identity' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'02'('identity' S 'Run' #.util.GEN∆T1 ⎕THIS) 0
'03'('identity' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍳5
'04'('identity' S 'Run' #.util.GEN∆T1 ⎕THIS) 2 3 4⍴⍳5

:EndNamespace

