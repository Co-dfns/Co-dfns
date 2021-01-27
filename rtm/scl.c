template<class fncls> inline V msclfn(A&z,CA&r,ENV&e,FN&rec_c,fncls fn){
 z.s=r.s;
 VSWITCH(r.v,err(6),fn(z,v,e)
  ,B cr=cnt(r);z.v=VEC<A>(cr);VEC<A>&zv=std::get<VEC<A>>(z.v);
   DOB(cr,rec_c(zv[i],v[i],e)))}
template<class fncls> inline V sclfn(A&z,CA&l,CA&r,ENV&e,fncls fn){
 B lr=rnk(l),rr=rnk(r);
 if(lr==rr){DOB(rr,if(l.s[i]!=r.s[i])err(5));z.s=l.s;}
 else if(!lr){z.s=r.s;}else if(!rr){z.s=l.s;}else if(lr!=rr)err(4);
 std::visit(visitor{DVSTR(),
   [&](CVEC<A>&lv,carr&rv){err(16);},
   [&](carr&lv,CVEC<A>&rv){err(16);},
   [&](CVEC<A>&lv,CVEC<A>&rv){err(16);},
   [&](carr&lv,carr&rv){
    if(lr==rr){fn(z,lv,rv,e);}
    if(!lr){fn(z,tile(lv,rv.dims()),rv,e);}
    if(!rr){fn(z,lv,tile(rv,lv.dims()),e);}}},
  l.v,r.v);}
inline V sclfn(A&z,CA&l,CA&r,ENV&e,CA&ax,FN&me_c){
 A a=l,b=r;I f=rnk(l)>rnk(r);if(f){a=r;b=l;}
 B ar=rnk(a),br=rnk(b);B d=br-ar;B rk=cnt(ax);if(rk!=ar)err(5);
 VEC<D> axd(rk);SHP axv(rk);
 if(rk)std::visit<V>(visitor{
  [&](NIL _){err(99,L"Unexpected value error.");},
  [&](CVEC<A>&v){err(99,L"Unexpected nested shape.");},
  [&](carr&v){v.as(f64).host(axd.data());}},
  ax.v);
 DOB(rk,if(axd[i]!=rint(axd[i]))err(11))DOB(rk,axv[i]=(B)axd[i])
 DOB(rk,if(axv[i]<0||br<=axv[i])err(11))
 VEC<B> t(br);VEC<U8> tf(br,1);DOB(rk,B j=axv[i];tf[j]=0;t[j]=d+i)
 B c=0;DOB(br,if(tf[i])t[i]=c++)A ta(SHP(1,br),arr(br,t.data()));
 trn_c(z,ta,b,e);rho_c(b,z,e);rho_c(a,b,a,e);
 if(f)me_c(b,z,a,e);else me_c(b,a,z,e);
 gdu_c(ta,ta,e);trn_c(z,ta,b,e);}
