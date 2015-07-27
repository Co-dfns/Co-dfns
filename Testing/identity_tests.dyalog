:Namespace identity

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{⊢⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

IDENTITY∆01∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/identity01'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I ⍬ ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

IDENTITY∆01∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/identity01'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I ⍬ ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

IDENTITY∆02∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/identity02'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I 0 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

IDENTITY∆02∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/identity02'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I 0 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

IDENTITY∆03∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/identity03'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I ⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

IDENTITY∆03∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/identity03'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I ⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

IDENTITY∆04∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/identity04'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I 2 3 4⍴⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

IDENTITY∆04∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/identity04'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I 2 3 4⍴⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

:EndNamespace

