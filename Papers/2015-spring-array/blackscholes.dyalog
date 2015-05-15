:Namepsace
  r←0.02 ⋄ v←0.03
  coeff←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442

  CNDP2←{L←|⍵ ⋄ B←⍵≥0
    R←(÷(○2)*0.5)×(*(L×L)÷¯2)×{coeff+.×⍵*1+⍳5}¨÷1+0.2316419×L
    (1 ¯1)[B]×((0 ¯1)[B])+R
  }

  Run←{
    S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←2⌷⍵ ⋄ vsqrtT←v×T*0.5
    D1←((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT ⋄ D2←D1-vsqrtT
    CD1←CNDP2 D1 ⋄ CD2←CNDP2 D2 ⋄ e←*(-r)×T
    ((S×CD1)-X×e×CD2),[0.5](X×e×1-CD2)-S×1-CD1
  }
:EndNamespace

