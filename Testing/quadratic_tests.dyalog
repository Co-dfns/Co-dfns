:Namespace quadratic

S←⊂':Namespace'
S,←⊂'Run←{A←0⌷⍵ ⋄ B←1⌷⍵ ⋄ C←2⌷⍵ ⋄ ((-B)+((B×B)-4×A×C)*0.5)÷2×A}'
S,←⊂':EndNamespace'

GD←{{⊃((⎕DR ⍵)645)⎕DR ⍵}{↑(0⌷⍵)(+⌿⍵)(1⌷⍵)}1+?2 ⍵⍴10}
D←GD 7

''('quadratic' S 'Run' #.GEN∆T1 ⎕THIS) D

:EndNamespace
