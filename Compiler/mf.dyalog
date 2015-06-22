:Namespace MF
  H←##.H ⋄ nl←H.nl ⋄ do←H.do ⋄ tl←H.tl ⋄ pdo←H.pdo ⋄ C←##.C

  ⍝ Indexing
  idx←{0≡⊃0⍴⊂⊃⊃1 0⌷⍵:⍺ idxr ⍵ ⋄ 0≡⊃0⍴⊂⊃⊃2 0⌷⍵:⍺ idxl ⍵ ⋄ ⍺ idxv ⍵}
  idxl←{rslt rgt←H.var/2↑⍵ ⋄ lft←⊃2 0⌷⍵
   z←'{',(⊃,/'rslt' 'rgt'{'LOCALP *',⍺,'=',⍵,';'}¨rslt rgt)
   z,←(⊃H.git 2⌷⍺),'v[]={',(⊃{⍺,',',⍵}/⍕¨lft),'};',nl
   z,←'BOUND c,j,k,m,*p,r;','j=',(⍕≢lft),';',nl
   z,←'r=rgt->p->RANK-j;',nl
   z,←'BOUND sp[15];','r'do'sp[i]=rgt->p->SHAPETC[j+i];'
   z,←'LOCALP tp;int tpused=0;tp.p=NULL;LOCALP*orz;',nl
   z,←'if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}',nl
   z,←'relp(rslt);getarray(',(⊃H.gie ⊃1⌷⍺),',(unsigned)r,sp,rslt);',nl
   z,←'p=rgt->p->SHAPETC;c=1;','r'do'c*=sp[i];'
   z,←'m=c;k=0;',nl
   z,←'j'do'BOUND a=j-(i+1);k+=m*v[a];m*=p[a];'
   z,←(⊃H.git 1⌷⍺),'*src,*dst;',nl
   z,←'dst=ARRAYSTART(rslt->p);src=ARRAYSTART(rgt->p);',nl
   z,←'c'pdo'dst[i]=src[k+i];'
   z,←'if(tpused){relp(orz);orz->p=zap(rslt->p);}',nl
   z,'}',nl}

  ⍝ TBW
  idxr←{⎕SIGNAL 16}
  idxv←{⎕SIGNAL 16}

  ⍝ Bracket Indexing
  bri←{0≡⊃0⍴⊂⊃⊃1 0⌷⍵:⍺ brir ⍵ ⋄ 0≡⊃0⍴⊂⊃⊃2 0⌷⍵:⍺ bril ⍵ ⋄ ⍺ briv ⍵}

  ⍝ XXX: Needs to be fixed
  briv←{z←'{',(⊃,/'rslt' 'rgt' 'lft'{'LOCALP *',⍺,'=',⍵,';'}¨⍵),nl
   z,←'BOUND sp[15];','rgt->p->RANK'do'sp[i]=rgt->p->SHAPETC[i];'
   z,←'LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;',nl
   z,←'if(rslt==rgt||rslt==lft){orz=rslt;rslt=&tp;tpused=1;}',nl
   z,←'relp(rslt);getarray(APLLONG,rgt->p->RANK,sp,rslt);',nl
   z,←'aplint32*z,*l,*r;z=ARRAYSTART(rslt->p);l=ARRAYSTART(lft->p);',nl
   z,←'BOUND c=1;','rgt->p->RANK'do'c*=rgt->p->SHAPETC[i];'
   z,←'r=ARRAYSTART(rgt->p);',nl
   z,←((⊂C.COMPILER)∊'icc' 'pgi')⊃''('#pragma simd',nl)
   z,←'c'do'z[i]=l[r[i]];'
   z,←'if(tpused){relp(orz);orz->p=zap(rslt->p);}',nl
   z,'}',nl}

  ⍝ XXX: Needs to be fixed
  brir←{z←'{',(⊃,/'rslt' 'rgt' 'lft'{'LOCALP *',⍺,'=',⍵,';'}¨⍵),nl
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
   z,←(⊃H.git 2⌷⍺),'l[]={',(⊃{⍺,',',⍵}/⍕¨⊃2 0⌷⍵),'};',nl
   z,←'BOUND sp[15];','rgt->p->RANK'do'sp[i]=rgt->p->SHAPETC[i];'
   z,←'LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;',nl
   z,←'if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}',nl
   z,←'relp(rslt);getarray(',(⊃H.gie ⊃⍺),',rgt->p->RANK,sp,rslt);',nl
   z,←(⊃H.git ⊃⍺),'*z;aplint32*r;'
   z,←'z=ARRAYSTART(rslt->p);','r=ARRAYSTART(rgt->p);',nl
   z,←'BOUND c=1;','rgt->p->RANK'do'c*=rgt->p->SHAPETC[i];'
   z,←'c'pdo'z[i]=l[r[i]];'
   z,←'if(tpused){relp(orz);orz->p=zap(rslt->p);}',nl
   z,'}',nl}

  ⍝ XXX: Rewrite this. Index generation
  iota←'aplint32*v=ARRAYSTART(rgt->p);aplint32 c=v[0];',nl
  iota,←'BOUND s[]={c};relp(rslt);getarray(APLLONG,1,s,rslt);',nl
  iota,←'v=ARRAYSTART(rslt->p);',nl,'c'do'v[i]=i;'
  iotm←iota

  ⍝ Catenation
  cat←{0≡⊃0⍴⊂⊃⊃1 0⌷⍵:⍺ catr ⍵ ⋄ 0≡⊃0⍴⊂⊃⊃2 0⌷⍵:⍺ catl ⍵ ⋄ ⍺ catv ⍵}
  
  catv←{z←'{',(⊃,/'rslt' 'rgt' 'lft'{'LOCALP *',⍺,'=',⍵,';'}¨H.var/⍵),nl
   z,←'BOUND s[]={rgt->p->SHAPETC[0],2};'
   z,←'LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;',nl
   z,←'if(rslt==lft||rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}',nl
   z,←'relp(rslt);getarray(',(⊃H.gie ⊃0⌷⍺),',2,s,rslt);',nl
   z,←(⊃,/(H.git ⍺){⍺,'*',⍵,';'}¨'zrl'),nl
   z,←⊃,/'zrl'{⍺,'=ARRAYSTART(',⍵,'->p);',nl}¨'rslt' 'rgt' 'lft'
   z,←'s[0]'pdo'z[i*2]=l[i];z[i*2+1]=r[i];'
   z,←'if(tpused){relp(orz);orz->p=zap(rslt->p);}',nl
   z,'}',nl}

  ⍝ TBW
  catl←{⎕SIGNAL 16}
  catr←{⎕SIGNAL 16}  

:EndNamespace
