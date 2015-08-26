:Namespace scan

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}

S←':Namespace' 'Run←{+\⍵}' 'R2←{×\⍵}' 'R3←{{⍺+⍵}\⍵}' ':EndNamespace'

NS←⎕FIX S ⋄ C←#.codfns

SCAN∆1∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/scan1'C.Fix S
  #.UT.expect←NS.Run I ⍬⍴1 ⋄ CS.Run I ⍬⍴1
}

SCAN∆1∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/scan1'C.Fix S
  #.UT.expect←NS.Run I ⍬⍴1 ⋄ CS.Run I ⍬⍴1
}

SCAN∆1∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'scan1'C.Fix S
  #.UT.expect←NS.Run I ⍬⍴1 ⋄ CS.Run I ⍬⍴1
}

SCAN∆2∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/scan2'C.Fix S
  #.UT.expect←NS.Run I 5⍴⍳5 ⋄ CS.Run I 5⍴⍳5
}

SCAN∆2∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/scan2'C.Fix S
  #.UT.expect←NS.Run I 5⍴⍳5 ⋄ CS.Run I 5⍴⍳5
}

SCAN∆2∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'scan2'C.Fix S
  #.UT.expect←NS.Run I 5⍴⍳5 ⋄ CS.Run I 5⍴⍳5
}

SCAN∆3∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/scan3'C.Fix S
  #.UT.expect←NS.Run I 3 3⍴⍳9 ⋄ CS.Run I 3 3⍴⍳9
}

SCAN∆3∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/scan3'C.Fix S
  #.UT.expect←NS.Run I 3 3⍴⍳9 ⋄ CS.Run I 3 3⍴⍳9
}

SCAN∆3∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'scan3'C.Fix S
  #.UT.expect←NS.Run I 3 3⍴⍳9 ⋄ CS.Run I 3 3⍴⍳9
}

SCAN∆4∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/scan4'C.Fix S
  #.UT.expect←NS.R2 I ⍬⍴3 ⋄ CS.R2 I ⍬⍴3
}

SCAN∆4∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/scan4'C.Fix S
  #.UT.expect←NS.R2 I ⍬⍴3 ⋄ CS.R2 I ⍬⍴3
}

SCAN∆4∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'scan4'C.Fix S
  #.UT.expect←NS.R2 I ⍬⍴3 ⋄ CS.R2 I ⍬⍴3
}

SCAN∆5∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/scan5'C.Fix S
  #.UT.expect←NS.R2 I ⍬ ⋄ CS.R2 I ⍬
}

SCAN∆5∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/scan5'C.Fix S
  #.UT.expect←NS.R2 I ⍬ ⋄ CS.R2 I ⍬
}

SCAN∆5∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'scan5'C.Fix S
  #.UT.expect←NS.R2 I ⍬ ⋄ CS.R2 I ⍬
}

SCAN∆6∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/scan6'C.Fix S
  #.UT.expect←NS.Run I ⍬ ⋄ CS.Run I ⍬
}

SCAN∆6∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/scan6'C.Fix S
  #.UT.expect←NS.Run I ⍬ ⋄ CS.Run I ⍬
}

SCAN∆6∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'scan6'C.Fix S
  #.UT.expect←NS.Run I ⍬ ⋄ CS.Run I ⍬
}

SCAN∆7∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/scan7'C.Fix S
  #.UT.expect←NS.R3 I ⍬⍴1 ⋄ CS.R3 I ⍬⍴1
}

SCAN∆7∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/scan7'C.Fix S
  #.UT.expect←NS.R3 I ⍬⍴1 ⋄ CS.R3 I ⍬⍴1
}

SCAN∆7∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'scan7'C.Fix S
  #.UT.expect←NS.R3 I ⍬⍴1 ⋄ CS.R3 I ⍬⍴1
}

SCAN∆8∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/scan8'C.Fix S
  #.UT.expect←NS.R3 I 5⍴⍳5 ⋄ CS.R3 I 5⍴⍳5
}

SCAN∆8∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/scan8'C.Fix S
  #.UT.expect←NS.R3 I 5⍴⍳5 ⋄ CS.R3 I 5⍴⍳5
}

SCAN∆8∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'scan8'C.Fix S
  #.UT.expect←NS.R3 I 5⍴⍳5 ⋄ CS.R3 I 5⍴⍳5
}

SCAN∆9∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/scan9'C.Fix S
  #.UT.expect←NS.R3 I 3 3⍴⍳9 ⋄ CS.R3 I 3 3⍴⍳9
}

SCAN∆9∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/scan9'C.Fix S
  #.UT.expect←NS.R3 I 3 3⍴⍳9 ⋄ CS.R3 I 3 3⍴⍳9
}

SCAN∆9∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'scan9'C.Fix S
  #.UT.expect←NS.R3 I 3 3⍴⍳9 ⋄ CS.R3 I 3 3⍴⍳9
}

:EndNamespace

