:Namespace SD
  nl←##.G.nl ⋄ do←##.G.do ⋄ tl←##.G.tl
  sb←{'getarray(',(0⊃⍺),',(unsigned)rk,sp,rslt);',nl,(1⊃⍺),sbb,'c'do ⍵}
  sbb←'*z=ARRAYSTART(rslt->p);l=ARRAYSTART(lft->p);r=ARRAYSTART(rgt->p);',nl
  st←{stdd,((0⊃⍺)sb ⍵),stdi,((1⊃⍺)sb ⍵),stid,((2⊃⍺)sb ⍵),stii,((3⊃⍺)sb ⍵),stfi}
  stt←{'if(',⍺⍺,'->p->ELTYPE==',⍺,'){',⍵,'*',(⊃⍺⍺),';'}
  sti←'APLLONG' 'aplint32' ⋄ std←'APLDOUB' 'double'
  stdd←(⊃'lft'stt/std),nl,(⊃'rgt'stt/std),nl
  stdi←'}else ',(⊃'rgt'stt/sti),nl
  stid←'}else{error(11);}',nl,'}else ',(⊃'lft'stt/sti),nl,(⊃'rgt'stt/std),nl
  stii←'}else ',(⊃'rgt'stt/sti),nl
  stfi←'}else{error(11);}',nl,'}else{error(11);}',nl
  sre←'if(lft->p->RANK==rgt->p->RANK){',nl
  sre,←'rgt->p->RANK'do'if(rgt->p->SHAPETC[i]!=lft->p->SHAPETC[i])error(5);'
  sre,←'BOUND rk=rgt->p->RANK;BOUND*sp=rgt->p->SHAPETC;',nl
  sre,←'BOUND c=1;','rk'do'c*=sp[i];'
  sre,←'BOUND sr=c;BOUND sl=c;',nl
  srl←'}else if(lft->p->RANK==0){BOUND sl=1;BOUND rk=rgt->p->RANK;',nl
  srl,←'BOUND*sp=rgt->p->SHAPETC;BOUND c=1;','rk'do'c*=sp[i];'
  srl,←'BOUND sr=c;',nl
  srr←'}else if(rgt->p->RANK==0){BOUND sr=1;BOUND rk=lft->p->RANK;',nl
  srr,←'BOUND*sp=lft->p->SHAPETC;BOUND c=1;','rk'do'c*=sp[i];'
  srr,←'BOUND sl=c;;',nl
  srt←'}else{error(4);}',nl
  scld←{t←tl ⍺ ⋄ sre,(t st ⍵),srl,(t st ⍵),srr,(t st ⍵),srt}
:EndNamespace
