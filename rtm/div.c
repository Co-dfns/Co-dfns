NM(div,"div",1,1,DID,MFD,DFD,MT,DAD)
div_f div_c;
ID(div,1,s32)
MF(div_f){z.r=r.r;z.s=r.s;z.v=1.0/r.v.as(f64);}
SF(div,z.v=lv.as(f64)/rv.as(f64))
