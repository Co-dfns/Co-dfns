:Namespace maximum

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'Run←{⍺⌈⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

MAXIMUM∆II∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/maximumii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

MAXIMUM∆II∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/maximumii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

MAXIMUM∆II∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'maximumii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

MAXIMUM∆FF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/maximumff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

MAXIMUM∆FF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/maximumff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

MAXIMUM∆FF∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'maximumff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

MAXIMUM∆IF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/maximumif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

MAXIMUM∆IF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/maximumif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

MAXIMUM∆IF∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'maximumif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

MAXIMUM∆FI∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/maximumfi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

MAXIMUM∆FI∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/maximumfi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

MAXIMUM∆FI∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'maximumfi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

:EndNamespace

