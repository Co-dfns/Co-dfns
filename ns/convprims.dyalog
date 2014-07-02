CP←{ast←⍵
     pm←(1⌷⍉⍵)∊⊂'Primitive'               ⍝ Mask of Primitive nodes
     pn←'name'Prop pm⌿⍵                   ⍝ Primitive names
     cn←(APLPrims⍳pn)⌷¨⊂APLRunts⍪APLRtOps ⍝ Converted names
     hd←⍉⍪'class' 'function'              ⍝ Class is function
     at←(⊂⊂'name')(hd⍪,)¨cn               ⍝ Name of the function
     vn←(⊂'Variable'),(⊂''),⍪at           ⍝ Build the basic node structure
     ast⊣(pm⌿ast)←(pm/0⌷⍉⍵),vn            ⍝ Replace Primitive nodes
}

