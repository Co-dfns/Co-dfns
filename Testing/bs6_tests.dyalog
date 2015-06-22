:Namespace bs6

⍝ Test the Black Scholes benchmark for the correct output

BS←⊂':Namespace'
BS,←⊂'coeff←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442'
BS,←'Run←{coeff+.×⍵}' ':EndNamespace'

NS←⎕FIX BS
C←#.codfns.C

coeff←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442

BS6∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc'
  CN←'Scratch/bs6'#.codfns.C.Fix BS
  #.UT.expect←interp←NS.Run coeff
  CN.Run coeff}

BS6∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc'
  CN←'Scratch/bs6'#.codfns.C.Fix BS
  #.UT.expect←interp←NS.Run coeff ⋄ C.COMPILER←'gcc'
  CN.Run coeff}

:EndNamespace
