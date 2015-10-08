:Namespace bs1

S←':Namespace' 'r←0.02	⋄ v←0.03' 
S,←'Run←{' 'S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5'
S,←'((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT' '}' ':EndNamespace'

NS←⎕FIX S ⋄ C←#.codfns

GD←{⍉↑(5+?⍵⍴25)(1+?⍵⍴100)(0.25+100÷⍨?⍵⍴1000)}

MK∆TST←{id cmp fn←⍺⍺ ⋄ ls rs←⍵⍵ ⋄ l←⍎ls ⋄ r←⍎rs
  ~(⊂cmp)∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←cmp ⋄ CS←('bs',⍕id)C.Fix S
  #.UT.expect←l(⍎'NS.',fn)r ⋄ l(⍎'CS.',fn)r
}

D←⍉GD 7 ⋄ R←⊃((⎕DR 2↑D)323)⎕DR 2↑D ⋄ L←,¯1↑D

BS1∆GCC_TEST←'1' 'gcc'   'Run' MK∆TST 'L' 'R' 
BS1∆ICC_TEST←'1' 'icc'   'Run' MK∆TST 'L' 'R' 
BS1∆VSC_TEST←'1' 'vsc'   'Run' MK∆TST 'L' 'R' 
BS1∆PGCC_TEST←'1' 'pgcc' 'Run' MK∆TST 'L' 'R' 

:EndNamespace
