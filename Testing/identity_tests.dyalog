:Namespace identity

I←{⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000

S←':Namespace' 'Run←{+⍵}' ':EndNamespace'

NS←⎕FIX S
C←#.codfns.C

IDENTITY∆I∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/identityi'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

IDENTITY∆I∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/identityi'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

IDENTITY∆F∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/identityf'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←NS.Run F ⋄ CS.Run F
}

IDENTITY∆F∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/identityf'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←NS.Run F ⋄ CS.Run F
}

:EndNamespace

