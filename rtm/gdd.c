NM(gdd,"gdd",0,0,MT ,MFD,DFD,MT ,MT )
DEFN(gdd)
MF(gdd_f){B rr=rnk(r);if(rr<1)err(4);z.s=SHP(1,r.s[rr-1]);
 if(!cnt(r)){z.v=r.v;R;}I c=1;DOB(rr-1,c*=(I)r.s[i]);
 arr rv;CVSWITCH(r.v,err(6),rv=v,err(16))
 arr mt,a(rv,c,r.s[rr-1]);arr zv=iota(dim4(z.s[0]),dim4(1),s32);
 DO(c,sort(mt,zv,flat(a(c-(i+1),zv)),zv,0,false));z.v=zv;}
DF(gdd_f){err(16);}

