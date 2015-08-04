:Namespace tally

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{≢⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

TALLY∆01∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/tally01'C.Fix S
  R←I ⍬ ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

TALLY∆01∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/tally01'C.Fix S
  R←I ⍬ ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

TALLY∆01∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'tally01'C.Fix S
  R←I ⍬ ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

TALLY∆02∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/tally02'C.Fix S
  R←I 0 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

TALLY∆02∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/tally02'C.Fix S
  R←I 0 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

TALLY∆02∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'tally02'C.Fix S
  R←I 0 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

TALLY∆03∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/tally03'C.Fix S
  R←I ⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

TALLY∆03∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/tally03'C.Fix S
  R←I ⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

TALLY∆03∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'tally03'C.Fix S
  R←I ⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

TALLY∆04∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/tally04'C.Fix S
  R←I 2 3 4⍴⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

TALLY∆04∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/tally04'C.Fix S
  R←I 2 3 4⍴⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

TALLY∆04∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'tally04'C.Fix S
  R←I 2 3 4⍴⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

:EndNamespace

