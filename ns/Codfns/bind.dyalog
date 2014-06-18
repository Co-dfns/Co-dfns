 Bind←{
     Ni←(A←0⌷⍉⊃0 3⌷Ast←⍵)⍳⊂'name'
     Ni≥⍴A:Ast⊣(⊃0 3⌷Ast)⍪←'name'⍺
     Ast⊣((0 3)(Ni 1)⊃Ast){⍺,⍵,⍨' ' ''⊃⍨0=⍴⍺}←⍺
 }