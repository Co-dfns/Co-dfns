:Namespace reciprocal

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000

S←':Namespace' 'Run←{÷⍵}' ':EndNamespace'

NS←⎕FIX S
C←#.codfns

RECIPROCAL∆I∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reciprocali'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

RECIPROCAL∆I∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reciprocali'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

RECIPROCAL∆F∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reciprocalf'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←NS.Run F ⋄ CS.Run F
}

RECIPROCAL∆F∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reciprocalf'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←NS.Run F ⋄ CS.Run F
}

:EndNamespace

