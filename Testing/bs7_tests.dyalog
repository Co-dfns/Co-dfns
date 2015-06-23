:Namespace bs7

BS←⊂':Namespace'
BS,←⊂'coeff←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442'
BS,←'Run←{{coeff+.×⍵*1 2 3 4 5}¨⍵}' ':EndNamespace'

NS←⎕FIX BS
C←#.codfns.C

coeff←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442

BS7∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc'
  CN←'Scratch/bs7'#.codfns.C.Fix BS
  #.UT.expect←interp←NS.Run coeff
  CN.Run coeff}

BS7∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc'
  CN←'Scratch/bs7'#.codfns.C.Fix BS
  #.UT.expect←interp←NS.Run coeff ⋄ C.COMPILER←'gcc'
  CN.Run coeff}

:EndNamespace
