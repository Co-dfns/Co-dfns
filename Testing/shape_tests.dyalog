:Namespace shape

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}

S←':Namespace' 'Run←{⍴⍵}' ':EndNamespace'

NS←⎕FIX S ⋄ C←#.codfns

SHAPE∆1∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/shape1'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←NS.Run I ⍬⍴0 ⋄ CS.Run I ⍬⍴0
}

SHAPE∆1∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/shape1'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←NS.Run I ⍬⍴0 ⋄ CS.Run I ⍬⍴0
}

SHAPE∆2∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/shape2'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←NS.Run I 5⍴0 ⋄ CS.Run I 5⍴0
}

SHAPE∆2∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/shape2'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←NS.Run I 5⍴0 ⋄ CS.Run I 5⍴0
}

SHAPE∆3∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/shape3'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←NS.Run I 2 2⍴0 ⋄ CS.Run I 2 2⍴0
}

SHAPE∆3∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/shape3'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←NS.Run I 2 2⍴0 ⋄ CS.Run I 2 2⍴0
}

:EndNamespace

