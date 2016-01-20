:Namespace singlevalue

S←':Namespace' 'R1←{⍵}' 'R2←{5}' 'R3←{⊢⍵}' ':EndNamespace'

'01'('singlevalue' S 'R1' #.util.GEN∆T1 ⎕THIS)⍳5
'02'('singlevalue' S 'R2' #.util.GEN∆T1 ⎕THIS)⍳5
'03'('singlevalue' S 'R3' #.util.GEN∆T1 ⎕THIS)⍳5

:EndNamespace