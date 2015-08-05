:Namespace plus

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'Run←{⍺+⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

PLUS∆II∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/plusii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

PLUS∆II∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/plusii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

PLUS∆II∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'plusii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

PLUS∆FF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/plusff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

PLUS∆FF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/plusff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

PLUS∆FF∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'plusff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

PLUS∆IF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/plusif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

PLUS∆IF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/plusif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

PLUS∆IF∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'plusif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

PLUS∆FI∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/plusfi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

PLUS∆FI∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/plusfi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

PLUS∆FI∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'plusfi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

:EndNamespace

