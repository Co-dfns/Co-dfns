:Namespace reducenwise

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}

S←':Namespace' 'Run←{⍺+/⍵}' 'R2←{⍺×/⍵}' 'R3←{⍺{⍺+⍵}/⍵}' ':EndNamespace'

NS←⎕FIX S ⋄ C←#.codfns

REDUCENWISE∆01∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwise01'C.Fix S
  #.UT.expect←(I 0)NS.Run I ⍳4 ⋄ (I 0)CS.Run I ⍳4
}

REDUCENWISE∆01∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwise01'C.Fix S
  #.UT.expect←(I 0)NS.Run I ⍳4 ⋄ (I 0)CS.Run I ⍳4
}

REDUCENWISE∆01∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwise01'C.Fix S
  #.UT.expect←(I 0)NS.Run I ⍳4 ⋄ (I 0)CS.Run I ⍳4
}

REDUCENWISE∆02∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwise02'C.Fix S
  #.UT.expect←(I 1)NS.Run I ⍳4 ⋄ (I 1)CS.Run I ⍳4
}

REDUCENWISE∆02∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwise02'C.Fix S
  #.UT.expect←(I 1)NS.Run I ⍳4 ⋄ (I 1)CS.Run I ⍳4
}

REDUCENWISE∆02∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwise02'C.Fix S
  #.UT.expect←(I 1)NS.Run I ⍳4 ⋄ (I 1)CS.Run I ⍳4
}

REDUCENWISE∆03∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwise03'C.Fix S
  #.UT.expect←(I 2)NS.Run I ⍳4 ⋄ (I 2)CS.Run I ⍳4
}

REDUCENWISE∆03∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwise03'C.Fix S
  #.UT.expect←(I 2)NS.Run I ⍳4 ⋄ (I 2)CS.Run I ⍳4
}

REDUCENWISE∆03∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwise03'C.Fix S
  #.UT.expect←(I 2)NS.Run I ⍳4 ⋄ (I 2)CS.Run I ⍳4
}

REDUCENWISE∆04∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwise04'C.Fix S
  #.UT.expect←(I 4)NS.Run I ⍳4 ⋄ (I 4)CS.Run I ⍳4
}

REDUCENWISE∆04∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwise04'C.Fix S
  #.UT.expect←(I 4)NS.Run I ⍳4 ⋄ (I 4)CS.Run I ⍳4
}

REDUCENWISE∆04∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwise04'C.Fix S
  #.UT.expect←(I 4)NS.Run I ⍳4 ⋄ (I 4)CS.Run I ⍳4
}

REDUCENWISE∆05∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwise05'C.Fix S
  #.UT.expect←(I 5)NS.Run I ⍳4 ⋄ (I 5)CS.Run I ⍳4
}

REDUCENWISE∆05∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwise05'C.Fix S
  #.UT.expect←(I 5)NS.Run I ⍳4 ⋄ (I 5)CS.Run I ⍳4
}

REDUCENWISE∆05∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwise05'C.Fix S
  #.UT.expect←(I 5)NS.Run I ⍳4 ⋄ (I 5)CS.Run I ⍳4
}

REDUCENWISE∆06∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwise06'C.Fix S
  #.UT.expect←(I 2)NS.Run I 3 3⍴⍳4 ⋄ (I 2)CS.Run I 3 3⍴⍳4
}

REDUCENWISE∆06∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwise06'C.Fix S
  #.UT.expect←(I 2)NS.Run I 3 3⍴⍳4 ⋄ (I 2)CS.Run I 3 3⍴⍳4
}

REDUCENWISE∆06∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwise06'C.Fix S
  #.UT.expect←(I 2)NS.Run I 3 3⍴⍳4 ⋄ (I 2)CS.Run I 3 3⍴⍳4
}

REDUCENWISE∆07∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwise07'C.Fix S
  #.UT.expect←(I 0)NS.R2 I ⍳4 ⋄ (I 0)CS.R2 I ⍳4
}

REDUCENWISE∆07∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwise07'C.Fix S
  #.UT.expect←(I 0)NS.R2 I ⍳4 ⋄ (I 0)CS.R2 I ⍳4
}

REDUCENWISE∆07∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwise07'C.Fix S
  #.UT.expect←(I 0)NS.R2 I ⍳4 ⋄ (I 0)CS.R2 I ⍳4
}

REDUCENWISE∆08∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwise08'C.Fix S
  #.UT.expect←(I 1)NS.R2 I ⍳4 ⋄ (I 1)CS.R2 I ⍳4
}

REDUCENWISE∆08∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwise08'C.Fix S
  #.UT.expect←(I 1)NS.R2 I ⍳4 ⋄ (I 1)CS.R2 I ⍳4
}

REDUCENWISE∆08∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwise08'C.Fix S
  #.UT.expect←(I 1)NS.R2 I ⍳4 ⋄ (I 1)CS.R2 I ⍳4
}

REDUCENWISE∆09∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwise09'C.Fix S
  #.UT.expect←(I 2)NS.R2 I ⍳4 ⋄ (I 2)CS.R2 I ⍳4
}

