NM(fac,"fac",1,1,DID,MFD,DFD,MT ,MT )
fac_f fac_c;
ID(fac,1,s32)
MF(fac_f){z.r=r.r;z.s=r.s;z.v=factorial(r.v.as(f64));}
SF(fac_f,array lvf=lv.as(f64);array rvf=rv.as(f64);
 if(allTrue<I>(floor(rvf)==rvf&&rvf>=0&&floor(lvf)==lvf&&lvf>=0)){
  z.v=factorial(rvf)/(factorial(lvf)*factorial(max(0,rvf-lvf)));
  z.v=(lvf<=rvf)*floor(z.v);R;}
 z.v=exp(lgamma(rvf)+lgamma(lvf)-lgamma(lvf+rvf)))

