:Namespace table

S←':Namespace' 'Run←{⍪⍵}' ':EndNamespace'

'01'('table' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'02'('table' S 'Run' #.util.GEN∆T1 ⎕THIS) 0
'03'('table' S 'Run' #.util.GEN∆T1 ⎕THIS) ,0
'04'('table' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍳5
'05'('table' S 'Run' #.util.GEN∆T1 ⎕THIS) 2 2 2⍴⍳5
'06'('table' S 'Run' #.util.GEN∆T1 ⎕THIS) 3 7⍴0 1
'07'('table' S 'Run' #.util.GEN∆T1 ⎕THIS) 21⍴1 0

:EndNamespace
