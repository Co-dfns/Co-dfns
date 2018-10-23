NM(rol,"rol",1,0,MT ,MFD,DFD,MT ,MT )
rol_f rol_c;
MF(rol_f){z.r=r.r;z.s=r.s;if(!cnt(r)){z.v=r.v;R;}
 array rnd=randu(r.v.dims(),f64);z.v=(0==r.v)*rnd+trunc(r.v*rnd);}
DF(rol_f){if(cnt(r)!=1||cnt(l)!=1)err(5);
 D lv=l.v.as(f64).scalar<D>();D rv=r.v.as(f64).scalar<D>();
 if(lv>rv||lv!=floor(lv)||rv!=floor(rv)||lv<0||rv<0)err(11);
 I s=(I)lv;I t=(I)rv;z.r=1;z.s=dim4(s);if(!s){z.v=scl(0);R;}
 std::vector<I> g(t);std::vector<I> d(t);
 ((1+range(t))*randu(t)).as(s32).host(g.data());
 DO(t,I j=g[i];if(i!=j)d[i]=d[j];d[j]=i)z.v=array(z.s,d.data());}
