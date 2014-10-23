 RF←{⍝ Resolve Functions: Attribute scope coordinate to functions
     rf←1,1↓f←(1⌷⍉⍵)∊⊂'Function' ⋄ c←(1+d)↑⍤¯1+⍀d∘.=⍳1+⌈/0,d←0⌷⍉⍵ ⋄ w←⍵
     (3⌷⍉rf⌿w)⍪←↓(⊂'coord'),⍪⍕¨↓rf⌿c ⋄ w}