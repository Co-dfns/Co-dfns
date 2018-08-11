NM(unq,"unq",0,0,MT ,MFD,DFD,MT ,MT )
MF(unq_f){if(r.r>1)err(4);z.r=1;if(!cnt(r)){z.s=r.s;z.v=r.v;R;}
 array a,b;sort(a,b,r.v);z.v=a!=shift(a,1);z.v(0)=1;
 z.v=where(z.v);sort(b,z.v,b(z.v),a(z.v));
 z.s=dim4(z.v.elements());}
DF(unq_f){if(r.r>1||l.r>1)err(4);z.r=1;dtype mt=mxt(l.v,r.v);
 if(!cnt(l)){z.s=r.s;z.v=r.v;R;}if(!cnt(r)){z.s=l.s;z.v=l.v;R;}
 array x=setUnique(l.v);B c=x.elements();
 z.v=!anyTrue(tile(r.v,1,(U)c)==tile(array(x,1,c),(U)r.s[0],1),1);
 z.v=join(0,l.v.as(mt),r.v(where(z.v)).as(mt));
 z.s=dim4(z.v.elements());}

