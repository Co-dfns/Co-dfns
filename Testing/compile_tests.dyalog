:Namespace compile

BS←':Namespace' 'r←0.02	⋄ v←0.03' 
BS,←⊂'coeff←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442'
BS,←⊂'CNDP2←{L←|⍵ ⋄ B←⍵≥0'
BS,←⊂'R←(÷(○2)*0.5)×(*(L×L)÷¯2)×{coeff+.×⍵*1+⍳5}¨÷1+0.2316419×L'
BS,←'(1 ¯1)[B]×((0 ¯1)[B])+R' '}'
BS,←'Run←{' 'S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5'
BS,←⊂'D1←((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT ⋄ D2←D1-vsqrtT'
BS,←⊂'CD1←CNDP2 D1 ⋄ CD2←CNDP2 D2 ⋄ e←*(-r)×T'
BS,←⊂'((S×CD1)-X×e×CD2),[0.5](X×e×1-CD2)-S×1-CD1'
BS,←'}' ':EndNamespace'

COMPILE_TEST←{
  #.UT.expect←1 1 1 1 1
  vals←'Run' 1 'CNDP2' 1 'coeff' 0 (,'v') 0 (,'r') 0
  (↓5 2⍴vals)∊↓'compile'#.codfns.Cmp BS
}

:EndNamespace
