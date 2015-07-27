:Namespace same

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{⊣⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

SAME∆01∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/same01'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I ⍬ ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

SAME∆01∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/same01'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I ⍬ ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

SAME∆02∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/same02'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I 0 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

SAME∆02∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/same02'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I 0 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

SAME∆03∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/same03'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I ⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

SAME∆03∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/same03'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I ⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

SAME∆04∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/same04'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I 2 3 4⍴⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

SAME∆04∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/same04'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I 2 3 4⍴⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

:EndNamespace

