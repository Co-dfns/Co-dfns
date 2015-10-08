:Namespace and

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
I1←I ?10⍴2
I2←I ?10⍴2

S←':Namespace' 'Run←{⍺∧⍵}' ':EndNamespace'

NS←⎕FIX S ⋄ C←#.codfns

MK∆TST←{id cmp fn←⍺⍺ ⋄ ls rs←⍵⍵ ⋄ l←⍎ls ⋄ r←⍎rs
  ~(⊂cmp)∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←cmp ⋄ CS←('and',⍕id)C.Fix S
  #.UT.expect←l(⍎'NS.',fn)r ⋄ l(⍎'CS.',fn)r
}

AND∆II∆GCC_TEST←'ii' 'gcc'  'Run' MK∆TST 'I1' 'I2'
AND∆II∆ICC_TEST←'ii' 'icc'  'Run' MK∆TST 'I1' 'I2'
AND∆II∆VSC_TEST←'ii' 'vsc'  'Run' MK∆TST 'I1' 'I2'
AND∆II∆PGCC_TEST←'ii' 'pgcc' 'Run' MK∆TST 'I1' 'I2'

:EndNamespace

