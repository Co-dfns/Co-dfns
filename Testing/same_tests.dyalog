:Namespace same

S←':Namespace' 'Run←{⊣⍵}' ':EndNamespace'

'01'('same' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍬
'02'('same' S 'Run' #.GEN∆T1 ⎕THIS) #.I 0
'03'('same' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍳5
'04'('same' S 'Run' #.GEN∆T1 ⎕THIS) #.I 2 3 4⍴⍳5

:EndNamespace

