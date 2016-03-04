:Namespace revfirst

S←':Namespace' 'Run←{⊖⍵}' ':EndNamespace'

'01'('revfirst' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'02'('revfirst' S 'Run' #.util.GEN∆T1 ⎕THIS) 0
'03'('revfirst' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍳5
'04'('revfirst' S 'Run' #.util.GEN∆T1 ⎕THIS) 2 3 4⍴⍳5
'05'('revfirst' S 'Run' #.util.GEN∆T1 ⎕THIS) 2 3 4⍴1 0 0
'06'('revfirst' S 'Run' #.util.GEN∆T1 ⎕THIS) 7⍴0 1

:EndNamespace

