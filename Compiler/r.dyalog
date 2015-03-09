:Namespace R
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ pp←#.pp
  var←##.U.var ⋄ nl←##.U.nl ⋄ tl←##.U.tl ⋄ do←##.U.do ⋄ pdo←##.U.pdo
  SD←##.SD
  idx←##.MF.idx ⋄ brki←##.MF.brki ⋄ iotm←##.MF.iotm
  comd←##.OP.comd ⋄ comm←##.OP.comm ⋄ eacd←##.OP.eacd ⋄ eacm←##.OP.eacm
  dff←{⍺⍺,'(',(⊃{⍺,',',⍵}/⍵),'); /* Fallback */',nl}
  fdb←3 3⍴,¨ '⌷' idx  ''   '[' brki ''   '⍳' ''   iotm
  grh←{'{',(⊃,/⍺⍺{'LOCALP*',⍺,'=',⍵,';'}¨⍺ var¨↓⍉⍵),nl}
  grhm←'rslt' 'rgt'grh ⋄ grhd←'rslt' 'lft' 'rgt'grh
  lkf←{'(',(((0⌷⍉⍵)⍳⊂⍺⍺)⊃(⍺⌷⍉⍵),⊂'dff'),')'}
  gd←{d←⍵⍵⍪fdb ⋄ (⍺ grhd ⍵),(((0⌷⍉d)⍳⊂⍺⍺)⊃(1⌷⍉d),⊂⍺⍺ dff ⍺),'}',nl}
  gm←{d←⍵⍵⍪fdb ⋄ (⍺ grhm ⍵),(((0⌷⍉d)⍳⊂⍺⍺)⊃(2⌷⍉d),⊂⍺⍺ dff ⍺),'}',nl}
  gf←{⍵,'(rslt,',⍺,',rgt);',nl}
  gs←{'{',(⍺ SD.(crk,grt,gpp,gsp,std,sto) ⍵),'}',nl}
  gomd←{⍎(((0⌷⍉odb)⍳⊂⍺)⊃1⌷⍉odb),' ⍵'} ⋄ gomm←{⍎(((0⌷⍉odb)⍳⊂⍺)⊃2⌷⍉odb),' ⍵'}
  odb←2 3⍴,¨'⍨' 'comd' 'comm' '¨' 'eacd' 'eacm'
:EndNamespace