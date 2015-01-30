:Namespace R
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ pp←#.pp
  var←##.G.var ⋄ nl←##.G.nl
  prs←'relp(rslt);',nl
  fdb←⍉⍪,¨'⌷' 'idx'
  idxc←'unsigned r=rgt->p->RANK-lft->p->RANK;BOUND s[r];',nl
  idxc,←'int i,j;for(i=0,j=lft->p->RANK;i<r;i++,j++){s[0]=rgt->p->SHAPETC[j];}',nl
  idxc,←'getarray(rgt->p->ELTYPE,r,s,rslt);',nl
  idxc,←'size_t c;for(i=0,c=1;i<r;i++){c*=s[i];}',nl
  idxc,←'aplint32*v=ARRAYSTART(lft->p);size_t k;',nl
  idxc,←'for(i=0,k=0;i<lft->p->SHAPETC[0];i++){k+=v[i]*rgt->p->SHAPETC[i+1];}',nl

  idx←{idxc}
  gb←{'LOCALP*',⍺,'=',⍵,';'}
  grh←{'{',(⊃,/'rslt' 'lft' 'rgt'gb¨⍺ var¨↓⍉⍵),prs}
  dff←{'default();',nl}
  gd←{d←⍵⍵⍪fdb ⋄ (⍺ grh ⍵),(⍎'⍬',⍨((0⌷⍉d)⍳⊂⍺⍺)⊃(1⌷⍉d),⊂'dff'),'}',nl}
:EndNamespace

