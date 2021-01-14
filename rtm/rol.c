NM(rol,"rol",1,0,MT ,MFD,DFD,MT ,MT )
DEFN(rol)
MF(rol_f){z.f=1;z.s=r.s;if(!cnt(r)){z.v=r.v;R;}
 arr rnd=randu(r.v.dims(),f64);z.v=(0==r.v)*rnd+trunc(r.v*rnd);}
DF(rol_f){z.f=1;if(cnt(r)!=1||cnt(l)!=1)err(5);
 D lv=l.v.as(f64).scalar<D>();D rv=r.v.as(f64).scalar<D>();
 if(lv>rv||lv!=floor(lv)||rv!=floor(rv)||lv<0||rv<0)err(11);
 I s=(I)lv;I t=(I)rv;z.s=SHP(1,s);if(!s){z.v=scl(0);R;}
 VEC<I> g(t);VEC<I> d(t);
 ((1+range(t))*randu(t)).as(s32).host(g.data());
 DO(t,I j=g[i];if(i!=j)d[i]=d[j];d[j]=i)z.v=arr(s,d.data());}
