:Namespace OP
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ nl←##.G.nl ⋄ do←##.G.do
  fdb←##.R.fdb
  comda←'LOCALP*or,*ol;or=rgt;ol=lft;lft=or;rgt=ol;',nl
  comd←{comda,(((0⌷⍉fdb)⍳⊂⍵)⊃1⌷⍉fdb)}
  comm←{'LOCALP*lft=rgt;',(((0⌷⍉fdb)⍳⊂⍵)⊃1⌷⍉fdb)}
  eacd←{'eacd();',nl}
  ema←'getarray(APLDOUB,rgt->p->RANK,rgt->p->SHAPETC,rslt);',nl
  ema,←'LOCALP sz,sr;regp(&sz);regp(&sr);',nl
  ema,←'getarray(APLDOUB,0,NULL,&sz);getarray(APLDOUB,0,NULL,&sr);',nl
  ema,←'double*z,*r;',nl
  ema,←'BOUND c=1;','rgt->p->RANK'do'c*=rgt->p->SHAPETC[i];'
  emb←'z=ARRAYSTART(sr.p);r=ARRAYSTART(rgt->p);z[0]=r[i];',nl
  emc←'(&sz,NULL,&sr,env);',nl,'z=ARRAYSTART(rslt->p);r=ARRAYSTART(sz.p);',nl
  emc,←'z[i]=r[0];'
  emd←'cutp(&sz);',nl
  eacm←{ema,('c'do emb,⍵,emc),emd}
:EndNamespace
