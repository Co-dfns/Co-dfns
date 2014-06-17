 Eachk←{
     km←+\(⊃=⊢)0⌷⍉k←1↓⍵ ⍝ Map of children
     (1↑⍵)⍪⊃⍪/km(⊂⍺⍺)⌸k ⍝ Must enclose the intermediate results
 }
