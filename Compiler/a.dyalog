:Namespace A
  (⎕IO ⎕ML ⎕WX)←0 1 3
  APLPrims←,¨'+-÷×|*⍟⌈⌊<≤=≠≥>⌷⍴,⍳¨'
  MtN←0 4⍴⍬
  depth type kind name←⍳fields←4
  
  up←⍉(1+1↑⍉)⍪1↓⍉ ⋄ new←{⍉⍪fields↑0 ⍺,⍵}

  Prim←{'Prm'new⊂⍵} ⋄ Fn←{('Fun'new⍬)⍪up⊃⍪/(⊂MtN),1↓¯1↓⍵} 
  Var←{'Var'new(,⍺⍺)⍵} ⋄ Ex←{('Exp'new⊂,⍺⍺)⍪up⊃⍪/⍵} ⋄ Fe←{('Fex'new⊂,⍺⍺)⍪up⊃⍪/⍵}
  Ns←{('Nms'new⍬)⍪up⊃⍪/(⊂MtN),1↓¯1↓⍵} ⋄ Atm←{('Atm'new⍬)⍪up⊃⍪/⍵}
  Bind←{nm _ ex←⍵ ⋄ (0 name⌷ex)←⊂nm ⋄ ex} ⋄ Num←{'Num'new⊂⍎⍵}

:EndNamespace
