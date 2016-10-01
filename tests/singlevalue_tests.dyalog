:Namespace singlevalue

S←':Namespace' 'R1←{⍵}' 'R2←{5}' 'R3←{⊢⍵}' 'R4←{A←5 3 2 1 ⋄ A}' ':EndNamespace'

'01'('singlevalue' S 'R1' #.util.GEN∆T1 ⎕THIS)⍳5
'02'('singlevalue' S 'R2' #.util.GEN∆T1 ⎕THIS)⍳5
'03'('singlevalue' S 'R3' #.util.GEN∆T1 ⎕THIS)⍳5
'04'('singlevalue' S 'R4' #.util.GEN∆T1 ⎕THIS)⍳5

:EndNamespace