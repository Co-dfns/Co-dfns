:Namespace R
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ pp←#.pp
  var←##.U.var ⋄ nl←##.U.nl ⋄ tl←##.U.tl ⋄ do←##.U.do ⋄ pdo←##.U.pdo
  idx←##.MF.idx ⋄ brki←##.MF.brki ⋄ iotm←##.MF.iotm
  dff←{⍺⍺,'(',(⊃{⍺,',',⍵}/⍵),'); /* Fallback */',nl}
  fdb←3 3⍴,¨ '⌷' idx  ''   '[' brki ''   '⍳' ''   iotm
  grh←{'{',(⊃,/⍺⍺{'LOCALP*',⍺,'=',⍵,';'}¨⍺ var¨↓⍉⍵),nl}
  grhm←'rslt' 'rgt'grh ⋄ grhd←'rslt' 'lft' 'rgt'grh
  lkf←{'(',(((0⌷⍉⍵)⍳⊂⍺⍺)⊃(⍺⌷⍉⍵),⊂'dff'),')'}
  gd←{d←⍵⍵⍪fdb ⋄ (⍺ grhd ⍵),(((0⌷⍉d)⍳⊂⍺⍺)⊃(1⌷⍉d),⊂⍺⍺ dff ⍺),'}',nl}
  gm←{d←⍵⍵⍪fdb ⋄ (⍺ grhm ⍵),(((0⌷⍉d)⍳⊂⍺⍺)⊃(2⌷⍉d),⊂⍺⍺ dff ⍺),'}',nl}
:EndNamespace
