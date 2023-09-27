:Namespace t0064

index∆R1←{⍺⌷⍵} ⋄ index∆R2←{1⌷⍵}
index∆R3←{X←⍳⍺ ⋄ Y←⍳⍺ ⋄ X Y⌷⍵}
index∆R4←{R←0⌷⍺ ⋄ C←1⌷⍺ ⋄ I←R↑2↓⍺ ⋄ J←C↑(2+R)↓⍺ ⋄ I J⌷⍵}

:EndNamespace