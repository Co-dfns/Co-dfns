:Namespace OP
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ H←##.H ⋄ nl←##.H.nl ⋄ do←##.H.do ⋄ C←##.C
  ⍝ idx←##.MF.idx ⋄ brki←##.MF.brki ⋄ iotm←##.MF.iotm
  ⍝ fdb←3 3⍴,¨ '⌷' idx  ''   '[' brki ''   '⍳' ''   iotm
 
  ⍝ XXX: Rewrite
  comda←'LOCALP*or,*ol;or=rgt;ol=lft;lft=or;rgt=ol;',nl
  comd←{comda,(((0⌷⍉fdb)⍳⊂⍵)⊃1⌷⍉fdb)}
  comm←{'LOCALP*lft=rgt;',(((0⌷⍉fdb)⍳⊂⍵)⊃1⌷⍉fdb)}

  ⍝ XXX: Implement
  eacd←{'eacd();',nl}

  ⍝ Monadic Each (¨)
  eacm←{0≡⊃0⍴⊂⊃⊃1 0⌷⍵:⍺(⍺⍺ eacmr)⍵ ⋄ ⍺(⍺⍺ eacmv)⍵}

  eacmv←{z←'{',(⊃,/'rslt' 'rgt'{'LOCALP *',⍺,'=',⍵,';'}¨H.var/⍵)
   z,←'BOUND sp[15];','rgt->p->RANK'do'sp[i]=rgt->p->SHAPETC[i];'
   z,←'if(rslt!=rgt){relp(rslt);'
   z,←'getarray(',(⊃H.gie ⊃⍺),',rgt->p->RANK,sp,rslt);}',nl
   z,←'LOCALP sz,sr;regp(&sz);regp(&sr);',nl
   z,←(⊃,/(H.gie ⍺){'getarray(',⍺,',0,NULL,&',⍵,');'}¨'sz' 'sr'),nl
   z,←(⊃,/(H.git ⍺){⍺,'*',⍵,';'}¨'zr'),nl
   z,←'BOUND c=1;','rgt->p->RANK'do'c*=rgt->p->SHAPETC[i];'
   b←'z=ARRAYSTART(sr.p);r=ARRAYSTART(rgt->p);z[0]=r[i];',nl
   b,←⍺⍺,((1⌷⍺)⊃'' 'i' 'f'),'n(&sz,NULL,&sr,env);',nl
   b,←'z=ARRAYSTART(rslt->p);r=ARRAYSTART(sz.p);',nl
   b,←'z[i]=r[0];'
   z,←('c'do b),'cutp(&sz);',nl
   z,'}',nl}

  ⍝ TBW
  eacml←{_←⍺⍺ ⋄ ⎕SIGNAL 16}
  eacmr←{_←⍺⍺ ⋄ ⎕SIGNAL 16}

  ⍝ XXX: Implement a proper general version
  ⍝ Inner Product
  ptd←{0≡⊃0⍴⊂⊃⊃1 0⌷⍵:⍺ ptdr ⍵ ⋄ 0≡⊃0⍴⊂⊃⊃2 0⌷⍵:⍺ ptdl ⍵ ⋄ ⍺ ptdv ⍵}

  ⍝ TBW
  ptdv←{⎕SIGNAL 16}
  ptdr←{⎕SIGNAL 16}

  ptdl←{z←'{',(⊃,/'rslt' 'rgt'{'LOCALP *',⍺,'=',⍵,';'}¨H.var/2↑⍵)
   z,←(⊃H.git 2⌷⍺),'l[]={',(⊃{⍺,',',⍵}/⍕¨⊃2 0⌷⍵),'};',nl
   z,←'LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;',nl
   z,←'if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}',nl
   z,←'getarray(',(⊃H.gie ⊃⍺),',0,NULL,rslt);BOUND c=1;',nl
   z,←'rgt->p->RANK'do'c*=rgt->p->SHAPETC[i];'
   z,←(⊃,/(H.git ¯1↓⍺){⍺,'*',⍵,';'}¨'zr'),nl
   z,←(⊃,/'zr'{⍺,'=ARRAYSTART(',⍵,'->p);',nl}¨'rslt' 'rgt'),nl
   prag←((⊂C.COMPILER)∊'pgi' 'icc')⊃''('#pragma simd reduction(+:z)',nl)
   do←prag H.{'{BOUND i;',nl,⍺⍺,(for ⍺),⍵,'}}',nl}
   z,←'c'do'z[0]+=l[i]*r[i];'
   z,←'if(tpused){relp(orz);orz->p=zap(rslt->p);}',nl
   z,'}',nl}

:EndNamespace
