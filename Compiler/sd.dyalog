:Namespace SD
  nl←##.G.nl ⋄ do←##.G.do ⋄ tl←##.G.tl
  body←{⍺,'*z=ARRAYSTART(rslt->p);l=ARRAYSTART(lft->p);r=ARRAYSTART(rgt->p);',nl,'c'do⍵}
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
