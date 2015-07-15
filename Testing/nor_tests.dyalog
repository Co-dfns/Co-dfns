:Namespace nor

I1←{⊃((⎕DR ⍵)323)⎕DR ⍵}?10⍴2
I2←{⊃((⎕DR ⍵)323)⎕DR ⍵}?10⍴2
S←':Namespace' 'Run←{⍺⍱⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

NOR∆II∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/norii'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←I1 NS.Run I2 ⋄ I1 CS.Run I2
}

NOR∆II∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/norii'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←I1 NS.Run I2 ⋄ I1 CS.Run I2
}

:EndNamespace

