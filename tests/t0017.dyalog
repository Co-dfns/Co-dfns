:Namespace t0017

circumference∆Run←{○⍵×2}
scan∆R1←{+\⍵} ⋄ scan∆R2←{×\⍵} ⋄ scan∆R3←{{⍺+⍵}\⍵} ⋄ scan∆R4←{<\⍵}
scanfirst∆R1←{+⍀⍵} ⋄ scanfirst∆R2←{×⍀⍵}
scanfirst∆R3←{{⍺+⍵}⍀⍵} ⋄ scanfirst∆R4←{<⍀⍵}
scanoverrun∆Run←{(⍺=⍺)/⍵}
uniqop∆Run←{(∪⍵)∘.=⍵}

:EndNamespace
