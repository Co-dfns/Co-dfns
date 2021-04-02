:Namespace t0017

circumference∆Run←{○⍵×2}
commute∆Run←{⍺-⍨⍵} ⋄ commute∆Rm←{-⍨⍵}
compose∆Rm←{×∘-⍵} ⋄ compose∆Rd←{⍺×∘-⍵}
compose∆Rl←{5∘×⍵} ⋄ compose∆Rr←{(-∘5)⍵}
each∆R1←{⍺-¨⍵} ⋄ each∆R2←{⍺{⍺-⍵}¨⍵} ⋄ each∆R3←{{÷⍵}¨⍵} ⋄ each∆R4←{÷¨⍵}
each∆R5←{×¨⍵} ⋄ each∆R6←{{×⍵}¨⍵} ⋄ each∆R7←{X←0⌷⍵ ⋄ ⍺{⍺-⍵}¨X}
innerproduct∆R1←{⍺+.×⍵} ⋄ innerproduct∆R2←{⍺{⍺+⍵}.{⍺×⍵}⍵}
innerproduct∆R3←{⍺=.+⍵} ⋄ innerproduct∆R4←{X←0⌷⍺ ⋄ Y←0⌷⍵ ⋄ X{⍺+⍵}.{⍺×⍵}Y}
innerproduct∆R5←{⍺∧.=⍵} ⋄ innerproduct∆R6←{X←0⌷⍵ ⋄ X+.×X}
laminate∆R1←{⍺,[0.5]⍵} ⋄ laminate∆R2←{⍺,[0]⍵} ⋄ laminate∆R3←{⍺,[1]⍵}
laminate∆R4←{⍺,[2]⍵} ⋄ laminate∆R5←{⍺,[¯0.5]⍵}
outerproduct∆R1←{⍺∘.×⍵} ⋄ outerproduct∆R2←{⍺∘.{⍺×⍵}⍵}
outerproduct∆R3←{⍺∘.=⍵} ⋄ outerproduct∆R4←{⍺∘.+⍵}
outerproduct∆R5←{X←0⌷⍵ ⋄ ⍺∘.×X}
power∆R01←{(×⍣⍺)⍵} ⋄ power∆R02←{×⍣⍺⊢⍵} ⋄ power∆R03←{⍺×⍣5⊢⍵}
power∆R04←{⍺(×⍣5)⍵} ⋄ power∆R05←{({×⍵}⍣⍺)⍵} ⋄ power∆R06←{{×⍵}⍣⍺⊢⍵}
power∆R07←{⍺{⍺×⍵}⍣5⊢⍵} ⋄ power∆R08←{⍺({⍺×⍵}⍣5)⍵} ⋄ power∆R09←{○⍣{∨/,100<⍺}⍵}
power∆R10←{○⍣{∨/,100<⍵}⍵} ⋄ power∆R11←{⍺×⍣{∨/,100<⍵}⍵}
power∆R12←{⍺×⍣{∨/,100<⍺}⍵} ⋄ power∆R13←{{○⍵}⍣{∨/,100<⍵}⍵}
power∆R14←{{○⍵}⍣{∨/,100<⍺}⍵} ⋄ power∆R15←{⍺{⍺×⍵}⍣{∨/,100<⍵}⍵}
power∆R16←{⍺{⍺×⍵}⍣{∨/,100<⍺}⍵}
rank∆R1←{(×⍤⍺)⍵} ⋄ rank∆R2←{(≢⍤⍺)⍵} ⋄ rank∆R3←{⍺×⍤1⍤1 2⊢⍵}
rank∆R4←{⍺(≠⍤2)⍵}
redfirst∆R1←{+⌿⍵} ⋄ redfirst∆R2←{×⌿⍵}
redfirst∆R3←{{⍺+⍵}⌿⍵} ⋄ redfirst∆R4←{X←0⌷⍵ ⋄ {⍺+⍵}⌿⍵}
reduce∆R01←{+/⍵} ⋄ reduce∆R02←{×/⍵} ⋄ reduce∆R03←{{⍺+⍵}/⍵}
reduce∆R04←{≠/⍵} ⋄ reduce∆R05←{{⍺≠⍵}/⍵} ⋄ reduce∆R06←{∧/⍵}
reduce∆R07←{-/⍵} ⋄ reduce∆R08←{÷/⍵} ⋄ reduce∆R09←{|/⍵}
reduce∆R10←{⌊/⍵} ⋄ reduce∆R11←{⌈/⍵} ⋄ reduce∆R12←{*/⍵}
reduce∆R13←{!/⍵} ⋄ reduce∆R14←{∧/⍵} ⋄ reduce∆R15←{∨/⍵}
reduce∆R16←{</⍵} ⋄ reduce∆R17←{≤/⍵} ⋄ reduce∆R18←{=/⍵}
reduce∆R19←{≥/⍵} ⋄ reduce∆R20←{>/⍵} ⋄ reduce∆R21←{≠/⍵}
reduce∆R22←{⊤/⍵} ⋄ reduce∆R23←{∪/⍵} ⋄ reduce∆R24←{//⍵}
reduce∆R25←{⌿/⍵} ⋄ reduce∆R26←{\/⍵} ⋄ reduce∆R27←{⍀/⍵}
reduce∆R28←{⌽/⍵} ⋄ reduce∆R29←{⊖/⍵} ⋄ reduce∆R30←{X←0⌷⍵ ⋄ {⍺≠⍵}/X}
reducenwise∆R1←{⍺+/⍵} ⋄ reducenwise∆R2←{⍺×/⍵} ⋄ reducenwise∆R3←{⍺{⍺+⍵}/⍵}
reducenwisefirst∆R1←{⍺+⌿⍵}
reducenwisefirst∆R2←{⍺×⌿⍵}
reducenwisefirst∆R3←{⍺{⍺+⍵}⌿⍵}
scan∆R1←{+\⍵} ⋄ scan∆R2←{×\⍵} ⋄ scan∆R3←{{⍺+⍵}\⍵} ⋄ scan∆R4←{<\⍵}
scanfirst∆R1←{+⍀⍵} ⋄ scanfirst∆R2←{×⍀⍵}
scanfirst∆R3←{{⍺+⍵}⍀⍵} ⋄ scanfirst∆R4←{<⍀⍵}
scanoverrun∆Run←{(⍺=⍺)/⍵}
uniqop∆Run←{(∪⍵)∘.=⍵}

:EndNamespace
