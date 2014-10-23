 FE←{⍝ Flatten Expressions
     ren←{0=≢w←⍵:⍵ ⋄ (0 3⌷w)←⊂(1,⍨~(0⌷⍉a)∊⊂'name')⌿(a←⊃0 3⌷⍵)⍪'name'⍺ ⋄ w}
     mv←{(1+⍺)'Expression' ''(⍉⍪'class' 'atomic')⍪⍉⍪(2+⍺)'Variable' ''(⍉⍪'name'⍵)}
     lf←{m←(⊃⍵)≥0⌷⍉⍵ ⋄ dn←⍉⍪0 '' ''(1 2⍴'name' 'res')
         n←(⊃'name'Prop⊢)¨1↓{(≢n)⊃1↑¨⍺ ⍵⊣n←'name'Prop 1↑⍵}\(⊂dn),p←(⊃m⊂⍺)⊂[0]⊃k←m⊂[0]⍵
         ⊃⍪/(1↓k),⍨⌽((¯1↓b)⍪¨(⊃⍵)mv¨1↓n),¯1↑b←n((⊃⍵){⍺ ren w⊣w[;0]-←⍺⍺-⍨⊃⍵⊣w←⍵})¨p}
     md←(e\('class'Prop e⌿⍵)∊'monadic' 'dyadic')∧e←(1⌷⍉⍵)∊⊂'Expression'
     re←(¯3⌽(1⌷⍉⍵)∊⊂'Condition')∨e∧d=(⊢+⊣×0=⊢)\(e∧1=d←0⌷⍉⍵)+3×(1⌷⍉⍵)∊⊂'Function'
     ⊃⍪/(⊂(e⍳1)↑⍵),lf⌿↑re∘(⊂[0])¨(md∨re)⍵}