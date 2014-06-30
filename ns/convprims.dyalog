CP←{ast←⍵
     pm←(1⌷⍉⍵)∊⊂'Primitive'               ⍝ Mask of Primitive nodes
     pn←'name'Prop pm⌿⍵                   ⍝ Primitive names
     cn←(APLPrims⍳pn)⊃¨⊂APLRunts,APLRtOps ⍝ Converted names
     at←⊂1 2⍴'class' 'function'           ⍝ Class is function
     at⍪¨←(⊂⊂'name'),∘⊂¨cn                ⍝ Use the converted name
     vn←(⊂'Variable'),(⊂''),⍪at           ⍝ Build the basic node structure
     ast⊣(pm⌿ast)←(pm/0⌷⍉⍵),vn            ⍝ Replace Primitive nodes
}

