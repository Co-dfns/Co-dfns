:Namespace enlist

I←{⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{,⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

ENLIST∆1∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/enlist1'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←NS.Run I ⍳5 ⋄ CS.Run I ⍳5
}

ENLIST∆1∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/enlist1'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←NS.Run I ⍳5 ⋄ CS.Run I ⍳5
}

ENLIST∆2∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/enlist2'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←NS.Run I 0 ⋄ CS.Run I 0
}

ENLIST∆2∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/enlist2'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←NS.Run I 0 ⋄ CS.Run I 0
}

ENLIST∆3∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/enlist3'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←NS.Run I ⍬ ⋄ CS.Run I ⍬
}

ENLIST∆3∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/enlist3'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←NS.Run I ⍬ ⋄ CS.Run I ⍬
}

ENLIST∆4∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/enlist4'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←NS.Run ÷2 2⍴1+⍳5 ⋄ CS.Run ÷2 2⍴1+⍳5
}

ENLIST∆4∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/enlist4'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←NS.Run ÷2 2⍴1+⍳5 ⋄ CS.Run ÷2 2⍴1+⍳5
}

:EndNamespace

