OM(map,"map",1,1,MFD,DFD,MT ,MT )
MF(map_o){if(scm(ll)){ll(z,r,e);R;}
 z.s=r.s;I c=(I)cnt(z);if(!c){z.v=scl(0);R;}
 A rv;cat_c(rv,r,e);z.v=VEC<A>(c);VEC<A>&v=std::get<VEC<A>>(z.v);
 DOB(c,A t;dis_c(t,scl(scl(i)),rv,e);ll(v[i],t,e))
 coal(z);}
DF(map_o){if(scd(ll)){ll(z,l,r,e);R;}B lr=rnk(l),rr=rnk(r);
 A rv,lv,a,b;cat_c(rv,r,e);cat_c(lv,l,e);
 if((lr==rr&&l.s==r.s)||!lr){z.s=r.s;}
 else if(!rr){z.s=l.s;}else if(lr!=rr)err(4);
 else if(l.s!=r.s)err(5);else err(99);
 I c=(I)cnt(z);if(!c){z.v=scl(0);R;}
 z.v=VEC<A>(c);VEC<A>&v=std::get<VEC<A>>(z.v);
 if(lr==rr){
  DOB(c,A ix=scl(scl(i));dis_c(a,ix,lv,e);dis_c(b,ix,rv,e);ll(v[i],a,b,e))}
 else if(!lr){
  dis_c(a,scl(scl(0)),lv,e);DOB(c,dis_c(b,scl(scl(i)),rv,e);ll(v[i],a,b,e))}
 else if(!rr){
  dis_c(b,scl(scl(0)),rv,e);DOB(c,dis_c(a,scl(scl(i)),lv,e);ll(v[i],a,b,e))}
 coal(z);}
