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
  _←'Scratch/bs6'#.codfns.C.Fix BS
  _←'Run_gcc'⎕NA'./Scratch/bs6_gcc.so|Run >PP P <PP'
  #.UT.expect←interp←NS.Run coeff
  Run_gcc 0 0 coeff}

BS6∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc'
  _←'Scratch/bs6'#.codfns.C.Fix BS
  _←'Run_icc'⎕NA'./Scratch/bs6_icc.so|Run >PP P <PP'
  #.UT.expect←interp←NS.Run coeff ⋄ C.COMPILER←'gcc'
  Run_icc 0 0 coeff}

:EndNamespace
