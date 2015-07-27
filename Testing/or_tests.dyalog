:Namespace or

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
I1←I ?10⍴2
I2←I ?10⍴2
S←':Namespace' 'Run←{⍺∨⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

OR∆II∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/orii'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←I1 NS.Run I2 ⋄ I1 CS.Run I2
}

OR∆II∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/orii'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←I1 NS.Run I2 ⋄ I1 CS.Run I2
}

:EndNamespace

