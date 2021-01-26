NM(mul,"mul",1,1,DID,MFD,DFD,MT ,DAD)
DEFN(mul)
ID(mul,1,s32)
MF(mul_f){z.s=r.s;
 VSWITCH(r.v,err(6),z.v=(v>0)-(v<0)
  ,B cr=cnt(r);z.v=VEC<A>(cr);VEC<A>&zv=std::get<VEC<A>>(z.v);
   DOB(cr,this_c(zv[i],v[i],e)))}
SF(mul,z.v=lv*rv)

