:Namespace t0009

r←0.02	⋄ v←0.03

extract_S←{S←0⌷⍵}
extract_X←{S←0⌷⍵ ⋄ X←1⌷⍵}
extract_T←{S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺}
vsqrtT←{S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5}
get_L←{S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5
 L←|(((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT)-vsqrtT}

Run←{S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5
 L←|(((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT)-vsqrtT
 (÷(○2)*0.5)×(*(L×L)÷¯2)×÷1+0.2316419×L}

coeff←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442
CNDP2←{L←|⍵ ⋄ B←⍵≥0
 R←(÷(○2)*0.5)×(*(L×L)÷¯2)×{coeff+.×⍵*1+⍳5}¨÷1+0.2316419×L
 (1 ¯1)[B]×((0 ¯1)[B])+R
}
bs←{S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5
 D1←((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT ⋄ D2←D1-vsqrtT
 CD1←CNDP2 D1 ⋄ CD2←CNDP2 D2 ⋄ e←*(-r)×T
 ((S×CD1)-X×e×CD2),[0.5](X×e×1-CD2)-S×1-CD1
}

bs1←{S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5
 ((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT}

bs2←{S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5
 D1←((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT ⋄ D2←D1-vsqrtT ⋄ CNDP2 D1}

CNDP2∆1←{L←|⍵ ⋄ B←⍵≥0
 (÷(○2)*0.5)×(*(L×L)÷¯2)×{coeff+.×⍵*1+⍳5}¨÷1+0.2316419×L}
bs3←{S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5
 D1←((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT ⋄ D2←D1-vsqrtT ⋄ CNDP2∆1 D1}

CNDP2∆2←{L←|⍵ ⋄ B←⍵≥0 ⋄ ÷1+0.2316419×L}
bs4←{S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5
 D1←((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT ⋄ D2←D1-vsqrtT ⋄ CNDP2∆2 D1}

CNDP2∆3←{L←|⍵ ⋄ B←⍵≥0 ⋄ {1+⍵}¨÷1+0.2316419×L}
bs5←{S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5
 D1←((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT ⋄ D2←D1-vsqrtT ⋄ CNDP2∆3 D1}

bs6←{coeff+.×⍵}

bs7←{{coeff+.×⍵*1 2 3 4 5}¨⍵}

CNDP2∆4←{L←|⍵ ⋄ B←⍵≥0 ⋄ {coeff+.×⍵*1+⍳5}¨÷1+0.2316419×L}
bs8←{S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5
 D1←((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT ⋄ D2←D1-vsqrtT ⋄ CNDP2∆4 D1}

CNDP2∆5←{L←|⍵ ⋄ B←⍵≥0 ⋄ 5×{coeff+.×⍵*1+⍳5}¨÷1+0.2316419×L}
bs9←{S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5
 D1←((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT ⋄ D2←D1-vsqrtT ⋄ CNDP2 D1}

:EndNamespace