﻿NM(brk,"brk",0,0,MT,MT,DFD,MT,MT)
DEFN(brk)
DF(brk_f){B lr=rnk(l);B rc=cnt(r);
 if(!rc){if(lr!=1)err(4);z=l;R;}if(rc!=lr)err(4);
 CVSWITCH(r.v,err(6),err(99,L"Unexpected bracket index set"),)
 VEC<B> rm(rc);CVEC<A>&rv=std::get<VEC<A>>(r.v);
 DOB(rc,CVSWITCH(rv[i].v,rm[i]=1,rm[i]=rnk(rv[i]),err(11)))
 B zr=0;DOB(rc,zr+=rm[i])z.s=SHP(zr);B s=zr;
 DOB(rc,B j=i;s-=rm[j];
  DOB(rm[j],B&x=z.s[s+i];
   CVSWITCH(rv[j].v,x=l.s[rc-j-1],x=rv[j].s[i],err(99))))
 CVSWITCH(l.v,err(6)
  ,if(zr<=4){IDX x[4];
    DOB(rc,CVSWITCH(rv[i].v,,x[rc-i-1]=v.as(s32),err(99)))
    dim4 sp(1);DO((I)lr,sp[i]=l.s[i])
    z.v=flat(moddims(v,sp)(x[0],x[1],x[2],x[3]));}
   else err(16);
  ,if(lr!=1)err(16);if(rc!=1)err(16);
   VEC<A> zv(1);I i=std::get<arr>(rv[0].v).as(s32).scalar<I>();\
   CVEC<A> lv=std::get<VEC<A>>(l.v);
   zv[0]=lv[i];z.v=zv;)}

OD(brk,"brk",scm(l),scd(l),MFD,DFD,MT ,MT )
MF(brk_o){if(rnk(ww)>1)err(4);ll(z,r,e,ww);}
DF(brk_o){if(rnk(ww)>1)err(4);ll(z,l,r,e,ww);}

