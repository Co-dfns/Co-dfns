:Namespace notmatch

S←':Namespace' 'Run←{⍺≢⍵}' ':EndNamespace'

'01'('notmatch' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ⍬)(#.I ⍬)
'02'('notmatch' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 0)(#.I 0)
'03'('notmatch' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ⍬)(#.I 0)
'04'('notmatch' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ⍬)(#.I ⍳5)
'05'('notmatch' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ⍳7)(#.I ⍳5)
'06'('notmatch' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 0)(#.I ⍳5)
'07'('notmatch' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2 2⍴0)(#.I 2 2⍴0)
'08'('notmatch' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2 2 3⍴0)(#.I 2 2⍴0)
'09'('notmatch' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2 2⍴0)(#.I 2 2 3⍴0)
'10'('notmatch' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2 2 3⍴0)(#.I 2 2 3⍴1)
'11'('notmatch' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 0)(#.I 2 2⍴0)
'12'('notmatch' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ,0)(#.I 2 2⍴0)
'13'('notmatch' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ,0)(#.I ,0)

:EndNamespace

