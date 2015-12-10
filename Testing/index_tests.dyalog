:Namespace index

S1←':Namespace' 'Run←{⍺⌷⍵}' ':EndNamespace'
S2←':Namespace' 'Run←{X←⍳5 ⋄ Y←⍳5 ⋄ X Y⌷⍵}' ':EndNamespace'

'01' ('index' S1 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)	(5)

:EndNamespace