NM(min,"min",1,1,DID,MFD,DFD,MT ,DAD)
min_f min_c;
ID(min,DBL_MAX,f64)
MF(min_f){z.f=1;z.s=r.s;z.v=floor(r.v).as(r.v.type());}
SF(min,z.v=min(lv,rv))

