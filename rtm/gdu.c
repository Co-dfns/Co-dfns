NM(gdu,"gdu",0,0,MT ,MFD,DFD,MT ,MT )
gdu_f gdu_c;
MF(gdu_f){if(r.r<1)err(4);z.r=1;z.s=dim4(r.s[r.r-1]);
 if(!cnt(r)){z.v=r.v;R;}I c=1;DO(r.r-1,c*=(I)r.s[i]);
 array mt,a=array(r.v,c,r.s[r.r-1]);z.v=iota(z.s,dim4(1),s32);
 DO(c,sort(mt,z.v,flat(a(c-(i+1),z.v)),z.v,0,true))}
DF(gdu_f){err(16);}
