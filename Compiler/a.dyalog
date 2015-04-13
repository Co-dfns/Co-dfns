:Namespace A
  (⎕IO ⎕ML ⎕WX)←0 1 3

  get←{⍺⍺⌷⍉⍵}
  up←⍉(1+1↑⍉)⍪1↓⍉
  bind←{n _ e←⍵ ⋄ (0 nf⌷e)←⊂n ⋄ e}
  
  df tf kf nf←⍳fc←4 ⋄ d←df get ⋄ t←tf get ⋄ k←kf get ⋄ n←nf get
  rf sf vf ef←fc+⍳4 ⋄ r←rf get ⋄ s←sf get ⋄ v←vf get ⋄ e←ef get

  new←{⍉⍪fc↑0 ⍺,⍵}                ⋄ msk←{(t ⍵)∊⊂⍺⍺} ⋄ sel←{(⍺⍺ msk ⍵)⌿⍵}
  A←{('A'new⍬)⍪up⊃⍪/⍵}            ⋄ Am←'A'msk       ⋄ As←'A'sel
  E←{('E'new ⍺⍺)⍪up⊃⍪/⍵}          ⋄ Em←'E'msk       ⋄ Es←'E'sel
  F←{('F'new 1)⍪up⊃⍪/(⊂0 fc⍴⍬),⍵} ⋄ Fm←'F'msk       ⋄ Fs←'F'sel
  M←{('M'new⍬)⍪up⊃⍪/(⊂0 fc⍴⍬),⍵}  ⋄ Mm←'M'msk       ⋄ Ms←'M'sel
  N←{'N'new 0 (⍎⍵)}               ⋄ Nm←'N'msk       ⋄ Ns←'N'sel
  O←{('O'new ⍺⍺)⍪up⊃⍪/⍵}          ⋄ Om←'O'msk       ⋄ Os←'O'sel
  P←{'P'new 0 ⍵}                  ⋄ Pm←'P'msk       ⋄ Ps←'P'sel
  V←{'V'new ⍺⍺ ⍵}                 ⋄ Vm←'V'msk       ⋄ Vs←'V'sel

:EndNamespace


