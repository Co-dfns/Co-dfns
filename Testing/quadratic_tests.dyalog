:Namespace quadratic

BS←⊂':Namespace'
BS,←⊂'Run←{A←0⌷⍵ ⋄ B←1⌷⍵ ⋄ C←2⌷⍵ ⋄ ((-B)+((B×B)-4×A×C)*0.5)÷2×A}'
BS,←⊂':EndNamespace'

NS←⎕FIX BS

GD←{{⊃((⎕DR ⍵)645)⎕DR ⍵}{↑(0⌷⍵)(+⌿⍵)(1⌷⍵)}1+?2 ⍵⍴10}

C←#.codfns

QUADRATIC∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  D←GD 7 ⋄ C.COMPILER←'gcc'
  CN←'Scratch/quadratic'C.Fix BS
  #.UT.expect←NS.Run D
  CN.Run D}

QUADRATIC∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  D←GD 7 ⋄ C.COMPILER←'icc'
  CN←'Scratch/quadratic'C.Fix BS
  #.UT.expect←NS.Run D
  CN.Run D}

:EndNamespace
