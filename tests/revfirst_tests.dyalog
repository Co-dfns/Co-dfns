:Namespace revfirst

S←':Namespace' 'Run←{⊖⍵}' ':EndNamespace'
S2←':Namespace' 'Run←{⊖⊖⊖⍵}' ':EndNamespace'

'01'('revfirst' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'02'('revfirst' S 'Run' #.util.GEN∆T1 ⎕THIS) 0
'03'('revfirst' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍳5
'04'('revfirst' S 'Run' #.util.GEN∆T1 ⎕THIS) 2 3 4⍴⍳5
'05'('revfirst' S 'Run' #.util.GEN∆T1 ⎕THIS) 2 3 4⍴1 0 0
'06'('revfirst' S 'Run' #.util.GEN∆T1 ⎕THIS) 40⍴0 1
'07'('revfirst' S 'Run' #.util.GEN∆T1 ⎕THIS) (0 1 1 0 0 1 1 1 1 0 0)
'08'('revfirst' S 'Run' #.util.GEN∆T1 ⎕THIS) (0 1 1 0 0 1 1)
'09'('revfirst' S2 'Run' #.util.GEN∆T1 ⎕THIS) (2 3 4⍴0 1 1 0 0 1 1 1 1 0 0)
'10'('revfirst' S2 'Run' #.util.GEN∆T1 ⎕THIS) 2 3 4⍴⍳5
'11'('revfirst' S 'Run' #.util.GEN∆T1 ⎕THIS) 13⍴0 1
'12'('revfirst' S 'Run' #.util.GEN∆T1 ⎕THIS) 7⍴0 1
'13'('revfirst' S 'Run' #.util.GEN∆T1 ⎕THIS) 2 3 5⍴1 0 0

:EndNamespace

