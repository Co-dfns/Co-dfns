:Namespace minimum

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'Run←{⍺⌊⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

MINIMUM∆II∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/minimumii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

MINIMUM∆II∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/minimumii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

MINIMUM∆II∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'minimumii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

MINIMUM∆FF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/minimumff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

MINIMUM∆FF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/minimumff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

MINIMUM∆FF∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'minimumff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

MINIMUM∆IF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/minimumif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

MINIMUM∆IF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/minimumif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

MINIMUM∆IF∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'minimumif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

MINIMUM∆FI∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/minimumfi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

MINIMUM∆FI∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/minimumfi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

MINIMUM∆FI∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'minimumfi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

:EndNamespace

