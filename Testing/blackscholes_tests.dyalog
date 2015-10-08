:Namespace blackscholes

S←':Namespace' 'r←0.02	⋄ v←0.03' 
S,←⊂'coeff←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442'
S,←⊂'CNDP2←{L←|⍵ ⋄ B←⍵≥0'
S,←⊂'R←(÷(○2)*0.5)×(*(L×L)÷¯2)×{coeff+.×⍵*1+⍳5}¨÷1+0.2316419×L'
S,←'(1 ¯1)[B]×((0 ¯1)[B])+R' '}'
S,←'Run←{' 'S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5'
S,←⊂'D1←((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT ⋄ D2←D1-vsqrtT'
S,←⊂'CD1←CNDP2 D1 ⋄ CD2←CNDP2 D2 ⋄ e←*(-r)×T'
S,←⊂'((S×CD1)-X×e×CD2),[0.5](X×e×1-CD2)-S×1-CD1'
S,←'}' ':EndNamespace'

NS←⎕FIX S ⋄ C←#.codfns

GD←{⍉↑(5+?⍵⍴25)(1+?⍵⍴100)(0.25+100÷⍨?⍵⍴1000)}

MK∆TST←{id cmp fn←⍺⍺ ⋄ ls rs←⍵⍵ ⋄ l←⍎ls ⋄ r←⍎rs
  ~(⊂cmp)∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←cmp ⋄ CS←('blackscholes',⍕id)C.Fix S
  nv←l(⍎'NS.',fn)r ⋄ cv←l(⍎'CS.',fn)r
  #.UT.expect←1 ⋄ ∧/,1e¯12>|nv-cv
}

D←⍉GD 7 ⋄ R←⊃((⎕DR 2↑D)323)⎕DR 2↑D ⋄ L←,¯1↑D

BLACKSCHOLES∆GCC_TEST←'' 'gcc' 'Run' MK∆TST 'L' 'R'
BLACKSCHOLES∆ICC_TEST←'' 'icc' 'Run' MK∆TST 'L' 'R'
BLACKSCHOLES∆VSC_TEST←'' 'vsc' 'Run' MK∆TST 'L' 'R'
BLACKSCHOLES∆PGCC_TEST←'' 'pgcc' 'Run' MK∆TST 'L' 'R'

:EndNamespace
