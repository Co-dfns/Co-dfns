:Namespace right

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{⍺⊢⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

RIGHT∆01∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/right01'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I ⍬ ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

RIGHT∆01∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/right01'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I ⍬ ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

RIGHT∆02∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/right02'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I 0 ⋄ R←I ⍬ ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

RIGHT∆02∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/right02'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I 0 ⋄ R←I ⍬ ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

:EndNamespace

