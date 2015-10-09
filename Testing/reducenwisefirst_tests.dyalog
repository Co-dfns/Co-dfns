:Namespace reducenwisefirst

S←':Namespace' 'Run←{⍺+⌿⍵}' 'R2←{⍺×⌿⍵}' 'R3←{⍺{⍺+⍵}⌿⍵}' ':EndNamespace'

'01'('reducenwisefirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 0)(#.I ⍳4)
'02'('reducenwisefirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 1)(#.I ⍳4)
'03'('reducenwisefirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2)(#.I ⍳4)
'04'('reducenwisefirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 4)(#.I ⍳4)
'05'('reducenwisefirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 5)(#.I ⍳4)
'06'('reducenwisefirst' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2)(#.I 3 3⍴⍳4)
'07'('reducenwisefirst' S 'R2'  #.GEN∆T2 ⎕THIS)(#.I 0)(#.I ⍳4)
'08'('reducenwisefirst' S 'R2'  #.GEN∆T2 ⎕THIS)(#.I 1)(#.I ⍳4)
'09'('reducenwisefirst' S 'R2'  #.GEN∆T2 ⎕THIS)(#.I 2)(#.I ⍳4)
'10'('reducenwisefirst' S 'R2'  #.GEN∆T2 ⎕THIS)(#.I 4)(#.I ⍳4)
'11'('reducenwisefirst' S 'R2'  #.GEN∆T2 ⎕THIS)(#.I 5)(#.I ⍳4)
'12'('reducenwisefirst' S 'R2'  #.GEN∆T2 ⎕THIS)(#.I 2)(#.I 3 3⍴⍳4)
'13'('reducenwisefirst' S 'R3'  #.GEN∆T2 ⎕THIS)(#.I 1)(#.I ⍳4)
'14'('reducenwisefirst' S 'R3'  #.GEN∆T2 ⎕THIS)(#.I 2)(#.I ⍳4)
'15'('reducenwisefirst' S 'R3'  #.GEN∆T2 ⎕THIS)(#.I 4)(#.I ⍳4)
'16'('reducenwisefirst' S 'R3'  #.GEN∆T2 ⎕THIS)(#.I 5)(#.I ⍳4)
'17'('reducenwisefirst' S 'R3'  #.GEN∆T2 ⎕THIS)(#.I 2)(#.I 3 3⍴⍳4)

:EndNamespace

