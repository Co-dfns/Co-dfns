NM(unq,"unq",0,0,MT ,MFD,DFD,MT ,MT )
DEFN(unq)
MF(unq_f){z.f=1;if(rnk(r)>1)err(4);if(!cnt(r)){z.s=r.s;z.v=r.v;R;}
 arr a,b;sort(a,b,r.v);z.v=a!=shift(a,1);z.v(0)=1;
 z.v=where(z.v);sort(b,z.v,b(z.v),a(z.v));z.s=SHP(1,z.v.elements());}
DF(unq_f){z.f=1;if(rnk(r)>1||rnk(l)>1)err(4);
 dtype mt=mxt(l.v,r.v);B lc=cnt(l),rc=cnt(r);
 if(!cnt(l)){z.s=SHP(1,rc);z.v=r.v;R;}if(!cnt(r)){z.s=SHP(1,lc);z.v=l.v;R;}
 arr x=setUnique(l.v);B c=x.elements();
 z.v=!anyTrue(tile(r.v,1,(U)c)==tile(arr(x,1,c),(U)rc,1),1);
 z.v=join(0,l.v.as(mt),r.v(where(z.v)).as(mt));z.s=SHP(1,z.v.elements());}
