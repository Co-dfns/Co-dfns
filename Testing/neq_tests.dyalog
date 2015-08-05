:Namespace neq

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'Run←{⍺≠⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

NEQ∆II∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/neqii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

NEQ∆II∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/neqii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

NEQ∆II∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'neqii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

NEQ∆FF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/neqff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

NEQ∆FF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/neqff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

NEQ∆FF∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'neqff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

NEQ∆IF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/neqif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

NEQ∆IF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/neqif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

NEQ∆IF∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'neqif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

NEQ∆FI∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/neqfi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

NEQ∆FI∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/neqfi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

NEQ∆FI∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'neqfi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

:EndNamespace

