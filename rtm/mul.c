NM(mul,"mul",1,1,DID,MFD,DFD,MT ,DAD)
mul_f mul_c;
ID(mul,1,s32)
MF(mul_f){z.f=1;z.s=r.s;z.v=(r.v>0)-(r.v<0);}
SF(mul,z.v=lv*rv)

