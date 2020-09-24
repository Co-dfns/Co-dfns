NM(get,"get",0,0,MT,MT,DFD,MT,MT)
get_f get_c;
DF(get_f){const std::vector<A>&lv=l.nv;I ll=(I)lv.size();
 if(!ll){if(z.r!=1)err(4);if(r.r!=1)err(5);DO(4,if(z.s[i]!=r.s[i])err(5));z=r;R;}
 if(ll!=z.r)err(4);I rk=0;DO(ll,rk+=abs(lv[i].r))if(r.r>0&&rk!=r.r)err(5);
 const B*rs=r.s.get();af::index x[4];
 if(!r.r)DO(ll,A v=lv[ll-(i+1)];I r=v.r;if(r>=0)x[i]=v.v.as(s32))
 if(r.r>0)
  DO(ll,A v=lv[ll-(i+1)];I r=v.r;if(r<0)if(z.s[i]!=*rs++)err(5);
   if(r>=0){DO(r,if(v.s[i]!=*rs++)err(5))x[i]=v.v.as(s32);})
 z.v(x[0],x[1],x[2],x[3])=r.v;}

OM(get,"get",0,0,MT,DFD)
DF(get_o){A t;brk_c(t,z,l,e);map_o mfn_c(ll);mfn_c(t,t,r,e);get_c(z,l,t,e);}