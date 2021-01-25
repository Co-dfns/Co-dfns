NM(gdd,"gdd",0,0,MT ,MFD,DFD,MT ,MT )
DEFN(gdd)
MF(gdd_f){B rr=rnk(r);if(rr<1)err(4);z.s=SHP(1,r.s[rr-1]);
 if(!cnt(r)){z.v=r.v;R;}I c=1;DOB(rr-1,c*=(I)r.s[i]);
 arr mt,a(r.v,c,r.s[rr-1]);z.v=iota(dim4(z.s[0]),dim4(1),s32);
 DO(c,sort(mt,z.v,flat(a(c-(i+1),z.v)),z.v,0,false))}
DF(gdd_f){err(16);}

