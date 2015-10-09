:Namespace reshape

S←':Namespace' 'Rv←{⍺⍴⍵}' 'Rl←{2 2⍴⍵}' 'Rr←{⍺⍴5}' ':EndNamespace'

'01'('reshape' S 'Rv' #.GEN∆T2 ⎕THIS)(#.I 2 2)(#.I ⍳4)
'02'('reshape' S 'Rv' #.GEN∆T2 ⎕THIS)(#.I 2 2)(#.I ⍳2)
'03'('reshape' S 'Rv' #.GEN∆T2 ⎕THIS)(#.I 2 2)(#.I ⍳6)
'04'('reshape' S 'Rv' #.GEN∆T2 ⎕THIS)(#.I ⍬)(#.I ⍳6)
'05'('reshape' S 'Rv' #.GEN∆T2 ⎕THIS)(#.I 2 2)(#.I ⍬)
'06'('reshape' S 'Rl' #.GEN∆T2 ⎕THIS)(#.I 2 2)(#.I ⍳4)
'07'('reshape' S 'Rl' #.GEN∆T2 ⎕THIS)(#.I 2 2)(#.I ⍳2)
'08'('reshape' S 'Rl' #.GEN∆T2 ⎕THIS)(#.I 2 2)(#.I ⍳6)
'09'('reshape' S 'Rl' #.GEN∆T2 ⎕THIS)(#.I ⍬)(#.I ⍳6)
'10'('reshape' S 'Rl' #.GEN∆T2 ⎕THIS)(#.I 2 2)(#.I ⍬)
'11'('reshape' S 'Rr' #.GEN∆T2 ⎕THIS)(#.I 2 2)(#.I ⍳4)
'12'('reshape' S 'Rr' #.GEN∆T2 ⎕THIS)(#.I 2 2)(#.I ⍳2)
'13'('reshape' S 'Rr' #.GEN∆T2 ⎕THIS)(#.I 2 2)(#.I ⍳6)
'14'('reshape' S 'Rr' #.GEN∆T2 ⎕THIS)(#.I ⍬)(#.I ⍳6)
'15'('reshape' S 'Rr' #.GEN∆T2 ⎕THIS)(#.I 2 2)(#.I ⍬)

:EndNamespace

