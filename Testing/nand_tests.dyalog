:Namespace nand

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
I1←I ?10⍴2
I2←I ?10⍴2
S←':Namespace' 'Run←{⍺⍲⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

NAND∆II∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/nandii'C.Fix S
  #.UT.expect←I1 NS.Run I2 ⋄ I1 CS.Run I2
}

NAND∆II∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/nandii'C.Fix S
  #.UT.expect←I1 NS.Run I2 ⋄ I1 CS.Run I2
}

NAND∆II∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'nandii'C.Fix S
  #.UT.expect←I1 NS.Run I2 ⋄ I1 CS.Run I2
}

:EndNamespace

