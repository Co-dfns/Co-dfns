:Namespace singlevalue

S1←':Namespace' 'Run←{⍵}' ':EndNamespace'
S2←':Namespace' 'Run←{5}' ':EndNamespace'
S3←':Namespace' 'Run←{⊢⍵}' ':EndNamespace'
S4←':Namespace' 'Run←{A←5 3 2 1 ⋄ A}' ':EndNamespace'
S5←':Namespace' 'Run←{4 3}' ':EndNamespace'
S6←':Namespace' 'Run←{1 0 1}' ':EndNamespace'

'01'('singlevalue' S1 'Run' #.util.GEN∆T1 ⎕THIS)⍳5
'02'('singlevalue' S2 'Run' #.util.GEN∆T1 ⎕THIS)⍳5
'03'('singlevalue' S3 'Run' #.util.GEN∆T1 ⎕THIS)⍳5
'04'('singlevalue' S4 'Run' #.util.GEN∆T1 ⎕THIS)⍳5
'05'('singlevalue' S5 'Run' #.util.GEN∆T1 ⎕THIS)⍳5
'06'('singlevalue' S5 'Run' #.util.GEN∆T1 ⎕THIS)⍳5

:EndNamespace