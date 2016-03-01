:Namespace same

S←':Namespace' 'Run←{⊣⍵}' ':EndNamespace'

'01'('same' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'02'('same' S 'Run' #.util.GEN∆T1 ⎕THIS) 0
'03'('same' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍳5
'04'('same' S 'Run' #.util.GEN∆T1 ⎕THIS) 2 3 4⍴⍳5

:EndNamespace

