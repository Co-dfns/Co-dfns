:Namespace t0038

innerproduct∆R1←{⍺+.×⍵} ⋄ innerproduct∆R2←{⍺{⍺+⍵}.{⍺×⍵}⍵}
innerproduct∆R3←{⍺=.+⍵} ⋄ innerproduct∆R4←{X←0⌷⍺ ⋄ Y←0⌷⍵ ⋄ X{⍺+⍵}.{⍺×⍵}Y}
innerproduct∆R5←{⍺∧.=⍵} ⋄ innerproduct∆R6←{X←0⌷⍵ ⋄ X+.×X}
innerproduct∆R7←{⍺≠.∧⍵}

:EndNamespace
