:Namespace catenate

I←{⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{⍺,⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

CATENATE∆01∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/catenate01'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I ⍬ ⋄ R←I ⍬ ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATENATE∆01∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/catenate01'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I ⍬ ⋄ R←I ⍬ ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATENATE∆02∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/catenate02'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I 0 ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATENATE∆02∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/catenate02'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I 0 ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATENATE∆03∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/catenate03'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I ⍬ ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATENATE∆03∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/catenate03'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I ⍬ ⋄ R←I 0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATENATE∆04∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/catenate04'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I ⍬ ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATENATE∆04∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/catenate04'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I ⍬ ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATENATE∆05∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/catenate05'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I ⍳7 ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATENATE∆05∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/catenate05'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I ⍳7 ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATENATE∆06∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/catenate06'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I 0 ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATENATE∆06∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/catenate06'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I 0 ⋄ R←I ⍳5 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATENATE∆07∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/catenate07'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I 2 2⍴0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATENATE∆07∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/catenate07'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I 2 2⍴0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATENATE∆08∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/catenate08'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I 2 2 3⍴0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATENATE∆08∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/catenate08'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I 2 2 3⍴0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATENATE∆09∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/catenate09'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I 2 2⍴0 ⋄ R←I 2 2 3⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATENATE∆09∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/catenate09'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I 2 2⍴0 ⋄ R←I 2 2 3⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATENATE∆10∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/catenate10'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I 2 2⍴0 ⋄ R←I 2 2 3⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATENATE∆10∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/catenate10'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I 2 2⍴0 ⋄ R←I 2 2 3⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

⍝ Commented out pending information on ⎕DR bug report

⍝ CATENATE∆11∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
⍝   C.COMPILER←'gcc' ⋄ CS←'Scratch/catenate11'C.Fix S ⋄ C.COMPILER←'gcc'
⍝   L←I 0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
⍝ }

⍝ CATENATE∆11∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
⍝   C.COMPILER←'icc' ⋄ CS←'Scratch/catenate11'C.Fix S ⋄ C.COMPILER←'gcc'
⍝   L←I 0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
⍝ }

⍝ Commented out pending information from Dyalog on appropriate behavior

⍝ CATENATE∆12∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
⍝   C.COMPILER←'gcc' ⋄ CS←'Scratch/catenate12'C.Fix S ⋄ C.COMPILER←'gcc'
⍝   L←I ,0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
⍝ }

⍝ CATENATE∆12∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
⍝   C.COMPILER←'icc' ⋄ CS←'Scratch/catenate12'C.Fix S ⋄ C.COMPILER←'gcc'
⍝   L←I ,0 ⋄ R←I 2 2⍴0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
⍝ }

CATENATE∆13∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/catenate13'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I ,0 ⋄ R←I ,0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

CATENATE∆13∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/catenate13'C.Fix S ⋄ C.COMPILER←'gcc'
  L←I ,0 ⋄ R←I ,0 ⋄ #.UT.expect←L NS.Run R ⋄ L CS.Run R
}

:EndNamespace

