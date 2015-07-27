:Namespace log

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'Run←{⍺⍟⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

LOG∆II∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/logii'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

LOG∆II∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/logii'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

LOG∆FF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/logff'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

LOG∆FF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/logff'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

LOG∆IF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/logif'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

LOG∆IF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/logif'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

LOG∆FI∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/logfi'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

LOG∆FI∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/logfi'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

:EndNamespace

