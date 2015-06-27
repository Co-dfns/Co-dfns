:Namespace lth

I←{⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'Run←{⍺<⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns.C

LTH∆II∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/lthii'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

LTH∆II∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/lthii'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

LTH∆FF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/lthff'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

LTH∆FF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/lthff'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

LTH∆IF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/lthif'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

LTH∆IF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/lthif'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

LTH∆FI∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/lthfi'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

LTH∆FI∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/lthfi'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

:EndNamespace

