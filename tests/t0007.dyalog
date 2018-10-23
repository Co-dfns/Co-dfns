:Namespace t0007

add←{⍺+⍵} ⋄ sub←{⍺-⍵} ⋄ mul←{⍺×⍵} ⋄ div←{⍺÷⍵}
pow←{⍺*⍵} ⋄ log←{⍺⍟⍵} ⋄ res←{⍺|⍵} ⋄ min←{⍺⌊⍵}
max←{⍺⌈⍵} ⋄ leq←{⍺≤⍵} ⋄ let←{⍺<⍵} ⋄ eql←{⍺=⍵}
geq←{⍺≥⍵} ⋄ get←{⍺>⍵} ⋄ neq←{⍺≠⍵} ⋄ and←{⍺∧⍵}
lor←{⍺∨⍵} ⋄ nor←{⍺⍱⍵} ⋄ nan←{⍺⍲⍵} ⋄ cir←{⍺○⍵}
bin←{⍺!⍵} ⋄ con←{+⍵}  ⋄ neg←{-⍵}  ⋄ dir←{×⍵}
rec←{÷⍵}  ⋄ exp←{*⍵}  ⋄ nlg←{⍟⍵}  ⋄ mag←{|⍵}
pit←{○⍵}  ⋄ flr←{⌊⍵}  ⋄ cel←{⌈⍵}  ⋄ not←{~⍵}
mat←{⌷⍵}  ⋄ fac←{!⍵}

r←0.02	⋄ v←0.03

Run←{S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5
 L←|(((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT)-vsqrtT
 (÷(○2)*0.5)×(*(L×L)÷¯2)×÷1+0.2316419×L}

:EndNamespace