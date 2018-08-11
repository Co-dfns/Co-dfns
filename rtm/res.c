NM(res,"res",1,1,DID,MFD,DFD,MT ,MT )
ID(res,0,s32)
MF(res_f){z.r=r.r;z.s=r.s;z.v=abs(r.v).as(r.v.type());}
SF(res_f,z.v=rv-lv*floor(rv.as(f64)/(lv+(0==lv))))

