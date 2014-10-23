 FD←{⍝ Annotate function with their scope depths
     w←⍵ ⋄ d←¯1++/c∧.(=∨0=⊢)⍉c←↑1↓⍎¨'coord'Prop ⍵
     (3⌷⍉((1⌷⍉w)∊⊂'Function')⌿w)⍪←↓(⊂'depth'),⍪⍕¨d ⋄ w}