NM(mul,"mul",1,1,DID,MFD,DFD,MT ,DAD)
DEFN(mul)
ID(mul,1,s32)
MF(mul_f){z.s=r.s;z.v=(r.v>0)-(r.v<0);}
SF(mul,z.v=lv*rv)

