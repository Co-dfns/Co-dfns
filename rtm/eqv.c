NM(eqv,"eqv",0,0,MT ,MFD,DFD,MT ,MT )
DEFN(eqv)
MF(eqv_f){z.s=eshp;z.v=scl(rnk(r)!=0);}
DF(eqv_f){z.s=eshp;B lr=rnk(l),rr=rnk(r);if(lr!=rr){z.v=scl(0);R;}
 DOB(lr,if(l.s[i]!=r.s[i]){z.v=scl(0);R;})
 z.v=allTrue(l.v==r.v);}
