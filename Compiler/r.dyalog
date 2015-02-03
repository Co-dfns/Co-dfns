:Namespace R
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ pp←#.pp ⋄ var←##.G.var ⋄ nl←##.G.nl
  scld←##.SD.scld ⋄ sclm←##.SM.sclm ⋄ do←##.G.do ⋄ tl←##.G.tl
  dff←'fallback();',nl
  idxc←'BOUND c,j,k,m,*p,r=rgt->p->RANK-lft->p->RANK;BOUND s[r];aplint32*v;',nl
  idxc,←'j=lft->p->RANK;p=rgt->p->SHAPETC;',nl,'r'do's[i]=p[j+i];'
  idxc,←'getarray(rgt->p->ELTYPE,r,s,rslt);c=1;',nl,'r'do'c*=s[i];'
  idxc,←'v=ARRAYSTART(lft->p);m=c;k=0;',nl,'j'do'int a=j-(i+1);k+=m*v[a];m*=p[a];'
  idxc,←'if(rgt->p->ELTYPE==APLLONG){aplint32*src,*dst;',nl
  idxd←'}else if(rgt->p->ELTYPE=APLDOUB){double*src,*dst;',nl
  idxb←'dst=ARRAYSTART(rslt->p);src=ARRAYSTART(rgt->p);',nl,'c'do'dst[i]=src[k+i];'
  idx←idxc,idxb,idxd,idxb,'}',nl
  subm←'di'sclm'dst[i]=-1*src[i]' ⋄ addm←'di'sclm'dst[i]=src[i]'
  mulm←'ii'sclm'if(src[i]==0)dst[i]=0;else if(src[i]<0)dst[i]=-1;else if(src[i]>0)dst[i]=1;'
  divm←'dd'sclm'if(src[i]!=0)dst[i]=1.0/src[i];else error(11);'
  powm←'dd'sclm'dst[i]=exp((double)src[i]);'
  logm←'dd'sclm'dst[i]=log((double)src[i]);'
  pitm←'dd'sclm'dst[i]=3.14159265358979323846*src[i];'
  modm←'di'sclm'dst[i]=_Generic((src[i]),double:fabs,aplint32:labs)(src[i]);'
  fdb←3 3⍴,¨ '⌷' idx  ''   '-' scld subm '+' scld addm
  fdb⍪←3 3⍴,¨'÷' scld divm '×' scld mulm '*' scld powm
  fdb⍪←3 3⍴,¨'⍟' scld logm '○' ''   pitm '|' scld modm
  fdb⍪←1 3⍴,¨'≥' scld ''
  grh←{'{',(⊃,/⍺⍺{'LOCALP*',⍺,'=',⍵,';'}¨⍺ var¨↓⍉⍵),'relp(rslt);',nl}
  grhm←'rslt' 'rgt'grh ⋄ grhd←'rslt' 'lft' 'rgt'grh
  lkf←{'(',(((0⌷⍉⍵)⍳⊂⍺⍺)⊃(⍺⌷⍉⍵),⊂'dff'),')'}
  gd←{d←⍵⍵⍪fdb ⋄ (⍺ grhd ⍵),(((0⌷⍉d)⍳⊂⍺⍺)⊃(1⌷⍉d),⊂dff),'}',nl}
  gm←{d←⍵⍵⍪fdb ⋄ (⍺ grhm ⍵),(((0⌷⍉d)⍳⊂⍺⍺)⊃(2⌷⍉d),⊂dff),'}',nl}
:EndNamespace
