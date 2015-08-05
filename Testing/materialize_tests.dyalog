:Namespace materialize

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?10⍴10000
F←100÷⍨?10⍴10000

S←':Namespace' 'Run←{⌷⍵}' ':EndNamespace'

NS←⎕FIX S
C←#.codfns

MATERIALIZE∆I∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/materializei'C.Fix S
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

MATERIALIZE∆I∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/materializei'C.Fix S
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

MATERIALIZE∆I∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'materializei'C.Fix S
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

MATERIALIZE∆F∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/materializef'C.Fix S
  #.UT.expect←NS.Run F ⋄ CS.Run F
}

MATERIALIZE∆F∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/materializef'C.Fix S
  #.UT.expect←NS.Run F ⋄ CS.Run F
}

MATERIALIZE∆F∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'materializef'C.Fix S
  #.UT.expect←NS.Run F ⋄ CS.Run F
}

:EndNamespace

