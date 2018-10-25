NM(fac,"fac",1,1,DID,MFD,DFD,MT ,MT )
fac_f fac_c;
ID(fac,1,s32)
MF(fac_f){z.r=r.r;z.s=r.s;z.v=factorial(r.v.as(f64));}
SF(fac_f,array lvf=lv.as(f64);array rvf=rv.as(f64);
 z.v=exp(lgamma(1+rvf)-(lgamma(1+lvf)+lgamma(1+rvf-lvf))))