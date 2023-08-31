:Namespace t0043

redfirst∆R1←{+⌿⍵} ⋄ redfirst∆R2←{×⌿⍵}
redfirst∆R3←{{⍺+⍵}⌿⍵} ⋄ redfirst∆R4←{X←0⌷⍵ ⋄ {⍺+⍵}⌿⍵}
redfirst∆min←{⌊⌿⍵}
redfirst∆max←{⌈⌿⍵}
redfirst∆and←{∧⌿⍵}
redfirst∆lor←{∨⌿⍵}
redfirst∆xor←{≠⌿⍵}

:EndNamespace
