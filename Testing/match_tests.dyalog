:Namespace match

S←':Namespace' 'Run←{⍺≡⍵}' ':EndNamespace'

'01'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)(⍬)
'02'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(0)(0)
'03'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)(0)
'04'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)(⍳5)
'05'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍳7)(⍳5)
'06'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(0)(⍳5)
'07'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 2⍴⍳4)(2 2⍴⍳4)
'08'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 2 3⍴⍳12)(2 2⍴⍳4)
'09'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 2⍴⍳4)(2 2 3⍴⍳12)
'10'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 2 3⍴⍳12)(2 2 3⍴1+⍳12)
'11'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(0)(2 2⍴⍳4)
'12'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(,0)(2 2⍴⍳4)
'13'('match' S 'Run' #.util.GEN∆T2 ⎕THIS)(,0)(,0)

:EndNamespace

