OM(map,"map",1,1,MFD,DFD,MT ,MT )
MF(map_o){if(scm(ll)){ll(z,r,e);R;}
 z.s=r.s;I c=(I)cnt(z);if(!c){z.v=scl(0);R;}
 A rv;z.v=VEC<A>(c);VEC<A>&v=std::get<VEC<A>>(z.v);
 cat_c(rv,r,e);DOB(c,A&a=v[i],t;dis_c(t,scl(i),rv,e);ll(a,t,e))
 coal(z);}
DF(map_o){if(scd(ll)){ll(z,l,r,e);R;}B lr=rnk(l),rr=rnk(r);
 if((lr==rr&&l.s==r.s)||!lr){z.s=r.s;}
 else if(!rr){z.s=l.s;}else if(lr!=rr)err(4);
 else if(l.s!=r.s)err(5);else err(99);I c=(I)cnt(z);
 if(!c){z.v=scl(0);R;}A zs;A rs=scl(r.v(0));A ls=scl(l.v(0));
 ll(zs,ls,rs,e);if(c==1){z.v=zs.v;R;}
 array v=array(cnt(z),zs.v.type());v(0)=zs.v(0);
 if(!rr){rs.v=r.v;
  DO(c-1,ls.v=l.v(i+1);ll(zs,ls,rs,e);v(i+1)=zs.v(0);)
  z.v=v;R;}
 if(!lr){ls.v=l.v;
  DO(c-1,rs.v=r.v(i+1);ll(zs,ls,rs,e);v(i+1)=zs.v(0);)
  z.v=v;R;}
 DO(c-1,ls.v=l.v(i+1);rs.v=r.v(i+1);ll(zs,ls,rs,e);
  v(i+1)=zs.v(0))z.v=v;}
