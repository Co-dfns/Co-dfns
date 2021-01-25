NM(rho,"rho",0,0,MT ,MFD,DFD,MT ,MT )
DEFN(rho)
MF(rho_f){B rr=rnk(r);VEC<I> sp(rr);DOB(rr,sp[rr-i-1]=(I)r.s[i])
 z.s=SHP(1,rr);if(!cnt(z)){z.v=scl(0);R;}z.v=array(rr,sp.data());}
DF(rho_f){B cr=cnt(r),cl=cnt(l);VEC<I> s(cl);
 if(rnk(l)>1)err(11);if(!isint(l))err(11);
 if(cl)l.v.as(s32).host(s.data());DOB(cl,if(s[i]<0)err(11))
 z.s=SHP(cl);DOB(cl,z.s[i]=(B)s[cl-i-1])
 B cz=cnt(z);if(!cz){z.v=scl(0);R;}if(cz==cr){z.v=r.v;R;}
 z.v=r.v(iota(cz)%cr);}
