:Namespace reducenwisefirst

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}

S←':Namespace' 'Run←{⍺+⌿⍵}' 'R2←{⍺×⌿⍵}' 'R3←{⍺{⍺+⍵}⌿⍵}' ':EndNamespace'

NS←⎕FIX S ⋄ C←#.codfns

REDUCENWISEFIRST∆01∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwisefirst01'C.Fix S
  #.UT.expect←(I 0)NS.Run I ⍳4 ⋄ (I 0)CS.Run I ⍳4
}

REDUCENWISEFIRST∆01∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwisefirst01'C.Fix S
  #.UT.expect←(I 0)NS.Run I ⍳4 ⋄ (I 0)CS.Run I ⍳4
}

REDUCENWISEFIRST∆01∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwisefirst01'C.Fix S
  #.UT.expect←(I 0)NS.Run I ⍳4 ⋄ (I 0)CS.Run I ⍳4
}

REDUCENWISEFIRST∆02∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwisefirst02'C.Fix S
  #.UT.expect←(I 1)NS.Run I ⍳4 ⋄ (I 1)CS.Run I ⍳4
}

REDUCENWISEFIRST∆02∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwisefirst02'C.Fix S
  #.UT.expect←(I 1)NS.Run I ⍳4 ⋄ (I 1)CS.Run I ⍳4
}

REDUCENWISEFIRST∆02∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwisefirst02'C.Fix S
  #.UT.expect←(I 1)NS.Run I ⍳4 ⋄ (I 1)CS.Run I ⍳4
}

REDUCENWISEFIRST∆03∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwisefirst03'C.Fix S
  #.UT.expect←(I 2)NS.Run I ⍳4 ⋄ (I 2)CS.Run I ⍳4
}

REDUCENWISEFIRST∆03∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwisefirst03'C.Fix S
  #.UT.expect←(I 2)NS.Run I ⍳4 ⋄ (I 2)CS.Run I ⍳4
}

REDUCENWISEFIRST∆03∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwisefirst03'C.Fix S
  #.UT.expect←(I 2)NS.Run I ⍳4 ⋄ (I 2)CS.Run I ⍳4
}

REDUCENWISEFIRST∆04∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwisefirst04'C.Fix S
  #.UT.expect←(I 4)NS.Run I ⍳4 ⋄ (I 4)CS.Run I ⍳4
}

REDUCENWISEFIRST∆04∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwisefirst04'C.Fix S
  #.UT.expect←(I 4)NS.Run I ⍳4 ⋄ (I 4)CS.Run I ⍳4
}

REDUCENWISEFIRST∆04∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwisefirst04'C.Fix S
  #.UT.expect←(I 4)NS.Run I ⍳4 ⋄ (I 4)CS.Run I ⍳4
}

REDUCENWISEFIRST∆05∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwisefirst05'C.Fix S
  #.UT.expect←(I 5)NS.Run I ⍳4 ⋄ (I 5)CS.Run I ⍳4
}

REDUCENWISEFIRST∆05∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwisefirst05'C.Fix S
  #.UT.expect←(I 5)NS.Run I ⍳4 ⋄ (I 5)CS.Run I ⍳4
}

REDUCENWISEFIRST∆05∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwisefirst05'C.Fix S
  #.UT.expect←(I 5)NS.Run I ⍳4 ⋄ (I 5)CS.Run I ⍳4
}

REDUCENWISEFIRST∆06∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwisefirst06'C.Fix S
  #.UT.expect←(I 2)NS.Run I 3 3⍴⍳4 ⋄ (I 2)CS.Run I 3 3⍴⍳4
}

REDUCENWISEFIRST∆06∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwisefirst06'C.Fix S
  #.UT.expect←(I 2)NS.Run I 3 3⍴⍳4 ⋄ (I 2)CS.Run I 3 3⍴⍳4
}

REDUCENWISEFIRST∆06∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwisefirst06'C.Fix S
  #.UT.expect←(I 2)NS.Run I 3 3⍴⍳4 ⋄ (I 2)CS.Run I 3 3⍴⍳4
}

REDUCENWISEFIRST∆07∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwisefirst07'C.Fix S
  #.UT.expect←(I 0)NS.R2 I ⍳4 ⋄ (I 0)CS.R2 I ⍳4
}

REDUCENWISEFIRST∆07∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwisefirst07'C.Fix S
  #.UT.expect←(I 0)NS.R2 I ⍳4 ⋄ (I 0)CS.R2 I ⍳4
}

REDUCENWISEFIRST∆07∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwisefirst07'C.Fix S
  #.UT.expect←(I 0)NS.R2 I ⍳4 ⋄ (I 0)CS.R2 I ⍳4
}

REDUCENWISEFIRST∆08∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwisefirst08'C.Fix S
  #.UT.expect←(I 1)NS.R2 I ⍳4 ⋄ (I 1)CS.R2 I ⍳4
}

REDUCENWISEFIRST∆08∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwisefirst08'C.Fix S
  #.UT.expect←(I 1)NS.R2 I ⍳4 ⋄ (I 1)CS.R2 I ⍳4
}

REDUCENWISEFIRST∆08∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwisefirst08'C.Fix S
  #.UT.expect←(I 1)NS.R2 I ⍳4 ⋄ (I 1)CS.R2 I ⍳4
}

REDUCENWISEFIRST∆09∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwisefirst09'C.Fix S
  #.UT.expect←(I 2)NS.R2 I ⍳4 ⋄ (I 2)CS.R2 I ⍳4
}

