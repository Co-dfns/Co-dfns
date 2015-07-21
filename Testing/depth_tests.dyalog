:Namespace depth

I←{⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{≡⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

DEPTH∆01∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/depth01'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I ⍬ ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

DEPTH∆01∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/depth01'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I ⍬ ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

DEPTH∆02∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/depth02'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I 0 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

DEPTH∆02∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/depth02'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I 0 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

DEPTH∆03∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/depth03'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I ⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

DEPTH∆03∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/depth03'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I ⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

DEPTH∆04∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/depth04'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I 2 3 4⍴⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

DEPTH∆04∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/depth04'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I 2 3 4⍴⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

:EndNamespace

