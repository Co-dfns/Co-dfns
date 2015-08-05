:Namespace exponential

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯500+?100⍴1000
F←100÷⍨?100⍴10000

S←':Namespace' 'Run←{*⍵}' ':EndNamespace'

NS←⎕FIX S
C←#.codfns

EXPONENTIAL∆I∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/exponentiali'C.Fix S
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

EXPONENTIAL∆I∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/exponentiali'C.Fix S
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

EXPONENTIAL∆I∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'exponentiali'C.Fix S
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

EXPONENTIAL∆F∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/exponentialf'C.Fix S
  #.UT.expect←NS.Run F ⋄ CS.Run F
}

EXPONENTIAL∆F∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/exponentialf'C.Fix S
  #.UT.expect←NS.Run F ⋄ CS.Run F
}

EXPONENTIAL∆F∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'exponentialf'C.Fix S
  #.UT.expect←NS.Run F ⋄ CS.Run F
}

:EndNamespace

