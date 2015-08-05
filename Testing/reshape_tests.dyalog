:Namespace reshape

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Rv←{⍺⍴⍵}' 'Rl←{2 2⍴⍵}' 'Rr←{⍺⍴5}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

RESHAPE∆01∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reshape01'C.Fix S
  #.UT.expect←(I 2 2)NS.Rv I ⍳4 ⋄ (I 2 2)CS.Rv I ⍳4
}

RESHAPE∆01∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reshape01'C.Fix S
  #.UT.expect←(I 2 2)NS.Rv I ⍳4 ⋄ (I 2 2)CS.Rv I ⍳4
}

RESHAPE∆01∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reshape01'C.Fix S
  #.UT.expect←(I 2 2)NS.Rv I ⍳4 ⋄ (I 2 2)CS.Rv I ⍳4
}

RESHAPE∆02∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reshape02'C.Fix S
  #.UT.expect←(I 2 2)NS.Rv I ⍳2 ⋄ (I 2 2)CS.Rv I ⍳2
}

RESHAPE∆02∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reshape02'C.Fix S
  #.UT.expect←(I 2 2)NS.Rv I ⍳2 ⋄ (I 2 2)CS.Rv I ⍳2
}

RESHAPE∆02∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reshape02'C.Fix S
  #.UT.expect←(I 2 2)NS.Rv I ⍳2 ⋄ (I 2 2)CS.Rv I ⍳2
}

RESHAPE∆03∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reshape03'C.Fix S
  #.UT.expect←(I 2 2)NS.Rv I ⍳6 ⋄ (I 2 2)CS.Rv I ⍳6
}

RESHAPE∆03∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reshape03'C.Fix S
  #.UT.expect←(I 2 2)NS.Rv I ⍳6 ⋄ (I 2 2)CS.Rv I ⍳6
}

RESHAPE∆03∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reshape03'C.Fix S
  #.UT.expect←(I 2 2)NS.Rv I ⍳6 ⋄ (I 2 2)CS.Rv I ⍳6
}

RESHAPE∆04∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reshape04'C.Fix S
  #.UT.expect←(I ⍬)NS.Rv I ⍳6 ⋄ (I ⍬)CS.Rv I ⍳6
}

RESHAPE∆04∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reshape04'C.Fix S
  #.UT.expect←(I ⍬)NS.Rv I ⍳6 ⋄ (I ⍬)CS.Rv I ⍳6
}

RESHAPE∆04∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reshape04'C.Fix S
  #.UT.expect←(I ⍬)NS.Rv I ⍳6 ⋄ (I ⍬)CS.Rv I ⍳6
}

RESHAPE∆05∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reshape05'C.Fix S
  #.UT.expect←(I 2 2)NS.Rv I ⍬ ⋄ (I 2 2)CS.Rv I ⍬
}

RESHAPE∆05∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reshape05'C.Fix S
  #.UT.expect←(I 2 2)NS.Rv I ⍬ ⋄ (I 2 2)CS.Rv I ⍬
}

RESHAPE∆05∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reshape05'C.Fix S
  #.UT.expect←(I 2 2)NS.Rv I ⍬ ⋄ (I 2 2)CS.Rv I ⍬
}

RESHAPE∆06∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reshape06'C.Fix S
  #.UT.expect←(I 2 2)NS.Rl I ⍳4 ⋄ (I 2 2)CS.Rl I ⍳4
}

RESHAPE∆06∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reshape06'C.Fix S
  #.UT.expect←(I 2 2)NS.Rl I ⍳4 ⋄ (I 2 2)CS.Rl I ⍳4
}

RESHAPE∆06∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reshape06'C.Fix S
  #.UT.expect←(I 2 2)NS.Rl I ⍳4 ⋄ (I 2 2)CS.Rl I ⍳4
}

RESHAPE∆07∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reshape07'C.Fix S
  #.UT.expect←(I 2 2)NS.Rl I ⍳2 ⋄ (I 2 2)CS.Rl I ⍳2
}

RESHAPE∆07∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reshape07'C.Fix S
  #.UT.expect←(I 2 2)NS.Rl I ⍳2 ⋄ (I 2 2)CS.Rl I ⍳2
}

RESHAPE∆07∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reshape07'C.Fix S
  #.UT.expect←(I 2 2)NS.Rl I ⍳2 ⋄ (I 2 2)CS.Rl I ⍳2
}

RESHAPE∆08∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reshape08'C.Fix S
  #.UT.expect←(I 2 2)NS.Rl I ⍳6 ⋄ (I 2 2)CS.Rl I ⍳6
}

