NM(sub,"sub",1,1,DID,MFD,DFD,MT ,DAD)
sub_f sub_c;
ID(sub,0,s32)
MF(sub_f){z.r=r.r;z.s=r.s;z.v=-r.v;}
SF(sub,z.v=lv-rv)

