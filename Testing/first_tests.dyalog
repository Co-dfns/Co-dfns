:Namespace first

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{⊃⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

FIRST∆01∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/first01'C.Fix S
  R←I ⍬ ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

FIRST∆01∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/first01'C.Fix S
  R←I ⍬ ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

FIRST∆01∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'first01'C.Fix S
  R←I ⍬ ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

FIRST∆02∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/first02'C.Fix S
  R←I 0 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

FIRST∆02∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/first02'C.Fix S
  R←I 0 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

FIRST∆02∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'first02'C.Fix S
  R←I 0 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

FIRST∆03∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/first03'C.Fix S
  R←I ⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

FIRST∆03∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/first03'C.Fix S
  R←I ⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

FIRST∆03∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'first03'C.Fix S
  R←I ⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

FIRST∆04∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/first04'C.Fix S
  R←÷I 2 3 4⍴1+⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

FIRST∆04∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/first04'C.Fix S
  R←÷I 2 3 4⍴1+⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

FIRST∆04∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'first04'C.Fix S
  R←÷I 2 3 4⍴1+⍳5 ⋄ #.UT.expect←NS.Run R ⋄ CS.Run R
}

:EndNamespace

