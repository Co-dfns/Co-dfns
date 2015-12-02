:Namespace match

S←':Namespace' 'Run←{⍺≡⍵}' ':EndNamespace'

'01'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)(⍬)
'02'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(0)(0)
'03'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)(0)
'04'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)(⍳5)
'05'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍳7)(⍳5)
'06'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(0)(⍳5)
'07'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 2⍴0)(2 2⍴0)
'08'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 2 3⍴0)(2 2⍴0)
'09'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 2⍴0)(2 2 3⍴0)
'10'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 2 3⍴0)(2 2 3⍴1)
'11'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(0)(2 2⍴0)
'12'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(,0)(2 2⍴0)
'13'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(,0)(,0)

:EndNamespace

