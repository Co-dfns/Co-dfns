:Namespace match

S←':Namespace' 'Run←{⍺≡⍵}' ':EndNamespace'

'01'('match' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ⍬)(#.I ⍬)
'02'('match' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 0)(#.I 0)
'03'('match' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ⍬)(#.I 0)
'04'('match' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ⍬)(#.I ⍳5)
'05'('match' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ⍳7)(#.I ⍳5)
'06'('match' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 0)(#.I ⍳5)
'07'('match' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2 2⍴0)(#.I 2 2⍴0)
'08'('match' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2 2 3⍴0)(#.I 2 2⍴0)
'09'('match' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2 2⍴0)(#.I 2 2 3⍴0)
'10'('match' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2 2 3⍴0)(#.I 2 2 3⍴1)
'11'('match' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 0)(#.I 2 2⍴0)
'12'('match' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ,0)(#.I 2 2⍴0)
'13'('match' S 'Run' #.GEN∆T2 ⎕THIS)(#.I ,0)(#.I ,0)

:EndNamespace

