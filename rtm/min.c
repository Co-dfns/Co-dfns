NM(min,"min",1,1,DID,MFD,DFD,MT ,DAD)
DEFN(min)
ID(min,DBL_MAX,f64)
MF(min_f){z.s=r.s;z.v=floor(r.v).as(r.v.type());}
SF(min,z.v=min(lv,rv))

