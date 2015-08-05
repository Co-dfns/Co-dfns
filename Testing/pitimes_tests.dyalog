:Namespace pitimes

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000

S←':Namespace' 'Run←{○⍵}' ':EndNamespace'

NS←⎕FIX S
C←#.codfns

PITIMES∆I∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/pitimesi'C.Fix S
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

PITIMES∆I∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/pitimesi'C.Fix S
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

PITIMES∆I∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'pitimesi'C.Fix S
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

PITIMES∆F∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/pitimesf'C.Fix S
  #.UT.expect←NS.Run F ⋄ CS.Run F
}

PITIMES∆F∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/pitimesf'C.Fix S
  #.UT.expect←NS.Run F ⋄ CS.Run F
}

PITIMES∆F∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'pitimesf'C.Fix S
  #.UT.expect←NS.Run F ⋄ CS.Run F
}

:EndNamespace

