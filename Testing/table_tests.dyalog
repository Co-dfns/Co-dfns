:Namespace table

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{⍪⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

TABLE∆01∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/table01'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I ⍬ ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

TABLE∆01∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/table01'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I ⍬ ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

TABLE∆02∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/table02'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I 0 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

TABLE∆02∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/table02'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I 0 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

TABLE∆03∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/table03'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I ,0 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

TABLE∆03∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/table03'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I ,0 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

TABLE∆04∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/table04'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I ⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

TABLE∆04∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/table04'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I ⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

TABLE∆05∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/table05'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I 2 2 2⍴⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

TABLE∆05∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/table05'C.Fix S ⋄ C.COMPILER←'gcc'
  R←I 2 2 2⍴⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}


:EndNamespace

