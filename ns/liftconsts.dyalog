LiftConsts←{
     I←¯1 ⋄ mkv←{'LC',⍕I⊣(⊃I)+←1}         ⍝ New variable maker
     at←{2 2⍴'name'⍵'class'⍺}          ⍝ Attribute maker
     ns←'Expression' 'Number'             ⍝ Nodes we care about
     e l←((1⌷⍉a←⍵)∊⊂)¨ns                  ⍝ All Expr and Number nodes
     v←mkv¨⍳+/s←2</0,l                    ⍝ Variables we need; start of literals
     hn←1⌷⍉h←(l∨e∧1⌽l)⌿a                  ⍝ Literal Expressions and node names
     vn←{'Variable' ''('array'at ⍵)}    ⍝ Variable node maker sans depth
     a[s/⍳⊃⍴a;1+⍳3]←↑vn¨v                 ⍝ Replace starting lits with variables
     a←(s∨~l)⌿a                           ⍝ Remove all non-first literals
     h[(i←{(hn∊⊂⍵)/⍳⊃⍴h})1⊃ns;0]←2        ⍝ Literal depths are all 2
     h[i⊃ns;0 3]←1,⍪'atomic'∘at¨v         ⍝ Litexprs are depth 1, with new names
     (1↑a)⍪h⍪1↓a                          ⍝ Connect root, lifted with the rest
 }
