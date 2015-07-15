:Namespace reshape

I←{⊃((⎕DR ⍵)323)⎕DR ⍵}
⍝ S←':Namespace' 'Rv←{⍺⍴⍵}' 'Rl←{2 2⍴⍵}' 'Rr←{⍺⍴5}' ':EndNamespace'
S←':Namespace' 'Rv←{⍺⍴⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

RESHAPE∆1∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reshape1'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←(I 2 2)NS.Rv I ⍳4 ⋄ (I 2 2)CS.Rv I ⍳4
}

RESHAPE∆1∆ICC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reshape1'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←(I 2 2)NS.Rv I ⍳4 ⋄ (I 2 2)CS.Rv I ⍳4
}

RESHAPE∆2∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reshape2'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←(I 2 2)NS.Rv I ⍳2 ⋄ (I 2 2)CS.Rv I ⍳2
}

RESHAPE∆2∆ICC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reshape2'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←(I 2 2)NS.Rv I ⍳2 ⋄ (I 2 2)CS.Rv I ⍳2
}

RESHAPE∆3∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reshape3'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←(I 2 2)NS.Rv I ⍳6 ⋄ (I 2 2)CS.Rv I ⍳6
}

RESHAPE∆3∆ICC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reshape3'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←(I 2 2)NS.Rv I ⍳6 ⋄ (I 2 2)CS.Rv I ⍳6
}

RESHAPE∆4∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reshape4'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←(I ⍬)NS.Rv I ⍳6 ⋄ (I ⍬)CS.Rv I ⍳6
}

RESHAPE∆4∆ICC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reshape4'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←(I ⍬)NS.Rv I ⍳6 ⋄ (I ⍬)CS.Rv I ⍳6
}

RESHAPE∆5∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reshape5'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←(I 2 2)NS.Rv I ⍬ ⋄ (I 2 2)CS.Rv I ⍬
}

RESHAPE∆5∆ICC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reshape5'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←(I 2 2)NS.Rv I ⍬ ⋄ (I 2 2)CS.Rv I ⍬
}

:EndNamespace

