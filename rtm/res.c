NM(res,"res",1,1,DID,MFD,DFD,MT ,DAD)
res_f res_c;
ID(res,0,s32)
MF(res_f){z.s=r.s;z.v=abs(r.v).as(r.v.type());}
SF(res,z.v=rv-lv*floor(rv.as(f64)/(lv+(0==lv))))