REDUCENWISEFIRST∆09∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwisefirst09'C.Fix S
  #.UT.expect←(I 2)NS.R2 I ⍳4 ⋄ (I 2)CS.R2 I ⍳4
}

REDUCENWISEFIRST∆09∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwisefirst09'C.Fix S
  #.UT.expect←(I 2)NS.R2 I ⍳4 ⋄ (I 2)CS.R2 I ⍳4
}

REDUCENWISEFIRST∆10∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwisefirst10'C.Fix S
  #.UT.expect←(I 4)NS.R2 I ⍳4 ⋄ (I 4)CS.R2 I ⍳4
}

REDUCENWISEFIRST∆10∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwisefirst10'C.Fix S
  #.UT.expect←(I 4)NS.R2 I ⍳4 ⋄ (I 4)CS.R2 I ⍳4
}

REDUCENWISEFIRST∆10∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwisefirst10'C.Fix S
  #.UT.expect←(I 4)NS.R2 I ⍳4 ⋄ (I 4)CS.R2 I ⍳4
}

REDUCENWISEFIRST∆11∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwisefirst11'C.Fix S
  #.UT.expect←(I 5)NS.R2 I ⍳4 ⋄ (I 5)CS.R2 I ⍳4
}

REDUCENWISEFIRST∆11∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwisefirst11'C.Fix S
  #.UT.expect←(I 5)NS.R2 I ⍳4 ⋄ (I 5)CS.R2 I ⍳4
}

REDUCENWISEFIRST∆11∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwisefirst11'C.Fix S
  #.UT.expect←(I 5)NS.R2 I ⍳4 ⋄ (I 5)CS.R2 I ⍳4
}

REDUCENWISEFIRST∆12∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwisefirst12'C.Fix S
  #.UT.expect←(I 2)NS.R2 I 3 3⍴⍳4 ⋄ (I 2)CS.R2 I 3 3⍴⍳4
}

REDUCENWISEFIRST∆12∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwisefirst12'C.Fix S
  #.UT.expect←(I 2)NS.R2 I 3 3⍴⍳4 ⋄ (I 2)CS.R2 I 3 3⍴⍳4
}

REDUCENWISEFIRST∆12∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwisefirst12'C.Fix S
  #.UT.expect←(I 2)NS.R2 I 3 3⍴⍳4 ⋄ (I 2)CS.R2 I 3 3⍴⍳4
}

REDUCENWISEFIRST∆13∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwisefirst13'C.Fix S
  #.UT.expect←(I 1)NS.R3 I ⍳4 ⋄ (I 1)CS.R3 I ⍳4
}

REDUCENWISEFIRST∆13∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwisefirst13'C.Fix S
  #.UT.expect←(I 1)NS.R3 I ⍳4 ⋄ (I 1)CS.R3 I ⍳4
}

REDUCENWISEFIRST∆13∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwisefirst13'C.Fix S
  #.UT.expect←(I 1)NS.R3 I ⍳4 ⋄ (I 1)CS.R3 I ⍳4
}

REDUCENWISEFIRST∆14∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwisefirst14'C.Fix S
  #.UT.expect←(I 2)NS.R3 I ⍳4 ⋄ (I 2)CS.R3 I ⍳4
}

REDUCENWISEFIRST∆14∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwisefirst14'C.Fix S
  #.UT.expect←(I 2)NS.R3 I ⍳4 ⋄ (I 2)CS.R3 I ⍳4
}

REDUCENWISEFIRST∆14∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwisefirst14'C.Fix S
  #.UT.expect←(I 2)NS.R3 I ⍳4 ⋄ (I 2)CS.R3 I ⍳4
}

REDUCENWISEFIRST∆15∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwisefirst15'C.Fix S
  #.UT.expect←(I 4)NS.R3 I ⍳4 ⋄ (I 4)CS.R3 I ⍳4
}

REDUCENWISEFIRST∆15∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwisefirst15'C.Fix S
  #.UT.expect←(I 4)NS.R3 I ⍳4 ⋄ (I 4)CS.R3 I ⍳4
}

REDUCENWISEFIRST∆15∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwisefirst15'C.Fix S
  #.UT.expect←(I 4)NS.R3 I ⍳4 ⋄ (I 4)CS.R3 I ⍳4
}

REDUCENWISEFIRST∆16∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwisefirst16'C.Fix S
  #.UT.expect←(I 5)NS.R3 I ⍳4 ⋄ (I 5)CS.R3 I ⍳4
}

REDUCENWISEFIRST∆16∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwisefirst16'C.Fix S
  #.UT.expect←(I 5)NS.R3 I ⍳4 ⋄ (I 5)CS.R3 I ⍳4
}

REDUCENWISEFIRST∆16∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwisefirst16'C.Fix S
  #.UT.expect←(I 5)NS.R3 I ⍳4 ⋄ (I 5)CS.R3 I ⍳4
}

REDUCENWISEFIRST∆17∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwisefirst17'C.Fix S
  #.UT.expect←(I 2)NS.R3 I 3 3⍴⍳4 ⋄ (I 2)CS.R3 I 3 3⍴⍳4
}

REDUCENWISEFIRST∆17∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwisefirst17'C.Fix S
  #.UT.expect←(I 2)NS.R3 I 3 3⍴⍳4 ⋄ (I 2)CS.R3 I 3 3⍴⍳4
}

REDUCENWISEFIRST∆17∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwisefirst17'C.Fix S
  #.UT.expect←(I 2)NS.R3 I 3 3⍴⍳4 ⋄ (I 2)CS.R3 I 3 3⍴⍳4
}



:EndNamespace

