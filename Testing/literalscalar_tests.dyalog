:Namespace literalscalar

S←':Namespace' 'R1←{X←1 ⋄ ⍵⊢X}' 'R2←{X←1 2 ⋄ ⍵⊢X}' ':EndNamespace'

'01'('literalscalar' S 'R1' #.util.GEN∆T1 ⎕THIS) ⍳5
'02'('literalscalar' S 'R2' #.util.GEN∆T1 ⎕THIS) ⍳5

:EndNamespace