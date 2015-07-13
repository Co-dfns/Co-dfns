:Namespace SHP
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ H←##.H ⋄ nl←H.nl ⋄ do←H.do ⋄ pdo←H.pdo

  ⍝ Shape
  mon←{z←'{',(⊃,/'rslt' 'rgt'{'LOCALP *',⍺,'=',⍵,';'}¨H.var/2↑⍵)
    z,←'BOUND rk=rgt->p->RANK;BOUND sp[15];',nl
    z,←'rk'do'sp[i]=rgt->p->SHAPETC[i];'
    z,←'relp(rslt);getarray(APLLONG,1,&rk,rslt);',nl
    z,←'aplint32 *b=ARRAYSTART(rslt->p);',nl,'rk'do'b[i]=sp[i];'
    z,←'}',nl
    z}
  
  ⍝ Reshape
  dya←{0≡⊃0⍴⊂⊃⊃1 0⌷⍵:⍺ rgt ⍵ ⋄ 0≡⊃0⍴⊂⊃⊃2 0⌷⍵:⍺ lft ⍵ ⋄ ⍺ vrs ⍵}

  vrs←{z←'{',(⊃,/'rslt' 'rgt' 'lft'{'LOCALP *',⍺,'=',⍵,';'}¨H.var/⍵),nl
    z,←'if(1!=lft->p->RANK)error(11);',nl,'BOUND rk=lft->p->SHAPETC[0];',nl
    z,←'if(15<rk)error(10);',nl,'BOUND sp[rk];aplint32*lv=ARRAYSTART(lft->p);'
    z,←'BOUND c=1;','rk'do'c*=lv[i];sp[i]=lv[i];'
    z,←'LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;',nl
    z,←'if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}',nl
    z,←'relp(rslt);getarray(',(⊃H.gie ⊃0⌷⍺),',rk,sp,rslt);',nl
    z,←'BOUND rc=1;','rgt->p->RANK'do'rc*=rgt->p->SHAPETC[i];'
    z,←(⊃,/(H.git 2↑⍺){⍺,'*',⍵,';'}¨'zr'),nl
    z,←⊃,/'zr'{⍺,'=ARRAYSTART(',⍵,'->p);',nl}¨'rslt' 'rgt'
    z,←'if(rc==0){',('c'pdo'z[i]=0;'),'}',nl,'else{'
    z,←('c'pdo'z[i]=r[i%rc];'),'}',nl
    z,←'if(tpused){relp(orz);orz->p=zap(rslt->p);}',nl
    z,←'}',nl
    z}

:EndNamespace
