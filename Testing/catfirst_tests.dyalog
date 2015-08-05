:Namespace catfirst

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{⍺⍪⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

CATFIRST∆01∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/catfirst01'C.Fix S
  L←I ⍬ ⋄ R←I ⍬ ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆01∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/catfirst01'C.Fix S
  L←I ⍬ ⋄ R←I ⍬ ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆01∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'catfirst01'C.Fix S
  L←I ⍬ ⋄ R←I ⍬ ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆02∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/catfirst02'C.Fix S
  L←I 0 ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆02∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/catfirst02'C.Fix S
  L←I 0 ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆02∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'catfirst02'C.Fix S
  L←I 0 ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆03∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/catfirst03'C.Fix S
  L←I ⍬ ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆03∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/catfirst03'C.Fix S
  L←I ⍬ ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆03∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'catfirst03'C.Fix S
  L←I ⍬ ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆04∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/catfirst04'C.Fix S
  L←I ⍬ ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆04∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/catfirst04'C.Fix S
  L←I ⍬ ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆04∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'catfirst04'C.Fix S
  L←I ⍬ ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆05∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/catfirst05'C.Fix S
  L←I ⍳7 ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆05∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/catfirst05'C.Fix S
  L←I ⍳7 ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆05∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'catfirst05'C.Fix S
  L←I ⍳7 ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆06∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/catfirst06'C.Fix S
  L←I 0 ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆06∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/catfirst06'C.Fix S
  L←I 0 ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆06∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'catfirst06'C.Fix S
  L←I 0 ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆07∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/catfirst07'C.Fix S
  L←I 2 2⍴0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆07∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/catfirst07'C.Fix S
  L←I 2 2⍴0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆07∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'catfirst07'C.Fix S
  L←I 2 2⍴0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆08∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/catfirst08'C.Fix S
  L←I 2 2 3⍴0 ⋄ R←I 2 3⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆08∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/catfirst08'C.Fix S
  L←I 2 2 3⍴0 ⋄ R←I 2 3⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆08∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'catfirst08'C.Fix S
  L←I 2 2 3⍴0 ⋄ R←I 2 3⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆09∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/catfirst09'C.Fix S
  L←I 2 3⍴0 ⋄ R←I 2 2 3⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆09∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/catfirst09'C.Fix S
  L←I 2 3⍴0 ⋄ R←I 2 2 3⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆09∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'catfirst09'C.Fix S
  L←I 2 3⍴0 ⋄ R←I 2 2 3⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆10∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/catfirst10'C.Fix S
  L←I 2 3⍴0 ⋄ R←I 2 2 3⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆10∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/catfirst09'C.Fix S
  L←I 2 3⍴0 ⋄ R←I 2 2 3⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆10∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'catfirst09'C.Fix S
  L←I 2 3⍴0 ⋄ R←I 2 2 3⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆11∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/catfirst11'C.Fix S
  L←I 0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆11∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/catfirst11'C.Fix S
  L←I 0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆11∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'catfirst11'C.Fix S
  L←I 0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆12∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/catfirst12'C.Fix S
  L←I ,0 0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆12∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/catfirst12'C.Fix S
  L←I ,0 0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆12∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'catfirst12'C.Fix S
  L←I ,0 0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆13∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/catfirst13'C.Fix S
  L←I ,0 ⋄ R←I ,0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆13∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/catfirst13'C.Fix S
  L←I ,0 ⋄ R←I ,0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATFIRST∆13∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'catfirst13'C.Fix S
  L←I ,0 ⋄ R←I ,0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

:EndNamespace

