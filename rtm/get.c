NM(get,"get",0,0,MT,MT,DFD,MT,MT)
get_f get_c;
DF(get_f){z.f=1;const VEC<A>&lv=l.nv;I ll=(I)lv.size();B zr=rnk(z),rr=rnk(r);
 if(!ll){if(zr!=1)err(4);if(rr!=1)err(5);if(z.s[0]!=r.s[0])err(5);z=r;R;}
 if(ll!=zr)err(4);B rk=0;DO(ll,rk+=lv[i].f?rnk(lv[i]):1)
 if(rr>0&&rk!=rr)err(5);
 const B*rs=r.s.data();index x[4];
 if(!rr)DO(ll,A v=lv[ll-i-1];if(v.f)x[i]=v.v.as(s32))
 if(rr>0)
  DO(ll,A v=lv[ll-i-1];if(!v.f)if(z.s[i]!=*rs++)err(5);
   if(v.f){DOB(rnk(v),if(v.s[i]!=*rs++)err(5))x[i]=v.v.as(s32);})
 arr zv=unrav(z),rv=unrav(r);zv(x[0],x[1],x[2],x[3])=rv;z.v=flat(zv);}

OM(get,"get",0,0,MT,DFD,MT,MT)
DF(get_o){z.f=1;A t;brk_c(t,z,l,e);map_o mfn_c(ll);mfn_c(t,t,r,e);
 get_c(z,l,t,e);}