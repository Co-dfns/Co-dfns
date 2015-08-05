:Namespace revfirst

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{⌽⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

REVFIRST∆01∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/revfirst01'C.Fix S
  R←I ⍬ ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

REVFIRST∆01∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/revfirst01'C.Fix S
  R←I ⍬ ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

REVFIRST∆01∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'revfirst01'C.Fix S
  R←I ⍬ ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

REVFIRST∆02∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/revfirst02'C.Fix S
  R←I 0 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

REVFIRST∆02∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/revfirst02'C.Fix S
  R←I 0 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

REVFIRST∆02∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'revfirst02'C.Fix S
  R←I 0 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

REVFIRST∆03∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/revfirst03'C.Fix S
  R←I ⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

REVFIRST∆03∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/revfirst03'C.Fix S
  R←I ⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

REVFIRST∆03∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'revfirst03'C.Fix S
  R←I ⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

REVFIRST∆04∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/revfirst04'C.Fix S
  R←I 2 3 4⍴⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

REVFIRST∆04∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/revfirst04'C.Fix S
  R←I 2 3 4⍴⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

REVFIRST∆04∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'revfirst04'C.Fix S
  R←I 2 3 4⍴⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

:EndNamespace

