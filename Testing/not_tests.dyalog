:Namespace not

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}?10⍴2

S←':Namespace' 'Run←{~⍵}' ':EndNamespace'

NS←⎕FIX S
C←#.codfns

NEGATIVE∆I∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/noti'C.Fix S
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

NEGATIVE∆I∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/noti'C.Fix S
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

NEGATIVE∆I∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'noti'C.Fix S
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

:EndNamespace

