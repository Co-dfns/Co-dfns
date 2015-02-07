:Namespace OP
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ nl←##.U.nl ⋄ do←##.U.do
  fdb←##.R.fdb
  comda←'LOCALP*or,*ol;or=rgt;ol=lft;lft=or;rgt=ol;',nl
  comd←{comda,(((0⌷⍉fdb)⍳⊂⍵)⊃1⌷⍉fdb)}
  comm←{'LOCALP*lft=rgt;',(((0⌷⍉fdb)⍳⊂⍵)⊃1⌷⍉fdb)}
  eacd←{'eacd();',nl}
  ema←'BOUND sp[15];','rgt->p->RANK'do'sp[i]=rgt->p->SHAPETC[i];'
  ema,←'if(rslt!=rgt){relp(rslt);getarray(APLDOUB,rgt->p->RANK,sp,rslt);}',nl
  ema,←'LOCALP sz,sr;regp(&sz);regp(&sr);',nl
  ema,←'getarray(APLDOUB,0,NULL,&sz);getarray(APLDOUB,0,NULL,&sr);',nl
  ema,←'double*z,*r;',nl
  ema,←'BOUND c=1;','rgt->p->RANK'do'c*=rgt->p->SHAPETC[i];'
  emb←'z=ARRAYSTART(sr.p);r=ARRAYSTART(rgt->p);z[0]=r[i];',nl
  emc←'(&sz,NULL,&sr,env);',nl,'z=ARRAYSTART(rslt->p);r=ARRAYSTART(sz.p);',nl
  emc,←'z[i]=r[0];'
  emd←'cutp(&sz);',nl
  eacm←{ema,('c'do emb,⍵,emc),emd}
  ptd←'LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;',nl
  ptd,←'if(rslt==lft||rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}',nl
  ptd,←'getarray(APLDOUB,0,NULL,rslt);BOUND c=1;',nl
  ptd,←'rgt->p->RANK'do'c*=rgt->p->SHAPETC[i];'
  ptd,←'double*z,*l,*r;z=ARRAYSTART(rslt->p);l=ARRAYSTART(lft->p);',nl
  ptd,←'r=ARRAYSTART(rgt->p);',nl,'c'do'z[0]+=l[i]*r[i];'
  ptd,←'if(tpused){relp(orz);orz->p=zap(rslt->p);}',nl
:EndNamespace
