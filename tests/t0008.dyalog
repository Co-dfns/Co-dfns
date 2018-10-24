:Namespace t0008

r←0.02	⋄ v←0.03

Run←{S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5
 L←|(((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT)-vsqrtT
 (÷(○2)*0.5)×(*(L×L)÷¯2)×÷1+0.2316419×L}

:EndNamespace