OM(oup,"oup",0,0,MT,DFD,MT ,MT )
DF(oup_o){B lr=rnk(l),rr=rnk(r),lc=cnt(l),rc=cnt(r);
 SHP sp(lr+rr);DOB(rr,sp[i]=r.s[i])DOB(lr,sp[i+rr]=l.s[i])
 if(!cnt(sp)){z.s=sp;z.v=scl(0);R;}
 std::visit(visitor{DVSTR(),
   [&](carr&lv,carr&rv){arr x(lv,1,lc),y(rv,rc,1);
    x=flat(tile(x,(I)rc,1));y=flat(tile(y,1,(I)lc));
    map_o mfn_c(llp);A xa(sp,x),ya(sp,y);mfn_c(z,xa,ya,e);},
   [&](CVEC<A>&lv,CVEC<A>&rv){z.s=sp;z.v=VEC<A>(lc*rc);
    VEC<A>&zv=std::get<VEC<A>>(z.v);DOB(lc*rc,ll(zv[i],lv[i],rv[i],e))
    coal(z);},
   [&](CVEC<A>&lv,carr&rv){z.s=sp;z.v=VEC<A>(lc*rc);
    VEC<A>&zv=std::get<VEC<A>>(z.v);DOB(lc*rc,ll(zv[i],lv[i],A(0,rv((I)i)),e))
    coal(z);},
   [&](carr&lv,CVEC<A>&rv){z.s=sp;z.v=VEC<A>(lc*rc);
    VEC<A>&zv=std::get<VEC<A>>(z.v);DOB(lc*rc,ll(zv[i],A(0,lv((I)i)),rv[i],e))
    coal(z);}},
  l.v,r.v);}
