:Namespace gte

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'Run←{⍺≥⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

GTE∆II∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/gteii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

GTE∆II∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/gteii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

GTE∆II∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'gteii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

GTE∆FF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/gteff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

GTE∆FF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/gteff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

GTE∆FF∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'gteff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

GTE∆IF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/gteif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

GTE∆IF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/gteif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

GTE∆IF∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'gteif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

GTE∆FI∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/gtefi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

GTE∆FI∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/gtefi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

GTE∆FI∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'gtefi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

:EndNamespace

