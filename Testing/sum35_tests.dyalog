:Namespace sum35

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}16
S←':Namespace' 'Run←{a←⍳⍵ ⋄ +/((0=3|a)∨0=5|a)/a}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

SUM35∆II∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/sum35ii'C.Fix S
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

SUM35∆II∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/sum35ii'C.Fix S
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

SUM35∆II∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'sum35ii'C.Fix S
  #.UT.expect←NS.Run I ⋄ CS.Run I
}

:EndNamespace

