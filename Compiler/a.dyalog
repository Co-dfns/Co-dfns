:Namespace A
  (⎕IO ⎕ML ⎕WX)←0 1 3
  APLPrims←,¨'+-÷×|*⍟⌈⌊<≤=≠≥>⌷⍴,⍳¨'
  MtN←0 4⍴⍬
  df tf kf nf←⍳fc←4
  
  up←⍉(1+1↑⍉)⍪1↓⍉ ⋄ new←{⍉⍪fc↑0 ⍺,⍵}

  Prm←{'Prm'new⊂⍵} ⋄ Fun←{('Fun'new⍬)⍪up⊃⍪/(⊂MtN),⍵} 
  Var←{'Var'new(,⍺⍺)⍵} ⋄ Exp←{('Exp'new⊂,⍺⍺)⍪up⊃⍪/⍵} ⋄ Fex←{('Fex'new⊂,⍺⍺)⍪up⊃⍪/⍵}
  Nms←{('Nms'new⍬)⍪up⊃⍪/(⊂MtN),⍵} ⋄ Atm←{('Atm'new⍬)⍪up⊃⍪/⍵}
  Bind←{nm _ ex←⍵ ⋄ (0 nf⌷ex)←⊂nm ⋄ ex} ⋄ Num←{'Num'new⊂⍎⍵}

:EndNamespace
