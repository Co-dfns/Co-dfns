NM(rho,"rho",0,0,MT ,MFD,DFD,MT ,MT )
DEFN(rho)
MF(rho_f){B rr=rnk(r);VEC<I> sp(rr);DOB(rr,sp[rr-i-1]=(I)r.s[i])
 z.s=SHP(1,rr);if(!cnt(z)){z.v=scl(0);R;}z.v=arr(rr,sp.data());}
DF(rho_f){B cr=cnt(r),cl=cnt(l);VEC<I> s(cl);
 if(rnk(l)>1)err(11);if(!isint(l))err(11);
 CVSWITCH(l.v,err(6),if(cl)v.as(s32).host(s.data()),if(cl)err(16))
 DOB(cl,if(s[i]<0)err(11))z.s=SHP(cl);DOB(cl,z.s[i]=(B)s[cl-i-1])
 B cz=cnt(z);
 if(!cz){CVSWITCH(r.v,err(6),z.v=proto(v(0)),z.v=VEC<A>(1,proto(v[0])))R;}
 if(cz==cr){z.v=r.v;R;}
 CVSWITCH(r.v,err(6),z.v=v(iota(cz)%cr),
  z.v=VEC<A>(cz);VEC<A>&zv=std::get<VEC<A>>(z.v);DOB(cz,zv[i]=v[i%cr]))}
