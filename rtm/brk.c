NM(brk,"brk",0,0,MT,MT,DFD,MT,MT)
brk_f brk_c;
DF(brk_f){z.f=1;B lr=rnk(l);const VEC<A>&rv=r.nv;B rc=cnt(r);
 if(!rc){if(lr!=1)err(4);z=l;R;}if(rc!=lr)err(4);
 VEC<B> rm(rc,1);DOB(rc,if(rv[i].f)rm[i]=rnk(rv[i]))
 B zr=0;DOB(rc,zr+=rm[i])z.s=SHP(zr);B s=zr;
 DOB(rc,B j=i;s-=rm[j];DOB(rm[j],z.s[s+i]=rv[j].f?rv[j].s[i]:l.s[rc-j-1]))
 if(zr<=4){index x[4];DOB(rc,if(rv[i].f)x[rc-i-1]=rv[i].v.as(s32))
  dim4 sp(1);DO((I)lr,sp[i]=l.s[i])
  z.v=flat(moddims(l.v,sp)(x[0],x[1],x[2],x[3]));R;}
 err(16);}

OD(brk,"brk",scm(l),scd(l),MFD,DFD,MT ,MT )
MF(brk_o){if(rnk(ww)>1)err(4);ll(z,r,e,ww);}
DF(brk_o){if(rnk(ww)>1)err(4);ll(z,l,r,e,ww);}