RESHAPE∆08∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reshape08'C.Fix S
  #.UT.expect←(I 2 2)NS.Rl I ⍳6 ⋄ (I 2 2)CS.Rl I ⍳6
}

RESHAPE∆08∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reshape08'C.Fix S
  #.UT.expect←(I 2 2)NS.Rl I ⍳6 ⋄ (I 2 2)CS.Rl I ⍳6
}

RESHAPE∆09∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reshape09'C.Fix S
  #.UT.expect←(I ⍬)NS.Rl I ⍳6 ⋄ (I ⍬)CS.Rl I ⍳6
}

RESHAPE∆09∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reshape09'C.Fix S
  #.UT.expect←(I ⍬)NS.Rl I ⍳6 ⋄ (I ⍬)CS.Rl I ⍳6
}

RESHAPE∆09∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reshape09'C.Fix S
  #.UT.expect←(I ⍬)NS.Rl I ⍳6 ⋄ (I ⍬)CS.Rl I ⍳6
}

RESHAPE∆10∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reshape10'C.Fix S
  #.UT.expect←(I 2 2)NS.Rl I ⍬ ⋄ (I 2 2)CS.Rl I ⍬
}

RESHAPE∆10∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reshape10'C.Fix S
  #.UT.expect←(I 2 2)NS.Rl I ⍬ ⋄ (I 2 2)CS.Rl I ⍬
}

RESHAPE∆10∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reshape10'C.Fix S
  #.UT.expect←(I 2 2)NS.Rl I ⍬ ⋄ (I 2 2)CS.Rl I ⍬
}

RESHAPE∆11∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reshape11'C.Fix S
  #.UT.expect←(I 2 2)NS.Rr I ⍳4 ⋄ (I 2 2)CS.Rr I ⍳4
}

RESHAPE∆11∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reshape11'C.Fix S
  #.UT.expect←(I 2 2)NS.Rr I ⍳4 ⋄ (I 2 2)CS.Rr I ⍳4
}

RESHAPE∆11∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reshape11'C.Fix S
  #.UT.expect←(I 2 2)NS.Rr I ⍳4 ⋄ (I 2 2)CS.Rr I ⍳4
}

RESHAPE∆12∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reshape12'C.Fix S
  #.UT.expect←(I 2 2)NS.Rr I ⍳2 ⋄ (I 2 2)CS.Rr I ⍳2
}

RESHAPE∆12∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reshape12'C.Fix S
  #.UT.expect←(I 2 2)NS.Rr I ⍳2 ⋄ (I 2 2)CS.Rr I ⍳2
}

RESHAPE∆12∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reshape12'C.Fix S
  #.UT.expect←(I 2 2)NS.Rr I ⍳2 ⋄ (I 2 2)CS.Rr I ⍳2
}

RESHAPE∆13∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reshape13'C.Fix S
  #.UT.expect←(I 2 2)NS.Rr I ⍳6 ⋄ (I 2 2)CS.Rr I ⍳6
}

RESHAPE∆13∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reshape13'C.Fix S
  #.UT.expect←(I 2 2)NS.Rr I ⍳6 ⋄ (I 2 2)CS.Rr I ⍳6
}

RESHAPE∆13∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reshape13'C.Fix S
  #.UT.expect←(I 2 2)NS.Rr I ⍳6 ⋄ (I 2 2)CS.Rr I ⍳6
}

RESHAPE∆14∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reshape14'C.Fix S
  #.UT.expect←(I ⍬)NS.Rr I ⍳6 ⋄ (I ⍬)CS.Rr I ⍳6
}

RESHAPE∆14∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reshape14'C.Fix S
  #.UT.expect←(I ⍬)NS.Rr I ⍳6 ⋄ (I ⍬)CS.Rr I ⍳6
}

RESHAPE∆14∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reshape14'C.Fix S
  #.UT.expect←(I ⍬)NS.Rr I ⍳6 ⋄ (I ⍬)CS.Rr I ⍳6
}

RESHAPE∆15∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/reshape15'C.Fix S
  #.UT.expect←(I 2 2)NS.Rr I ⍬ ⋄ (I 2 2)CS.Rr I ⍬
}

RESHAPE∆15∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/reshape15'C.Fix S
  #.UT.expect←(I 2 2)NS.Rr I ⍬ ⋄ (I 2 2)CS.Rr I ⍬
}

RESHAPE∆15∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'reshape15'C.Fix S
  #.UT.expect←(I 2 2)NS.Rr I ⍬ ⋄ (I 2 2)CS.Rr I ⍬
}

:EndNamespace

