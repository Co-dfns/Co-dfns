 AV←{⍝ Anchor Variables
     w←⊃⍪/((~m)/w),(m←t/t∧(1⌷⍉⍵)∊⊂'FuncExpr')/w←⍵⊂[0]⍨t←1,1↓1=0⌷⍉⍵
     sb←(k←+\1⌽(1⌷⍉w)∊⊂'Function'){'name'Prop ⍵⌿⍨(1⌷⍉⍵)∊⊂'Expression'}⌸w
     sk←↑,∘⍎¨(gc←'coord'∘Prop)w ⋄ gn←'name'∘Prop
     a←{b←sb[sk⍳{k[⍒k;]⊣k←↑(↓sk)∩(≢⍵)↑¨(1+⍳⍵⍳0)↑¨⊂⍵},⍎⊃gc ⍵;] ⋄ s←⍴b ⋄ b←,b ⋄ w←⍵
         v←(~v\(gn v⌿⍵)∊,¨'⍺⍵')∧(v\(1⌷⍉(1⌽v)⌿⍵)∊⊂'Expression')∧v←(1⌷⍉⍵)∊⊂'Variable'
         (3⌷⍉v⌿w)⍪←'env' 'slot'∘{⍺,⍪⍕¨2↑⍵}¨↓⍉s⊤b⍳gn v⌿⍵ ⋄ ⊂w}
     ⊃⍪/k a⌸w}