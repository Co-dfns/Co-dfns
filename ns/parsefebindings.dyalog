ParseFeBindings←{
     1=≢⍺:⍵                      ⍝ Nothing on the line, done
     fp←'Function' 'Primitive'   ⍝ Looking for Functions and Prims
     ~fp∨.≡⊂0(0 1)⊃⌽k←1 Kids ⍺:⍵ ⍝ Not a function line, done
     ok←⊃⍪/(⊂MtAST),¯1↓k         ⍝ Other children
     tm←(1⌷⍉ok)∊⊂'Token'         ⍝ Mask of all Tokens
     tn←'name'Prop tm⌿ok         ⍝ Token names
     ~∧/tn∊⊂,'←':⎕SIGNAL 2       ⍝ Are all tokens assignments?
     ∨/0=2|tm/⍳≢ok:⎕SIGNAL 2     ⍝ Are all tokens separated correctly?
     vm←(1⌷⍉ok)∊⊂'Variable'      ⍝ Mask of all variables
     vn←'name'Prop vm⌿ok         ⍝ Variable names
     ∨/0≠2|vm/⍳≢ok:⎕SIGNAL 2     ⍝ Are all variables before assignments?
     ~∧/vm∨tm:⎕SIGNAL 2          ⍝ Are there only variables, assignments?
     ⍵⍪⍨2,⍨⍪vn                   ⍝ We're good, return new environment
}

