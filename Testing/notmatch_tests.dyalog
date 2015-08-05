:Namespace notmatch

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{⍺≢⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

NOTMATCH∆01∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/notmatch01'C.Fix S
  L←I ⍬ ⋄ R←I ⍬ ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆01∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/notmatch01'C.Fix S
  L←I ⍬ ⋄ R←I ⍬ ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆01∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'notmatch01'C.Fix S
  L←I ⍬ ⋄ R←I ⍬ ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆02∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/notmatch02'C.Fix S
  L←I 0 ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆02∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/notmatch02'C.Fix S
  L←I 0 ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆02∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'notmatch02'C.Fix S
  L←I 0 ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆03∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/notmatch03'C.Fix S
  L←I ⍬ ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆03∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/notmatch03'C.Fix S
  L←I ⍬ ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆03∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'notmatch03'C.Fix S
  L←I ⍬ ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆04∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/notmatch04'C.Fix S
  L←I ⍬ ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆04∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/notmatch04'C.Fix S
  L←I ⍬ ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆04∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'notmatch04'C.Fix S
  L←I ⍬ ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆05∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/notmatch05'C.Fix S
  L←I ⍳7 ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆05∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/notmatch05'C.Fix S
  L←I ⍳7 ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆05∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'notmatch05'C.Fix S
  L←I ⍳7 ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆06∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/notmatch06'C.Fix S
  L←I 0 ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆06∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/notmatch06'C.Fix S
  L←I 0 ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆06∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'notmatch06'C.Fix S
  L←I 0 ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆07∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/notmatch07'C.Fix S
  L←I 2 2⍴0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆07∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/notmatch07'C.Fix S
  L←I 2 2⍴0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆07∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'notmatch07'C.Fix S
  L←I 2 2⍴0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆08∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/notmatch08'C.Fix S
  L←I 2 2 3⍴0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆08∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/notmatch08'C.Fix S
  L←I 2 2 3⍴0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆08∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'notmatch08'C.Fix S
  L←I 2 2 3⍴0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆09∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/notmatch09'C.Fix S
  L←I 2 2⍴0 ⋄ R←I 2 2 3⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆09∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/notmatch09'C.Fix S
  L←I 2 2⍴0 ⋄ R←I 2 2 3⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆09∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'notmatch09'C.Fix S
  L←I 2 2⍴0 ⋄ R←I 2 2 3⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆10∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/notmatch10'C.Fix S
  L←I 2 2 3⍴0 ⋄ R←I 2 2 3⍴1 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆10∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/notmatch10'C.Fix S
  L←I 2 2 3⍴0 ⋄ R←I 2 2 3⍴1 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆10∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'notmatch10'C.Fix S
  L←I 2 2 3⍴0 ⋄ R←I 2 2 3⍴1 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆11∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/notmatch11'C.Fix S
  L←I 0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆11∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/notmatch11'C.Fix S
  L←I 0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆11∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'notmatch11'C.Fix S
  L←I 0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆12∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/notmatch12'C.Fix S
  L←I ,0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆12∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/notmatch12'C.Fix S
  L←I ,0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆12∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'notmatch12'C.Fix S
  L←I ,0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆13∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/notmatch13'C.Fix S
  L←I ,0 ⋄ R←I ,0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆13∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/notmatch13'C.Fix S
  L←I ,0 ⋄ R←I ,0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

NOTMATCH∆13∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'notmatch13'C.Fix S
  L←I ,0 ⋄ R←I ,0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

:EndNamespace

