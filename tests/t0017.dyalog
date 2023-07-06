:Namespace t0017

circumference∆Run←{○⍵×2}
scanfirst∆R1←{+⍀⍵} ⋄ scanfirst∆R2←{×⍀⍵}
scanfirst∆R3←{{⍺+⍵}⍀⍵} ⋄ scanfirst∆R4←{<⍀⍵}
scanoverrun∆Run←{(⍺=⍺)/⍵}
uniqop∆Run←{(∪⍵)∘.=⍵}

:EndNamespace
