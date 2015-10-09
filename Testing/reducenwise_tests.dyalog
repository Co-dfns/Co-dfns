:Namespace reducenwise

S←':Namespace' 'Run←{⍺+/⍵}' 'R2←{⍺×/⍵}' 'R3←{⍺{⍺+⍵}/⍵}' ':EndNamespace'

'01'('reducenwise' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 0)(#.I ⍳4)
'02'('reducenwise' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 1)(#.I ⍳4)
'03'('reducenwise' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2)(#.I ⍳4)
'04'('reducenwise' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 4)(#.I ⍳4)
'05'('reducenwise' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 5)(#.I ⍳4)
'06'('reducenwise' S 'Run' #.GEN∆T2 ⎕THIS)(#.I 2)(#.I 3 3⍴⍳4)
'07'('reducenwise' S 'R2'  #.GEN∆T2 ⎕THIS)(#.I 0)(#.I ⍳4)
'08'('reducenwise' S 'R2'  #.GEN∆T2 ⎕THIS)(#.I 1)(#.I ⍳4)
'09'('reducenwise' S 'R2'  #.GEN∆T2 ⎕THIS)(#.I 2)(#.I ⍳4)
'10'('reducenwise' S 'R2'  #.GEN∆T2 ⎕THIS)(#.I 4)(#.I ⍳4)
'11'('reducenwise' S 'R2'  #.GEN∆T2 ⎕THIS)(#.I 5)(#.I ⍳4)
'12'('reducenwise' S 'R2'  #.GEN∆T2 ⎕THIS)(#.I 2)(#.I 3 3⍴⍳4)
'13'('reducenwise' S 'R3'  #.GEN∆T2 ⎕THIS)(#.I 1)(#.I ⍳4)
'14'('reducenwise' S 'R3'  #.GEN∆T2 ⎕THIS)(#.I 2)(#.I ⍳4)
'15'('reducenwise' S 'R3'  #.GEN∆T2 ⎕THIS)(#.I 4)(#.I ⍳4)
'16'('reducenwise' S 'R3'  #.GEN∆T2 ⎕THIS)(#.I 5)(#.I ⍳4)
'17'('reducenwise' S 'R3'  #.GEN∆T2 ⎕THIS)(#.I 2)(#.I 3 3⍴⍳4)

:EndNamespace

