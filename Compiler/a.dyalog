:Namespace A
  (⎕IO ⎕ML ⎕WX)←0 1 3
  APLPrims←,¨'+-÷×|*⍟⌈⌊<≤=≠≥>⌷⍴,⍳¨'

  df tf kf nf←⍳fc←4 ⋄ get←{⍺⍺⌷⍉⍵} ⋄ d←df get ⋄ t←tf get ⋄ k←kf get ⋄ n←nf get
  rf sf←fc+⍳2 ⋄ r←rf get ⋄ s←sf get
  
  up←⍉(1+1↑⍉)⍪1↓⍉ ⋄ new←{⍉⍪fc↑0 ⍺,⍵} ⋄ MtN←0 4⍴⍬
  Prm←{'Prm'new⊂⍵} ⋄ Fun←{('Fun'new⍬)⍪up⊃⍪/(⊂MtN),⍵} 
  Var←{'Var'new(,⍺⍺)⍵} ⋄ Exp←{('Exp'new⊂,⍺⍺)⍪up⊃⍪/⍵} ⋄ Fex←{('Fex'new⊂,⍺⍺)⍪up⊃⍪/⍵}
  Nms←{('Nms'new⍬)⍪up⊃⍪/(⊂MtN),⍵} ⋄ Atm←{('Atm'new⍬)⍪up⊃⍪/⍵} ⋄ Num←{'Num'new⊂⍎⍵}
  Bind←{nm _ ex←⍵ ⋄ (0 nf⌷ex)←⊂nm ⋄ ex}
  
  msk←{(t ⍵)∊⊂⍺⍺} ⋄ FexM←'Fex'msk ⋄ FunM←'Fun'msk ⋄ AtmM←'Atm'msk ⋄ NumM←'Num'msk
  ExpM←'Exp'msk
  sel←{(⍺⍺ msk ⍵)⌿⍵} ⋄ FunS←'Fun'sel ⋄ ExpS←'Exp'sel

:EndNamespace


