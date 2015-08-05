:Namespace match

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{⍺≡⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

MATCH∆01∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/match01'C.Fix S
  L←I ⍬ ⋄ R←I ⍬ ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆01∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/match01'C.Fix S
  L←I ⍬ ⋄ R←I ⍬ ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆01∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'match01'C.Fix S
  L←I ⍬ ⋄ R←I ⍬ ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆02∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/match02'C.Fix S
  L←I 0 ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆02∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/match02'C.Fix S
  L←I 0 ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆02∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'match02'C.Fix S
  L←I 0 ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆03∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/match03'C.Fix S
  L←I ⍬ ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆03∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/match03'C.Fix S
  L←I ⍬ ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆03∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'match03'C.Fix S
  L←I ⍬ ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆04∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/match04'C.Fix S
  L←I ⍬ ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆04∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/match04'C.Fix S
  L←I ⍬ ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆04∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'match04'C.Fix S
  L←I ⍬ ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆05∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/match05'C.Fix S
  L←I ⍳7 ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆05∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/match05'C.Fix S
  L←I ⍳7 ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆05∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'match05'C.Fix S
  L←I ⍳7 ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆06∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/match06'C.Fix S
  L←I 0 ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆06∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/match06'C.Fix S
  L←I 0 ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆06∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'match06'C.Fix S
  L←I 0 ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆07∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/match07'C.Fix S
  L←I 2 2⍴0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆07∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/match07'C.Fix S
  L←I 2 2⍴0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆07∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'match07'C.Fix S
  L←I 2 2⍴0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆08∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/match08'C.Fix S
  L←I 2 2 3⍴0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆08∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/match08'C.Fix S
  L←I 2 2 3⍴0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆08∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'match08'C.Fix S
  L←I 2 2 3⍴0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆09∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/match09'C.Fix S
  L←I 2 2⍴0 ⋄ R←I 2 2 3⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆09∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/match09'C.Fix S
  L←I 2 2⍴0 ⋄ R←I 2 2 3⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆09∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'match09'C.Fix S
  L←I 2 2⍴0 ⋄ R←I 2 2 3⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆10∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/match10'C.Fix S
  L←I 2 2 3⍴0 ⋄ R←I 2 2 3⍴1 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆10∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/match10'C.Fix S
  L←I 2 2 3⍴0 ⋄ R←I 2 2 3⍴1 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆10∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'match10'C.Fix S
  L←I 2 2 3⍴0 ⋄ R←I 2 2 3⍴1 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆11∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/match11'C.Fix S
  L←I 0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆11∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/match11'C.Fix S
  L←I 0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆11∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'match11'C.Fix S
  L←I 0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆12∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/match12'C.Fix S
  L←I ,0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆12∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/match12'C.Fix S
  L←I ,0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆12∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'match12'C.Fix S
  L←I ,0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆13∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/match13'C.Fix S
  L←I ,0 ⋄ R←I ,0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆13∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/match13'C.Fix S
  L←I ,0 ⋄ R←I ,0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

MATCH∆13∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'match13'C.Fix S
  L←I ,0 ⋄ R←I ,0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

:EndNamespace

