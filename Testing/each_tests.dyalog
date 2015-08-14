:Namespace minus

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'R1←{⍺-¨⍵}' 'R2←{⍺{⍺-⍵}¨⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

EACH∆1II∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/each1ii'C.Fix S
  #.UT.expect←I NS.R1 I ⋄ I CS.R1 I
}

EACH∆1II∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/each1ii'C.Fix S
  #.UT.expect←I NS.R1 I ⋄ I CS.R1 I
}

EACH∆1II∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'each1ii'C.Fix S
  #.UT.expect←I NS.R1 I ⋄ I CS.R1 I
}

EACH∆1FF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/each1ff'C.Fix S
  #.UT.expect←F NS.R1 F ⋄ F CS.R1 F
}

EACH∆1FF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/each1ff'C.Fix S
  #.UT.expect←F NS.R1 F ⋄ F CS.R1 F
}

EACH∆1FF∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'each1ff'C.Fix S
  #.UT.expect←F NS.R1 F ⋄ F CS.R1 F
}

EACH∆1IF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/each1if'C.Fix S
  #.UT.expect←I NS.R1 F ⋄ I CS.R1 F
}

EACH∆1IF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/each1if'C.Fix S
  #.UT.expect←I NS.R1 F ⋄ I CS.R1 F
}

EACH∆1IF∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'each1if'C.Fix S
  #.UT.expect←I NS.R1 F ⋄ I CS.R1 F
}

EACH∆1FI∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/each1fi'C.Fix S
  #.UT.expect←F NS.R1 I ⋄ F CS.R1 I
}

EACH∆1FI∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/each1fi'C.Fix S
  #.UT.expect←F NS.R1 I ⋄ F CS.R1 I
}

EACH∆1FI∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'each1fi'C.Fix S
  #.UT.expect←F NS.R1 I ⋄ F CS.R1 I
}

EACH∆2II∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/each2ii'C.Fix S
  #.UT.expect←I NS.R2 I ⋄ I CS.R2 I
}

EACH∆2II∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/each2ii'C.Fix S
  #.UT.expect←I NS.R2 I ⋄ I CS.R2 I
}

EACH∆2II∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'each2ii'C.Fix S
  #.UT.expect←I NS.R2 I ⋄ I CS.R2 I
}

EACH∆2FF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/each2ff'C.Fix S
  #.UT.expect←F NS.R2 F ⋄ F CS.R2 F
}

EACH∆2FF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/each2ff'C.Fix S
  #.UT.expect←F NS.R2 F ⋄ F CS.R2 F
}

EACH∆2FF∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'each2ff'C.Fix S
  #.UT.expect←F NS.R2 F ⋄ F CS.R2 F
}

EACH∆2IF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/each2if'C.Fix S
  #.UT.expect←I NS.R2 F ⋄ I CS.R2 F
}

EACH∆2IF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/each2if'C.Fix S
  #.UT.expect←I NS.R2 F ⋄ I CS.R2 F
}

EACH∆2IF∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'each2if'C.Fix S
  #.UT.expect←I NS.R2 F ⋄ I CS.R2 F
}

EACH∆2FI∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/each2fi'C.Fix S
  #.UT.expect←F NS.R2 I ⋄ F CS.R2 I
}

EACH∆2FI∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/each2fi'C.Fix S
  #.UT.expect←F NS.R2 I ⋄ F CS.R2 I
}

EACH∆2FI∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'each2fi'C.Fix S
  #.UT.expect←F NS.R2 I ⋄ F CS.R2 I
}

:EndNamespace

