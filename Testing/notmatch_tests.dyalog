:Namespace notmatch

S←':Namespace' 'Run←{⍺≢⍵}' ':EndNamespace'

'01'('notmatch' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)(⍬)
'02'('notmatch' S 'Run' #.util.GEN∆T2 ⎕THIS)(0)(0)
'03'('notmatch' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)(0)
'04'('notmatch' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)(⍳5)
'05'('notmatch' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍳7)(⍳5)
'06'('notmatch' S 'Run' #.util.GEN∆T2 ⎕THIS)(0)(⍳5)
'07'('notmatch' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 2⍴⍳4)(2 2⍴⍳4)
'08'('notmatch' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 2 3⍴⍳12)(2 2⍴⍳4)
'09'('notmatch' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 2⍴⍳4)(2 2 3⍴⍳12)
'10'('notmatch' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 2 3⍴⍳12)(2 2 3⍴1+⍳12)
'11'('notmatch' S 'Run' #.util.GEN∆T2 ⎕THIS)(0)(2 2⍴⍳4)
'12'('notmatch' S 'Run' #.util.GEN∆T2 ⎕THIS)(,0)(2 2⍴⍳4)
'13'('notmatch' S 'Run' #.util.GEN∆T2 ⎕THIS)(,0)(,0)

:EndNamespace