REDUCENWISE∆09∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwise09'C.Fix S
  #.UT.expect←(I 2)NS.R2 I ⍳4 ⋄ (I 2)CS.R2 I ⍳4
}

REDUCENWISE∆09∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwise09'C.Fix S
  #.UT.expect←(I 2)NS.R2 I ⍳4 ⋄ (I 2)CS.R2 I ⍳4
}

REDUCENWISE∆10∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwise10'C.Fix S
  #.UT.expect←(I 4)NS.R2 I ⍳4 ⋄ (I 4)CS.R2 I ⍳4
}

REDUCENWISE∆10∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwise10'C.Fix S
  #.UT.expect←(I 4)NS.R2 I ⍳4 ⋄ (I 4)CS.R2 I ⍳4
}

REDUCENWISE∆10∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwise10'C.Fix S
  #.UT.expect←(I 4)NS.R2 I ⍳4 ⋄ (I 4)CS.R2 I ⍳4
}

REDUCENWISE∆11∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwise11'C.Fix S
  #.UT.expect←(I 5)NS.R2 I ⍳4 ⋄ (I 5)CS.R2 I ⍳4
}

REDUCENWISE∆11∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwise11'C.Fix S
  #.UT.expect←(I 5)NS.R2 I ⍳4 ⋄ (I 5)CS.R2 I ⍳4
}

REDUCENWISE∆11∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwise11'C.Fix S
  #.UT.expect←(I 5)NS.R2 I ⍳4 ⋄ (I 5)CS.R2 I ⍳4
}

REDUCENWISE∆12∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwise12'C.Fix S
  #.UT.expect←(I 2)NS.R2 I 3 3⍴⍳4 ⋄ (I 2)CS.R2 I 3 3⍴⍳4
}

REDUCENWISE∆12∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwise12'C.Fix S
  #.UT.expect←(I 2)NS.R2 I 3 3⍴⍳4 ⋄ (I 2)CS.R2 I 3 3⍴⍳4
}

REDUCENWISE∆12∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwise12'C.Fix S
  #.UT.expect←(I 2)NS.R2 I 3 3⍴⍳4 ⋄ (I 2)CS.R2 I 3 3⍴⍳4
}

REDUCENWISE∆13∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwise13'C.Fix S
  #.UT.expect←(I 1)NS.R3 I ⍳4 ⋄ (I 1)CS.R3 I ⍳4
}

REDUCENWISE∆13∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwise13'C.Fix S
  #.UT.expect←(I 1)NS.R3 I ⍳4 ⋄ (I 1)CS.R3 I ⍳4
}

REDUCENWISE∆13∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwise13'C.Fix S
  #.UT.expect←(I 1)NS.R3 I ⍳4 ⋄ (I 1)CS.R3 I ⍳4
}

REDUCENWISE∆14∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwise14'C.Fix S
  #.UT.expect←(I 2)NS.R3 I ⍳4 ⋄ (I 2)CS.R3 I ⍳4
}

REDUCENWISE∆14∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwise14'C.Fix S
  #.UT.expect←(I 2)NS.R3 I ⍳4 ⋄ (I 2)CS.R3 I ⍳4
}

REDUCENWISE∆14∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwise14'C.Fix S
  #.UT.expect←(I 2)NS.R3 I ⍳4 ⋄ (I 2)CS.R3 I ⍳4
}

REDUCENWISE∆15∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwise15'C.Fix S
  #.UT.expect←(I 4)NS.R3 I ⍳4 ⋄ (I 4)CS.R3 I ⍳4
}

REDUCENWISE∆15∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwise15'C.Fix S
  #.UT.expect←(I 4)NS.R3 I ⍳4 ⋄ (I 4)CS.R3 I ⍳4
}

REDUCENWISE∆15∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwise15'C.Fix S
  #.UT.expect←(I 4)NS.R3 I ⍳4 ⋄ (I 4)CS.R3 I ⍳4
}

REDUCENWISE∆16∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwise16'C.Fix S
  #.UT.expect←(I 5)NS.R3 I ⍳4 ⋄ (I 5)CS.R3 I ⍳4
}

REDUCENWISE∆16∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwise16'C.Fix S
  #.UT.expect←(I 5)NS.R3 I ⍳4 ⋄ (I 5)CS.R3 I ⍳4
}

REDUCENWISE∆16∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwise16'C.Fix S
  #.UT.expect←(I 5)NS.R3 I ⍳4 ⋄ (I 5)CS.R3 I ⍳4
}

REDUCENWISE∆17∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducenwise17'C.Fix S
  #.UT.expect←(I 2)NS.R3 I 3 3⍴⍳4 ⋄ (I 2)CS.R3 I 3 3⍴⍳4
}

REDUCENWISE∆17∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducenwise17'C.Fix S
  #.UT.expect←(I 2)NS.R3 I 3 3⍴⍳4 ⋄ (I 2)CS.R3 I 3 3⍴⍳4
}

REDUCENWISE∆17∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducenwise17'C.Fix S
  #.UT.expect←(I 2)NS.R3 I 3 3⍴⍳4 ⋄ (I 2)CS.R3 I 3 3⍴⍳4
}



:EndNamespace

