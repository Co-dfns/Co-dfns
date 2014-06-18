 ConvPrims←{ast←⍵
     pm←(1⌷⍉⍵)∊⊂'Primitive'               ⍝ Mask of Primitive nodes
     pn←'name'Prop pm⌿⍵                   ⍝ Primitive names
     cn←(APLPrims⍳pn)⌷¨⊂APLRunts⍪APLRtOps ⍝ Converted names
     hd←⊂1 2⍴'class' 'function'           ⍝ Class is function
     at←(⊂'mname' 'dname')(hd⍪,⍤0)¨cn     ⍝ Monadic and Dyadic names
     vn←(⊂'Variable'),(⊂''),⍪at           ⍝ Build the basic node structure
     ast⊣(pm⌿ast)←(pm/0⌷⍉⍵),vn            ⍝ Replace Primitive nodes
 }