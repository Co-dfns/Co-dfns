 LC←{⍝ Lift Constants
     I←¯1 ⋄ mkv←{'LC',⍕I⊣(⊃I)+←1} ⋄ e l←((1⌷⍉a←⍵)∊⊂)¨ns←'Expression' 'Number'
     at←{2 2⍴'name'⍵'class'⍺} ⋄ vn←{'Variable' ''('array'at ⍵)}
     hn←1⌷⍉h←(l∨e∧1⌽l)⌿a ⋄ a[s/⍳⊃⍴a;1+⍳3]←↑vn¨v←mkv¨⍳+/s←2</0,l ⋄ a←(s∨~l)⌿a
     h[(i←{(hn∊⊂⍵)/⍳⊃⍴h})1⊃ns;0]←2 ⋄ h[i⊃ns;0 3]←1,⍪'atomic'∘at¨v ⋄ (1↑a)⍪h⍪1↓a}