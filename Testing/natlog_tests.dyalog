:Namespace natlog

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}?100⍴10000
F←100÷⍨?100⍴10000

S←':Namespace' 'Run←{⍟⍵}' ':EndNamespace'

NS←⎕FIX S
C←#.codfns

NATLOG∆I∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/natlogi'C.Fix S
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

NATLOG∆I∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/natlogi'C.Fix S
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

NATLOG∆I∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'natlogi'C.Fix S
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

NATLOG∆F∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/natlogf'C.Fix S
  #.UT.expect←NS.Run F ⋄ CS.Run F
}

NATLOG∆F∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/natlogf'C.Fix S
  #.UT.expect←NS.Run F ⋄ CS.Run F
}

NATLOG∆F∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'natlogf'C.Fix S
  #.UT.expect←NS.Run F ⋄ CS.Run F
}

:EndNamespace

