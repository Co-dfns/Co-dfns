:Namespace reducenwisefirst

S←':Namespace' 'Run←{⍺+⌿⍵}' 'R2←{⍺×⌿⍵}' 'R3←{⍺{⍺+⍵}⌿⍵}' ':EndNamespace'

'01'('reducenwisefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(0)(⍳4)
'02'('reducenwisefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(1)(⍳4)
'03'('reducenwisefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(2)(⍳4)
'04'('reducenwisefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(4)(⍳4)
'05'('reducenwisefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(5)(⍳4)
'06'('reducenwisefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(2)(3 3⍴⍳4)
'07'('reducenwisefirst' S 'R2'  #.util.GEN∆T2 ⎕THIS)(0)(⍳4)
'08'('reducenwisefirst' S 'R2'  #.util.GEN∆T2 ⎕THIS)(1)(⍳4)
'09'('reducenwisefirst' S 'R2'  #.util.GEN∆T2 ⎕THIS)(2)(⍳4)
'10'('reducenwisefirst' S 'R2'  #.util.GEN∆T2 ⎕THIS)(4)(⍳4)
'11'('reducenwisefirst' S 'R2'  #.util.GEN∆T2 ⎕THIS)(5)(⍳4)
'12'('reducenwisefirst' S 'R2'  #.util.GEN∆T2 ⎕THIS)(2)(3 3⍴⍳4)
'13'('reducenwisefirst' S 'R3'  #.util.GEN∆T2 ⎕THIS)(1)(⍳4)
'14'('reducenwisefirst' S 'R3'  #.util.GEN∆T2 ⎕THIS)(2)(⍳4)
'15'('reducenwisefirst' S 'R3'  #.util.GEN∆T2 ⎕THIS)(4)(⍳4)
'16'('reducenwisefirst' S 'R3'  #.util.GEN∆T2 ⎕THIS)(5)(⍳4)
'17'('reducenwisefirst' S 'R3'  #.util.GEN∆T2 ⎕THIS)(2)(3 3⍴⍳4)

:EndNamespace

