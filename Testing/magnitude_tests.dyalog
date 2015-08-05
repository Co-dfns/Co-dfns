:Namespace magnitude

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000

S←':Namespace' 'Run←{|⍵}' ':EndNamespace'

NS←⎕FIX S
C←#.codfns

MAGNITUDE∆I∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/magnitudei'C.Fix S
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

MAGNITUDE∆I∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/magnitudei'C.Fix S
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

MAGNITUDE∆I∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'magnitudei'C.Fix S
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

MAGNITUDE∆F∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/magnitudef'C.Fix S
  #.UT.expect←NS.Run F ⋄ CS.Run F
}

MAGNITUDE∆F∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/magnitudef'C.Fix S
  #.UT.expect←NS.Run F ⋄ CS.Run F
}

MAGNITUDE∆F∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'magnitudef'C.Fix S
  #.UT.expect←NS.Run F ⋄ CS.Run F
}

:EndNamespace

