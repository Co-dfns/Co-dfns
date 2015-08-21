:Namespace reduce

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}

S←':Namespace' 'Run←{+/⍵}' 'R2←{×/⍵}' 'R3←{{⍺+⍵}/⍵}' ':EndNamespace'

NS←⎕FIX S ⋄ C←#.codfns

REDUCE∆1∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reduce1'C.Fix S
  #.UT.expect←NS.Run I ⍬⍴1 ⋄ CS.Run I ⍬⍴1
}

REDUCE∆1∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reduce1'C.Fix S
  #.UT.expect←NS.Run I ⍬⍴1 ⋄ CS.Run I ⍬⍴1
}

REDUCE∆1∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reduce1'C.Fix S
  #.UT.expect←NS.Run I ⍬⍴1 ⋄ CS.Run I ⍬⍴1
}

REDUCE∆2∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reduce2'C.Fix S
  #.UT.expect←NS.Run I 5⍴⍳5 ⋄ CS.Run I 5⍴⍳5
}

REDUCE∆2∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reduce2'C.Fix S
  #.UT.expect←NS.Run I 5⍴⍳5 ⋄ CS.Run I 5⍴⍳5
}

REDUCE∆2∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'Sreduce2'C.Fix S
  #.UT.expect←NS.Run I 5⍴⍳5 ⋄ CS.Run I 5⍴⍳5
}

REDUCE∆3∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reduce3'C.Fix S
  #.UT.expect←NS.Run I 3 3⍴⍳9 ⋄ CS.Run I 3 3⍴⍳9
}

REDUCE∆3∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reduce3'C.Fix S
  #.UT.expect←NS.Run I 3 3⍴⍳9 ⋄ CS.Run I 3 3⍴⍳9
}

REDUCE∆3∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reduce3'C.Fix S
  #.UT.expect←NS.Run I 3 3⍴⍳9 ⋄ CS.Run I 3 3⍴⍳9
}

REDUCE∆4∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reduce4'C.Fix S
  #.UT.expect←NS.R2 I ⍬⍴3 ⋄ CS.R2 I ⍬⍴3
}

REDUCE∆4∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reduce4'C.Fix S
  #.UT.expect←NS.R2 I ⍬⍴3 ⋄ CS.R2 I ⍬⍴3
}

REDUCE∆4∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reduce4'C.Fix S
  #.UT.expect←NS.R2 I ⍬⍴3 ⋄ CS.R2 I ⍬⍴3
}

REDUCE∆5∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reduce5'C.Fix S
  #.UT.expect←NS.R2 I ⍬ ⋄ CS.R2 I ⍬
}

REDUCE∆5∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reduce5'C.Fix S
  #.UT.expect←NS.R2 I ⍬ ⋄ CS.R2 I ⍬
}

REDUCE∆5∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reduce5'C.Fix S
  #.UT.expect←NS.R2 I ⍬ ⋄ CS.R2 I ⍬
}

REDUCE∆6∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reduce6'C.Fix S
  #.UT.expect←NS.Run I ⍬ ⋄ CS.Run I ⍬
}

REDUCE∆6∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reduce6'C.Fix S
  #.UT.expect←NS.Run I ⍬ ⋄ CS.Run I ⍬
}

REDUCE∆6∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reduce6'C.Fix S
  #.UT.expect←NS.Run I ⍬ ⋄ CS.Run I ⍬
}

REDUCE∆7∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reduce7'C.Fix S
  #.UT.expect←NS.R3 I ⍬⍴1 ⋄ CS.R3 I ⍬⍴1
}

REDUCE∆7∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reduce7'C.Fix S
  #.UT.expect←NS.R3 I ⍬⍴1 ⋄ CS.R3 I ⍬⍴1
}

REDUCE∆7∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reduce7'C.Fix S
  #.UT.expect←NS.R3 I ⍬⍴1 ⋄ CS.R3 I ⍬⍴1
}

REDUCE∆8∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reduce8'C.Fix S
  #.UT.expect←NS.R3 I 5⍴⍳5 ⋄ CS.R3 I 5⍴⍳5
}

REDUCE∆8∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reduce8'C.Fix S
  #.UT.expect←NS.R3 I 5⍴⍳5 ⋄ CS.R3 I 5⍴⍳5
}

REDUCE∆8∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'Sreduce8'C.Fix S
  #.UT.expect←NS.R3 I 5⍴⍳5 ⋄ CS.R3 I 5⍴⍳5
}

REDUCE∆9∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reduce9'C.Fix S
  #.UT.expect←NS.R3 I 3 3⍴⍳9 ⋄ CS.R3 I 3 3⍴⍳9
}

REDUCE∆9∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reduce9'C.Fix S
  #.UT.expect←NS.R3 I 3 3⍴⍳9 ⋄ CS.R3 I 3 3⍴⍳9
}

REDUCE∆9∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reduce9'C.Fix S
  #.UT.expect←NS.R3 I 3 3⍴⍳9 ⋄ CS.R3 I 3 3⍴⍳9
}

:EndNamespace

