:Namespace multiply

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'Run←{⍺×⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

MULTIPLY∆II∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/multiplyii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

MULTIPLY∆II∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/multiplyii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

MULTIPLY∆II∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'multiplyii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

MULTIPLY∆FF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/multiplyff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

MULTIPLY∆FF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/multiplyff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

MULTIPLY∆FF∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'multiplyff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

MULTIPLY∆IF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/multiplyif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

MULTIPLY∆IF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/multiplyif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

MULTIPLY∆IF∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'multiplyif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

MULTIPLY∆FI∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/multiplyfi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

MULTIPLY∆FI∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/multiplyfi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

MULTIPLY∆FI∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'multiplyfi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

:EndNamespace

