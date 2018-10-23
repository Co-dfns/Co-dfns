NM(nqv,"nqv",0,0,MT ,MFD,DFD,MT ,MT )
nqv_f nqv_c;
MF(nqv_f){z.v=scl(r.r?(I)r.s[r.r-1]:1);z.r=0;z.s=dim4(1);}
DF(nqv_f){z.r=0;z.s=eshp;I t=l.r==r.r&&l.s==r.s;
 if(t)t=allTrue<I>(l.v==r.v);z.v=scl(!t);}

