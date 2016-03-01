:Namespace reducenwise

S←':Namespace' 'Run←{⍺+/⍵}' 'R2←{⍺×/⍵}' 'R3←{⍺{⍺+⍵}/⍵}' ':EndNamespace'

'01'('reducenwise' S 'Run' #.util.GEN∆T2 ⎕THIS)(0)(⍳4)
'02'('reducenwise' S 'Run' #.util.GEN∆T2 ⎕THIS)(1)(⍳4)
'03'('reducenwise' S 'Run' #.util.GEN∆T2 ⎕THIS)(2)(⍳4)
'04'('reducenwise' S 'Run' #.util.GEN∆T2 ⎕THIS)(4)(⍳4)
'05'('reducenwise' S 'Run' #.util.GEN∆T2 ⎕THIS)(5)(⍳4)
'06'('reducenwise' S 'Run' #.util.GEN∆T2 ⎕THIS)(2)(3 3⍴⍳4)
'07'('reducenwise' S 'R2'  #.util.GEN∆T2 ⎕THIS)(0)(⍳4)
'08'('reducenwise' S 'R2'  #.util.GEN∆T2 ⎕THIS)(1)(⍳4)
'09'('reducenwise' S 'R2'  #.util.GEN∆T2 ⎕THIS)(2)(⍳4)
'10'('reducenwise' S 'R2'  #.util.GEN∆T2 ⎕THIS)(4)(⍳4)
'11'('reducenwise' S 'R2'  #.util.GEN∆T2 ⎕THIS)(5)(⍳4)
'12'('reducenwise' S 'R2'  #.util.GEN∆T2 ⎕THIS)(2)(3 3⍴⍳4)
'13'('reducenwise' S 'R3'  #.util.GEN∆T2 ⎕THIS)(1)(⍳4)
'14'('reducenwise' S 'R3'  #.util.GEN∆T2 ⎕THIS)(2)(⍳4)
'15'('reducenwise' S 'R3'  #.util.GEN∆T2 ⎕THIS)(4)(⍳4)
'16'('reducenwise' S 'R3'  #.util.GEN∆T2 ⎕THIS)(5)(⍳4)
'17'('reducenwise' S 'R3'  #.util.GEN∆T2 ⎕THIS)(2)(3 3⍴⍳4)

:EndNamespace

