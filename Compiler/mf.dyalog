:Namespace MF
  nl←##.G.nl ⋄ do←##.G.do ⋄ tl←##.G.tl
  idxc←'BOUND c,j,k,m,*p,r;aplint32*v;j=lft->p->RANK;j=(j==0?1:j);',nl
  idxc,←'r=rgt->p->RANK-j;p=rgt->p->SHAPETC;',nl
  idxc,←'getarray(rgt->p->ELTYPE,(unsigned)r,&p[j],rslt);c=1;',nl,'r'do'c*=p[j+i];'
  idxc,←'v=ARRAYSTART(lft->p);m=c;k=0;',nl,'j'do'BOUND a=j-(i+1);k+=m*v[a];m*=p[a];'
  idxc,←'if(rgt->p->ELTYPE==APLLONG){aplint32*src,*dst;',nl
  idxd←'}else if(rgt->p->ELTYPE=APLDOUB){double*src,*dst;',nl
  idxb←'dst=ARRAYSTART(rslt->p);src=ARRAYSTART(rgt->p);',nl,'c'do'dst[i]=src[k+i];'
  idx←idxc,idxb,idxd,idxb,'}',nl
  bia←'getarray(APLLONG,rgt->p->RANK,rgt->p->SHAPETC,rslt);',nl
  bia,←'aplint32*z,*l,*r;z=ARRAYSTART(rslt->p);l=ARRAYSTART(lft->p);',nl
  bia,←'BOUND c=1;','rgt->p->RANK'do'c*=rgt->p->SHAPETC[i];'
  bia,←'r=ARRAYSTART(rgt->p);',nl,'c'do'z[i]=l[r[i]];'
  brki←bia
  iota←'aplint32*v=ARRAYSTART(rgt->p);aplint32 c=v[0];',nl
  iota,←'BOUND s[]={c};getarray(APLLONG,1,s,rslt);',nl
  iota,←'v=ARRAYSTART(rslt->p);',nl,'c'do'v[i]=i;'
  iotm←iota
  cat←'BOUND s[]={rgt->p->SHAPETC[0],2};getarray(APLDOUB,2,s,rslt);',nl
  cat,←'double*z,*l,*r;z=ARRAYSTART(rslt->p);l=ARRAYSTART(lft->p);',nl
  cat,←'r=ARRAYSTART(rgt->p);',nl,'s[0]'do'z[i*2]=l[i];z[i*2+1]=r[i];'
:EndNamespace
