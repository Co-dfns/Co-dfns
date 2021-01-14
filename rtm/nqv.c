NM(nqv,"nqv",0,0,MT ,MFD,DFD,MT ,MT )
DEFN(nqv)
MF(nqv_f){z.f=1;B rr=rnk(r);z.v=scl(rr?(I)r.s[rr-1]:1);z.s=eshp;}
DF(nqv_f){z.f=1;z.s=eshp;B lr=rnk(l),rr=rnk(r);if(lr!=rr){z.v=scl(1);R;}
 DOB(lr,if(r.s[i]!=l.s[i]){z.v=scl(1);R;})z.v=allTrue(l.v!=r.v);}

