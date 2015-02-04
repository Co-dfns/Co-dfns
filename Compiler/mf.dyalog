:Namespace MF
  nl←##.G.nl ⋄ do←##.G.do ⋄ tl←##.G.tl
  idxc←'BOUND c,j,k,m,*p,r=rgt->p->RANK-lft->p->RANK;BOUND s[r];aplint32*v;',nl
  idxc,←'j=lft->p->RANK;p=rgt->p->SHAPETC;',nl,'r'do's[i]=p[j+i];'
  idxc,←'getarray(rgt->p->ELTYPE,r,s,rslt);c=1;',nl,'r'do'c*=s[i];'
  idxc,←'v=ARRAYSTART(lft->p);m=c;k=0;',nl,'j'do'int a=j-(i+1);k+=m*v[a];m*=p[a];'
  idxc,←'if(rgt->p->ELTYPE==APLLONG){aplint32*src,*dst;',nl
  idxd←'}else if(rgt->p->ELTYPE=APLDOUB){double*src,*dst;',nl
  idxb←'dst=ARRAYSTART(rslt->p);src=ARRAYSTART(rgt->p);',nl,'c'do'dst[i]=src[k+i];'
  idx←idxc,idxb,idxd,idxb,'}',nl
  bia←'getarray(APLLONG,rgt->p->RANK,rgt->p->SHAPETC,rslt);',nl
  bia,←'aplint32*z,*l,*r;z=ARRAYSTART(rslt->p);l=ARRAYSTART(lft->p);',nl
  bia,←'r=ARRAYSTART(rgt->p);',nl,'rgt->p->RANK'do'z[i]=l[r[i]];'
  brki←bia
  iota←'aplint32*v=ARRAYSTART(rgt->p);aplint32 c=v[0];',nl
  iota,←'BOUND s[]={c};getarray(APLLONG,1,s,rslt);',nl
  iota,←'v=ARRAYSTART(rslt->p);',nl,'c'do'v[i]=i;'
  iotm←iota
  cat←'BOUND s[]={rgt->p->SHAPETC[0],2};getarray(APLDOUB,2,s,rslt);',nl
  cat,←'double*z,*l,*r;z=ARRAYSTART(rslt->p);l=ARRAYSTART(lft->p);',nl
  cat,←'r=ARRAYSTART(rgt->p);',nl,'s[0]'do'z[i*2]=l[i];z[i*2+1]=r[i];'
:EndNamespace
