:Namespace left

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{⍺⊣⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

LEFT∆01∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/left01'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I ⍬ ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

LEFT∆01∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/left01'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I ⍬ ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

LEFT∆02∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/left02'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I 0 ⋄ R←I ⍬ ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

LEFT∆02∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/left02'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I 0 ⋄ R←I ⍬ ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

:EndNamespace

