:Namespace eq

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'Run←{⍺=⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

EQ∆II∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/eqii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

EQ∆II∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/eqii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

EQ∆II∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'eqii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

EQ∆FF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/eqff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

EQ∆FF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/eqff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

EQ∆FF∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'eqff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

EQ∆IF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/eqif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

EQ∆IF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/eqif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

EQ∆IF∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'eqif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

EQ∆FI∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/eqfi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

EQ∆FI∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/eqfi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

EQ∆FI∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'eqfi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

:EndNamespace

