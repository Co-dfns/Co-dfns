NM(eqv,"eqv",0,0,MT ,MFD,DFD,MT ,MT )
MF(eqv_f){z.r=0;z.s=eshp;z.v=scl(r.r!=0);}
DF(eqv_f){z.r=0;z.s=eshp;
 if(l.r==r.r&&l.s==r.s){z.v=allTrue(l.v==r.v);R;}z.v=scl(0);}

