NM(get,"get",0,0,MT,MT,DFD,MT,MT)
DEFN(get)
DF(get_f){CVSWITCH(l.v,err(6),err(99,L"Unexpected simple array"),)
 CVEC<A>&lv=std::get<VEC<A>>(l.v);B ll=lv.size();B zr=rnk(z),rr=rnk(r);
 if(!ll){if(zr!=1)err(4);if(rr!=1)err(5);if(z.s[0]!=r.s[0])err(5);z=r;R;}
 if(ll!=zr)err(4);B rk=0;DOB(ll,CVSWITCH(lv[i].v,rk+=1,rk+=rnk(lv[i]),err(11)))
 if(rr>0&&rk!=rr)err(5);
 const B*rs=r.s.data();IDX x[4];
 if(!rr)DOB(ll,A v=lv[ll-i-1];CVSWITCH(v.v,,x[i]=v.as(s32),err(11)))
 if(rr>0)
  DOB(ll,A u=lv[ll-i-1];
   CVSWITCH(u.v
    ,if(z.s[i]!=*rs++)err(5)
    ,DOB(rnk(u),if(u.s[i]!=*rs++)err(5))x[i]=v.as(s32)
    ,err(11)))
 I tp=0;
 CVSWITCH(r.v,err(6)
  ,CVSWITCH(z.v,err(6),tp=1,tp=2)
  ,CVSWITCH(z.v,err(6),tp=3,tp=4))
 switch(tp){
  CS(1,{
   arr rv=unrav(std::get<arr>(r.v),r.s);arr zv=unrav(std::get<arr>(z.v),z.s);
   zv(x[0],x[1],x[2],x[3])=rv;z.v=flat(zv);})
  CS(2,err(16))
  CS(3,err(16))
  CS(4,{I i;VEC<A>&zv=std::get<VEC<A>>(z.v);CVEC<A>&rv=std::get<VEC<A>>(r.v);
   if(zr!=1)err(16);
   CVSWITCH(lv[0].v,
    ,arr x=v.as(s32);if(x.elements()!=1)err(16);i=x.scalar<I>();
    ,)
   zv[i]=rv[0];})
  default:err(99);}}

OM(get,"get",0,0,MT,DFD,MT,MT)
DF(get_o){A t;brk_c(t,z,l,e);map_o mfn_c(llp);mfn_c(t,t,r,e);
 get_c(z,l,t,e);}