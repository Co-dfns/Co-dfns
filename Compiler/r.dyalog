:Namespace R
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ pp←#.pp
  var←##.G.var ⋄ nl←##.G.nl
  prs←'relp(rslt);',nl
  fdb←⍉⍪,¨'⌷' 'idx'
  idx←{'⌷(rslt,lft,rgt);',nl}
  gb←{'LOCALP*',⍺,'=',⍵,';'}
  grh←{'{',(⊃,/'rslt' 'lft' 'rgt'gb¨⍺ var¨↓⍉⍵),prs}
  dff←{'default();',nl}
  gd←{d←⍵⍵⍪fdb ⋄ (⍺ grh ⍵),(⍎'⍬',⍨((0⌷⍉d)⍳⊂⍺⍺)⊃(1⌷⍉d),⊂'dff'),'}',nl}
:EndNamespace
