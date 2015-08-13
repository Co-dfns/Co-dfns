:Namespace commute

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'Run←{⍺-⍨⍵}' 'Rm←{-⍨⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

COMMUTE∆II∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/commuteii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

COMMUTE∆II∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/commuteii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

COMMUTE∆II∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'commuteii'C.Fix S
  #.UT.expect←I NS.Run I ⋄ I CS.Run I
}

COMMUTE∆FF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/commuteff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

COMMUTE∆FF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/commuteff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

COMMUTE∆FF∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'commuteff'C.Fix S
  #.UT.expect←F NS.Run F ⋄ F CS.Run F
}

COMMUTE∆IF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/commuteif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

COMMUTE∆IF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/commuteif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

COMMUTE∆IF∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'commuteif'C.Fix S
  #.UT.expect←I NS.Run F ⋄ I CS.Run F
}

COMMUTE∆FI∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/commutefi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

COMMUTE∆FI∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/commutefi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

COMMUTE∆FI∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'commutefi'C.Fix S
  #.UT.expect←F NS.Run I ⋄ F CS.Run I
}

COMMUTE∆I∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/commutei'C.Fix S
  #.UT.expect←NS.Rm I ⋄ CS.Rm I
}

COMMUTE∆I∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/commutei'C.Fix S
  #.UT.expect←NS.Rm I ⋄ CS.Rm I
}

COMMUTE∆I∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'commutei'C.Fix S
  #.UT.expect←NS.Rm I ⋄ CS.Rm I
}

COMMUTE∆F∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/commutef'C.Fix S
  #.UT.expect←NS.Rm F ⋄ CS.Rm F
}

COMMUTE∆F∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/commutef'C.Fix S
  #.UT.expect←NS.Rm F ⋄ CS.Rm F
}

COMMUTE∆F∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'commutef'C.Fix S
  #.UT.expect←NS.Rm F ⋄ CS.Rm F
}

:EndNamespace

