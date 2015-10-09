:Namespace revfirst

S←':Namespace' 'Run←{⌽⍵}' ':EndNamespace'

'01'('revfirst' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍬
'02'('revfirst' S 'Run' #.GEN∆T1 ⎕THIS) #.I 0
'03'('revfirst' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍳5
'04'('revfirst' S 'Run' #.GEN∆T1 ⎕THIS) #.I 2 3 4⍴⍳5

:EndNamespace

