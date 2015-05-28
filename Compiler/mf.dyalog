:Namespace MF
  H←##.H ⋄ nl←H.nl ⋄ do←H.do ⋄ tl←H.tl
  idxc←'BOUND c,j,k,m,*p,r;aplint32*v;j=lft->p->RANK;j=(j==0?1:j);',nl
  idxc,←'r=rgt->p->RANK-j;',nl
  idxc,←'BOUND sp[15];','r'do'sp[i]=rgt->p->SHAPETC[j+i];'
  idxc,←'LOCALP tp;int tpused=0;tp.p=NULL;LOCALP*orz;',nl
  idxc,←'if(rslt==rgt||rslt==lft){orz=rslt;rslt=&tp;tpused=1;}',nl
  idxc,←'relp(rslt);getarray(rgt->p->ELTYPE,(unsigned)r,sp,rslt);',nl
  idxc,←'p=rgt->p->SHAPETC;c=1;','r'do'c*=sp[i];'
  idxc,←'v=ARRAYSTART(lft->p);m=c;k=0;',nl
  idxc,←'j'do'BOUND a=j-(i+1);k+=m*v[a];m*=p[a];'
  idxc,←'if(rgt->p->ELTYPE==APLLONG){aplint32*src,*dst;',nl
  idxd←'}else if(rgt->p->ELTYPE=APLDOUB){double*src,*dst;',nl
  idxb←'dst=ARRAYSTART(rslt->p);src=ARRAYSTART(rgt->p);',nl
  idxb,←'c'do'dst[i]=src[k+i];'
  idx←idxc,idxb,idxd,idxb,'}',nl
  idx,←'if(tpused){relp(orz);orz->p=zap(rslt->p);}',nl
  briv←{z←'{',(⊃,/'rslt' 'lft' 'rgt'{'LOCALP *',⍺,'=',⍵,';'}¨⍵),nl
   z,←'BOUND sp[15];','rgt->p->RANK'do'sp[i]=rgt->p->SHAPETC[i];'
   z,←'LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;',nl
   z,←'if(rslt==rgt||rslt==lft){orz=rslt;rslt=&tp;tpused=1;}',nl
   z,←'relp(rslt);getarray(APLLONG,rgt->p->RANK,sp,rslt);',nl
   z,←'aplint32*z,*l,*r;z=ARRAYSTART(rslt->p);l=ARRAYSTART(lft->p);',nl
   z,←'BOUND c=1;','rgt->p->RANK'do'c*=rgt->p->SHAPETC[i];'
   z,←'r=ARRAYSTART(rgt->p);',nl,'c'do'z[i]=l[r[i]];'
   z,←'if(tpused){relp(orz);orz->p=zap(rslt->p);}',nl
   z,'}',nl}
  bril←{z←'{',(⊃,/'rslt' 'rgt'{'LOCALP *',⍺,'=',⍵,';'}¨H.var/2↑⍵)
   z,←(⊃H.git 2⌷⍺),'*lft={',(⊃{⍺,',',⍵}/⍕¨⊃2 0⌷⍵),'};',nl
   z,←'BOUND sp[15];','rgt->p->RANK'do'sp[i]=rgt->p->SHAPETC[i];'
   z,←'LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;',nl
   z,←'if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}',nl
   z,←'relp(rslt);getarray(',(⊃H.gie ⊃⍺),',rgt->p->RANK,sp,rslt);',nl
   z,←(⊃H.git ⊃⍺),'*z,*l;aplint32*r;'
   z,←'z=ARRAYSTART(rslt->p);l=lft;','r=ARRAYSTART(rgt->p);',nl
   z,←'BOUND c=1;','rgt->p->RANK'do'c*=rgt->p->SHAPETC[i];'
   z,←'c'do'z[i]=l[r[i]];'
   z,←'if(tpused){relp(orz);orz->p=zap(rslt->p);}',nl
   z,'}',nl}
  bri←{0≡⊃0⍴⊂⊃⊃1 0⌷⍵:⍺ brir ⍵ ⋄ 0≡⊃0⍴⊂⊃⊃2 0⌷⍵:⍺ bril ⍵ ⋄ ⍺ briv ⍵}
  iota←'aplint32*v=ARRAYSTART(rgt->p);aplint32 c=v[0];',nl
  iota,←'BOUND s[]={c};relp(rslt);getarray(APLLONG,1,s,rslt);',nl
  iota,←'v=ARRAYSTART(rslt->p);',nl,'c'do'v[i]=i;'
  iotm←iota
  cat←'BOUND s[]={rgt->p->SHAPETC[0],2};'
  cat,←'LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;',nl
  cat,←'if(rslt==lft||rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}',nl
  cat,←'relp(rslt);getarray(APLDOUB,2,s,rslt);',nl
  cat,←'double*z,*l,*r;z=ARRAYSTART(rslt->p);l=ARRAYSTART(lft->p);',nl
  cat,←'r=ARRAYSTART(rgt->p);',nl,'s[0]'do'z[i*2]=l[i];z[i*2+1]=r[i];'
  cat,←'if(tpused){relp(orz);orz->p=zap(rslt->p);}',nl
:EndNamespace
