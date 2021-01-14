NM(max,"max",1,1,DID,MFD,DFD,MT ,DAD)
DEFN(max)
ID(max,-DBL_MAX,f64)
MF(max_f){z.f=1;z.s=r.s;z.v=ceil(r.v).as(r.v.type());}
SF(max,z.v=max(lv,rv))

