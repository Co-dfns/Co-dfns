:Namespace t0040

outerproduct∆R1←{⍺∘.×⍵} ⋄ outerproduct∆R2←{⍺∘.{⍺×⍵}⍵}
outerproduct∆R3←{⍺∘.=⍵} ⋄ outerproduct∆R4←{⍺∘.+⍵}
outerproduct∆R5←{X←0⌷⍵ ⋄ ⍺∘.×X}

:EndNamespace
