:Namespace quadratic

⍝ Test the Black Scholes benchmark for the correct output

BS←⊂':Namespace'
BS,←⊂'Run←{A←0⌷⍵ ⋄ B←1⌷⍵ ⋄ C←2⌷⍵ ⋄ ((-B)+((B*2)-4×A×C)*0.5)÷2×A}'
BS,←⊂':EndNamespace'

NS←⎕FIX BS

GD←{{⊃((⎕DR ⍵)645)⎕DR ⍵}{↑(⍵÷2)(⍵)(⍵÷4)}?⍵⍴1000}

C←#.codfns.C

QUADRATIC∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  D←GD 7 ⋄ C.COMPILER←'gcc'
  _←'Scratch/quadratic_gcc.c'#.codfns.C.Fix BS
  _←⎕SH './gcc Scratch/quadratic_gcc'
  _←'Run_gcc'⎕NA'./Scratch/quadratic_gcc.so|Run >PP P <PP'
  #.UT.expect←NS.Run D
  Run_gcc 0 0 D}

QUADRATIC∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  D←GD 7 ⋄ C.COMPILER←'icc'
  _←'Scratch/quadratic_icc.c'#.codfns.C.Fix BS
  _←⎕SH './icc Scratch/quadratic_icc'
  _←'Run_icc'⎕NA'./Scratch/quadratic_icc.so|Run >PP P <PP'
  #.UT.expect←NS.Run D
  Run_icc 0 0 D}

QUADRATIC∆PGI_TEST←{~(⊂'pgcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  D←GD 7 ⋄ C.COMPILER←'pgcc'
  _←'Scratch/quadratic_pgi.c'#.codfns.C.Fix BS
  _←⎕SH './pgi Scratch/quadratic_pgi'
  _←'Run_pgi'⎕NA'./Scratch/quadratic_pgi.so|Run >PP P <PP'
  #.UT.expect←NS.Run D
  Run_pgi 0 0 D}

:EndNamespace
