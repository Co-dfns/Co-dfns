:Namespace bs7

S←⊂':Namespace'
S,←⊂'coeff←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442'
S,←'Run←{{coeff+.×⍵*1 2 3 4 5}¨⍵}' ':EndNamespace'

NS←⎕FIX S ⋄ C←#.codfns

coeff←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442

MK∆TST←{id cmp fn←⍺⍺ ⋄ r←⍎⍵⍵
  ~(⊂cmp)∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←cmp ⋄ CS←('bs7',⍕id)C.Fix S
  #.UT.expect←(⍎'NS.',fn)r ⋄ (⍎'CS.',fn)r
}

BS7∆GCC_TEST←'' 'gcc' 'Run' MK∆TST 'coeff'
BS7∆ICC_TEST←'' 'icc' 'Run' MK∆TST 'coeff'
BS7∆VSC_TEST←'' 'vsc' 'Run' MK∆TST 'coeff'
BS7∆PGCC_TEST←'' 'pgcc' 'Run' MK∆TST 'coeff'

:EndNamespace
