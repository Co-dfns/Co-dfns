NM(exp,"exp",1,1,DID,MFD,DFD,MT ,MT )
ID(exp,1,s32)
MF(exp_f){z.r=r.r;z.s=r.s;z.v=exp(r.v.as(f64));}
SF(exp_f,z.v=pow(lv.as(f64),rv.as(f64)))

