NM(rho,"rho",0,0,MT ,MFD,DFD,MT ,MT )
rho_f rho_c;
MF(rho_f){z.f=1;B rr=rnk(r);VEC<I> sp(rr);DOB(rr,sp[rr-i-1]=(I)r.s[i])
 z.s=SHP(1,rr);if(!cnt(z)){z.v=scl(0);R;}z.v=array(rr,sp.data());}
DF(rho_f){z.f=1;B cr=cnt(r);B cl=cnt(l);SHP s(cl);
 if(rnk(l)>1)err(11);if(!isint(l))err(11);l.v.as(s64).host(s.data());
 z.s=SHP(cl);DOB(cl,z.s[i]=s[cl-i-1])B cz=cnt(z);if(!cz){z.v=scl(0);R;}
 z.v=array(cz==cr?r.v:r.v(iota(cz)%cr));}
