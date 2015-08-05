:Namespace conjugate

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000

S←':Namespace' 'Run←{+⍵}' ':EndNamespace'

NS←⎕FIX S
C←#.codfns

CONJUGATE∆I∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/conjugatei'C.Fix S
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

CONJUGATE∆I∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/conjugatei'C.Fix S
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

CONJUGATE∆I∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'conjugatei'C.Fix S
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

CONJUGATE∆F∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/conjugatef'C.Fix S
  #.UT.expect←NS.Run F ⋄ CS.Run F
}

CONJUGATE∆F∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/conjugatef'C.Fix S
  #.UT.expect←NS.Run F ⋄ CS.Run F
}

CONJUGATE∆F∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'conjugatef'C.Fix S
  #.UT.expect←NS.Run F ⋄ CS.Run F
}

:EndNamespace

