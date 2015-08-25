:Namespace reducefirst

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}

S←':Namespace' 'Run←{+⌿⍵}' 'R2←{×⌿⍵}' 'R3←{{⍺+⍵}⌿⍵}' ':EndNamespace'

NS←⎕FIX S ⋄ C←#.codfns

REDUCEFIRST∆1∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducefirst1'C.Fix S
  #.UT.expect←NS.Run I ⍬⍴1 ⋄ CS.Run I ⍬⍴1
}

REDUCEFIRST∆1∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducefirst1'C.Fix S
  #.UT.expect←NS.Run I ⍬⍴1 ⋄ CS.Run I ⍬⍴1
}

REDUCEFIRST∆1∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducefirst1'C.Fix S
  #.UT.expect←NS.Run I ⍬⍴1 ⋄ CS.Run I ⍬⍴1
}

REDUCEFIRST∆2∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducefirst2'C.Fix S
  #.UT.expect←NS.Run I 5⍴⍳5 ⋄ CS.Run I 5⍴⍳5
}

REDUCEFIRST∆2∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducefirst2'C.Fix S
  #.UT.expect←NS.Run I 5⍴⍳5 ⋄ CS.Run I 5⍴⍳5
}

REDUCEFIRST∆2∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'Sreducefirst2'C.Fix S
  #.UT.expect←NS.Run I 5⍴⍳5 ⋄ CS.Run I 5⍴⍳5
}

REDUCEFIRST∆3∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducefirst3'C.Fix S
  #.UT.expect←NS.Run I 3 3⍴⍳9 ⋄ CS.Run I 3 3⍴⍳9
}

REDUCEFIRST∆3∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducefirst3'C.Fix S
  #.UT.expect←NS.Run I 3 3⍴⍳9 ⋄ CS.Run I 3 3⍴⍳9
}

REDUCEFIRST∆3∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducefirst3'C.Fix S
  #.UT.expect←NS.Run I 3 3⍴⍳9 ⋄ CS.Run I 3 3⍴⍳9
}

REDUCEFIRST∆4∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducefirst4'C.Fix S
  #.UT.expect←NS.R2 I ⍬⍴3 ⋄ CS.R2 I ⍬⍴3
}

REDUCEFIRST∆4∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducefirst4'C.Fix S
  #.UT.expect←NS.R2 I ⍬⍴3 ⋄ CS.R2 I ⍬⍴3
}

REDUCEFIRST∆4∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducefirst4'C.Fix S
  #.UT.expect←NS.R2 I ⍬⍴3 ⋄ CS.R2 I ⍬⍴3
}

REDUCEFIRST∆5∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducefirst5'C.Fix S
  #.UT.expect←NS.R2 I ⍬ ⋄ CS.R2 I ⍬
}

REDUCEFIRST∆5∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducefirst5'C.Fix S
  #.UT.expect←NS.R2 I ⍬ ⋄ CS.R2 I ⍬
}

REDUCEFIRST∆5∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducefirst5'C.Fix S
  #.UT.expect←NS.R2 I ⍬ ⋄ CS.R2 I ⍬
}

REDUCEFIRST∆6∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducefirst6'C.Fix S
  #.UT.expect←NS.Run I ⍬ ⋄ CS.Run I ⍬
}

REDUCEFIRST∆6∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducefirst6'C.Fix S
  #.UT.expect←NS.Run I ⍬ ⋄ CS.Run I ⍬
}

REDUCEFIRST∆6∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducefirst6'C.Fix S
  #.UT.expect←NS.Run I ⍬ ⋄ CS.Run I ⍬
}

REDUCEFIRST∆7∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducefirst7'C.Fix S
  #.UT.expect←NS.R3 I ⍬⍴1 ⋄ CS.R3 I ⍬⍴1
}

REDUCEFIRST∆7∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducefirst7'C.Fix S
  #.UT.expect←NS.R3 I ⍬⍴1 ⋄ CS.R3 I ⍬⍴1
}

REDUCEFIRST∆7∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducefirst7'C.Fix S
  #.UT.expect←NS.R3 I ⍬⍴1 ⋄ CS.R3 I ⍬⍴1
}

REDUCEFIRST∆8∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducefirst8'C.Fix S
  #.UT.expect←NS.R3 I 5⍴⍳5 ⋄ CS.R3 I 5⍴⍳5
}

REDUCEFIRST∆8∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducefirst8'C.Fix S
  #.UT.expect←NS.R3 I 5⍴⍳5 ⋄ CS.R3 I 5⍴⍳5
}

REDUCEFIRST∆8∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'Sreducefirst8'C.Fix S
  #.UT.expect←NS.R3 I 5⍴⍳5 ⋄ CS.R3 I 5⍴⍳5
}

REDUCEFIRST∆9∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reducefirst9'C.Fix S
  #.UT.expect←NS.R3 I 3 3⍴⍳9 ⋄ CS.R3 I 3 3⍴⍳9
}

REDUCEFIRST∆9∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reducefirst9'C.Fix S
  #.UT.expect←NS.R3 I 3 3⍴⍳9 ⋄ CS.R3 I 3 3⍴⍳9
}

REDUCEFIRST∆9∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reducefirst9'C.Fix S
  #.UT.expect←NS.R3 I 3 3⍴⍳9 ⋄ CS.R3 I 3 3⍴⍳9
}

:EndNamespace

