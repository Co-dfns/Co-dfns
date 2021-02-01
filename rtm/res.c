NM(res,"res",1,1,DID,MFD,DFD,MT ,DAD)
DEFN(res)
ID(res,0,s32)
SMF(res,z.v=abs(rv).as(rv.type()))
SF(res,z.v=rv-lv*floor(rv.as(f64)/(lv+(0==lv))))

