:Namespace scalar

BS←':Namespace' 'r←0.02	⋄ v←0.03' 
BS,←'Run←{' 'S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5'
BS,←⊂'L←|(((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT)-vsqrtT'
BS,←⊂'(÷(○2)*0.5)×(*(L×L)÷¯2)×÷1+0.2316419×L' 
BS,←'}' ':EndNamespace'

NS←⎕FIX BS

GD←{⍉1+?⍵ 3⍴1000} ⋄ INT←{⊃((⎕DR ⍵)323)⎕DR ⍵}

C←#.codfns

SCALAR∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  D←GD 2*20 ⋄ L←INT ,¯1↑D ⋄ R←INT 2↑D
  CN←'Scratch/scalar'C.Fix BS
  #.UT.expect←1
  ∧/0.0000000001≥|(L CN.Run R)-L NS.Run R}

SCALAR∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  D←GD 2*20 ⋄ L←INT ,¯1↑D ⋄ R←INT 2↑D
  CN←'Scratch/scalar'C.Fix BS
  #.UT.expect←1
  ∧/0.0000000001≥|(L NS.Run R)-L CN.Run R}

SCALAR∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  D←GD 2*20 ⋄ L←INT ,¯1↑D ⋄ R←INT 2↑D
  CN←'scalar'C.Fix BS
  #.UT.expect←1
  ∧/0.0000000001≥|(L NS.Run R)-L CN.Run R}

:EndNamespace
