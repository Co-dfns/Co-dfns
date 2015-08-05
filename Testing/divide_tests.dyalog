:Namespace divide

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'Run←{⍺÷⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

DIVIDE∆II∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/divideii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

DIVIDE∆II∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/divideii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

DIVIDE∆II∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'divideii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

DIVIDE∆FF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/divideff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

DIVIDE∆FF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/divideff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

DIVIDE∆FF∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'divideff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

DIVIDE∆IF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/divideif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

DIVIDE∆IF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/divideif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

DIVIDE∆IF∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'divideif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

DIVIDE∆FI∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/dividefi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

DIVIDE∆FI∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/dividefi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

DIVIDE∆FI∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'dividefi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

:EndNamespace

