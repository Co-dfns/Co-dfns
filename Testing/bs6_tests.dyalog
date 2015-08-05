:Namespace bs6

BS←⊂':Namespace'
BS,←⊂'coeff←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442'
BS,←'Run←{coeff+.×⍵}' ':EndNamespace'

NS←⎕FIX BS
C←#.codfns

coeff←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442

BS6∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc'
  CN←'Scratch/bs6'C.Fix BS
  #.UT.expect←interp←NS.Run coeff
  CN.Run coeff}

BS6∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc'
  CN←'Scratch/bs6'C.Fix BS
  #.UT.expect←interp←NS.Run coeff
  CN.Run coeff}

BS6∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc'
  CN←'bs6'C.Fix BS
  #.UT.expect←interp←NS.Run coeff
  CN.Run coeff}

:EndNamespace
