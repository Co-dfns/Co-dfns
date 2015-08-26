:Namespace scanfirst

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}

S←':Namespace' 'Run←{+⍀⍵}' 'R2←{×⍀⍵}' 'R3←{{⍺+⍵}⍀⍵}' ':EndNamespace'

NS←⎕FIX S ⋄ C←#.codfns

SCANFIRST∆1∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/scanfirst1'C.Fix S
  #.UT.expect←NS.Run I ⍬⍴1 ⋄ CS.Run I ⍬⍴1
}

SCANFIRST∆1∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/scanfirst1'C.Fix S
  #.UT.expect←NS.Run I ⍬⍴1 ⋄ CS.Run I ⍬⍴1
}

SCANFIRST∆1∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'scanfirst1'C.Fix S
  #.UT.expect←NS.Run I ⍬⍴1 ⋄ CS.Run I ⍬⍴1
}

SCANFIRST∆2∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/scanfirst2'C.Fix S
  #.UT.expect←NS.Run I 5⍴⍳5 ⋄ CS.Run I 5⍴⍳5
}

SCANFIRST∆2∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/scanfirst2'C.Fix S
  #.UT.expect←NS.Run I 5⍴⍳5 ⋄ CS.Run I 5⍴⍳5
}

SCANFIRST∆2∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'scanfirst2'C.Fix S
  #.UT.expect←NS.Run I 5⍴⍳5 ⋄ CS.Run I 5⍴⍳5
}

SCANFIRST∆3∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/scanfirst3'C.Fix S
  #.UT.expect←NS.Run I 3 3⍴⍳9 ⋄ CS.Run I 3 3⍴⍳9
}

SCANFIRST∆3∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/scanfirst3'C.Fix S
  #.UT.expect←NS.Run I 3 3⍴⍳9 ⋄ CS.Run I 3 3⍴⍳9
}

SCANFIRST∆3∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'scanfirst3'C.Fix S
  #.UT.expect←NS.Run I 3 3⍴⍳9 ⋄ CS.Run I 3 3⍴⍳9
}

SCANFIRST∆4∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/scanfirst4'C.Fix S
  #.UT.expect←NS.R2 I ⍬⍴3 ⋄ CS.R2 I ⍬⍴3
}

SCANFIRST∆4∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/scanfirst4'C.Fix S
  #.UT.expect←NS.R2 I ⍬⍴3 ⋄ CS.R2 I ⍬⍴3
}

SCANFIRST∆4∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'scanfirst4'C.Fix S
  #.UT.expect←NS.R2 I ⍬⍴3 ⋄ CS.R2 I ⍬⍴3
}

SCANFIRST∆5∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/scanfirst5'C.Fix S
  #.UT.expect←NS.R2 I ⍬ ⋄ CS.R2 I ⍬
}

SCANFIRST∆5∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/scanfirst5'C.Fix S
  #.UT.expect←NS.R2 I ⍬ ⋄ CS.R2 I ⍬
}

SCANFIRST∆5∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'scanfirst5'C.Fix S
  #.UT.expect←NS.R2 I ⍬ ⋄ CS.R2 I ⍬
}

SCANFIRST∆6∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/scanfirst6'C.Fix S
  #.UT.expect←NS.Run I ⍬ ⋄ CS.Run I ⍬
}

SCANFIRST∆6∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/scanfirst6'C.Fix S
  #.UT.expect←NS.Run I ⍬ ⋄ CS.Run I ⍬
}

SCANFIRST∆6∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'scanfirst6'C.Fix S
  #.UT.expect←NS.Run I ⍬ ⋄ CS.Run I ⍬
}

SCANFIRST∆7∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/scanfirst7'C.Fix S
  #.UT.expect←NS.R3 I ⍬⍴1 ⋄ CS.R3 I ⍬⍴1
}

SCANFIRST∆7∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/scanfirst7'C.Fix S
  #.UT.expect←NS.R3 I ⍬⍴1 ⋄ CS.R3 I ⍬⍴1
}

SCANFIRST∆7∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'scanfirst7'C.Fix S
  #.UT.expect←NS.R3 I ⍬⍴1 ⋄ CS.R3 I ⍬⍴1
}

SCANFIRST∆8∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/scanfirst8'C.Fix S
  #.UT.expect←NS.R3 I 5⍴⍳5 ⋄ CS.R3 I 5⍴⍳5
}

SCANFIRST∆8∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/scanfirst8'C.Fix S
  #.UT.expect←NS.R3 I 5⍴⍳5 ⋄ CS.R3 I 5⍴⍳5
}

SCANFIRST∆8∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'scanfirst8'C.Fix S
  #.UT.expect←NS.R3 I 5⍴⍳5 ⋄ CS.R3 I 5⍴⍳5
}

SCANFIRST∆9∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/scanfirst9'C.Fix S
  #.UT.expect←NS.R3 I 3 3⍴⍳9 ⋄ CS.R3 I 3 3⍴⍳9
}

SCANFIRST∆9∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/scanfirst9'C.Fix S
  #.UT.expect←NS.R3 I 3 3⍴⍳9 ⋄ CS.R3 I 3 3⍴⍳9
}

SCANFIRST∆9∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'scanfirst9'C.Fix S
  #.UT.expect←NS.R3 I 3 3⍴⍳9 ⋄ CS.R3 I 3 3⍴⍳9
}

:EndNamespace

