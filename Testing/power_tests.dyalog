:Namespace power

IP←{⊃((⎕DR ⍵)323)⎕DR ⍵}1+?15⍴10 ⋄ IN←{⊃((⎕DR ⍵)323)⎕DR ⍵}¯5+?15⍴10
FP←100÷⍨?15⍴1000 ⋄ FN←100÷⍨¯500+?15⍴1000
S←':Namespace' 'Run←{⍺*⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

POWER∆II∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/powerii'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←IP NS.Run IN ⋄ IP CS.Run IN
}

POWER∆II∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/powerii'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←IP NS.Run IN ⋄ IP CS.Run IN
}

POWER∆FF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/powerff'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←FP NS.Run FN ⋄ FP CS.Run FN
}

POWER∆FF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/powerff'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←FP NS.Run FN ⋄ FP CS.Run FN
}

POWER∆IF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/powerif'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←IP NS.Run FN ⋄ IP CS.Run FN
}

POWER∆IF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/powerif'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←IP NS.Run FN ⋄ IP CS.Run FN
}

POWER∆FI∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/powerfi'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←FP NS.Run IN ⋄ FP CS.Run IN
}

POWER∆FI∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/powerfi'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←FP NS.Run IN ⋄ FP CS.Run IN
}

:EndNamespace

