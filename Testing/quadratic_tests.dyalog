:Namespace quadratic

⍝ Test the Black Scholes benchmark for the correct output

BS←⊂':Namespace'
BS,←⊂'Run←{A←0⌷⍵ ⋄ B←1⌷⍵ ⋄ C←2⌷⍵ ⋄ ((-B)+((B×B)-4×A×C)*0.5)÷2×A}'
BS,←⊂':EndNamespace'

NS←⎕FIX BS

GD←{{⊃((⎕DR ⍵)645)⎕DR ⍵}{↑(0⌷⍵)(+⌿⍵)(1⌷⍵)}1+?2 ⍵⍴10}

C←#.codfns.C

QUADRATIC∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  D←GD 7 ⋄ C.COMPILER←'gcc'
  _←'Scratch/quadratic'#.codfns.C.Fix BS
  _←'Run_gcc'⎕NA'./Scratch/quadratic_gcc.so|Run >PP P <PP'
  #.UT.expect←NS.Run D
  Run_gcc 0 0 D}

QUADRATIC∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  D←GD 7 ⋄ C.COMPILER←'icc'
  _←'Scratch/quadratic'#.codfns.C.Fix BS
  _←'Run_icc'⎕NA'./Scratch/quadratic_icc.so|Run >PP P <PP'
  #.UT.expect←NS.Run D
  Run_icc 0 0 D}

:EndNamespace
