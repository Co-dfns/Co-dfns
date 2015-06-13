:Namespace scalar

BS←':Namespace' 'r←0.02	⋄ v←0.03' 
BS,←'Run←{' 'S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5'
BS,←⊂'L←|(((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT)-vsqrtT'
BS,←⊂'(÷(○2)*0.5)×(*(L×L)÷¯2)×÷1+0.2316419×L' 
BS,←'}' ':EndNamespace'

NS←⎕FIX BS

GD←{{⊃((⎕DR ⍵)323)⎕DR ⍵}⍉1+?⍵ 3⍴1000}

C←#.codfns.C

SCALAR∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  D←GD 2*25 ⋄ L←,¯1↑D ⋄ R←2↑D ⋄ C.COMPILER←'gcc'
  _←'Scratch/scalar_gcc.c'#.codfns.C.Fix BS
  _←⎕SH './gcc Scratch/scalar_gcc'
  _←'Run_gcc'⎕NA'./Scratch/scalar_gcc.so|Run >PP <PP <PP'
  #.UT.expect←1
  ∧/0.0000000001≥|(Run_gcc 0 L R)-L NS.Run R}

SCALAR∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  D←GD 2*25 ⋄ L←,¯1↑D ⋄ R←2↑D ⋄ C.COMPILER←'icc'
  _←'Scratch/scalar_icc.c'#.codfns.C.Fix BS
  _←⎕SH './icc Scratch/scalar_icc'
  _←'Run_icc'⎕NA'./Scratch/scalar_icc.so|Run >PP <PP <PP'
  #.UT.expect←1
  ∧/0.0000000001≥|(L NS.Run R)-Run_icc 0 L R}

SCALAR∆PGI_TEST←{~(⊂'pgcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  D←GD 2*25 ⋄ L←,¯1↑D ⋄ R←2↑D ⋄ C.COMPILER←'pgcc'
  _←'Scratch/scalar_pgi.c'#.codfns.C.Fix BS
  _←⎕SH './pgi Scratch/scalar_pgi'
  _←'Run_pgi'⎕NA'./Scratch/scalar_pgi.so|Run >PP <PP <PP'
  #.UT.expect←1
  ∧/0.0000000001≥|(L NS.Run R)-Run_pgi 0 L R}


:EndNamespace
