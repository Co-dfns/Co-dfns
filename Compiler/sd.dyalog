:Namespace SD
  U←##.U ⋄ nl←U.nl ⋄ do←U.do ⋄ pdo←U.pdo ⋄ tl←U.tl ⋄ var←U.var ⋄ pp←#.pp
  A←##.A ⋄ k←A.k ⋄ n←A.n ⋄ v←A.v ⋄ e←A.e
  ivh←{'{LOCALP *pat=',⍵,';BOUND types=0;',nl}
  rt1←'if(pat->p->RANK!=(' ⋄ rt2←')->p->RANK){if(pat->p->RANK==0)pat='
  spt←{'if(pat->p->SHAPETC[i]!=(',⍵,')->p->SHAPETC[i])error(4);'}
  crv←{rt1,⍵,rt2,⍵,';else error(4);}',nl,'else','pat->p->RANK'do spt ⍵}
  frv←{∪⊃,/((⌽¯1↓¯1⌽⊢)¨⍵)~∘∪¨(⍳≢⍺)↑¨⊂⍺}
  dov←{⍺←⊢ ⋄ ⍺ ⍺⍺ ((n⍵)frv v⍵)var¨((,1↑⍉)¨frv(↓1↓⍉)¨)e⍵}
  crk←{{(ivh⊃⍵),⊃,/crv¨1↓⍵}dov ⍵}
  rif←{'if((',⍵,')->p->ELTYPE==APLLONG)types|=1<<',(⍕⍺),';',nl}
  grt←{⊃,/{(⍳≢⍵)rif¨⍵}dov ⍵}
  ars←{⊃,/{'/* Allocate result for ',⍵,' */',nl}¨∪n ⍵}
  gdp←{'*d',(⍕⍺),'=ARRAYSTART((',⍵,')->p);',nl}
  git←{(⌽((≢⍵)⍴2)⊤⍺)⊃¨⊂'double ' 'aplint32 '}
  gip←{⊃,/⍺{(⍺ git ⍵),¨(⍳≢⍵)gdp¨⍵}dov ⍵}
  cnt←{'BOUND cnt=1;',nl,'pat->p->RANK'do'cnt*=pat->p->SHAPETC[i];'}
  rkm←{⊃,/{(⍳≢⍵){'BOUND m',(⍕⍺),'=(',(⍕⍵),')->p->RANK==0?1:cnt;',nl}¨⍵}dov ⍵}
  lai←{(⊃⍺ git ⍵),'s',(⍕⍵),'=d',(⍕⍵),'[i%m',(⍕⍵),'];',nl}
  lpa←{⊃,/⍺{(⌽((≢⍵)⍴2)⊤⍺)lai¨⍳≢⍵}dov ⍵}
  sva←{'s',∘⍕¨⍺-1+((-⍺)↑⍺⍺)⍳⌽¯1↓¯1⌽⊃v ⍵}
  stm←{⊂'/* ?type? s',(⍕⍺),'=',(⊃⌽¯1⌽⊃v⍵),'(',(⍕⍺(⍺⍺ sva)⍵),'); */',nl}
  lpc←{⊃,/(⍵{(≢⍵)+⍳≢⍺}dov ⍵)((⌽((n⍵)frv v⍵),n⍵)stm)⍤¯1⊢⍵}
  lps←{⊃,/((¯1+≢dov ⍵)+(≢n⍵)-(⌽n⍵)⍳∪n⍵){'r',(⍕⍵),'[i%cnt]=s',(⍕⍺),';',nl}¨⍳≢∪n⍵}
  bod←{'{',nl,(⍺ ars ⍵),(⍺ gip ⍵),('cnt'pdo nl,(⍺ lpa ⍵),(⍺ lpc ⍵),⍺ lps ⍵),'}',nl}
  cas←{'case ',(⍕⍺),':',(⍺ bod ⍵),'break;',nl}
  dis←{'switch(types){',nl,(⊃,/(⍳⍺)cas¨⊂⍵),'}'}
  std←{(cnt ⍵),(rkm ⍵),((2*≢(n⍵)frv v ⍵)dis ⍵),'}',nl}
  body←{⍺,'*z=ARRAYSTART(rslt->p);l=ARRAYSTART(lft->p);r=ARRAYSTART(rgt->p);',nl,'c'pdo ⍵}
    scld←{(dde ddt)(die dit)(ide idt)(iie iit)←tl ⍺ ⋄ z←''
      z,←'LOCALP tp;tp.p=NULL;int tpused=0;BOUND sr,sl,c,rk,elt,rt,lt,sp[15];',nl
      z,←'LOCALP*orz;c=1;rt=rgt->p->ELTYPE;lt=lft->p->ELTYPE;',nl
      z,←'if(lt==APLDOUB&&rt==APLDOUB)elt=',dde,';if(lt==APLDOUB&&rt==APLLONG)elt=',die,';',nl
      z,←'if(lt==APLLONG&&rt==APLDOUB)elt=',ide,';if(lt==APLLONG&&rt==APLLONG)elt=',iie,';',nl
      z,←'if(lft->p->RANK==rgt->p->RANK){rk=rgt->p->RANK;',nl
      z,←' ',('rk'do'sp[i]=rgt->p->SHAPETC[i];'),('rk'do'c*=sp[i];'),'sr=sl=c;',nl
      z,←'}else if(lft->p->RANK==0){rk=rgt->p->RANK;',nl
      z,←' ',('rk'do'sp[i]=rgt->p->SHAPETC[i];'),('rk'do'c*=sp[i];'),'sr=c;sl=1;',nl
      z,←'}else if(rgt->p->RANK==0){rk=lft->p->RANK;',nl
      z,←' ',('rk'do'sp[i]=lft->p->SHAPETC[i];'),('rk'do'c*=sp[i];'),'sr=1;sl=c;',nl
      z,←'}else{error(4);}',nl
      z,←'if((rslt==rgt||rslt==lft)&&(elt!=rslt->p->ELTYPE||rk!=rslt->p->RANK)){',nl
      z,←' orz=rslt;rslt=&tp;tpused=1;',nl
      z,←'}else if(rslt->p!=NULL&&(elt!=rslt->p->ELTYPE||rk!=rslt->p->RANK)){',nl
      z,←' relp(rslt);',nl
      z,←'}else if(rslt->p!=NULL){',nl
      z,←' ','rk'do'if(sp[i]!=rslt->p->SHAPETC[i]){relp(rslt);break;}',nl
      z,←'}',nl
      z,←'if(rslt->p==NULL){getarray(elt,rk,sp,rslt);}',nl
      z,←'if(lt==APLDOUB&&rt==APLDOUB){double*l,*r;',nl,ddt body ⍵
      z,←'}else if(lt==APLDOUB&&rt==APLLONG){double*l;aplint32*r;',nl,dit body ⍵
      z,←'}else if(lt==APLLONG&&rt==APLDOUB){aplint32*l;double*r;',nl,idt body ⍵
      z,←'}else if(lt==APLLONG&&rt==APLLONG){aplint32*l,*r;',nl,iit body ⍵
      z,←'}',nl
      z,←'if(tpused){relp(orz);orz->p=zap(rslt->p);}',nl
      z}
:EndNamespace