NM(iot,"iot",0,0,MT ,MFD,DFD,MT ,MT )
DEFN(iot)
MF(iot_f){if(rnk(r)>1)err(4);B c=cnt(r);if(c>4)err(10);if(c>1)err(16);
 CVSWITCH(r.v,err(6)
  ,I rv=v.as(s32).scalar<I>();
   z.s=SHP(1,rv);z.v=z.s[0]?iota(dim4(rv),dim4(1),s32):scl(0);
  ,err(11))}
DF(iot_f){z.s=r.s;B c=cnt(r);if(!c){z.v=scl(0);R;}
 I lc=(I)cnt(l)+1;if(lc==1){z.v=constant(0,cnt(r),s16);R;};if(rnk(l)>1)err(16);
 std::visit(visitor{DVSTR(),
   [&](carr&olv,carr&orv){arr lv=olv,rv=orv,ix;sort(lv,ix,lv);
    z.v=constant(0,cnt(r),s32);arr&zv=std::get<arr>(z.v);
    for(I h;h=lc/2;lc-=h){arr t=zv+h;replace(zv,lv(t)>rv,t);}
    zv=arr(select(lv(zv)==rv,ix(zv).as(s32),(L)cnt(l)),c);},
   [&](CVEC<A>&lv,carr&rv){err(16);},
   [&](carr&lv,CVEC<A>&rv){err(16);},
   [&](CVEC<A>&lv,CVEC<A>&rv){err(16);}},
  l.v,r.v);}
